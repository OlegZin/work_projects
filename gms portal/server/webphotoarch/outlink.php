<?php 

require_once "tools.php";

function GetUserID( $token ){

    // получаем данные пользователя из базы портала
    $data = ExecQuery1( "SELECT user_id, email FROM web_Users WHERE token like ?", array( $token ), NFT_DATABASE, NFT_UID, NFT_PWD );

    // есть ли данные по пользователю?
    if (!is_array($data) || (count($data) == 0)) { return; }


    // сопоставляем и получаем данные пользователя из фотоархива
    $data = ExecQuery1( "SELECT UserLogin, UserPass FROM PhotoArchAccess WHERE UserEmail like ? OR empl_id = ?", 
    	        array( $data[0]['email'], $data[0]['user_id'] ), FILE_DATABASE, FILE_UID, FILE_PWD );

    if (!is_array($data) || (count($data) == 0)) { return; }

    $data[0]['UserPass'] = base64_decode($data[0]['UserPass']);

    return $data;
}


?>

