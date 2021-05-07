<template>
  <div>
    
    <div class=myphone>
      <p>Мой телефон: </p>
      <select v-model="myphoneCaption" @change="onMyPhoneChange()">
        <option v-for="item in curr_user.phones">{{item.num_str}}</option>
      </select>

    </div>  
    
    <div class = top :key="keyUpdate">
      <div v-if="conference_users.length > 0" class = confContainer> 
        <h3>Конференция</h3>
        <div id="confList">
          <div v-for="(item, index) in conference_users" class=phoneRow> 
            <div class = conference_user>
              <div class = photo><img :src="getPhoto(item.id)"></div> 
              <div class = fio>{{item.fio}}</div>
              <div class = position>{{item.name}}, {{item.full_name}}, {{item.pname}}</div>
              <div class = phoneInner>{{item.phoneCaption | number_filter}}</div>
              <div class = call v-if="conf_started" @click="doConfCall(item.num)"><img src="./../assets/phone/call.png"></div>
              <div class = remove v-if="!item.fixed && !conf_started" @click="confDelUser(index)"><img src="./../assets/phone/remove.png"></div>
            </div>  
          </div> 
        </div>
        <div class = conference_add>
          <p>Моб.:</p>
          <input type="text" v-model="custom_phone" v-phone pattern="[(][0-9]{3}[)] [0-9]{3}-[0-9]{4}">
          <div class = confAdd @click="AddCustomPhone" v-if="custom_phone.length == 11">+</div>
        </div>
        <div class = conference_bottom>
          <div class = confCall v-if="!conf_started" @click="confStart">Начать</div>
          <div class = confClear v-if="!conf_started" @click="confCancel">Отменить</div>
          <div class = confCancel v-if="conf_started" @click="confCancel">Закончить</div>
        </div>
      </div>  
      
      <div class=search>
        <p>Отдел:</p>
        <select class = department v-model="depart" @change="onDepartSelect()">
          <option v-for="item in departmens">{{item.name}}</option>
        </select>
        <input class = filter type="text" v-model="filter_value" @keyup="onFilter()" autocomplete="on">
        <img class = searchIcon src="./../assets/phone/remove.png" @click="filter_value = ''; onFilter();">
      </div>
    </div>

    <div :key="keyPhonesUpdate">
    <div v-for="item in phoneBook"  v-if="item.showing" class=phoneRow> 
      <div class = contact>
        <div class = fio>{{item.fio}}</div>
        <div class = position>{{item.name}}, {{item.full_name}}, {{item.pname}}</div>
        <PhoneList class = poneList :showMob="curr_user.name == item.name || curr_user.name == 'Дирекция'" :id="item.id" :phones="item.phones" @onCall="doCall" @onToConf="AddToConference"/>
      </div>  
    </div>
    </div>  

    <div class="placeholder" v-if="filter_value == '' || filter_value.length < 2">Начните вводить имя, отдел, должность или телефон для показа сотрудников</div>

    <div v-if="history.length > 0" :key="keyHistoryUpdate">
        <h3><img src="./../assets/phone/history.png"> История</h3>
        <div v-for="item in history"  class=phoneRow> 
          <div class = contact>
            <div class = fio>{{item.fio}}</div>
            <div class = position>{{item.name}}, {{item.full_name}}, {{item.pname}}</div>
            <PhoneList class = poneList :id="item.id" :phones="item.phones" @onCall="doCall" @onToConf="AddToConference"/>
          </div>  
        </div>
    </div>
  </div>
</template>

<script>

import PhoneList from '@/components/phone/PhoneList.vue'


