<?php 

/*********************************************************************
 Серверная часть портала ГМС
 Все операции строятся на токене допуска, который выдается клиенту при логине.
 Токен является бессрочным и при следующем обращении к серверу идентифицирует пользователя
 по таблице активных токенов.
 После удачного совершения операции клиент получает новый токен. 
 И в таблице токенов он обновляется.
**********************************************************************/
// небезопасное разрешение на запросы со сторонних сайтов.
// но позволяет избежать блокировки запросов из браузера при разработке
header("Access-Control-Allow-Origin: HTTP://localhost:8080");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: *");
header('Content-Type: text/html; charset= utf-8');


require_once "tools.php";


$data = "";
$new_token = "";
$result = RESULT_ERROR;
$user_id = 0;

$adminmail = ';zinovev@hms-neftemash.ru';


require_once "phonebook.php";



if ( $_GET['method'] == 'getWebUserData' ) {

    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { 
        echo GetResultJSON( "Не указан токен", RESULT_ERROR, $new_token ); 
        exit;
    }    

    $token = $_GET['token'];

    // получаем данные пользователя из базы портала
    $data = ExecQuery1( "SELECT * FROM web_Users WHERE token like ?", array( $token ), NFT_DATABASE, NFT_UID, NFT_PWD );

    if (!is_array($data) || (count($data) == 0)) {
        echo GetResultJSON( $data, RESULT_ERROR, $token ); 
        exit;
    }

    echo GetResultJSON( $data, RESULT_OK, $token );

    exit;
}





if ( $_GET['method'] == 'getPhotoUser' ) {
/*
  Метод автологина на фотоархиве при переходе на него с веб-портала.
  по данным логина веб-портала находит и возвращает регистрационные данные пользователя
  в фотоархиве
*/    
    
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { 
        echo GetResultJSON(	"Не указан токен", RESULT_ERROR, $new_token ); 
        exit;
    }    

    $new_token = $_GET['token'];


    // получаем данные пользователя из базы портала
    $data = ExecQuery1( "SELECT user_id, email FROM web_Users WHERE token like ?", array( $new_token ), NFT_DATABASE, NFT_UID, NFT_PWD );

    if (!is_array($data) || (count($data) == 0)) {
        echo GetResultJSON(	$data, RESULT_ERROR, $new_token ); 
        exit;
    }


    // сопоставляем и получаем данные пользователя из фотоархива
    $data = ExecQuery1( "SELECT UserLogin, UserPass FROM PhotoArchAccess WHERE UserEmail like ? OR empl_id = ?", 
    	        array( $data[0]['email'], $data[0]['user_id'] ), FILE_DATABASE, FILE_UID, FILE_PWD );

    if (!is_array($data) || (count($data) == 0)) {
        echo GetResultJSON(	$data, RESULT_ERROR, $new_token ); 
        exit;
    }


    // расшифровываем, поскольку будем передавать, словно пользователь ввел пароль руками
    $data[0]['UserPass'] = base64_decode($data[0]['UserPass']);

	echo GetResultJSON( $data[0], RESULT_OK, $new_token );

	exit;
}





// выполняем сырой SQL запрос
// получаем сырые данные указанной таблицы
if ( $_GET['method'] == 'sql' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['sql'])) || ($_GET['sql'] == "") ) { $data = "Не указана строка SQL"; }    
    if ( $data === "" && (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }

    if ($data === "") {

        $sql = $_GET['sql'];

        $data = ExecQuery1( $sql, array(), NFT_DATABASE, NFT_UID, NFT_PWD );

        /// если запрос выполнился корректно - вернется массив, иначе строка с текстом ошибки       
        if (is_array($data)) {
            
            /// ставим флаг успешного запроса
            $result = RESULT_OK;
        }
    } 

    echo GetResultJSON( $data, $result, $new_token );

    exit;
}





// получаем сырые данные указанной таблицы
if ( $_GET['method'] == 'select' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['table'])) || ($_GET['table'] == "") ) { $data = "Не указано имя таблицы"; }    
    if ( $data === "" && (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; } 	
    }

    if ($data === "") {

	    $table_name = ClearUp($_GET['table']);

	    $data = ExecQuery1( 'SELECT * FROM '.$table_name, array(), NFT_DATABASE, NFT_UID, NFT_PWD );

        /// если запрос выполнился корректно - вернется массив, иначе строка с текстом ошибки	    
	    if (is_array($data)) {
            
            /// ставим флаг успешного запроса
            $result = RESULT_OK;

            /// обновляем токен для пользователя (механизм невъебенной безопасности с динамическими ключами)
//            $new_token = GUID();
//            RefreshToken($_GET['token'], $new_token);
        }
    } 

	echo GetResultJSON( $data, $result, $new_token );

    exit;
}




