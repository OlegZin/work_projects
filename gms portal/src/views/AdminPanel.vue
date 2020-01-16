<template>
  <div>
      <h1>Панель администратора</h1>
      <h3>Доступ к программам</h3>
      Пользователь <select v-model="userID" @change="onUserSelect()">
         <option value="0"></option>
         <option v-for="(item, index) in userList" :value="item.user_id" >{{item.email}}</option>
      </select>
      <div class="table progs">
          <div class="row" v-for="(item, index) in progList">
             <div class="cell">{{item.name}}</div>
             <input type="checkbox" name="" :checked="item.flag" @change="onChange(index)">
          </div>
      </div>
      <button @click="onSave()" :disabled="inSaveProcess" v-if="progList.length > 0">Сохранить настройки</button>
      <h3>Регистрация нового пользователя</h3>
      Логин: <input type="text" v-model="login">
      Рабочий E-mail: <input type="text" v-model="email">
      <button @click="onRegisterUser()">Зарегистрировать</button>
	</div>
</template>


<script>

export default {
  data(){
      return{
          userList: {},
          progList: {},
          userID: 0,
          inSaveProcess: false,
          login: '',
          email: '',
      } 
  },
  computed: {
      //list() { return this.$store.state.programAdminList }
  },

  methods:{

      /// при выборе пользователя получаем список программ с текущими флагами доступности
      onUserSelect(){
          
          this.$store.dispatch(

              'ServerRequest', 
              { 
                  method: "getUserProgList",
                  user_id: this.userID,

                  callback: (data) => { 

                      this.progList = data;     
                  }
              }
          );
      },


      /// регистрация нового пользователя
      onRegisterUser(){

          this.$store.dispatch(

              'ServerRequest',

              {
                  method: "register",
                  login: this.login,
                  email: this.email,
                  url: process.env.VUE_APP_WEB,
                  callback: (data) => {

                      this.email = '';
                      this.login = '';
                      this.getUsers();

                  }
              }
          );
      },

      /// приклике по чекбоксу, меняем значение флага привязки с 1 на 0 или обратно
      /// установленный флаг указывает на то, что привязка актуальна
      onChange(index){
          this.progList[index].flag = 1 - this.progList[index].flag;  
      },

      /// при сохранении формируем списки связок на удаление или создание
      /// это определяется сочетанием знаяений link_id и flag
      /// link_id <> 0, flag = 1 - без изменений
      /// link_id  = 0, flag = 1 - создаем привязку 
      /// link_id <> 0, flag = 0 - удаляем привязку
      onSave(){

          let toDelete = [];  /// массив link_id, которые нужно будет удалить
          let toCreate = [];  /// массив program_id для которых нужно создать связки

          /// перебираем массив программ для текущего пользователя и находим элементы для удаления/добавления

          this.progList.forEach((item) => {
              if ((item.link_id == null) && (item.flag == 1)) toCreate.push( item.id );
              if ((item.link_id !== null) && (item.flag == 0)) toDelete.push( item.link_id );
          });
          
          /// если состояние не отличается от исходного - выходим
          if ((toCreate.length == 0) && (toDelete.length == 0)) return;

          /// запускаем на сервере метод обновления привязок
          this.inSaveProcess = true;

          this.$store.dispatch(

              'ServerRequest', 
              { 
                  method: "updateProgLinks",
                  create: (toCreate || []).join(','),
                  delete: (toDelete || []).join(','),
                  user: this.userID,

                  callback: (data, error) => { 

                       if (error) {

                          console.log(error);

                       } else {

                          /// получае6м обновленные данные и перестраиваем список
                          this.onUserSelect();
    
                          /// делаем доступной кнопку сохранения изменений
                          this.inSaveProcess = false;

                       }

                  }
              }
          );

      },

      getUsers(){
          /// при подключении компонента получаем список зарегистрированных пользователей
          this.$store.dispatch(

              'ServerRequest', 
              { 
                  method: "select",
                  table: "web_Users",

                  callback: (data) => { 

                      this.userList = data; 
                  }
              }
          );
      },
  },

  mounted(){
      this.getUsers();
  }
}
</script>

<style>
    .progs {
      margin: 30px 0;
    } 
    .progs .row{
        display: grid;
        grid-template-columns: 1.5fr 1fr;
        grid-column-gap: 20px;
        text-align: right;
    }
</style>
