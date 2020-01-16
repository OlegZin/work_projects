import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

const axios = require('axios');

export default new Vuex.Store({
  state: {
      fio: "",
      /// имя текущего залогиненого пользователя

      token: "",
      /// легкодоступный текущий токен для обеспечения реактивности (совпадает с хронящимся в localstore)


      
      programs: {},  /// список доступных программ, загруженный с сервера, с учетом прав доступа

      /// данные для отображения, если доступных программ нет (ошибка сервера или нет прав)
      programs_empty: [{
      	name: "Программы не доступны", 
      	detail: "У вас нет доступных программ или сервер базы данных не доступен. Повод немного отдохнуть. Обратитесь к администратору.", 
      	icon: "prog_icon"
      }],



      news: {}, /// список новостей

      /// данные для отображения поумолчанию, если новости отсутствуют или проблема с сервером
      news_empty: [{
      	date: new Date(), 
        name: "Новости отсутствуют",
        detail: "Жизнь скучна и однообразна или отсутсвует связь с сервером. Обратитесь к администратору или займитесь саморазвитием.",
      	icon: "news_icon"
      }],
  },

  getters: {
      getToken( state ) {
          var val = localStorage.getItem('token') || "";
          state.token = val;
          return val
      },
      getFio( state ) {
          return localStorage.getItem('fio') || "";
      },
      getAdmin( state ) {
          return localStorage.getItem('admin') || "";
      },

  },

  actions: {
      setToken( context, a_token ) {
          localStorage.setItem('token', a_token);
          context.state.token = a_token;
      },
      removeToken( context ) {
          localStorage.removeItem('token');
          console.log('token removed!');
      },

      setFio( context, _fio ){
          localStorage.setItem('fio', _fio); 
      },
      removeFio( context ) {
          localStorage.removeItem('fio');
      },

      setAdmin( context, _admin ){
          localStorage.setItem('admin', _admin); 
      },
      removeAdmin( context ) {
          localStorage.removeItem('admin');
      },



      getProgsData( context ){
          context.dispatch(
              'ServerRequest', 
              {
                  method: "selectProgList", 
                  callback: (data) => { context.state.programs = data; }
              }
          );          

      },

      getNewsData( context ){
          context.dispatch(
              'ServerRequest', 
              {
                  method: "select",
                  table: "web_News",
                  callback: (data) => { context.state.news = data; }
              }
          );          
      },

      /// универсальный метод запроса к серверу. обрабатывает возвращаемый массив данных или строку ошибки
      ServerRequest( context, params ){

          params.token = context.getters.getToken;
          var callback = params.callback;
          delete params.callback;

          axios({
              method: 'get',
              url: process.env.VUE_APP_URL,
              params: params
          })
          .then(response => {

              if ((response.data.ok !== undefined) && response.data.ok) {
                  context.dispatch('setToken', response.data.token);  
                  if (callback) callback(response.data.data);        
              } else {
                /// показываем текст ошибки
                console.log('ERROR: ' + response.data.data);
                if (callback) callback('', response.data.data);        
              }

          })
          .catch(function (error) {
              console.log(error);
          }); 

      },





      TryPostRequest( context ){
      
      // https://toster.ru/q/623962 - post-запросы axios
      // axios.post('aaa.php?action=create', 'myvalue=строка&sub=ahaha&value=22')
      //  .then(function(response) {
      
//          axios.post( process.env.VUE_APP_URL, 'method=test&token=' + context.getters.getToken )
          axios.post( process.env.VUE_APP_URL, 'method=test' )
          .then(response => { console.log(response); })
          .catch(function (error) { console.log(error); }); 
      },

      TryGetRequest( context ){
      
          axios.get( process.env.VUE_APP_URL, { params: { method: "test", token: context.getters.getToken }} )
          .then(response => { console.log(response); })
          .catch(function (error) { console.log(error); }); 
      },
  }
})
