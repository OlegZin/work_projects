<template>
	<div id="login-form">
        <div v-if="this.error !== ''">
        	<p class="error">{{error}}</p>
        </div>
        <div><img src="./../assets/logo_gms.jpg"></div> 
		<div class="screen" v-if="state == 0">
			<div id="login">
		        <h4>Логин</h4>
				<input type="text" v-model="login" >
			</div>
			<div id="pwd">
		        <h4>Пароль</h4>
				<input type="password" v-model="pwd" >
			</div>
			<button @click="onLogin">Войти</button>
			<button class="first" @click="toScreen(1)">Регистрация</button>
			<button @click="toScreen(2)">Восстановить пароль</button>
		</div>

		<div class="screen" v-if="state == 1">
			<div id="login">
		        <h4>Логин</h4>
				<input type="text" v-model="login" >
			</div>
			<div id="email">
		        <h4>E-mail</h4>
				<input type="text" v-model="email" >
			</div>
            <p>Пароль будет сгененрирован автоматически и выслан на указанный e-mail.</p>
            <p>Используйте свой рабочий e-mail, чтобы система смогла вас идентифицировать и дать доступ к программам.</p>
			<div><button @click="onRegister">Регистрация</button></div>
			<div><button class="first" @click="toScreen(0)">На главную</button></div>
        </div>

		<div class="screen" v-if="state == 2">
            <p>Укажите ваш e-mail, который был указан Вами при регистрации, для получения нового пароля:</p>
			<div id="email">
				<input type="text" v-model="email" >
			</div>
			<button @click="onRestore">Получить</button>
			<button class="first" @click="toScreen(0)">На главную</button>
		</div>

		<div v-if="state == 3">
            <p>Новый пароль был выслан на указанный e-mail. Используйте его для входа в систему.</p>
			<button class="first" @click="toScreen(0)">На главную</button>
		</div>

	</div>
</template>

<script>
    const axios = require('axios');

	export default {
        data() {
        	return {
	        	login: "",
	        	pwd: "",
	        	email: "",
	        	error : "",         	/// текущая ошибка, отображаемая на странице
	        	state: 0,  
                // текущий режим отображения формы логина:
	        	// 0 - логин, 1 - регистрация, 2 - форма восстановления пароля, 3 - ожидание ввода кода подтверждения с мыла
            }
        },
        methods: {
        	onLogin() { 
        		this.error = '';
				
				/// отсекаем очевидные ошибки чтобы не делать очевидно провальный запрос к серверу
				if (this.login === "") { this.error = 'Не указан логин'; }
				if (this.pwd === "") { this.error = 'Не указан пароль'; }

				if (this.error !== '') { return; }
                
                var _this = this; // сохраняем контекст для вызова колбека при удачном логине

                onRequest(
                	{   
                		method: "login",
			            login: this.login,
			            pwd: this.pwd
                    },
                    function( error, data ){ 	
                    	
                    	console.log('onLogin:');
                    	console.log(error);
                    	console.log(data);
                    	console.log('---------');

                    	if ( error !== "" ) {
                    		_this.error = error;
                    	} else {
				        	_this.$store.dispatch('setToken', data.token); 
				        	_this.$store.dispatch('setFio', data.data[0]); 
				        	_this.$store.dispatch('setAdmin', data.data[1]); 

		    		    	/// обновляем страницу исходя из того, что токен получен.
		    		    	/// у vue нет реактивности на значение в localstorage
		    		    	window.location.reload(); 
                    	}
                    });
        	},

            /// пользователь регистрируется,введя логин и e-mail для получения пароля
        	onRegister() {
        		this.error = '';
        		this.$store.dispatch('setFio', '');

				/// отсекаем очевидные ошибки чтобы не делать очевидно провальный запрос к серверу
				if (this.login === "") { this.error = 'Не указан логин'; }
				if (this.email === "") { this.error = 'Не указан e-mail'; }

				if (this.error !== '') { return; }

				var _this = this;

                onRequest(
			        {
			            method: "register",
			            login: this.login,
			            email: this.email,
			            url: process.env.VUE_APP_WEB,
                    },
			        function( error, data ){

                    	console.log('onRegister:');
                    	console.log(error);
                    	console.log(data);
                    	console.log('---------');

			        	if ( error !== "" )	{
			        		_this.error = error;
			        	} else {
				        	_this.$store.dispatch('setFio', data.data);
				        	_this.toScreen(3);
   				        }
			        }
				);
        	},

            /// пользователь регистрируется,введя логин и e-mail для получения пароля
        	onRestore() {
        		this.error = '';

				/// отсекаем очевидные ошибки чтобы не делать очевидно провальный запрос к серверу
				if (this.email === "") { this.error = 'Не указан e-mail'; return; }

                /// сохраняем контекст для вызова колбека
                var _this = this;
                
                console.log(this.email);
                console.log(process.env.VUE_APP_WEB);

                onRequest(
                	{   method: "restore",
			            email: this.email,
                        url: process.env.VUE_APP_WEB
                    },
                    function( error, data ){ 	
                    	if ( error !== "" ) {
                    		_this.error = error;
                    	} else {
                        	console.log('Restored!');
                        	console.log(data.data);
	                    	_this.$store.dispatch('setFio', data.data);
					       	_this.toScreen(3);
				       }
                    }
                );
        	},

			toScreen( index ) {
			    this.error = '';
				this.state = index;
			}
        }
	};    


	/// общая функция выполнения запроса с возвратом ошибки, если была
	function onRequest( params, callback ) {
		
		axios({
	        method: 'get',
		    url: process.env.VUE_APP_URL,
	        params: params
	    })
			.then(response => {

            /// проверка на наличие поля, присутствующего в корректном возвращаемом значении 
            if ( response.data.ok !== undefined ) {

            	if ( response.data.ok === true ) {
    				
		        	callback('', response.data);
           	
            	} else {
            		/// при неудачном логине показываем ошибку обракботчика
            		callback(response.data.data);
            	}

            } else {
                callback('Ошибка обращения к серверу. Попробуйте еще раз или обратитесь к администратору, не закрывая эту страницу.');
                console.log(response);
            }

		})
		.catch( error => {
            callback('Ошибка обращения к серверу. Попробуйте еще раз или обратитесь к администратору, не закрывая эту страницу.');
			console.log(error);
		})
	}

</script>

<style>

.error{
	color: red;
}	
#login-form{
	text-align: center;
}
#login-form button, #login-form input{
	width: 300px;
	text-align: center;
}
#login-form button{
	margin-top: 20px;
}
.screen{
	display: block;
	margin: 0 auto;
	width: 300px;
}
#login-form input{
	font-size: 100%;
}
#login-form button.first{
	margin-top: 50px;
}

</style>