<?php
/*
   Доработка от 24.10.2019
   Автор: 
       Зиновьев О.Н.
   Изменения:
       - В форму добавления видео на сайт добавлен альтернативный формат фидеофайла: video/3gpp2 для устарения проблем загрузки с устаревшего планшета
       - Добавлена поддержка будущего автоматического входа из ГМС-портала: c GET параметром method=outlink&token=xxxxxxxxxx. 
         Реализация функции поддерживается двумя дополнительными скриптами outlink.php и tools.php
*/
	require_once "functions.php";		
	require_once "outlink.php";

	if ($_SERVER['REQUEST_METHOD'] == 'GET') {
		//если нажали кнопку "Выход"
		if (isset($_GET['logout'])) {
			Authenticate('nobody', '');
			header("Location: login.php");
			exit ;
		}
	}
	
	if (!isset($_SESSION)) {
		session_start();
		if (!isset($_SESSION['CurZav']))
			$_SESSION['CurZav'] = '';
		if (!isset($_SESSION['CurFolderId']))
			$_SESSION['CurFolderId'] = 0;
		if (!isset($_SESSION['Crumbs']))
			$_SESSION['Crumbs'] = '';
		if (!isset($_SESSION['Objects']))
			$_SESSION['Objects'] = '';
		if (!isset($_SESSION['ZavNumBlocks']))
			$_SESSION['ZavNumBlocks'] = array();
		if (!isset($_SESSION['CheckboxesState']))
			$_SESSION['CheckboxesState'] = array(0,0,array());
		if (!isset($_SESSION["tipAccess"]))
			$_SESSION["tipAccess"]=0;
	}	
	
	// если вызов из ГМС портала, программе передан токен по которому можно идентифицировать пользователя
    if ( isset($_GET['method']) && $_GET['method'] === 'outlink') {

        if ( isset($_GET['token']) && $_GET['token'] !== '') {

        	$UserData = GetUserID($_GET['token']);

        	if (is_array($UserData)) {

                Authenticate($UserData[0]['UserLogin'], $UserData[0]['UserPass']);
            }
        	
        } 
    }

	//проверка авторизации
	if (!isset($_SESSION["user_id"])) {
		header("Location: login.php");
		exit ;
	}