// получаем список доступных пользователю программ для отображения в 
// главном окне веб-портала
if ( $_GET['method'] == 'selectProgList' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }

    if ($data === "") {

        $data = ExecQuery1( 
            'SELECT * FROM web_Programs where id in ( '.
               ' SELECT pr.program_id FROM web_link_ProgramRoles pr '.
               ' left join RolesAccess ra ON ra.role_id = pr.role_id '.
               ' left join employees e ON e.id = ra.employees_id '.
               ' left join web_Users wu ON e.id = wu.user_id '.
               ' WHERE wu.token like ? '.
            ')', 
            array($new_token), NFT_DATABASE, NFT_UID, NFT_PWD );

        /// если запрос выполнился корректно - вернется массив, иначе строка с текстом ошибки       
        if (is_array($data)) {
            
            /// ставим флаг успешного запроса
            $result = RESULT_OK;
        }
    } 

    echo GetResultJSON( $data, $result, $new_token );

    exit;
}





// получаем список доступных пользователю программ для окна Администрирования
if ( $_GET['method'] == 'getUserProgList' ) {

    /// проверка входных переметров
    if ( (!isset($_GET['user_id'])) || ($_GET['user_id'] == "") ) { $data = "Не указан пользователь"; }    
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }

    if ($data === "") {

        $user_id = $_GET['user_id'];

        if ($user_id <> 0) {
            $data = ExecQuery1( 
                ' DECLARE @uid int = ?'.
                ' SELECT p.id, p.name, s.link_id, case when s.link_id IS not null then 1 else 0 end as flag, p.Params, s.Params as ParamValues FROM web_Programs p '.
                ' left join ( '.
                '    select ra.ID as link_id, pr.program_id, ps.Params from RolesAccess ra '.
                '    left join web_link_ProgramRoles pr ON pr.role_id = ra.role_id '.
                '    left join web_UserPrograms_settings ps ON ps.program_id = pr.program_id '.
                '    where ra.employees_id = @uid and ps.user_id = @uid'.
                ' ) as s on s.program_id = p.id ',
                array($user_id), NFT_DATABASE, NFT_UID, NFT_PWD 
            );
        } else {
            $data = array();
        }

        /// если запрос выполнился корректно - вернется массив, иначе строка с текстом ошибки       
        if (is_array($data)) {
            
            /// ставим флаг успешного запроса
            $result = RESULT_OK;
        }
    } 

    echo GetResultJSON( $data, $result, $new_token );

    exit;
}





if ( $_GET['method'] == 'login' ) {
// логиним пользователя в систему: по паролю и логину возвращаем разовый токен, если
// верификационные данные верны.

    if ( (!isset($_GET['pwd'])) || ($_GET['pwd'] == "") ) { $data = "Не указан пароль"; }    
    if ( (!isset($_GET['login'])) || ($_GET['login'] == "") ) { $data = "Не указан логин"; }    

    if ($data === ""){


        /// после отсеивания некорректных входящих данных, проверяем наличие пользователя в базе
		$user = ClearUp($_GET['login']);
		$pwd = ClearUp($_GET['pwd']);

	    $data = ExecQuery1( 'SELECT e.name, u.token, u.isAdmin as admin FROM web_Users AS u '.
	    	               'left join employees AS e ON e.id = u.user_id '.
	    	               'left join RolesAccess AS ra ON ra.employees_id = e.id and ra.role_id = 181 '.
                           'WHERE u.pwd like ? and u.login like ?', 
	    	               array($pwd, $user), NFT_DATABASE, NFT_UID, NFT_PWD );
        
        /// если запрос выполнился корректно - вернется массив, иначе строка с текстом ошибки	    
	    if (is_array($data)) {

	        /// найден ли пользователь
	        if (count($data) > 0) {

			    /// получаем новый токен
                
                /// обновляем токен пользователя
//			    ExecQuery( 'UPDATE web_Users SET token = ?  WHERE id = ?', array( $new_token, $data[0]['id'] ), NFT_DATABASE, NFT_UID, NFT_PWD );

                $token = $data[0]['token'];
                $data = array( $data[0]['name'], $data[0]['admin'] );

			    $result = RESULT_OK;

	        } else {
	        	$data = "Пользователь не зарегистрирован или пароль/логин не верны.";
	        }
        } else {
            $data = "Ошибка получения данных пользователя: ".$data;
        }
    }

    echo GetResultJSON( $data, $result, $token );

    exit;
}