export default {
  name: 'PhoneBook',
  data() {
        return {
            filter_value: "",   /// текущее значение фильтра данных
            custom_phone: "",   /// текущее значение вводимое в поле кастомного номера телевона в конференции
            
            target_user: {},    /// текущий выбранный для звонка сотрудник

            conference_users: [],    /// набор пользователей выбранных для конференции

            departmens: [],    /// список для быстрого поиска по отделам
            depart: "",

            curr_user : {},     /// ссылка на элемет массива phoneBook, где phoneBook.id = user.user_id 
            user: {}, /// данные текущего пользователя
            // [user_id],[login],[pwd],[token],[email],[isAdmin]   user_id = employees.id
            /// данные текущего телефон текущего пользователя = phoneBook.main_phone, где phoneBook.id = user.user_id 
            
            phoneBook: {},     /// данные всех контактов из телефонной книги
            // id,   fio,                      full_name,           pname,               main_phone, name
            // 4661, Зиновьев Олег Николаевич, Отдел автоматизации, Инженер-программист, 2021,       OA
        
            photoCache: {}, /// объект с загруженными фотками пользователей

            myphoneCaption: "", // активный номер телефона залогиненого пользователя в виде для показа в интерфейсе
            myphone: "", // активный номер телефона залогиненого пользователя в рабочем виде для Asterisk

            keyUpdate: 1,  /// небольшой хак для принудителной перерисовки конференции, поскольку не на все изменения массива участников реагирует v-if
            // например, на очистку массива. для принудительного обновления, после изменения массива участников нужно изменить значение этой переменной.
            keyPhonesUpdate: 2, // аналогично предыдущему но для списка телефонов
            keyHistoryUpdate: 3, // аналогично предыдущему но для списка телефонов

            history: {}, // история последних вызовов и конференций

            conf_started: false, // флаг того, что конференция запущена
        } 
  },
  components: { PhoneList },

  filters: {
    number_filter: function(value){
       if  (value.length > 7) {return 'Моб.'} else {return value};
    }
  },
  
  methods:{
      
      /// получение списка типов журналов
      doCall(empl_id, phoneNumber){
          
          console.log('Call: phoneCaller='+this.myphone);
          console.log('Call: phoneTarget='+phoneNumber);

          // созваниваемся
          this.$store.dispatch(

                  'ServerRequest',
                  {
                      method: "singlecall",
                      phone1: this.myphone,
                      phone2: phoneNumber,
                      empl_id1: this.curr_user.id,
                      empl_id2: empl_id,
 
                      callback: (data) => {
                          // получаем обновленный список истории
                          //this.history = data;

                          // вместо истории, метод возвращает лог ответов asterisk
                          console.log(data);
                      }

                  }
          );
          
      },

      AddToConference(empl_id, phoneNumber, phoneCaption){
        

          // самого себя тоже добавить нельзя
        if (empl_id == this.curr_user.id && this.conference_users.length == 0) return;

        /// проверяем, нет ли уже в конфе такого участника
        for (let i = 0; i < this.conference_users.length; i++){
          
          if (this.conference_users[i].id == empl_id){
            /// обновляем номер телефона, поскольку могли захотеть подключить его по другому
            this.conference_users[i].phoneNumber = phoneNumber;
            this.conference_users[i].phoneCaption = phoneCaption;
            return;
          }

        }


        /// если не найден - добавляем нового,
        /// но, если конференция пустая, сначала добавим самого текущего пользователя как неудаляемого участника
        let confUser = {};

        if (!this.conference_users || this.conference_users.length == 0) {
            /// заполняем данными участника конференции
            confUser.id           = this.curr_user.id;
            confUser.fio          = this.curr_user.fio;
            confUser.full_name    = this.curr_user.full_name;
            confUser.pname        = this.curr_user.pname;
            confUser.phoneNumber  = this.myphone;
            confUser.phoneCaption = this.myphoneCaption;
            confUser.name         = this.curr_user.name;
            confUser.fixed        = true;

            this.conference_users.unshift(confUser);
        }

        confUser = {};

        for (let i = 0; i < this.phoneBook.length; i++)
          if (this.phoneBook[i].id == empl_id) {
            
            /// заполняем данными участника конференции
            confUser.id           = this.phoneBook[i].id;
            confUser.fio          = this.phoneBook[i].fio;
            confUser.full_name    = this.phoneBook[i].full_name;
            confUser.name         = this.phoneBook[i].name;
            confUser.pname        = this.phoneBook[i].pname;
            confUser.phoneNumber  = phoneNumber;
            confUser.phoneCaption = phoneCaption;
            confUser.fixed        = false;
            
            this.conference_users.unshift(confUser);
        }

      },

      // 
      AddCustomPhone(){
            let confUser = {};

            confUser.id           = null;
            confUser.fio          = "Контакт";
            confUser.full_name    = "";
            confUser.pname        = "";
            confUser.phoneNumber  = this.custom_phone;
            confUser.phoneCaption = this.custom_phone;
            confUser.name         = this.custom_phone;
            confUser.fixed        = false;

            this.conference_users.unshift(confUser);
            this.custom_phone = "";
      },

      /// изменение строки фильтра
      onFilter(key){

        /// при фильтре от двух символов ищем соответствия в текстовых полях
        if (this.filter_value.length > 1){

          for (let i = 0; i < this.phoneBook.length; i++){
            
            if (key == null) {
              this.phoneBook[i].showing = 
                // по фомилии
                (this.phoneBook[i].fio       != null && this.phoneBook[i].fio.toUpperCase().indexOf(this.filter_value.toUpperCase()) > -1) ||
                // по полному наименованию отдела
                (this.phoneBook[i].full_name != null && this.phoneBook[i].full_name.toUpperCase().indexOf(this.filter_value.toUpperCase()) > -1) ||
                // по должности
                (this.phoneBook[i].pname     != null && this.phoneBook[i].pname.toUpperCase().indexOf(this.filter_value.toUpperCase()) > -1) ||
                // по краткому наименованию отдела
                (this.phoneBook[i].name      != null && this.phoneBook[i].name.toUpperCase().indexOf(this.filter_value.toUpperCase()) > -1);

                // ищем в номерах телефонов
                if (!this.phoneBook[i].showing){
                  for (let j = 0; j < this.phoneBook[i].phones.length; j++){
                    if (this.phoneBook[i].phones[j].num.indexOf(this.filter_value.toUpperCase()) > -1) this.phoneBook[i].showing = true;
                    if (this.phoneBook[i].phones[j].num_str.indexOf(this.filter_value.toUpperCase()) > -1) this.phoneBook[i].showing = true;
                  }
                }
            }

            if (key == "department") {
              this.phoneBook[i].showing = 
                  this.phoneBook[i].name != null && this.phoneBook[i].name.toUpperCase() == this.filter_value.toUpperCase();
            }

          }

        } else {

          /// иначе полностью сбрасываем видимость  
          for (let i = 0; i < this.phoneBook.length; i++)
            this.phoneBook[i].showing = false;

        };
          
        this.keyPhonesUpdate = -this.keyPhonesUpdate;
      },

      /// возвращает данные картинки в raw формате.
      /// используется поиск в локальном хранилище по id пользователя или
      /// из запроса к базе с последующим кэшированием в хранилище
      getPhoto(empl_id){
        let imagedata = 
          "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";        
        
        // id пользователя может быть не задано. например, при добавлении участника конфененции по рандомному телефону, а не из телкниги
        if (empl_id) {
          
          /// сначала ищем в хранилище
          if (this.photoCache[empl_id] != undefined){
            imagedata = this.photoCache[empl_id];
          } else {
            //иначе будем получать запросом, писать в хранилище и вызывать валидацию для перерисовки
            // а до момента срабатывания запроса будут возвращена картинка-заглушка
            this.$store.dispatch(

                'ServerRequest',
                {
                    method: "getUserPhoto",
                    empl_id: empl_id, 
                    callback: (data) => {

                        // сохраняем данные в хранилище
                        this.photoCache[empl_id] = data[0].baze64;

                        // инициализируем обновление интерфейса конференции
                        this.keyUpdate = -this.keyUpdate;
                    }
                }
            ); 
          }
        }

        return "data:image/jpeg;base64," + imagedata;
         
      },

      /// удаление участиника из конференции
      confDelUser(index){
          this.conference_users.splice(index,1);

          // себя удалить нельзя. если остался один участник - это только текущий
          // пользователь и конференцию можно сбрасывать 
          if (this.conference_users.length == 1) {
            this.conference_users.length = 0;
            this.keyUpdate = -this.keyUpdate;
          }

          // за одно, кикаем из конференции

      }, 

      /// отмена конференции
      confCancel(){
          this.conference_users.length = 0;
          this.keyUpdate = -this.keyUpdate;
          this.conf_started = false;
      }, 

      /// запуск конференции
      confStart(){
        
        this.conf_started = true;

        let phones = [];

        for (let i = 0; i < this.conference_users.length; i++)
            phones.push(this.conference_users[i].phoneNumber);
        

          console.log('Conference: '+phones.join(','));

          this.$store.dispatch(

                  'ServerRequest',
                  {
                      method: "dynamic_conference",
                      phones: phones.join(',')
                  }
          );

      }, 

      // персональный дозвон до участника конференции.
      // по внутреннему соглашению, на стороне сервера номер инициатора считается id конференции
      // потому в дополнение к номеру вызываемого, передаем собственный, что бы звонок попал в конференцию с таким id
      doConfCall(number){
          this.$store.dispatch(

                  'ServerRequest',
                  {
                      method: "dynamic_conference",
                      phones: number + ',' + this.myphone
                  }
          );
      },

      // получение номера телефона для Asterisk
      GetInnerPhone(){
        for(var i = 0; i < this.curr_user.phones.length; i++){
          if (this.curr_user.phones[i].num_str == this.myphone) return this.curr_user.phones[i].num;
        }
      },
      
      onMyPhoneChange(){
        // по красивому номеру определяем внутренний
        for(var i = 0; i < this.curr_user.phones.length; i++){
          if (this.curr_user.phones[i].num_str == this.myphoneCaption) 
              this.myphone = this.curr_user.phones[i].num;
        }
        
        // если есть конференция, позменим там номер телефона пользователя
        for(var i = 0; i < this.conference_users.length; i++){
          if (this.conference_users[i].id == this.curr_user.id) {
            this.conference_users[i].phoneNumber = this.myphone;
            this.conference_users[i].phoneCaption = this.myphoneCaption;
          } 
        }

      },

      onDepartSelect(){
        this.filter_value = this.depart;
        this.onFilter("department");
      },

      // получаем список всех телефонов пользователей и
      // дополняем массив телефонного справочника
      GetPhones(){
          this.$store.dispatch(

              'ServerRequest',
              {
                  method: "getAllPhones",
                  callback: (data) => {

                      /// перебираем телефонную книгу и список телефонов, сопоставляя с пользователем
                      for (var b = 0; b < this.phoneBook.length; b++) {
                        for (var p = 0; p < data.length; p++) {

                          // есть совпадение
                          if (this.phoneBook[b].id == data[p].empl_id) {

                            // инициируем массив телефонов, если отсутствует
                            if (!this.phoneBook[b].phones) this.phoneBook[b].phones = [];

                            // дополняем массив имеющихся телефонов (пишется изьбыточная информация в виде id пользователя,
                            // но важнее сохранить все возвращенные поля не задумываясь об их количестве)
                            this.phoneBook[b].phones.push(data[p]);

                          }
                        }

                        // если добрались до текущего залогиненного пользователя, определяем активный телефон
                        // первый в приоритете: сотовый номер (предполагается, что программа пользуется на телефоне)
                        // второй: главный рабочий (phoneBook.main_phone)
                        if (this.phoneBook[b].id == this.curr_user.id) {
                          for (var i = 0; i < this.phoneBook[b].phones.length; i++){

                               // телефон - основной внутренний и сотовый еще не найден
                            if ((this.phoneBook[b].phones[i].num == this.phoneBook[b].main_phone && this.myphone == '') || 
                               // телефон - сотовый
                               (this.phoneBook[b].phones[i].tp == 5 )){

                                  this.myphone = this.phoneBook[b].phones[i].num;
                                  this.myphoneCaption = this.phoneBook[b].phones[i].num_str;
                            }

                          }
                        }
                      }
                      

                      /// перебираем телефонную книгу и список телефонов, сопоставляя с пользователем
                      for (var h = 0; h < this.history.length; h++) {
                        for (var p = 0; p < data.length; p++) {

                          // есть совпадение
                          if (this.history[h].id == data[p].empl_id) {

                            // инициируем массив телефонов, если отсутствует
                            if (!this.history[h].phones) this.history[h].phones = [];

                            // дополняем массив имеющихся телефонов (пишется изьбыточная информация в виде id пользователя,
                            // но важнее сохранить все возвращенные поля не задумываясь об их количестве)
                            this.history[h].phones.push(data[p]);
                          }
                        }
                      }

                      // к этому моменту список истории звонков уже отображен, а поле phones не является реактивным,
                      // поскольку добавляется вручную. для отображения телефонов, требуется изменить некое реактивное значение,
                      // которым и является ключ
                      this.keyHistoryUpdate = -this.keyHistoryUpdate;

                  }
              }
          );

      },

      /// получение данных телефонной книги по всем сотрудникам
      GetPhoneBook(){
          
          this.$store.dispatch(

              'ServerRequest',
              {
                  method: "getPhoneBook",
                  callback: (data) => {

                      this.phoneBook = data;

                      console.log("data length = " + data.length);
                      console.log("PhoneBook length = " + this.phoneBook.length);

                      // сортировка в запросе ломает данные, поотому сортируем фамилии по алфавиту здесь
                      this.phoneBook.sort((a, b) => {
                        return a.fio > b.fio ? 1 : -1;
                      });

                      /// находим в телефонной книге данные залогиненного пользователя
                      for (var i = 0; i < this.phoneBook.length; i++) {
                        if (this.phoneBook[i].id == this.user.user_id) {
                          this.curr_user = this.phoneBook[i];
                        }
                      }

                      // подгружаем телефоны сотрудников
                      this.GetPhones();
                  }
              }
          );
      },


      GetCallHistory(){
          
          /// получаем данные текущего пользователя    
          this.$store.dispatch(

              'ServerRequest',
              {
                  method: "getCallHistory",
                  empl: this.user.user_id,
                  callback: (data) => {

                      // сохраняем данные в рабочий массив
                      this.history = data;
    
                      /// получаем контакты
                      this.GetPhoneBook();
                  }
              }
          );
      },


      GetDepartments(){
          
          /// получаем данные текущего пользователя    
          this.$store.dispatch(

              'ServerRequest',
              {
                  method: "getDepartments",
                  callback: (data) => {

                      // сохраняем данные в рабочий массив
                      this.departmens = data;
    
                  }
              }
          );
      },

  },
  
  /// на загрузку получаем данные
  mounted(){
      
      /// получаем данные текущего пользователя    
      this.$store.dispatch(

          'ServerRequest',
          {
              method: "getWebUserData",
              callback: (data) => {

                  // сохраняем данные в рабочий массив
                  this.user = data[0];
                  console.log('User data: ');
                  console.log(this.user);

                  /// получаем историю звонков
                  this.GetCallHistory();  

              }
          }
      );

    this.GetDepartments();

  },

}
</script>


