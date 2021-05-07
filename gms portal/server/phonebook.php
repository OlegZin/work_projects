<?php 


//$asteriskUser = "webami";
//$strhost = "192.168.11.6"; // тестовый сервер Asterisk
//$asteriskPass = "srf43fsf4344hg";

$asteriskUser = "webami";
$strhost = "192.168.11.5"; // боевой сервер Asterisk.
$asteriskPass = "we32ewef9gi03";

//$asteriskUser = "admin";
//$strhost = "192.168.11.5"; // боевой сервер Asterisk.
//$asteriskPass = "fjnJ4+Y4ZfSM";

$strport = "5038"; // AMI  - порт, как настроено в секции [general] файла manager.conf;

//////////////////////////////////////////////////////////////////////
///
///  методы рализации телефонии и телефонного справочника
///  BEGIN


/// созвон двух номеров.
/// на телефонном сервере может быть настроена переадресация с местного на мобильный номер.
if ( $_GET['method'] == 'singlecall' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( (!isset($_GET['phone1'])) || ($_GET['phone1'] == "") ) { $data = "Не указан номер телефона звонящего"; }    
    if ( (!isset($_GET['phone2'])) || ($_GET['phone2'] == "") ) { $data = "Не указан номер телефона вызываемого абонента"; }    

    if ($data != ""){
        echo GetResultJSON( $data, RESULT_ERROR, $token );
        exit;
    }

    $phone1 = PhoneConvert( $_GET['phone1'] ); // получаем номер абонента, который хочет получить callback; 
    $caller = $_GET['phone1'];
    $phone2 = $_GET['phone2']; // получаем номер абонента, который хочет получить callback; 
    $empl1 = $_GET['empl_id1']; // id звонящего
    $empl2 = $_GET['empl_id2']; // id тому, кому звоним
    $token = $_GET['token'];
    $errno=0;
    $errstr=0;

    $sconn = fsockopen($strhost, $strport, $errno, $errstr, 10);
    $buff = '';

    if (!$sconn) { echo GetResultJSON( "$Подключение($strhost:$strport) - $errstr ($errno)", RESULT_ERROR, $token ); exit; } 
    else {

        fputs($sconn, "Action: Login\r\n");
        fputs($sconn, "Username: $asteriskUser\r\n"); 
        fputs($sconn, "Secret: $asteriskPass\r\n"); // укажите пароль созданного пользователя в файле manager.conf 
        fputs($sconn, "Events: off\r\n\r\n"); 
        usleep(500);

        do {
            $buff=fgets($sconn,128);
            $data=$data.$buff;
        } while ($buff != "\r\n");

        $data = $data."Action: Originate\r\n";
        $data = $data."Channel: ".$phone1."\r\n";
        $data = $data."CallerID: Neftemash <$phone1>\r\n";
        $data = $data."Timeout: 30000\r\n";
        $data = $data."Context: from-internal\r\n";
        $data = $data."Exten: ".$phone2."\r\n";
        $data = $data."Priority: 1\r\n";
        $data = $data."Async: true\r\n\r\n";

        fputs($sconn, "Action: Originate\r\n");
        fputs($sconn, "Channel: $phone1\r\n");
        fputs($sconn, "CallerID: Neftemash <$phone1>\r\n");
        fputs($sconn, "Timeout: 30000\r\n");
        fputs($sconn, "Context: from-internal\r\n");
        fputs($sconn, "Exten: $phone2\r\n");
        fputs($sconn, "Priority: 1\r\n");
        fputs($sconn, "Async: true\r\n\r\n" );
        fputs($sconn, "Action: Logoff\r\n\r\n");
        usleep (500);

        do {
            $buff=fgets($sconn,128);
            $data=$data.$buff;
        } while ($buff != "\r\n");

        fclose($sconn);
    }
/*    
    /// пишем в историю
    $data = ExecQuery1( "EXEC web_WritePhoneHistory ?, ?", array( $empl1, $empl2 ), NFT_DATABASE, NFT_UID, NFT_PWD );
    // возвращаемые данные (10 последних звонков этого пользователя):
    // id, fio, full_name, pname, phones1, email, main_phone, phones_inner, phones_outer, mobile_ph, have_photo
    // 4661, Зиновьев Олег Николаевич, Отдел автоматизации, Инженер-программист, 20-21,17-11, zinovev@hms-neftemash.ru, 2021, 20211711, NULL, NULL, 1

    // вернулись ли данные
    if (!is_array($data) || (count($data) == 0)) {
        echo GetResultJSON( $data, RESULT_ERROR, $token ); 
        exit;
    }
*/
    // пишем звонок в историю. инициатор звонка всегда в конце списка номеров
    ExecQuery1( "exec tool_log ?, ?", array( "WPB Solo", $phone2+","+$phone1), NFT_DATABASE, NFT_UID, NFT_PWD );

    echo GetResultJSON( $data, RESULT_OK, $token );

    exit; 
}