?>
<!DOCTYPE html>
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">

		<script src="js/jquery-3.2.1.min.js"></script>
		<script src="js/tether.min.js"></script>
		<script src="js/bootstrap.min.js"></script>
		<script src="js/FileSaver.js"></script>	
		<script src="js/Base64EncDec.js"></script>
		<script src="js/photoarch.js"></script>				
		
		<link href="css/bootstrap.min.css" rel="stylesheet">
		<link href="css/glyphicons.css" rel="stylesheet">
		<link rel="stylesheet" type="text/css" href="css/mycss.css">
		<link rel="stylesheet" href="css/jquery.fancybox.min.css">
		
		<style>	        
	        .breadcrumbs > li + li:before {
				color: #cccccc;
				content: "/";
				padding: 0 5px;
			}
	    </style>

		<title>Фотоархив АО "ГМС Нефтемаш"</title>
	</head>	
	<body>
		<?php			
			$_SESSION['ZavNumBlocks']='';
			
			if ((isset($_SESSION['CurFolderId'])) && ($_SESSION['CurFolderId']!=0)) {
				$_SESSION['Crumbs'] = '';	
				$_SESSION['Objects'] = '';

				$SqlData=ListCurDir(2);
				if (!is_array($SqlData)) {
					print("<script> modalError('Ошибка получения списка файлов и папок.', '$SqlData');</script>");
				} else {
					//если в иерархии только заводской номер - не отображаем хлебные крошки	
					if (strpos($SqlData[0]['hyer'],'/')!==false) {
						//выстраивам "хлебные крошки"		
						$dt=explode('/', $SqlData[0]['hyer']);
						$cnt=count($dt);
						$CrumbPath='';
						
						$_SESSION['CurZav']=str_replace('_','/',$dt[0]);						
						if ($_SESSION['tipAccess']==1)
						{
							//получаем список блоков изделий заводского номера
							$BlocksData=ExecQuery('exec nft.dbo.PHA_GetZavNumBlocks ?',array($_SESSION['CurZav']));
							if (!is_array($BlocksData)) {
								print("<script> modalError('Ошибка получения списка блоков изделия.', '$BlocksData');</script>");
							} else {
								$_SESSION['ZavNumBlocks']=$BlocksData;
							}
						}
						
						$_SESSION['Crumbs']="<ol class='breadcrumb'>";
						foreach ($dt as $ind=>$value) {
							$CrumbPath=$CrumbPath.$value.'/';
							
							if (++$ind==$cnt) {
								$_SESSION['Crumbs']=$_SESSION['Crumbs']."<li class='active'>$value</li>";
							} else {
								$_SESSION['Crumbs']=$_SESSION['Crumbs']."<li><a href='#' class='crumbfoldpath' data-crumbfolder='$CrumbPath'>$value</a></li>";
							}
						}
						$_SESSION['Crumbs']=$_SESSION['Crumbs']."</ol>";
					}

					$CheckBox='';
					if ($_SESSION['CheckboxesState'][0]!=1) {
						$CheckBox='hidden';
					}
					
					//пройдёмся по всем записям, записывая их в переменную объектов
					foreach ($SqlData as $row) {
						if ($row['id']!='') {
							$rowdata=implode('‰',array($row['id'],$row['Naim'],$row['Is_folder'],$row['Comment'],$row['ChCnt']));
							//если это каталог	
							if ($row['Is_folder']) {	
								$_SESSION['Objects']=$_SESSION['Objects']."
									<div class='col-md-2 col-sm-3 col-xs-4 thumbnail' align='center' style='margin-bottom:10px;margin-right:10px;'>
										<input type='checkbox' $CheckBox style='float:right; transform:scale(1.5, 1.5);' id="."'ObjId_".$row['id']."'".">
						            		<a class='subfolder' data-subfolddata='$rowdata' href='#'>
						            			<img class='img-fluid' src='pic/folder.png' height='50%' width='50%' alt=''>${row['Naim']}			            			
						            		</a>
					        		</div>";
							} else {
								$filetype=pathinfo($row['Naim'])['extension'];								
								//если это jpeg - рисуем миниатюру	
								if (($filetype=='jpeg') || ($filetype=='jpg') || ($filetype=='JPEG') || ($filetype=='JPG')) {
									$rowdata=$rowdata.'‰1';
									$filedata=GetPicBase64($row['file_stream']);
										
									$_SESSION['Objects']=$_SESSION['Objects']."
										<div class='col-md-2 col-sm-3 col-xs-4 thumbnail' align='center'  style='margin-bottom:10px;margin-right:10px;'>
											<input type='checkbox' $CheckBox style='float:right; transform:scale(1.5, 1.5);' id="."'ObjId_".$row['id']."'".">
						            		<a class='fileobj' data-filedata='$rowdata' data-toggle='modal' data-target='#WorkWithFileForm' href='#'>
						            			<img class='img-fluid' src='$filedata' height='50%' width='50%' alt=''>${row['Naim']}														            			
						            		</a>
						        		</div>";
								} else {
									$rowdata=$rowdata.'‰0';
									$_SESSION['Objects']=$_SESSION['Objects']."
										<div class='col-md-2 col-sm-3 col-xs-4 thumbnail' align='center' style='margin-bottom:10px;margin-right:10px;'>
											<input type='checkbox' $CheckBox style='float:right; transform:scale(1.5, 1.5);' id="."'ObjId_".$row['id']."'".">
						            		<a class='fileobj' data-filedata='$rowdata' data-toggle='modal' data-target='#WorkWithFileForm' href='#'>
						            			<img class='img-fluid' src='pic/file.bmp' height='50%' width='50%' alt=''>${row['Naim']}		            			
						            		</a>
						        		</div>";
								}
							}
						}
					}
				}	
		
		
				if ($_SESSION['Objects']!='')
					$_SESSION['Objects']="<div class='row' style='display: flex; flex-flow: row wrap;'>".$_SESSION['Objects']."</div>";		
			}
		?>	
			
		<div class='container-fluid'>
			<div class="row">
				<div class="col-md-10 col-sm-10 col-xs-10">
					<h3 align="center">Фотоархив АО " ГМС Нефтемаш " </h3>
				</div>
				<div class="col-md-2 col-sm-2 col-xs-2">
					<div style="float: right">
						<?=$_SESSION["user_fio"] ?><a href="index.html">   </a>

						<div class="dropdown">
							<button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown">
								<span class="glyphicon glyphicon-th"></span> Меню
							</button>
							<ul class="dropdown-menu dropdown-menu-right">
								<li>
									<a data-toggle='modal' data-target='#ReqDocsForm' href="#" class="ReqDocsBtn">Заказанные документы</a>
								</li>
								<li>
									<a data-toggle='modal' data-target='#ChangePassForm' href='#'>Сменить пароль</a>
								</li>
								<li>
									<a href="?logout">Выход</a>
								</li>
							</ul>
						</div>
					</div>
				</div>				
			</div>

			<div >
				<div >
					<form method="post" id="ZavNumForm" >
						<div style="float: left;"  >
						<div style="margin-left:15px; margin-bottom:15px">
							<?php				
								$SqlData=SpisokTip();
								$ch='checked';
								foreach ($SqlData as $row) 
								{
									if ($row['id']==$_SESSION["tipAccess"]) {$ch='checked';}
									print("<input  type='radio' style='margin-left:10px;' name='tip' ".$ch." value=".$row['id']." /><label style='margin-left:5px; font-weight:normal;'>".$row['naim']."</label>");
									$ch='';
								}
							?>
						</div>
						<div class="col-lg-2 col-md-3 col-sm-4">
						<div class="input-group" >
							<input class="form-control"   name="ZavNum" id="zav"   value="<?=$_SESSION['CurZav'] ?>" required>
							<span class="input-group-btn" >
								<button class="btn btn-default" id="SelZavNumBtn" Margin="5">
									Выбрать
								</button>	
							</span>
						</div>
						</div>
						<label style="float: left; margin-left:10px; font-weight: normal; " >
							<?php echo GetName() ?>
						</label>	
						</div>			
					</form>
				</div>
														
			</div>
		</div>
		<br>
		<div class='container-fluid' style="margin-left:15px">
			<!-- Отображаем путь до текущей папки -->		
			<?=$_SESSION['Crumbs']?>
			
			<!-- Если выбрана какая-либо папка - позволяем работать с ней -->
			<?php
				if ((($_SESSION['Crumbs'] != '') || ($_SESSION['tipAccess']==2)) && ($_SESSION["user_acclevel"]==1) && ($_SESSION['CurZav']!=='')) {
					print " 
						<div class='container col-md-2 col-sm-2 col-xs-2' style='margin-left:-15px;'>									
							<button class='btn btn-default col-md-12 col-sm-12 col-xs-12' data-toggle='modal' data-target='#MakeFolderForm' title='Создать новую папку'>
								<img src='pic/newfolder.png' /></button>						
							<button class='btn btn-default col-md-12 col-sm-12 col-xs-12' data-toggle='modal' data-target='#ImportFilesForm' title='Загрузить файл'>
								<img src='pic/upload.png' /></button>	
							<div class='col-md-12 col-sm-12 col-xs-12' style='padding-left:0px; padding-right:0px' id='WorkWithSelection'>";
					
					//если ещё не выбирали позиции для переноса или экспорта
					if ($_SESSION['CheckboxesState'][0]==0) {
						print "<button class='btn btn-default col-md-12 col-sm-12 col-xs-12' title='Выбрать файлы и папки' onclick='SelectDownloadFiles();'>
								   <img src='pic/filecheck.png' /></button>
							   </div>";
					} else {
						$ExportLi='';
						$PasteLi='';
						$CutLi='';
						//если начали выбирать позиции		
						if ($_SESSION['CheckboxesState'][0]==1) {
							$PasteLi="class='disabled'";
						}
						
						//если уже нажали кнопку "Вырезать"		
						if ($_SESSION['CheckboxesState'][0]==2) {
							$ExportLi="class='disabled'";
							$CutLi="class='disabled'";
						}
						
						print " <button class='btn btn-default dropdown-toggle' style='width:100%' type='button' data-toggle='dropdown' title='Выбрать файлы и папки'>
									<table><tr><td><img src='pic/paste.png' /></td><td style='padding:0px 20px'>Выбрать файлы и папки</td></tr></table></button>
								<ul class='dropdown-menu dropdown-menu-left'>
									<li $ExportLi id='ExportLi'>
										<a href='#' class='ExportSelected'>Экспортировать...</a>
									</li>
									<li $CutLi id='CutLi'>
										<a href='#' class='CutSelected'>Вырезать</a>
									</li>
									<li $PasteLi id='PasteLi'>
										<a href='#' class='PasteCutted'>Вставить</a>
									</li>
									<li>
										<a href='#' class='CancelCutExp'>Отмена</a>
									</li>
								</ul>
							</div>";						
					}
					
					print "</div>";
				}
			?>
			
			<!-- Содержимое папки -->
			<?=$_SESSION['Objects']?>
		</div>		

		<!-- Модальная форма смены пароля -->
		<div class="modal fade" id="ChangePassForm" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							&times;
						</button>
						<h4 class="modal-title">Смена пароля.</h4>
					</div>
					<form method="post">
						<div class="modal-body">
							<label for="OldPass">Текущий пароль</label>
							<input class="form-control" type="password" name="OldPass" id="OldPass" required>

							<label for="NewPass1">Новый пароль</label>
							<input class="form-control" type="password" name="NewPass1" id="NewPass1" required>

							<label for="NewPass2">Подтверждение пароля</label>
							<input class="form-control" type="password" name="NewPass2" id="NewPass2" required>
						</div>
						<div class="modal-footer">
							<div style="float: left">
								<label id="ChangePassAlertLbl" class="hidden"></label>
							</div>
							<button class="btn btn-default" name="ChangePass" id="ChangePass" type="button">
								Сменить пароль
							</button>
							<button type="button" class="btn btn-default" data-dismiss="modal">
								Отмена
							</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		
		<!-- Модальная форма фотографирования -->
		<div class="modal fade bd-example-modal-lg" id="MakePhotoForm" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<form method="post">
						<div class="modal-body" style="position:relative;">
							<video id="CamVid" width="100%" height="100%" style="border:1px solid #000000; margin: 0 auto;"></video>
							<div style="position:absolute;left:50%;transform: translateX(-50%);bottom:5vw;">
								<span id="StartStopBtn" class="btn glyphicon glyphicon-pause" style="font-size: 5vw;"></span>
								<span id="CloseFormBtn" class="btn glyphicon glyphicon-home" style="font-size: 5vw;"></span>
								<span id="SavePicBtn" class="btn glyphicon glyphicon-download-alt" style="font-size: 5vw;"></span>								
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
		
		<!-- Модальная форма создания новой папки -->
		<div class="modal fade" id="MakeFolderForm" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							&times;
						</button>
						<h4 class="modal-title">Создание новой папки</h4>
					</div>
					<form method="post">
						<div class="modal-body">
							<label for="FoldNaim">Наименование</label>
							<div class="input-group">
								<input class="form-control" type="text" name="FoldNaim" id="FoldNaim" required>
								<div class="input-group-btn">
									<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button>
					      			<ul class="dropdown-menu dropdown-menu-right">
										<?php			
											//если работаем с зав.
											if ($_SESSION['tipAccess']==1)	
											{		
												//записываем стандартные наименования папок
												print("
													<li onclick=".'"'."document.getElementById('FoldNaim').value='Технология'".'"'."><a href='#'>Технология</a></li>
													<li onclick=".'"'."document.getElementById('FoldNaim').value='Электрооборудование'".'"'."><a href='#'>Электрооборудование</a></li>
													<li role='separator' class='divider'></li>
												");
												
												//пробежимся по всем блокам и впишем их в список
												foreach ($_SESSION['ZavNumBlocks'] as $row) {
													print("<li onclick=".'"'."document.getElementById('FoldNaim').value='${row['Naim']}'".'"'."><a href='#'>${row['Naim']}</a></li>");
												}
											}
										?>
						  			</ul>
						  		</div>
					  		</div>
						</div>
						<div class="modal-footer">
							<div style="float: left">
								<label id="FolderExistsAlertLbl" class="hidden"></label>
							</div>
							<button class="btn btn-default" name="CreateFolder" id="CreateFolder" type="button submit">
								Создать папку
							</button>
							<button type="button" class="btn btn-default" data-dismiss="modal">
								Отмена
							</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		
		<!-- Модальная форма загрузки файла -->
		<div class="modal fade" id="ImportFilesForm" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							&times;
						</button>
						<h4 class="modal-title">Загрузка файлов на сервер</h4>
					</div>
					<form method="post" enctype="multipart/form-data" id="ImpForm">
						<div class="modal-body">							
							<input type="file" size="50" multiple="multiple" name="SelectedFiles[]" id="ImpFormInput" accept="image/jpeg,application/pdf,image/tiff,video/mpeg,video/mp4,video/ogg,video/3gpp,video/3gpp2">					
						
							<label for="LoadProgress" class="hidden" id="LoadProgressLbl">Загрузка...</label>
							<div class="progress hidden" id="LoadProgress">						  
								<div class="progress-bar progress-bar-info progress-bar-striped progress-bar-animated active" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" id="ProgBar"></div>
							</div>
						</div>				
						<div class="modal-footer">
							<div style="float: left">
								<label id="ImpFileAlertLbl" class="hidden"></label>
							</div>
							<button class="btn btn-default" name="ImportFiles" id="ImportFiles" type="button">
								Загрузить на сервер
							</button>
							<button type="button" class="btn btn-default" data-dismiss="modal">
								Отмена
							</button>
						</div>
					</form>
				</div>
			</div>
		</div>
		
		<!-- Текстовая форма -->
		<div class="modal fade" id="TextForm" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							&times;
						</button>
						<h4 class="modal-title">Информация</h4>
					</div>					
					<div class="modal-body">							
						<textarea class="form-control" id="InfoText" rows="10" readonly></textarea>					
					</div>				
					<div class="modal-footer">
						<button type="button" class="btn btn-default" onclick="window.location='index.php';">
							ОК
						</button>
					</div>
				</div>
			</div>
		</div>
		
		<!-- Форма подтверждения -->
		<div class="modal fade" id="ConfForm" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<input class="form-control" type="hidden" id="ConfFormMode">				
					<div class="modal-body">							
						<textarea class="form-control" id="ConfFormText" rows="10" readonly></textarea>					
					</div>				
					<div class="modal-footer">
						<button type="button" class="btn btn-default" id="ConfButton">
							ОК
						</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">
							Отмена
						</button>
					</div>
				</div>
			</div>
		</div>
		
		<!-- Модальная форма заказанных документов -->
		<div class="modal fade" id="ReqDocsForm" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							&times;
						</button>
						<h4 class="modal-title">Заказанные документы.</h4>
					</div>
					<div class="modal-body" id="ReqDocsData"></div>
				</div>
			</div>
		</div>
		
		<?php			
			$req='';
			$readonly='readonly';
			
			if ($_SESSION["user_acclevel"]==1) {
				$req='required';
				$readonly='';
			}			
			
			print "
				<div class='modal fade' id='WorkWithFileForm' role='dialog'>
					<div class='modal-dialog modal-lg'>
						<div class='modal-content'>
							<div class='modal-header'>
								<button type='button' class='close' data-dismiss='modal'>
									&times;
								</button>
							</div>
							<form method='post'>
								<div class='modal-body'>
									<input class='form-control' type='hidden' id='FileExtension'>
									<input class='form-control' type='hidden' id='FileId'>
									<img id='FullImage'><br>
									<label for='FileNaim'>Наименование</label>
									<input class='form-control' type='text' id='FileNaim' $req $readonly>
									<label for='CommentText'>Комментарий</label>							
									<input class='form-control' type='text' id='CommentText' $readonly>						
								</div>				
								<div class='modal-footer'>
									<button type='button' class='btn btn-default' id='SaveFileData'>
										Сохранить
									</button>
									<button type='button' class='btn btn-default' data-dismiss='modal'>
										Отмена
									</button>
									<button type='button' class='btn btn-default' id='DownloadThisFile'>
										Скачать файл
									</button>
								</div>
							</form>
						</div>
					</div>
				</div>";
		?>
		
		<script>
			var CamStream;
			var IsPlaying=false;
			var cam_vid=document.getElementById('CamVid');
		</script>			
	</body>
</html>