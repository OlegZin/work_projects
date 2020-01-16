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
//header("Access-Control-Allow-Origin: HTTP://localhost:8080");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: *");
header('Content-Type: text/html; charset= utf-8');


require_once "tools.php";

if ( isset($_POST['method']) && $_POST['method'] == 'test' ) {
//    echo GetResultJSON( $_POST['method'], RESULT_OK, '' );
	echo "POST!!!";
    exit;
}

if ( $_GET['method'] == 'test' ) {
//    echo GetResultJSON( $_POST['method'], RESULT_OK, '' );
	echo "GET!!!";
    exit;
}



$data = "";
$new_token = "";
$result = RESULT_ERROR;
$user_id = 0;

$adminmail = ',zinovev@hms-neftemash.ru';

if ( $_GET['method'] == 'getPhotoUser' ) {
    
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




// получаем список доступных пользователю программ
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





// получаем список доступных пользователю программ
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
                ' SELECT p.id, p.name, s.link_id, case when s.link_id IS not null then 1 else 0 end as flag FROM web_Programs p '.
                ' left join ( '.
                '    select ra.ID as link_id, pr.program_id from RolesAccess ra '.
                '    left join web_link_ProgramRoles pr ON pr.role_id = ra.role_id '.
                '    where ra.employees_id = ? '.
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
                           'WHERE u.pwd like ?', 
	    	               array($pwd), NFT_DATABASE, NFT_UID, NFT_PWD );
        
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
    
/// проверка на дублирование данных с уже зарегистрированными пользователями
    if ($data === ""){

        $email = $_GET['email'];
        $token = $_GET['token']; 

        if ($data === "") {
   	        $query = ExecQuery1( "SELECT user_id, email FROM web_Users WHERE ( email like ? ) or ( token like ? )", array($email, $token), NFT_DATABASE, NFT_UID, NFT_PWD );
            if (is_array($query) && (count($query) > 0) ) { 
            	$user_id = $query[0]['user_id']; 
                $email = $query[0]['email']; 
            } else {
            	$data = "Пользователь в системе не зарегистрирован. Email: ".$email." Token: ".$token;
            }
   	    }

        if ($data === "") {
    /// получение нового пароля и токена

			$pwd = GetPWD(GUID());
			$token = GUID();

	        ExecQuery1( "UPDATE web_Users SET pwd = ?, token = ? WHERE user_id = ?", array( $pwd, $token, $user_id ), NFT_DATABASE, NFT_UID, NFT_PWD );

	        $data = $pwd;

            /// после успешной регистрации пользователя, отсылаем емайл с паролем
            /// по неизвестной причине, вызов хранимой процедуры успешен (письмо приходит), но в браузер возвращается ошибка 500
	        ExecQuery1( "exec web_sendmail ?, ?", array( $email, $pwd ), NFT_DATABASE, NFT_UID, NFT_PWD );

		    $result = RESULT_OK;
	    }
    }

    echo GetResultJSON( $data, $result, $token );

    exit;

}






if ( $_GET['method'] == 'updateProgLinks' ) {
// получение нового пароля для пользователя
    
/// проверка корректности входных данных
    if (!isset($_GET['create'])) { $data = "Не указаны связи для создания"; }    
    if (!isset($_GET['delete'])) { $data = "Не указаны связи для удаления"; }    
    if ($data === "" && (!isset($_GET['user'])) || ($_GET['user'] == '')) { $data = "Не указан пользователь для изменнеия привязок к программам"; }    
    if ( $data === "" && (!isset($_GET['token'])) || ($_GET['token'] == "") ) { $data = "Не указан токен безопасности"; }    

/// приведение входящих данных к нужному виду
    if ($data === ""){

        /// преобразование строк в рабочие массивы
        $create = explode(',', $_GET['create']);  /// содержит строку id программ к которым нужно привязать пользователя
        $delete = $_GET['delete'];  /// содержит строку id существующих привязок на удаление
        $user_id = $_GET['user'];
        $token = $_GET['token'];   

        /// удаление привязок
        if ($data === "") {

            /// если есть что-то на удаление - грохаем
            if ($delete !== '') {

                $res = ExecQuery1( "DELETE FROM RolesAccess WHERE id in ( ".$delete." )", array(), NFT_DATABASE, NFT_UID, NFT_PWD );
                if (!is_array($res))
                    $data = 'Ошибка удаления привязок: ' . $res;

            };
        };

        
        /// создание привязок 
        if ($data === "") {
            /// если есть что-то на добавление - привязываем
            if (is_array($create) && (count($create) > 0) ) {  
                
                forEach( $create as $prog ){

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
                                
                                $data = 'Ошибка создания привязки: ' . $res;       

                        };

                    } else {

                        $data = 'Нет данных по program_id = '.$prog;

                    };
                };

            };

            if ($data === '') $result = RESULT_OK;

        };
        
    }

    echo GetResultJSON( $data, $result, $token );

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
            $data = ExecQuery1( "exec sp_vp_get_CMOTKIzdBlocks ?", array($zavnum), NFT_DATABASE, NFT_UID, NFT_PWD );
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
// установка 
    
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

        $data = ExecQuery1('exec sp_vp_get_CMOTKPosHist ?, ?', array( $Izd, '%'.$obozn.'%' ), NFT_DATABASE, NFT_UID, NFT_PWD );
        
        if (is_array($data)) { 
            $result = RESULT_OK;
        } 

    }

    echo GetResultJSON( $data, $result, $new_token );

    exit;

}


echo GetResultJSON( 'Метод не найден', RESULT_ERROR, '' );

?>