/// сбор динамической конференции.
/// в отличии от обычной, которая привязана к диапазону заранее созданных в диалплане,
/// не требует ввода пароля для входа. 
/// лишь для номеров с аппаратов Panasonic требуется ввода единицы для соединения (какая-то внетренняя кухня астериска)
if ( $_GET['method'] == 'dynamic_conference' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( (!isset($_GET['phones'])) || ($_GET['phones'] == "") ) { $data = "Не указаны номера телефонов участников конференции"; }    

    if ($data != ""){
        echo GetResultJSON( $data, RESULT_ERROR, $token );
        exit;
    }

    /// получаем и разбиваем в массив список номеров участников конференции
    $phones = explode( ',', $_GET['phones'] );
    $token = $_GET['token'];
    $errno=0;
    $errstr=0;


   
    $sconn = fsockopen($strhost, $strport, $errno, $errstr, 10);

    if (!$sconn) { echo GetResultJSON( "$Подключение($strhost:$strport) - $errstr ($errno)", RESULT_ERROR, $token ); exit; } 
    else { 
        // логинимся
        fputs($sconn, "Action: Login\r\n");
        fputs($sconn, "Username: $asteriskUser\r\n"); 
        fputs($sconn, "Secret: $asteriskPass\r\n"); // укажите пароль созданного пользователя в файле manager.conf 
        fputs($sconn, "Events: off\r\n\r\n");
        usleep(500);
        do {
            $buff=fgets($sconn,128);
            $data=$data.$buff;
        } while ($buff != "\r\n");


        // выбираем номер конференции (уникальный номер для всех существующих в данный момент).
        // для этого выбираем номер инициатора конфиренции, который находится в конце массива.
        // в дальнейшем этот id будет применяться для повторного дозвона в рамках конференции этим же методом
        $confnumber = end($phones);


        /// вызваниваем каждого участника, присоединяя его к конференции
        foreach ($phones as $phone) {

            $phone = PhoneConvert($phone);

            $data=$data."Action: Originate\r\n";
            $data=$data."Channel: ".$phone."\r\n";
            $data=$data."Callerid: <".$phone.">\r\n";
            $data=$data."Timeout: 30000\r\n";
            $data=$data."Context: nft_refconf\r\n";
            $data=$data."Exten: ".$confnumber."\r\n";
            $data=$data."Priority: 1\r\n";
            $data=$data."Async: true\r\n\r\n";

            fputs($sconn, "Action: Originate\r\n");
            fputs($sconn, "Channel: $phone\r\n");
            fputs($sconn, "Callerid: <$phone>\r\n");
            fputs($sconn, "Timeout: 30000\r\n");
            fputs($sconn, "Context: nft_refconf\r\n");
            fputs($sconn, "Exten: $confnumber\r\n");
            fputs($sconn, "Priority: 1\r\n");
            fputs($sconn, "Async: true\r\n\r\n" );

            do {
                $buff=fgets($sconn,128);
                $data=$data.$buff;
            } while ($buff != "\r\n");

        }


        fputs($sconn, "Action: Logoff\r\n\r\n");
        usleep (500);
        fclose($sconn);
    }
    
    // пишем звонок в историю. инициатор звонка всегда в конце списка номеров
    ExecQuery1( "exec tool_log ?, ?", array( "WPB Conf", $_GET['phones']), NFT_DATABASE, NFT_UID, NFT_PWD );

    echo GetResultJSON( $data, RESULT_OK, $token );

    exit; 
}