if ( $_GET['method'] == 'register' ) {
//
//   регистрация нового пользователя в системе. следует помнить, что при этом у него будут отсутствовать права на
//   доступ у программам. они накатываются отдельной функцией автоматом (базовые) или вручную админом.
//
//   функция получает логин и мыло, а пароль генерится автоматом и отправляется на ящик. 
//   это позволяет быстро идентифицировать пользователя по базе сотрудников и дает возможность автоматической
//   раздачи прав исходя из должности/отдела
//

/// проверка корректности входных данных
    if ( (!isset($_GET['email'])) || ($_GET['email'] == "") ) { $data = "Не указан email"; }    
    if ( (!isset($_GET['login'])) || ($_GET['login'] == "") ) { $data = "Не указан логин"; }    
    if ( (!isset($_GET['url'])) || ($_GET['url'] == "") ) { $data = "Не указан URL портала"; }    
    
//    if ($data === "") {
//        $email = ClearUp($_GET['email']);
//        if (filter_var($email, FILTER_VALIDATE_EMAIL) !== true ) { $data = $email." - Некорректный формат e-mail"; }
//    }
// убрано, поскольку не пропускает стандартные рабочие ящики вида zinovev@hms-neftemash.ru    



/// проверка на дублирование данных с уже зарегистрированными пользователями
    if ($data === ""){

        $login = ClearUp($_GET['login']);
        $email = ClearUp($_GET['email']);
        $url = $_GET['url'];

        /// проверяем, не занят ли логин или email
   	    $query = ExecQuery1( "SELECT id FROM web_Users WHERE login = ?", array($login), NFT_DATABASE, NFT_UID, NFT_PWD );
        if (is_array($query) && (count($query) > 0) ) { $data = "Логин уже используется"; } 

        if ($data === "") {
   	        $query = ExecQuery1( "SELECT id FROM web_Users WHERE email = ?", array($email), NFT_DATABASE, NFT_UID, NFT_PWD );
            if (is_array($query) && (count($query) > 0) ) { $data = "E-mail ".$email." уже зарегистрирован"; } 
   	    }

        if ($data === "") {
   	        $query = ExecQuery1( "SELECT fio, id FROM employees WHERE email like ?", array($email), NFT_DATABASE, NFT_UID, NFT_PWD );
            if (is_array($query) && (count($query) > 0) ) { 
            	$fio = $query[0]['fio']; 
            	$user_id = $query[0]['id']; 
            } else {
            	$data = "В системе не найден пользователь с e-mail: ".$email."\n В регистрации отказано."; 
            }
   	    }

        if ($data === "") {
    /// указанные значения не зарегистрированы в базе. регистрация нового пользователя

			$pwd = GetPWD($email);
			$token = GUID();

	        ExecQuery1( "INSERT INTO web_Users (login, pwd, email, user_id, token) VALUES ( ?, ?, ?, ?, ? )", 
	        	array( $login, $pwd, $email, $user_id, $token ), NFT_DATABASE, NFT_UID, NFT_PWD );

	        $data = $fio;

            /// после успешной регистрации пользователя, отсылаем емайл с паролем
            /// по неизвестной причине, вызов хранимой процедуры успешен (письмо приходит), но в браузер возвращается ошибка 500
	        ExecQuery1( "exec web_sendmail ?, ?, ?, ?", array( $email.$adminmail, $pwd, $login, $url ), NFT_DATABASE, NFT_UID, NFT_PWD );

		    $result = RESULT_OK;
	    }
    }

    echo GetResultJSON( $data, $result, $pwd );

    exit;

}





if ( $_GET['method'] == 'restore' ) {
// получение нового пароля для пользователя

/// проверка корректности входных данных
    if ( ((!isset($_GET['email'])) || ($_GET['email'] == "")) && (!isset($_GET['token'])) ) { $data = "Не указан email"; }    
    if ( (!isset($_GET['url'])) || ($_GET['url'] == "") ) { $data = "Не указан URL портала"; }    
    
/// проверка на дублирование данных с уже зарегистрированными пользователями
    if ($data === ""){

        $email = $_GET['email'];
        $token = isset($_GET['token']) ? $_GET['token'] : ''; 
        $url   = $_GET['url'];

        if ($data === "") {
   	        $query = ExecQuery1( "SELECT user_id, email, login FROM web_Users WHERE ( email like ? ) or ( token like ? )", array($email, $token), NFT_DATABASE, NFT_UID, NFT_PWD );
            if (is_array($query) && (count($query) > 0) ) { 
            	$user_id = $query[0]['user_id']; 
                $email = $query[0]['email']; 
                $login = $query[0]['login']; 
            } else {
            	$data = "Пользователь в системе не зарегистрирован. Email: ".$email." Token: ".$token;
            }
   	    }

        if ($data === "") {
    /// получение нового пароля и токена

			$pwd = GetPWD(GUID());
			$token = GUID();

	        ExecQuery1( "UPDATE web_Users SET pwd = ?, token = ? WHERE user_id = ?", array( $pwd, $token, $user_id ), NFT_DATABASE, NFT_UID, NFT_PWD );

	        $data = $email.$adminmail.' '.$pwd.' '.$login.' '.$url;

            /// после успешной регистрации пользователя, отсылаем емайл с паролем
            /// по неизвестной причине, вызов хранимой процедуры успешен (письмо приходит), но в браузер возвращается ошибка 500
            ExecQuery1( "exec web_sendmail ?, ?, ?, ?", array( $email.$adminmail, $pwd, $login, $url ), NFT_DATABASE, NFT_UID, NFT_PWD );

		    $result = RESULT_OK;
	    }
    }

    echo GetResultJSON( $data, $result, $token );

    exit;

}