<style>
  
  .myphone p, .myphone select{
    display: inline-block;
  }
  .myphone select{
    margin-left: 20px;
    width: 150px;
  }

  #confList{  
    overflow: auto;
    max-height: 200px;
  }
  .phoneRow{     
    width: 550px;        
    margin: 0 auto;
  }
  .top{
     position: sticky;
     top: 0;
     background-color: white;
     padding-top: 10px 0;
     border-bottom: 1px solid #aaa;
  }
  .search{
    display: grid;
    width: 400px;
    grid-template-columns: 50px 20px 300px 30px;
    text-align: center;
    margin: 0 auto;
    padding: 10px 0;
    align-items: center;
    justify-items: center;
  }
  .search select{
    width: 100%;
  }
  .search input{
    width: 95%;
  }
  .search img{
    cursor: pointer;
  }

  .filter, .department{
    font-size: 110%;
  }


  .confContainer{
    padding-bottom: 10px;
    border-bottom: 1px solid #aaa;
  }
  .conference_user{
     display:grid;
     grid-template-columns: 60px 330px 130px auto auto;         
     grid-template-areas: 
        "photo fio phoneInner call remove"
        "photo position phoneInner call remove";
  }  

  .conference_add *{
    display: inline-block;
    margin-right: 5px;
  }

  .conference_bottom{
     display:grid;
     grid-template-columns: 50% 50%;   
     grid-template-rows: auto auto;   
     grid-template-areas: "a b"
                          "c c";   
     width: 320px;      
     margin:0 auto;
  }  

  .confCall, .confClear, .confCancel, .confAdd{
    font-weight: bold;
    padding: 10px;
    margin: 10px;
    border-radius: 5px;
    color: white;
    cursor: pointer;
  }
  .confCall{ background-color: #30DF32; grid-area: a;}
  .confClear{ background-color: #aaa; grid-area: b;}
  .confCancel{ background-color: #aaa; grid-area: c;}
  
  .confAdd{
    padding: 5px;
    margin: 5px;
    border-radius: 5px;
    color: white;
    cursor: pointer;
    background-color: #aaa;    
    width: 20px;
  }


  .contact{
     display:grid;
     grid-template-columns: 350px 200px; 
     grid-template-areas: 
        "fio phoneList"
        "position phoneList";
     border-bottom: 1px solid #aaa;
     padding: 10px 0;
  }  
  .liked        { grid-area: like; cursor: pointer;}
  .call         { grid-area: call; align-self: center; cursor: pointer; margin-left: 5px;}
  .photo        { grid-area: photo;}
  .fio          { grid-area: fio;  align-self: center; font-weight: bold;}
  .position     { grid-area: position; align-self: start; font-size: 80%; color: #aaa;}
  .position2    { grid-area: position2; align-self: start; font-size: 80%; color: #aaa;}
  .phoneInner   { grid-area: phoneInner; align-self: center; justify-self: end;}
  .phoneMobil   { grid-area: phoneMobil; align-self: center; justify-self: end;}
  .toInnerCall  { grid-area: toInnerCall; align-self: center; cursor: pointer;}
  .toInnerConf  { grid-area: toInnerConf; align-self: center; cursor: pointer;}
  .toMobilCall  { grid-area: toMobilCall; align-self: center; cursor: pointer;}
  .toMobilConf  { grid-area: toMobilConf; align-self: center; cursor: pointer;}
  .remove       { grid-area: remove; align-self: center; cursor: pointer; margin-left: 5px;}
  .poneList     { grid-area: phoneList;}

.photo img       { width: 50px; height: 50px; border-radius: 50%;}
.position, .fio, .position2  {text-align: left;}


.placeholder{
  font-weight: bold;
  width: 500px;
  color: #ddd;
  font-size: 150%;
  margin:0 auto;
  padding-top: 50px;
}



@media all and (min-width: 421px) and (max-width: 600px) {
  .contact{
     grid-template-columns: 230px 170px; 
  }
 .phoneRow, .placeholder{     
    width: 400px;  
    font-size: 90%;      
  }
  .contactPhone{
     grid-template-columns: 100px 40px 30px; 
  }
  .conference_user{
     grid-template-columns: 50px 250px 80px auto auto;         
  }
  .photo img { width: 45px; height: 45px; border-radius: 50%;}
}



@media all and (max-width: 420px){
  .contact{
     grid-template-columns: 225px 125px; 
  }
 .phoneRow, .placeholder{     
    width: 350px;  
    font-size: 85%;      
  }
  .contactPhone{
     grid-template-columns: 55px 40px 30px; 
  }
  .search{
    width: 350px;
    grid-template-columns: 50px 20px 250px 30px;
  }
  .conference_user{
     grid-template-columns: 50px 200px 50px auto auto;         
  }
  .photo img { width: 45px; height: 45px; border-radius: 50%;}
}

</style>