/// сбор конференции на приписанном в диалплане номере
if ( $_GET['method'] == 'conference' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( (!isset($_GET['phones'])) || ($_GET['phones'] == "") ) { $data = "Не указаны номера телефонов участников конференции"; }    

    if ($data != ""){
        echo GetResultJSON( $data, RESULT_ERROR, $token );
        exit;
    }

    /// получаем и разбиваем в массив список номеров участников конференции
    $phones = explode( ',', $_GET['phones'] );
    $token = $_GET['token'];
    $errno=0;
    $errstr=0;


   
    $sconn = fsockopen($strhost, $strport, $errno, $errstr, 10);

    if (!$sconn) { echo GetResultJSON( "$Подключение($strhost:$strport) - $errstr ($errno)", RESULT_ERROR, $token ); exit; } 
    else { 
        // логинимся
        fputs($sconn, "Action: Login\r\n");
        fputs($sconn, "Username: $asteriskUser\r\n"); 
        fputs($sconn, "Secret: $asteriskPass\r\n"); // укажите пароль созданного пользователя в файле manager.conf 
        fputs($sconn, "Events: off\r\n\r\n");
        usleep(500);
        do {
            $buff=fgets($sconn,128);
            $data=$data.$buff;
        } while ($buff != "\r\n");


        // запрашиваем список текущих конференций
        // если они есть, нужно выбрать свободную из диапазона 4505-4510
        fputs($sconn, "Action: ConfbridgeListRooms\r\n");
        usleep (500);

        // ответ при отсутствии конференций:
        // Response: Error
        // Message: No active conferences.

        // ответ при наличии конференций:
        // Response: Success 
        // EventList: start 
        // Message: Confbridge conferences will follow 
        //
        // Event: ConfbridgeListRooms 
        // Conference: 1111 
        // Parties: 1 
        // Marked: 0 
        // Locked: No 
        //
        // Event: ConfbridgeListRoomsComplete 
        // EventList: Complete 
        // ListItems: 1

        $break = false;
        $confs = "";
        do {
            $buff=fgets($sconn,128);

            // конференций нет
            if ( strripos($buff,"Response: Error") !== false) {
                $data=$data."Активные конференции отсутствуют.\r\n";
                $break = true;
            }
            
            // найдена строка с номером существующей конференции
            // пихаем в массив для дальнейшего разбора
            if ( strripos($buff, "Conference: ") !== false) {
                $confs = $confs . str_replace ("Conference:", "", $buff);
                $data=$data."Активная конференция:".str_replace ("Conference:", "", $buff)."\r\n";
            }  

            // список существующих конференций завершен
            if ( strripos($buff,"EventList: Complete") !== false) { 
                $data=$data."Конец списка активных конференций.\r\n";
                $break = true; 
            }

        } while (!$break);
        // тут не получится привязаться к пустой строке как концу сообщения.
        // идет несколько событий с такими разрывами и нужен явный флаг.



        // выбираем номер конференции
        $confnumber = 4505;
        // если список не пуст, выбираем свободную с наименьшим номером диапазона
        if ($confs != ""){
            for ($i = 4510; $i >= 4505; $i--) {
                if (strripos($confs, $i) === false) $confnumber = $i;
            }
        }

        $data=$data."Выбран номер конференции ".$confnumber."\r\n";
        $data=$data."Номера ".$_GET['phones']."\r\n";



        /// вызваниваем каждого участника, присоединяя его к конференции
        foreach ($phones as $phone) {

            $phone = PhoneConvert($phone);
            $data=$data."Вызываем ".$phone."\r\n";

            fputs($sconn, "Action: Originate\r\n");
            fputs($sconn, "Channel: $phone\r\n");
            fputs($sconn, "Callerid: Conference\r\n");
            fputs($sconn, "Timeout: 30000\r\n");
            fputs($sconn, "Context: from-internal\r\n");
            fputs($sconn, "Exten: $confnumber\r\n");
            fputs($sconn, "Priority: 1\r\n");
            fputs($sconn, "Async: true\r\n\r\n" );

            do {
                $buff=fgets($sconn,128);
                $data=$data.$buff;
            } while ($buff != "\r\n");

        }


        fputs($sconn, "Action: Logoff\r\n\r\n");
        usleep (500);
        fclose($sconn);
    }
    // пишем звонок в историю. инициатор звонка всегда в конце списка номеров
    ExecQuery1( "exec tool_log ?, ?", array( "WPB Conf", $_GET['phones']), NFT_DATABASE, NFT_UID, NFT_PWD );
    
    echo GetResultJSON( $data, RESULT_OK, $token );

    exit; 
}