if ( $_GET['method'] == 'updateProgLinks' ) {
// получение нового пароля для пользователя

    _Log('(updateProgLinks) Обновление настроек программ пользоваетля...');

/// проверка корректности входных данных
    if (!isset($_GET['create'])) { $data = _Log("Не указаны связи для создания"); }    
    if (!isset($_GET['delete'])) { $data = _Log("Не указаны связи для удаления"); }    
    if ($data === "" && (!isset($_GET['user'])) || ($_GET['user'] == '')) { $data = _Log("Не указан пользователь для изменнеия привязок к программам"); }    
    if ( $data === "" && (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = _Log("Не указан токен безопасности"); }    
    if ($data === "" && (!isset($_GET['params']))) { $data = _Log("Не указаны параметры настроек"); }    

/// приведение входящих данных к нужному виду
    if ($data === ""){

        /// преобразование строк в рабочие массивы
        $create = explode(',', $_GET['create']);  /// содержит строку id программ к которым нужно привязать пользователя
        _Log('create array: '.$_GET['create']);

        $delete = $_GET['delete'];  /// содержит строку id существующих привязок на удаление
        _Log('delete array: '.$_GET['delete']);

        $user_id = $_GET['user'];
        _Log('user id: '.$_GET['user']);

        $token = $_GET['token'];   

        $params = $_GET['params'];  /// содержит строку настроек программ, если таковые есть  
        /// формат: данные программ разделены ";"  данные отдельных полей разделены "," первое значение - id программы 
        /// пример: "4,0,1,1;2,0,0,0;1;3,1,0,1,1,1" - настройки для четырех программ, третья не имеет настроек
        _Log('params: '.$_GET['params']);


        /// удаление привязок
        if ($data === "") {

            /// если есть что-то на удаление - грохаем
            if ($delete !== '') {

                _Log('удаление привязок');
                $res = ExecQuery1( "DELETE FROM RolesAccess WHERE id in ( ".$delete." )", array(), NFT_DATABASE, NFT_UID, NFT_PWD );
                if (!is_array($res))
                    $data = _Log('Ошибка удаления привязок: ' . $res);

            };
        };

        
        /// создание привязок 
        if ($data === "") {
            /// если есть что-то на добавление - привязываем
            if (is_array($create) && (count($create) > 0) ) {  
                
                _Log('создание привязок');
                forEach( $create as $prog ){
                     
                    _Log('$prog: '.$prog);

                    /// получаем id роли по id программы
                    $role = ExecQuery1( "SELECT role_id FROM web_link_ProgramRoles WHERE program_id = ?", array( $prog ), NFT_DATABASE, NFT_UID, NFT_PWD ); 
                    if (is_array($role) && (count($role) > 0) ) {       


                        /// проверяем наличие связки, чтобы не создавать дублей
                        $res = ExecQuery1( 
                            "SELECT id FROM RolesAccess WHERE employees_id = ? AND role_id = ?", 
                            array( $user_id, $role[0]['role_id'] ), 
                            NFT_DATABASE, NFT_UID, NFT_PWD 
                        );

                        /// если таких привязок еще нет...
                        if (is_array($res) && ( count($res) == 0 )) {       

                            /// создаем привязку программы к пользователю 
                            $res = ExecQuery1( 
                                "INSERT INTO RolesAccess (employees_id, role_id, Access) VALUES (?,?,1)", 
                                array( $user_id, $role[0]['role_id'] ), 
                                NFT_DATABASE, NFT_UID, NFT_PWD 
                            );

                            /// проверка на ощибки
                            if (!is_array($res)) 
                                
                                $data = _Log('Ошибка создания привязки: ' . $res);       

                        };

                    } else {

                        $data = _Log('Нет данных по program_id = '.$prog);

                    };
                };

            };

            if ($data === '') $result = RESULT_OK;

        };

        /// обработка настроек программы
        _Log('обработка настроек программы');
        /// получаем список строк настрооек 
        $progs_set_arr = explode(';', $params);
        
        forEach( $progs_set_arr as $progs_set ){
            
            _Log('$progs_set: '.$progs_set);

            /// получаем массив настроек
            $prog_params = explode(',', $progs_set);

            /// первый элемент: id программы из таблицы [nft].[web_Programs]
            
            // фотоархив
            if ($prog_params[0] == 3 ) { 
                    
                _Log('обработка настроек фотоархива');
   
                /// для начала найдем пользователя в фотоархиве или создадим при необходимости
                /// Base64.encode('fakepass'); = "ZmFrZXBhc3M=" - используется для всех новых пользователей
                /// при регистрации силами web-портала
            
                _Log('получаем id пользователя из базы портала. user_id = '.$user_id);
                // получаем id пользователя из базы портала
                $res = ExecQuery1( "SELECT id FROM PhotoArchAccess WHERE empl_id = ?", array( $user_id ), FILE_DATABASE, FILE_UID, FILE_PWD );
                if (!is_array($res)) {
                    _Log('Результат: '.$res);
                } else {
                    _Log('Результат: '.implode( $res ));    
                }
                

                // пользователь не найден - будем регистрировать 
                if (!is_array($res) || is_array(($res) && (count($res) == 0))) {

                    _Log('пользователь не найден - будем регистрировать');

                    /// получаем полные данные пользователя
                    $res = ExecQuery1( "SELECT name FROM employees WHERE id = ?", array( $user_id ), NFT_DATABASE, NFT_UID, NFT_PWD );

                    $fio = $res[0]['name'];

                    /// получаем полные данные пользователя
                    $res = ExecQuery1( "SELECT * FROM web_Users WHERE user_id = ?", array( $user_id ), NFT_DATABASE, NFT_UID, NFT_PWD );
 
                    /// добавляем пользователя                     
                    $res = ExecQuery1( 
                        "INSERT INTO PhotoArchAccess( UserLogin, UserPass, UserFIO, UserEmail, AccessLevel, empl_id ) VALUES(?,?,?,?,?,?)", 
                        array( $res[0]['login'], "ZmFrZXBhc3M=", $fio, $res[0]['email'], "1", $user_id ), FILE_DATABASE, FILE_UID, FILE_PWD );     
                                   

                    // получаем id созданного пользователя из 
                    $res = ExecQuery1( "SELECT id FROM PhotoArchAccess WHERE empl_id = ?", array( $user_id ), FILE_DATABASE, FILE_UID, FILE_PWD );
                    if (!is_array($res) || (is_array($res) && (count($res) == 0))) {
                        echo GetResultJSON( $res, RESULT_ERROR, $token ); 
                        exit;
                    }
                } 

                $photo_user_id = $res[0]['id'];
                

                /// для пользователя грохаем все привязки прав
                _Log('для пользователя грохаем все привязки прав: $photo_user_id = '.$photo_user_id);
                $res = ExecQuery1( "DELETE FROM PhotoArchTipAccessUser WHERE user_id = ?", array( $photo_user_id ), FILE_DATABASE, FILE_UID, FILE_PWD );
                _Log('Результат: '.$res);

                /// создаем привязки настроек
                for ($i = 1; $i < 5; $i++){
                    /// пареметры идут в том же порядке, что и настройки в [nft].[web_Programs].[Params] 
                    /// "Зав. №/Номенкл. №/№ акта ОТК/№ акта (гидроисп.)/Режим для просмотра".  
                    /// первые четыре параметра - видимость радиокнопок типов поиска. справочник типов в [FilesDB].[dbo].[PhotoArchTip]
                    /// последнее - запрет манипулировать папками/файлами, кроме просмотра и запроса на выгрузку
                    if ($prog_params[$i] == "1") {
                        _Log('параметр $prog_params[$i] = 1 ($i = '.$i.')');
                        _Log('добавление привязки');
                        $res = ExecQuery1( "INSERT INTO PhotoArchTipAccessUser(tip_id,user_id) VALUES (?,?)", array( $i, $photo_user_id ), FILE_DATABASE, FILE_UID, FILE_PWD );
                        if (!is_array($res)) {
                            _Log('Результат: '.$res);
                        } else {
                            _Log('Результат: '.implode( $res ));    
                        }

                    };

                };

                /// обновляем тип доступа
                _Log('обновляем тип доступа');
                $res = ExecQuery1( "UPDATE PhotoArchAccess SET AccessLevel = ? WHERE empl_id = ?", array( $prog_params[5], $photo_user_id ), FILE_DATABASE, FILE_UID, FILE_PWD );
                if (!is_array($res)) {
                    _Log('Результат: '.$res);
                } else {
                    _Log('Результат: '.implode( $res ));    
                }

            };


            /// для программы запоминаем текущий набор настроек

            /// подготовка массива параметров к записи в базу
            /// удаляем первый элемент - id программы
            $param_line = "";
            $prog_id = array_shift ( $prog_params );
            /// собираем массив в строку
            if (count($prog_params) != 0) {
                $param_line = implode(',', $prog_params);
            } 

            /// ищем запись для текущего сочетания программы/пользователя
            _Log('ищем в web_UserPrograms_settings запись для текущего сочетания программы/пользователя: '.$prog_id.'/'.$user_id);
            $res = ExecQuery1( "SELECT id FROM web_UserPrograms_settings WHERE user_id = ? AND program_id = ?", array( $user_id, $prog_id ), NFT_DATABASE, NFT_UID, NFT_PWD );
            if (!is_array($res)) {
                _Log('Результат: '.$res);
            } else {
                _Log('Результат: '.implode( $res ));    
            }

            // запись не найдена - будем регистрировать 
            if (!is_array($res) || (is_array($res) && (count($res) == 0))) {
                _Log('запись не найдена - будем регистрировать');
                $res = ExecQuery1( "INSERT INTO web_UserPrograms_settings (user_id, program_id, params) VALUES (?,?,?)", array( $user_id, $prog_id, $param_line ), NFT_DATABASE, NFT_UID, NFT_PWD );
                if (!is_array($res)) {
                    _Log('Результат: '.$res);
                } else {
                    _Log('Результат: '.implode( $res ));    
                }
            } 
            /// запись найдена - обновляем данные
            else {
                _Log('запись найдена - обновляем данные');
                $res = ExecQuery1( "UPDATE web_UserPrograms_settings SET params = ? WHERE id = ?", array( $param_line, $res[0]['id'] ), NFT_DATABASE, NFT_UID, NFT_PWD );
                if (!is_array($res)) {
                    _Log('Результат: '.$res);
                } else {
                    _Log('Результат: '.implode( $res ));    
                }
            }


        };
        
    }

    echo GetResultJSON( $data, $result, $token );

    _Log("(updateProgLinks) ...End.");

    exit;

}




if ( $_GET['method'] == 'getUserProgSettings' ) {

    if ( (!isset($_GET['prog_id'])) || ($_GET['prog_id'] == "") ) { $data = "Не указана программа"; }    
    if ( $data === "" && (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }

    if ($data === ""){

        $prog_id = ClearUp($_GET['prog_id']);

            $data = ExecQuery1( "exec sp_vp_get_CMOTKIzdBlocks ?", array($zavnum), NFT_DATABASE, NFT_UID, NFT_PWD );

            if (is_array($data)) { 
                $result = RESULT_OK;
            } 

    }

    echo GetResultJSON( $data, $result, $new_token );

    exit;
  
}



if ( $_GET['method'] == 'getBlocks' ) {
// получение списка блоков указанного изделия

/// проверка корректности входных данных
    if ( (!isset($_GET['zavnum'])) || ($_GET['zavnum'] == "") ) { $data = "Не указан заводской номер"; }    
    if ( $data === "" && (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }
    
/// проверка на дублирование данных с уже зарегистрированными пользователями
    if ($data === ""){

        $zavnum = ClearUp($_GET['zavnum']);

        if ($data === "") {
            $data = ExecQuery1( "exec sp_vp_get_CMOTKIzdBlocks_web ?", array($zavnum), NFT_DATABASE, NFT_UID, NFT_PWD );
            if (is_array($data)) { 
                $result = RESULT_OK;
            } 
        }
    }

    echo GetResultJSON( $data, $result, $new_token );

    exit;

}




if ( $_GET['method'] == 'getMounted' ) {
// получение всех смонтированных позиций указанного блока

/// проверка корректности входных данных
    if ( (!isset($_GET['izdid'])) || ($_GET['izdid'] == "") ) { $data = "Не указан блок изделия"; }    
    if ( $data === "" && (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }
    
/// проверка на дублирование данных с уже зарегистрированными пользователями
    if ($data === ""){

        $izdid = ClearUp($_GET['izdid']);

        if ($data === "") {
            $data = ExecQuery1( "exec sp_vp_get_CMOTKRecs ?, 0, 0, 0", array($izdid), NFT_DATABASE, NFT_UID, NFT_PWD );
            if (is_array($data)) { 
                $result = RESULT_OK;
            } 
        }
    }

    echo GetResultJSON( $data, $result, $new_token );

    exit;

}



if ( $_GET['method'] == 'getMeasures' ) {
// получение всех смонтированных позиций указанного блока

/// проверка корректности входных данных
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }
    
/// получаем единицы измерения
    if ($data === ""){

        $data = ExecQuery1( "select Naimeb from eb with(nolock) order by Naimeb", array(), NFT_DATABASE, NFT_UID, NFT_PWD );
        if (is_array($data)) { 
            $result = RESULT_OK;
        } 

    }

    echo GetResultJSON( $data, $result, $new_token );

    exit;

}




if ( $_GET['method'] == 'saveRecord' ) {
// получение всех смонтированных позиций указанного блока
    
    $user_id = 0;

/// проверка корректности входных данных
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( $data === "" && (!isset($_GET['data'])) || ($_GET['data'] == "") ) { $data = "Не указаны данные для внесения в базу"; }    
    if ( $data === "" && (!isset($_GET['mode'])) || ($_GET['mode'] == "") ) { $data = "Не указан режим редактирования данных"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }

    /// получаем пользователя по токену    
    if ($data === "") {
        $query = ExecQuery1( "SELECT user_id FROM web_Users WHERE token like ?", array($new_token), NFT_DATABASE, NFT_UID, NFT_PWD );
        if (is_array($query) && (count($query) > 0) ) { 
            $user_id = $query[0]['user_id']; 
        } else {
            $data = "Пользователь в системе не зарегистрирован"; 
        }
    }

    if ($data === ""){

        /// данные представляют собой JSONстроку
        $data = json_decode( $_GET['data'] );
        $mode = $_GET['mode'];

        $data = ExecQuery1( "exec sp_vp_CMOTKRecEdit ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?", 
            array(
               $data->id,      //    @RecId int,                 --id редактируемой записи
               $data->ZavNum,  //    @ZavNums nvarchar(500),     --заводские номера
               $data->Comment, //    @Comment nvarchar(200),     --примечание
               $user_id,       //    @Author int,                --id пользователя из таблицы employees
               $data->State == -1 ? null : $data->State,   
                               //    @RecState tinyint,          --установить статус: null - "Не обработано", 0 - Не установлено, 1 - Установлено
                               //                                  при добавлении новой записи игнорится. всегда ставится признак Установлено.
               $mode,          //    @Mode tinyint,              --0 - редактирование записи, 1 - отмена карты замены у записи, 2 - добавление записи
               $data->Cnt,     //    @Cnt float,                 --количество
               $data->CurMat,  //    @SetNaim nvarchar(200),     --наименование
               $data->obozn,   //    @SetObozn nvarchar(200),    --обозначение
               $data->EIzm,    //    @SetEizm varchar(10),       --единица измерения
               $data->Izd,     //    @Izd int,                   --id изделия
               $data->division //    @PosDiv tinyint             --раздел: 0 - КИП, 1 - Технология, 2 - ОПС, 3 - Вентиляция, 5 - АОВ
            ), 
            NFT_DATABASE, NFT_UID, NFT_PWD 
        );
        if (is_array($data)) { 
            $result = RESULT_OK;
        } 

    }

    echo GetResultJSON( $data, $result, $new_token );

    exit;

}


if ( $_GET['method'] == 'saveState' ) {
// получение всех смонтированных позиций указанного блока

/// проверка корректности входных данных
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( $data === "" && (!isset($_GET['data'])) || ($_GET['data'] == "") ) { $data = "Не указаны данные для внесения в базу"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }

    /// получаем пользователя по токену    
    if ($data === "") {
        $query = ExecQuery1( "SELECT user_id FROM web_Users WHERE token like ?", array($new_token), NFT_DATABASE, NFT_UID, NFT_PWD );
        if (is_array($query) && (count($query) > 0) ) { 
            $user_id = $query[0]['user_id']; 
        } else {
            $data = "Пользователь в системе не зарегистрирован"; 
        }
    }

    if ($data === ""){

        /// данные представляют собой JSONстроку
        $data = json_decode( $_GET['data'] );

        $data = ExecQuery1('exec sp_vp_SetCMOTKRecState ?, ?, ?, ?, ?, ?, ?, ?', 
            array(
                $data->Izd, 
                $data->CurMatId, 
                $data->Cnt, 
                $data->ZavNum, 
                $data->Comment, 
                $data->division, 
                $data->State, 
                $user_id
            ),
            NFT_DATABASE, NFT_UID, NFT_PWD 
        );
        if (is_array($data)) { 
            $result = RESULT_OK;
        } 

    }

    echo GetResultJSON( $data, $result, $new_token );

    exit;

}




if ( $_GET['method'] == 'getMat' ) {
// получение фактически выданных покупных вместо текущего для позиции с картой замены

/// проверка корректности входных данных
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( $data === "" && (!isset($_GET['IzdId'])) || ($_GET['IzdId'] == "") ) { $data = "Не указано изделие"; }    
    if ( $data === "" && (!isset($_GET['MatId'])) || ($_GET['MatId'] == "") ) { $data = "Не указан материал"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }

    if ($data === ""){

        $IzdId = ClearUp($_GET['IzdId']);
        $MatId = ClearUp($_GET['MatId']);

        $data = ExecQuery1('exec sp_vp_get_CMOTKChangedRecs ?, ?', array($IzdId, $MatId), NFT_DATABASE, NFT_UID, NFT_PWD );
        if (is_array($data)) { 
            $result = RESULT_OK;
        } 

    }

    echo GetResultJSON( $data, $result, $new_token );

    exit;

}




if ( $_GET['method'] == 'setMount' ) {
// установка 
    
/// проверка корректности входных данных
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( $data === "" && (!isset($_GET['data'])) || ($_GET['data'] == "") ) { $data = "Не указаны данные для внесения в базу"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }

    /// получаем пользователя по токену    
    if ($data === "") {
        $query = ExecQuery1( "SELECT user_id FROM web_Users WHERE token like ?", array($new_token), NFT_DATABASE, NFT_UID, NFT_PWD );
        if (is_array($query) && (count($query) > 0) ) { 
            $user_id = $query[0]['user_id']; 
        } else {
            $data = "Пользователь в системе не зарегистрирован"; 
        }
    }

    if ($data === ""){

        /// данные представляют собой JSONстроку
        $data = json_decode( $_GET['data'] );

        $data = ExecQuery1('exec sp_vp_CMOTKRecMount ?, ?, ?, ?, ?, ?, ?, ?, ?', 
            array(
                $data->Izd,         //    @IzdId int,                 --id изделия
                $data->FirstMatId,  //    @FirstMatId int,            --id заменяемого покупного
                $data->CurMatId,    //    @NewMatId int,              --id покупного, на которое заменяем
                $data->Cnt,         //    @Count float,               --количество устанавливаемого оборудования
                $data->Division,    //    @div tinyint,               --0 - КИП, 1 - Технология, 2 - ОПС, 3 - Вентиляция, 5 - АОВ
                $user_id,           //    @Author int,                --id пользователя из таблицы employees
                $data->ZavNum,      //    @ZavNums nvarchar(500)='',  --заводские номера
                $data->Comment,     //    @Comment nvarchar(200)='',  --примечание
                $data->BaseId       //    @RecId int                  --id позиции, которая была ранее не установлена
            ), 
            NFT_DATABASE, NFT_UID, NFT_PWD 
        );
        
        if (is_array($data)) { 
            $result = RESULT_OK;
        } 

    }

    echo GetResultJSON( $data, $result, $new_token );

    exit;

}


if ( $_GET['method'] == 'getHistory' ) {
/// получение истории изменении позиции.
/// есть проблема у AXIOS со знаками + при url кодировке. Это связано с некорректными библиотеками, неподдерживающими стандарт.
/// https://github.com/axios/axios/issues/1111    
/// для обхода проблемы, чтобы не перелопачивать логику, значимой строкой для поиска будет все от начала до первого найденного плюса,
/// или вся строке, если их нет. эти данные входят из программы (обрезаются до отправления запроса), поскольку на стороне сервера
/// плюсы уже заменены на пробелы при urldecode.

/// проверка корректности входных данных
    if ( (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    
    if ( $data === "" && (!isset($_GET['Izd'])) || ($_GET['Izd'] == "") ) { $data = "Не указано изделие"; }    
    if ( $data === "" && (!isset($_GET['obozn'])) || ($_GET['obozn'] == "") ) { $data = "Не указано обозначение"; }    

    /// проверяем токен
    if ($data === "") {
        $new_token = ValidToken( $_GET['token'] );
        if ($new_token === "") { $data = "Токен идентификации некорректен"; }   
    }

    if ($data === ""){

        $Izd = ClearUp($_GET['Izd']);
        $obozn = ClearUp($_GET['obozn']);


        $data = ExecQuery1('exec sp_vp_get_CMOTKPosHist ?, ?', array( $Izd, urldecode($obozn) ), NFT_DATABASE, NFT_UID, NFT_PWD );
        
        if (is_array($data)) { 
            $result = RESULT_OK;
        } 

    }

    echo GetResultJSON( $data, $result, $new_token );

    exit;

}


echo GetResultJSON( 'Метод не найден', RESULT_ERROR, '' );

?>

