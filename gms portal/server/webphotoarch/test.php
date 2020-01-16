<?php 

/// настройки доступа к базам данных 
define("SERVER", "server-htm.ntm.grouphms.local");

define("NFT_DATABASE", "nft_test_15092019");
define("NFT_UID",      "UserProgNFT");
define("NFT_PWD",      "H6v92InV");


	$connectionOptions = array(
	    "Database" => NFT_DATABASE,
	    "Uid"      => NFT_UID,
	    "PWD"      => NFT_PWD
	);
	
	$conn = sqlsrv_connect(SERVER, $connectionOptions);		


?>