/// получение списка последних исходящих звонков указанного сотрудника
/// получение данных всех контактов телефонной книги
if ( $_GET['method'] == 'getCallHistory' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( (!isset($_GET['empl'])) || ($_GET['empl'] == "") ) { $data = "Не указан id сотрудника"; }    

    if ($data != ""){
        echo GetResultJSON( $data, RESULT_ERROR, $token );
        exit;
    }

    $token = $_GET['token'];
    $empl = $_GET['empl'];

    // получаем данные из базы
    $data = ExecQuery1( "EXEC web_GetCallHistory ?", array($empl), NFT_DATABASE, NFT_UID, NFT_PWD );
    // возвращаемые данные:
    // id,   fio,                      full_name,           pname,               main_phone, subdiv
    // 4661, Зиновьев Олег Николаевич, Отдел автоматизации, Инженер-программист, 2021,       ОА

    // вернулись ли данные
    if (!is_array($data) || (count($data) == 0)) {
        echo GetResultJSON( $data, RESULT_ERROR, $token ); 
        exit;
    }
    
    echo GetResultJSON( $data, RESULT_OK, $token );

    exit; 
}




/// получение данных всех контактов телефонной книги
if ( $_GET['method'] == 'getPhoneBook' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    if ($data != ""){
        echo GetResultJSON( $data, RESULT_ERROR, $token );
        exit;
    }

    $token = $_GET['token'];

    // получаем данные из базы
    $data = ExecQuery1( "EXEC web_GetPhoneBook", array(), NFT_DATABASE, NFT_UID, NFT_PWD );
    // возвращаемые данные:
    // id,   fio,                      full_name,           pname,               main_phone, name
    // 4661, Зиновьев Олег Николаевич, Отдел автоматизации, Инженер-программист, 2021,       OA

    // вернулись ли данные
    if (!is_array($data) || (count($data) == 0)) {
        echo GetResultJSON( $data, RESULT_ERROR, $token ); 
        exit;
    }
    
    echo GetResultJSON( $data, RESULT_OK, $token );

    exit; 
}

/// получение данных всех контактных телефонов для указанного пользователя
if ( $_GET['method'] == 'getPhones' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( (!isset($_GET['empl_id'])) || ($_GET['empl_id'] == "") ) { $data = "Не указан id пользователя"; }    

    if ($data != ""){
        echo GetResultJSON( $data, RESULT_ERROR, $token );
        exit;
    }

    $token = $_GET['token'];
    $id = $_GET['empl_id'];

    // получаем данные из базы
    $data = ExecQuery1( "EXEC web_GetPhones ?", array( $id ), NFT_DATABASE, NFT_UID, NFT_PWD );
    // возвращаемые данные:
    //id  empl_id num   num_str tp is_hidden
    //28  1613    4000  40-00   1	false

    // вернулись ли данные
    if (!is_array($data) || (count($data) == 0)) {
        echo GetResultJSON( $data, RESULT_ERROR, $token ); 
        exit;
    }
    
    echo GetResultJSON( $data, RESULT_OK, $token );

    exit; 
}



/// получение данных всех контактных телефонов для всех пользователей
if ( $_GET['method'] == 'getAllPhones' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    if ($data != ""){
        echo GetResultJSON( $data, RESULT_ERROR, $token );
        exit;
    }

    $token = $_GET['token'];
    $id = $_GET['empl_id'];

    // получаем данные из базы
    $data = ExecQuery1( "EXEC web_GetPhones", array(), NFT_DATABASE, NFT_UID, NFT_PWD );
    // возвращаемые данные:
    //id  empl_id num   num_str tp (tp(1) = внутренний, tp(5) = сотовый )
    //28  1613    4000  40-00   1

    // вернулись ли данные
    if (!is_array($data) || (count($data) == 0)) {
        echo GetResultJSON( $data, RESULT_ERROR, $token ); 
        exit;
    }
    
    echo GetResultJSON( $data, RESULT_OK, $token );

    exit; 
}



