<?php 

/// настройки доступа к базам данных 
define("SERVER", "192.168.100.180"); //server-htm.ntm.grouphms.local

define("FILE_DATABASE", "FilesDB");
define("FILE_UID",      "PhotoArch");
define("FILE_PWD",      "NTMPhotoArchUser");

define("NFT_DATABASE", "nft_test_15092019");
define("NFT_UID",      "UserProgNFT");
define("NFT_PWD",      "H6v92InV");

/// флаги успешности возвращаемых сервером результатов
define("RESULT_OK", true);
define("RESULT_ERROR", false);


// возвращает результат выполнения команды SQL в виде массива
// чужая функция. пользую как есть.
function ExecQuery1 ($sql, $params, $database, $uid, $pwd) {	
	
	$connectionOptions = array(
	    "Database" => $database,
	    "Uid"      => $uid,
	    "PWD"      => $pwd
	);
	
	$conn = sqlsrv_connect(SERVER, $connectionOptions);		
	
	if ( $conn === false ) {
        return GetResultJSON( 'Ошибка подключения к серверу: '.FormatErrors1(sqlsrv_errors()), RESULT_ERROR, '');
        exit;
	} 

	$arrayResult=array();
	
	$stmt=sqlsrv_prepare($conn, $sql, $params);
	if(!$stmt) {
		$res='Ошибка подготовки запроса: '.FormatErrors1(sqlsrv_errors());
	
	} else {	
	    try {

//			sqlsrv_query($conn, 'SET NAMES cp1251');

			$getResults=sqlsrv_query($conn, $sql, $params);
			if(!$getResults)
				$res='Ошибка выполнения запроса: '.FormatErrors1(sqlsrv_errors());
			else {
				$res=array();					
				while($arrayResult = sqlsrv_fetch_array($getResults, SQLSRV_FETCH_ASSOC)) {
				    if ($arrayResult !== false) {
				        array_push($res, $arrayResult);
				    }
				}
				sqlsrv_free_stmt($getResults);
			}				
		} catch (Exception $e) {
		    $res = 'Exception: '.$e->getMessage();
		}		
	}

	try{
	sqlsrv_close($conn);		
	} catch (Exception $e) {
	    $res = 'Exception: '.$e->getMessage();
	}		

	return $res;
}





/// сборка ответа в единообразный json
function GetResultJSON( $data, $ok, $token ){
//
// $array = ['€', 'http://example.com/some/cool/page', '337'];
// $bad   = json_encode($array);
// $good  = json_encode($array,  JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_NUMERIC_CHECK);

// $bad would be  ["\u20ac","http:\/\/example.com\/some\/cool\/page","337"]
// $good would be ["€","http://example.com/some/cool/page",337]
//
    return 

    	    '{ "ok": ' . json_encode($ok) . ',' .
            ' "data": ' . json_encode($data,  JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_NUMERIC_CHECK) . ',' .
            ' "token": "' . $token . '"' .
            '}';

/*
        iconv(
        	'cp1251', 
        	'UTF-8', 
    	    '{ "ok": ' . json_encode($ok) . ',' .
            ' "data": ' . json_encode($data,  JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_NUMERIC_CHECK) . ',' .
            ' "token": "' . $token . '"' .
            '}'
        );
*/
}





function ClearUp( $input_text ){
/// чистим входящие строки запросов от потенциальной зловредности

	$input_text = trim($input_text);
	$input_text = strip_tags($input_text);
	$input_text = htmlspecialchars($input_text);
	return $input_text;
}





function FormatErrors1( $errors )  
{  
    $res = '<br>';  
  
    foreach ( $errors as $error )  
    {  
        $res=$res." SQLSTATE: ".$error['SQLSTATE']."<br>";  
        $res=$res." Code: ".$error['code']."<br>";  
        $res=$res." Message: ".$error['message']."<br>";  
    } 
	return $res; 
}





function ValidToken( $token ){
/// проверка токена на валидность. токен - разовый ключ доступа залогиненого пользователя
/// проверка валидности проводится простым поиском по текущим токенам всех пользователей.
/// если не обнаружен - возвращаем пустой. это автоматом разлогинивает пользователя, поскольку
/// токен является усторевшим или скомпромитированным (например, злобные хакеры перехватили его,
/// чтобы под текущим пользователем наворотить делов. нахрена бы это кому-то сдалось?)	

/// если обнаружен - токен валидный. генерим новый, обновляем таблицу и возвращаем. по идее, это
/// позволит отсекать несанкционированный доступ или обнаруживать его, если реальный пользователь внезапно разлогинивается
/// и при этом работает со своей машины	
	
	$result = "";

    /// получаем пользователя с данным токеном
	$data = ExecQuery1( "SELECT id FROM web_Users WHERE token like ?", array( $token ), NFT_DATABASE, NFT_UID, NFT_PWD );

    /// найден - обновляе6м и возвражаем актуальный
    if (is_array($data) && (count($data) > 0) ) { 
  
        $result = $token;
        // с таким подходом токен постоянный

//     	$result = GUID(); 
//      ExecQuery( "UPDATE web_Users SET token = ? WHERE id = ?", array( $result, $data[0]['id'] ), NFT_DATABASE, NFT_UID, NFT_PWD );
// убрано, поскольку смена токена при каждой операции приводит к коллизии при асинхронных обращениях

    } 

    return $result;
}



function GetPWD( $email ) {
/// криптуем значение, но результат слишком длинный и сложный для пароля, который можно ввести вручную. берем только 5 символов из него.
/// с солью 'GMS', два первых символа всегда будут GM. их игнорим.
	$pwd = crypt( $email, 'GMS');
	return substr( $pwd, 2, 5);
}


function GUID()
/// генерация псевдо-GUID для разовой идентификации пользователя. после каждого запроса возвращается новый GUID, который
/// является ключем для следующей операции. что как-бы должно повышать безопасность системы... я не знаю.
{
    return sprintf('%04X%04X%04X%04X', mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535), mt_rand(0, 65535));
}


?>

