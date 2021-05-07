<template>
  <div>
      <h1>Панель администратора</h1>
      <h3>Доступ к программам</h3>
      Пользователь <select v-model="userID" @change="onUserSelect()">
         <option value="0"></option>
         <option v-for="(item, index) in userList" :value="item.user_id" >{{item.email}}</option>
      </select>
      <div class="table progs">
          <div class="row" :class="{params: item.flag}" v-for="(item, index) in progList">
              <div class="cell progname">{{item.name}}</div>
              <input type="checkbox" name="" :checked="item.flag" @change="onChange(index)">
              <div v-if="item.flag">
                  <div v-for="(name, n_index) in item.Names">
                      <input type="checkbox" name="" :checked="item.Values[n_index]" @change="onChangeParam(index, n_index)">
                      <div>{{name}}</div>
                  </div>
              </div>
          </div>
      </div>
      <button @click="onSave()" :disabled="inSaveProcess" v-if="progList.length > 0">Сохранить настройки</button>
      <h3>Регистрация нового пользователя</h3>
      Логин: <input type="text" v-model="login">
      Рабочий E-mail: <input type="text" v-model="email">
      <button @click="onRegisterUser()">Зарегистрировать</button>
	</div>
</template>


<style>
    .progs {
      margin: 30px 0;
    } 
    .progs .row{
        display: grid;
        grid-template-columns: 1fr 1fr;
        grid-column-gap: 20px;
        text-align: right;
    }
    .progs .row.params div:nth-child(3){
        grid-row-start: 2;
        grid-column-start: 1;
        grid-row-end: 2;
        grid-column-end: 3;    
        text-align: center;    
    } 
    .progs .row.params div:nth-child(3) div{
        display: inline-block;
        margin-right: 10px;
    }
    .progname{
        font-weight: bold;
        color: #30a1aa;
    }

</style>

<script>

export default {
  data(){
      return{
          userList: {},
          progList: {},  /// возвращаемый из базы набор полей: id, name, link_id, flag, Params, ParamValues
                         /// дополнительное вычисляемые поля Names, Values - массивы одинакового размера, получаемые
                         /// из строки параметров (Params) которая содержит склеенный массив имен параметров.
                         /// при разборе имена попадают в массив Names на основе которого будет создан набор чекбоксов
                         /// для установки/снятия параметра, а обработчик чекбоксов меняет значения в массиве Values
                         /// которые при сохранении будут строкой переданы на сервер для обработки (наруливания указанных параметров в настройках программы)

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

                      /// добавляем поля с вычисляемыми массивами для формирования и функционирования набора чекбоксов
                      for( let i = 0; i < this.progList.length; i++) {

                          if (this.progList[i].Params) {
                              /// получаем имена параметров
                              this.progList[i].Names = this.progList[i].Params.split( '/' );
                              
                              /// получаем значения параметров (в виде строк)
                              if (this.progList[i].ParamValues) {

                                  this.progList[i].Values = this.progList[i].ParamValues.split( ',' );  

                                  /// превращаем строки в числа, чтобы корректно расставились флажки
                                  for( let val = 0; val < this.progList[i].Values.length; val++ ){ 
                                        this.progList[i].Values[val] = +this.progList[i].Values[val]; 
                                  };

                              } else {

                                  this.progList[i].Values = [];
                                  this.progList[i].Values.length = this.progList[i].Names.length;

                                  for( let val = 0; val < this.progList[i].Values.length; val++ ){ 
                                      this.progList[i].Values[val] = 0; 
                                  };
                              };
                          }
                      }
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

                      // добавляем доступ к телефонному справочнику
                      this.$store.dispatch(
                          'ServerRequest', 
                          { 
                              method: "updateProgLinks",
                              create: [1],
                              delete: [],
                              user: this.userID,
                              params: "",
                              callback: (data, error) => { if (error) { console.log(error); } }
                          }
                      );


                  }
              }
          );
      },

      /// приклике по чекбоксу, меняем значение флага привязки с 1 на 0 или обратно
      /// установленный флаг указывает на то, что привязка актуальна
      onChange(index){
          this.progList[index].flag = 1 - this.progList[index].flag;  
      },

      onChangeParam(index, param){
          this.progList[index].Values[param] = 1 - this.progList[index].Values[param];  
      },

      /// при сохранении формируем списки связок на удаление или создание
      /// это определяется сочетанием знаяений link_id и flag
      /// link_id <> 0, flag = 1 - без изменений
      /// link_id  = 0, flag = 1 - создаем привязку 
      /// link_id <> 0, flag = 0 - удаляем привязку
      onSave(){

          let toDelete = [];  /// массив link_id, которые нужно будет удалить
          let toCreate = [];  /// массив program_id для которых нужно создать связки


          /// собираем значений строку по всем программам
          let params = ''; /// строка со значениями параметров всех программ
          let comma = '';
          this.progList.forEach((item) => {
              
              /// первый элемент строки параметров - id программы
              if (item.Values) {
                  item.Values.unshift(item.id);
              } else {
                  item.Values = [];
                  item.Values[0] = item.id;
              }

              params = params + comma + item.Values.join(',');
              comma = ';';

              item.Values.shift();

          });


          /// перебираем массив программ для текущего пользователя и находим элементы для удаления/добавления

          this.progList.forEach((item) => {
              if ((item.link_id == null) && (item.flag == 1)) toCreate.push( item.id );
              if ((item.link_id !== null) && (item.flag == 0)) toDelete.push( item.link_id );
          });
          
          console.log('params: ' + params);
          console.log('params: ' + (toCreate || []).join(',') );
          console.log('params: ' + (toDelete || []).join(',') );

          /// если состояние не отличается от исходного - выходим
//          if ((toCreate.length == 0) && (toDelete.length == 0)) return;

          /// блокируем кнопку сохранения для исключения спама
          this.inSaveProcess = true;

          this.$store.dispatch(

              'ServerRequest', 
              { 
                  method: "updateProgLinks",
                  create: (toCreate || []).join(','),
                  delete: (toDelete || []).join(','),
                  user: this.userID,
                  params: params,

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