/// получение данных фотографии указанного пользователя
if ( $_GET['method'] == 'getUserPhoto' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( (!isset($_GET['empl_id'])) || ($_GET['empl_id'] == "") ) { $data = "Не указан id пользователя"; }    

    if ($data != ""){
        echo GetResultJSON( $data, RESULT_ERROR, $token );
        exit;
    }

    $token = $_GET['token'];
    $id = $_GET['empl_id'];

/*
	function make_thumb($src, $dest, $desired_width) {			
	    $source_image = imagecreatefromjpeg($src);
	    $width = imagesx($source_image);
	    $height = imagesy($source_image);
	
	    $desired_height = floor($height * ($desired_width / $width));
	
	    $virtual_image = imagecreatetruecolor($desired_width, $desired_height);
	
	    imagecopyresampled($virtual_image, $source_image, 0, 0, 0, 0, $desired_width, $desired_height, $width, $height);
	
	    imagejpeg($virtual_image, $dest);
	}
	LoadFileToBase($_SESSION['CurFolderId'],$FileName,base64_encode($file_content),'', $hash, $_POST['SortIndex']);
*/

/*	 доработка: 
     прочитать данные из поля с миниатюрой.
     при отсутствии - читать полные данные, преобразовывать и возвращать их, параллельно записав в поле миниатюры
*/



    // получаем данные из базы
    $data = ExecQuery1( 
        "SELECT baze64 FROM varbinary_data ".
        "cross apply (select data as '*' for xml path('')) T (baze64) ".
        "WHERE obj_id=? and tp=0", array( $id ), NFT_DATABASE, NFT_UID, NFT_PWD );
    // возвращаемые данные: бинарная строка jpeg-картинки преобразованная в текст base64
     
    // вернулись ли данные
    if (!is_array($data) || (count($data) == 0)) {
        echo GetResultJSON( $data, RESULT_ERROR, $token ); 
        exit;
    }
    
    echo GetResultJSON( $data, RESULT_OK, $token );

    exit; 
}



/// получение данных фотографии указанного пользователя
if ( $_GET['method'] == 'getDepartments' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    if ($data != ""){
        echo GetResultJSON( $data, RESULT_ERROR, $token );
        exit;
    }

    $token = $_GET['token'];

    // получаем данные из базы
    $data = ExecQuery1( "EXEC web_GetDepartments", array(), NFT_DATABASE, NFT_UID, NFT_PWD );
     
    // вернулись ли данные
    if (!is_array($data) || (count($data) == 0)) {
        echo GetResultJSON( $data, RESULT_ERROR, $token ); 
        exit;
    }
    
    echo GetResultJSON( $data, RESULT_OK, $token );

    exit; 
}

///  END
///  конец рализации телефонии и телефонного справочника
///
//////////////////////////////////////////////////////////////////////


function PhoneConvert($number){
    // для выбора корректного значения Channel, члкдует учитывать имеющиеся типы номеров
    //внутренние номера
    //SIP/4XXX
    //SIP/ntmpbx01/XXXX
    //Корпоративные номера 
    //SIP/ntmpbx01/XXXXX
    //SIP/ntmpbx01/XXXXXX
    //Внешние, пример, сотовый
    //Local/089097459881@from-internal

/*  // определяет некорректно. добавляет ранки в локальные номера, что забивает лишние линии и сокращает количество звонков прошедших в конференции
    //внутренние номера
    if (($number < 5000 ) && ($number % 4000 == 1)) {$number = "SIP/$number";} else 
    if (($number < 5000 ) && ($number % 4000 != 1)) {$number = "SIP/ntmpbx01/$number";} else
    //Корпоративные номера 
    if ($number < 1000000 )                         {$number = "SIP/ntmpbx01/$number";} else
    //Внешние, пример, сотовый
                                                    {$number = "Local/$number@from-internal";} 
*/
    if (($number < 10000) || (($number % 100000) == 6) || (($number % 1000000) == 6)) then {

      if ($number div 1000 !== 4) then
         $number := "ntmpbx01/$number";

      $number := "SIP/$number";

    } else {
      $number := "Local/0$number@from-internal"
    }

    return $number;

}

?>

