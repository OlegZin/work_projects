<template>
	<div>
        <EditForm v-if="screen == 1" :data="curr_data" :mode="editMode" :journals="jKindList" :head="mode_head" :user_id="user.user_id" @onCancel="onCancelEdit" @onSave="onSaveEdit"/>
		<div v-if="screen == 0">
	    <h1>Журнал ОТК</h1>
	    <div class="panel">
	       <p>Период:</p>
	       <datepicker :language="languages[language]" v-model="begDate" format="dd.MM.yyyy"></datepicker>
	       <p>-</p>
	       <datepicker :language="languages[language]" v-model="endDate" format="dd.MM.yyyy"></datepicker>
	       <div class="button" @click="GetJournalList"><img src="./../assets/otk/refresh.png"></div>
	       <div class="button" @click="viewKind=0" v-bind:class="{ bordered: viewKind == 0 }"><img src="./../assets/otk/list_l.png"></div>
	       <div class="button" @click="viewKind=1" v-bind:class="{ bordered: viewKind == 1 }"><img src="./../assets/otk/card_l.png"></div>
	    </div>
	    <div class="filter">
	       <div class="button large" @click="goNewJournal()"><img src="./../assets/otk/add.png"></div>
	       <div><p>Журнал:</p></div>
	       <div><select v-model="jCurrent">
	       	  <option>Все</option>
	       	  <option v-for="item in jKindList">{{item.tip_name}}</option>
	       </select>
	       </div>
	       <div><p>Фильтр:</p></div>
	       <div><select v-model="jFilterField" @change="ChangeFilter()">
	       	  <option>Все</option>
	       	  <option v-for="item in jFieldList">{{item}}</option>
	       </select>
	       </div>
	       <div><input type="text" v-model="jFilterValue" @keyup="ChangeFilter()"></div>
	       <div class="button" @click="jFilterValue = ''; ChangeFilter();"><img src="./../assets/otk/clear.png"></div>
	    </div>
	    <div class="data" v-bind:counter="counter">

	    	<!-- табличное отображение -->
	    	<table class="table" v-if="viewKind == 0">
	    		<tr class="row header">
	    			<th></th>
	    			<th v-for="item in jFieldList">{{item}}</th>
	    		</tr>
	    		<tr v-for="item in jList" class="row" v-if="(jCurrent == 'Все' || jCurrent == item.tip_name) && item.showing == 1">
	    			<td>
	    				<div class="button" @click="goEditJournal(item)"><img src="./../assets/otk/edit.png"></div>
	    				<div class="button" @click="goNewJournal(item)"><img src="./../assets/otk/copy.png"></div>
	    				<div class="button" @click="goResendJournal(item)" v-if="item.id == item.first_pred_id"><img src="./../assets/otk/resend.png"></div> 
	    				<div class="button" @click="goDelRow(item)" v-if="user.login == 'zinovev'"><img src="./../assets/otk/clear.png"></div> 
	    			</td>
	    			<td @dblclick="ChangeFilter(item.num)">[{{item.num}}]</td>
	    			<td @dblclick="ChangeFilter(item.data)">{{item.data}}</td>
	    			<td @dblclick="ChangeFilter(item.tip_name)">{{item.tip_name}}</td>
	    			<td @dblclick="ChangeFilter(item.num_pred)">{{item.num_pred}}</td>
	    			<td @dblclick="ChangeFilter(item.naim)">{{item.naim}}</td>
	    			<td @dblclick="ChangeFilter(item.Obozn)">{{item.Obozn}}</td>
	    			<td @dblclick="ChangeFilter(item.vid_oper)">{{item.vid_oper}}</td>
	    			<td @dblclick="ChangeFilter(item.zavnum_string)">{{item.zavnum_string}}</td>
	    			<td @dblclick="ChangeFilter(item.ZavNumDetal)">{{item.ZavNumDetal}}</td>
	    			<td @dblclick="ChangeFilter(item.GeomRazmer)">{{item.GeomRazmer}}</td>
	    			<td @dblclick="ChangeFilter(item.material)">{{item.material}}</td>
	    			<td @dblclick="ChangeFilter(item.KolvoPredl)">{{item.KolvoPredl}}</td>
	    			<td @dblclick="ChangeFilter(item.KolvoVyborka)">{{item.KolvoVyborka}}</td>
	    			<td @dblclick="ChangeFilter(item.KolvoGodn)">{{item.KolvoGodn}}</td>
	    			<td @dblclick="ChangeFilter(item.KolvoVozvrat)">{{item.KolvoVozvrat}}</td>
	    			<td @dblclick="ChangeFilter(item.KolvoBrak)">{{item.KolvoBrak}}</td>
	    			<td @dblclick="ChangeFilter(item.OpisanieDefekt)">{{item.OpisanieDefekt}}</td>
	    			<td @dblclick="ChangeFilter(item.isp_FIO)">{{item.isp_FIO}}</td>
	    			<td @dblclick="ChangeFilter(item.brigada)">{{item.brigada}}</td>
	    			<td @dblclick="ChangeFilter(item.FioOtk)">{{item.FioOtk}}</td>
	    			<td @dblclick="ChangeFilter(item.Primech)">{{item.Primech}}</td>
	    			<td @dblclick="ChangeFilter(item.NoFormula)">{{item.NoFormula}}</td>
	    			<td @dblclick="ChangeFilter(item.SoprList)">{{item.SoprList}}</td>
	    			<td @dblclick="ChangeFilter(item.KartaKontrol)">{{item.KartaKontrol}}</td>
	    		</tr>	
			</table>

	    	<!-- отображение карточками -->
	    	<div v-if="viewKind == 1">
	    		<div class="row card" v-for="item in jList" v-if="(jCurrent == 'Все' || jCurrent == item.tip_name)  && item.showing == 1">
	    			<div class="cell">
	    				<div class="button" @click="goEditJournal(item)"><img src="./../assets/otk/edit.png"></div>
	    				<div class="button" @click="goNewJournal(item)"><img src="./../assets/otk/copy.png"></div>
	    				<div class="button" @click="goResendJournal(item)" v-if="item.id == item.first_pred_id"><img src="./../assets/otk/resend.png"></div> 
	    				<div class="button" @click="goDelRow(item)" v-if="user.login == 'zinovev'"><img src="./../assets/otk/clear.png"></div> 
	    				<div class="content" @dblclick="ChangeFilter(item.num)">[{{item.num}}]</div>
	    				<div class="content">{{item.tip_name}}</div>
	    			</div>
	    			<div class="cell"><div class="content" @dblclick="ChangeFilter(item.data)">{{item.data}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.num_pred != ''" @dblclick="ChangeFilter(item.num_pred)">{{item.num_pred}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.naim != ''" @dblclick="ChangeFilter(item.naim)">{{item.naim}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.obozn != ''" @dblclick="ChangeFilter(item.Obozn)">{{item.Obozn}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.vid_oper != ''" @dblclick="ChangeFilter(item.vid_oper)">{{item.vid_oper}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.zavnum_string != ''" @dblclick="ChangeFilter(item.zavnum_string)">{{item.zavnum_string}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.ZavNumDetal != ''" @dblclick="ChangeFilter(item.ZavNumDetal)">{{item.ZavNumDetal}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.GeomRazmer != ''" @dblclick="ChangeFilter(item.GeomRazmer)">{{item.GeomRazmer}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.material != ''" @dblclick="ChangeFilter(item.material)">{{item.material}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.KolvoPredl != ''" @dblclick="ChangeFilter(item.KolvoPredl)">{{item.KolvoPredl}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.KolvoVyborka != ''" @dblclick="ChangeFilter(item.KolvoVyborka)">{{item.KolvoVyborka}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.KolvoGodn != ''" @dblclick="ChangeFilter(item.KolvoGodn)">{{item.KolvoGodn}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.KolvoVozvrat != ''" @dblclick="ChangeFilter(item.KolvoVozvrat)">{{item.KolvoVozvrat}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.KolvoBrak != ''" @dblclick="ChangeFilter(item.KolvoBrak)">{{item.KolvoBrak}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.OpisanieDefekt != ''" @dblclick="ChangeFilter(item.OpisanieDefekt)">{{item.OpisanieDefekt}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.isp_FIO != ''" @dblclick="ChangeFilter(item.isp_FIO)">{{item.isp_FIO}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.brigada != ''" @dblclick="ChangeFilter(item.brigada)">{{item.brigada}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.FioOtk != ''" @dblclick="ChangeFilter(item.FioOtk)">{{item.FioOtk}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.Primech != ''" @dblclick="ChangeFilter(item.Primech)">{{item.Primech}}</div></div>
	    			<div class="cell"><div class="content" @dblclick="ChangeFilter(item.NoFormula)">{{item.NoFormula}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.SoprList != ''" @dblclick="ChangeFilter(item.SoprList)">{{item.SoprList}}</div></div>
	    			<div class="cell"><div class="content" v-if="item.KartaKontrol != ''" @dblclick="ChangeFilter(item.KartaKontrol)">{{item.KartaKontrol}}</div></div>
	    		</div>
	    	</div>
	    </div>
	    </div>
	</div>  
</template>


<script>
import Datepicker from "vuejs-datepicker/dist/vuejs-datepicker.esm.js";
import * as lang from "vuejs-datepicker/src/locale";
import EditForm from '@/components/otk/EditForm.vue';
const axios = require('axios');

export default {

  data(){
  	return {
  		language: "ru",
  		languages: lang,
  		begDate: null,
  		endDate: null,
  		jList: [],       // список журналов
        jCurrent: "Все", // текущий отображаемый тип журналов
        jKindList: [],   // типы журналов для выпадающего списка
        jFilterField: "Все",
        jFieldList: ['№ п/п','Дата','Тип журнала','№ предъявл.','Наименование','Обозначение','Вид операции','Зав. № изделия','Зав. № детали',
                     'Геометрические размеры','Материал','Кол-во предъявл.','Кол-во выборки','Кол-во годных','Кол-во возврата','Кол-во брака',
                     'Хар-тика дефектов','ФИО исп.','Организация/бригада','ФИО ОТК','Примечание','Приемка без предъявл.','Сопр. лист','Карта контроля'],
                     /// список отображаемых столбцов

        jFieldNameList: ['num','data','tip_name','num_pred','naim','Obozn','vid_oper','zavnum_string','ZavNumDetal',
                     'GeomRazmer','material','KolvoPredl','KolvoVyborka','KolvoGodn','KolvoVozvrat','KolvoBrak',
                     'OpisanieDefekt','isp_FIO','brigada','FioOtk','Primech','NoFormula','SoprList','KartaKontrol'],
                     /// список сопоставленных столбцам jFieldList полей данных в jList
                     /// используется для механизма фильтрации

        jFilterValue: '',
        viewKind: 0, // способ отображения данных: 0 - карточки, 1 - таблица
        counter: 0, /* https://qna.habr.com/q/643833
                       хак для обновления компонента при изменении поля showing при применении фильтра ChangeFilter().
                       проблема в том, что данное поле не реактивно и после выполнения процедуры таблица не обновлялась, только после изменения реактивного значения, 
                       например значения фильтра.
					   данный хак вводит скрытое реактивное значение привязанное к <div class="data" v-bind:counter="counter"> и поле применения фильтра,
					   вызывается функция refreshComponent(), которая обновляет значение counter, что приводит к перерисовке компонента и применение v-if в таблицах
					*/
		screen: 0,	
		editMode: 0,
		curr_data: {},
		mode_head: "",
		user: {},
  	}
  },

  components:{
      Datepicker, EditForm
  },

  methods:{
      
      /// получение списка типов журналов
      GetJournalKinds(){
          
		  this.$store.dispatch(

              'ServerRequest',
              {
                  method: "sql",
                  sql: "exec sp_JournalOTK_GetTipJ",
                  callback: (data) => {

                      this.jKindList = data;

                  }
              }
          );
      },

      /// получение списка журналов
      GetJournalList(){
          
          /// getMonth()+1, поскольку номера месяцев отсчитываются с нуля
          let sql = "exec sp_JournalOTK_GetRowData null, '"+
              this.begDate.getDate()+"."+(this.begDate.getMonth()+1)+"."+this.begDate.getFullYear()+"','"+ 
              this.endDate.getDate()+"."+(this.endDate.getMonth()+1)+"."+this.endDate.getFullYear()+"'";

          console.log(sql);    

		  this.$store.dispatch(

              'ServerRequest',
              {
                  method: "sql",
                  sql: sql,
                  callback: (data) => {

                  	  // сохраняем данные в рабочий массив
                      this.jList = data;

                      /// добавляем поле для отслеживания соответствия записи текущему фильтру
                      /// и проводим контроль данных, с необъодимой адаптацией для простого отображения в списках
                      this.jList.forEach(function(item) {
						  item.showing = 1;

		  			  	  item.num            = ''+(item.num || '');                                        /// '№ п/п'	
		 			  	  item.data           = (new Date(item.data.date)).toLocaleString('ru', { year: 'numeric', month: 'numeric', day: 'numeric'}) || ''; /// 'Дата'
						  item.tip_name       = ''+(item.tip_name || '');                                   /// 'Тип журнала' 	  
		 			  	  item.num_pred       = ''+((item.id != item.first_pred_id ? 'П'+item.num_pred : '') || ''); /// '№ предъявл.'
		 			  	  item.naim           = ''+(item.naim || '');                                       /// 'Наименование'
		 			  	  item.Obozn          = ''+(item.Obozn || '');                                      /// 'Обозначение'
		 			  	  item.vid_oper       = ''+(item.vid_oper || '');                                   /// вид операции
		 			  	  item.zavnum_string  = ''+(item.zavnum_string || '');                              /// 'Зав. № изделия'
		 			  	  item.ZavNumDetal    = ''+(item.ZavNumDetal || '');                                /// 'Зав. № детали'
						  item.GeomRazmer     = ''+(item.GeomRazmer || '');                                 /// 'Геометрические размеры'
						  item.material       = ''+(item.material || '');                                   /// 'Материал'
						  item.KolvoPredl     = ''+(item.KolvoPredl || '');                                 /// 'Кол-во предъявл.'
						  item.KolvoVyborka   = ''+(item.KolvoVyborka || '');                               /// 'Кол-во выборки'
						  item.KolvoGodn      = ''+(item.KolvoGodn || '');                                  /// 'Кол-во годных'
						  item.KolvoVozvrat   = ''+(item.KolvoVozvrat || '');                               /// 'Кол-во возврата'
						  item.KolvoBrak      = ''+(item.KolvoBrak || '');                                  /// 'Кол-во брака'
						  item.OpisanieDefekt = ''+(item.OpisanieDefekt || '');                             /// 'Хар-тика дефектов'
						  item.isp_FIO        = ''+(item.isp_FIO || '');                                    /// 'ФИО исп.'
						  item.brigada        = ''+((item.post_id > 0 ? item.postav : item.brigada) || ''); /// 'Организация/бригада'
						  item.fiootk         = ''+(item.fiootk || '');                                     /// 'ФИО ОТК'
						  item.Primech        = ''+(item.Primech || '');                                    /// 'Примечание'
						  item.NoFormula      = ''+item.NoFormula == 0 ? 'Да' : 'Нет';                      /// 'Приемка без предъявл.'
						  item.SoprList       = ''+(item.SoprList || '');                                   /// 'Сопр. лист'
						  item.KartaKontrol   = ''+(item.KartaKontrol || '');                               /// 'Карта контроля'

					  });
                  }
              }
          );
      },

      /// метод вызывается при изменении текста в поле фильтра, выставляя флаг соответствия фильтру каждой записи
      /// проверяется конкретное поле или каждое, если значение фильтра = 'Все'
      ChangeFilter(value){
          
          
          if (value) {
          	this.jFilterValue = value;
          }
          
          var context = this;
          var val = '';  // значение поля текущей записи, указанного в фильтре
          var all_val = '';  // склеенное значение сех полей текущей записи. для проверки по всем полям
          var index = -1;

		  /// получаем индекс поля по в массиве jFieldList, по которому производится фильтрация 
		  for (var i = 0 ; i < context.jFieldList.length; i++){
		  		if (context.jFieldList[i] == context.jFilterField) index = i;
		  };

          /// перебираем все записи 
          this.jList.forEach(function(item) {
		
              val = '';
              all_val = '';

			  if (context.jFilterValue == ''){

 			  	  item.showing = 1;	

			  } 
			  else
			  {

				  item.showing = 0;

				  /// если поиск по конкретному полю, берем только его значение
				  if (index !== -1){ 
  				  	  
  				  	  val = item[context.jFieldNameList[index]]; 
				  	  
				  	  if (val.indexOf(context.jFilterValue) != -1) item.showing = 1;

				  } else {

				  /// иначе нужно проверить все отображаемые поля	
			
					  for (var i = 0 ; i < context.jFieldNameList.length; i++){

	  				  	  val = item[context.jFieldNameList[i]]; 
					  	  
					  	  if (val.indexOf(context.jFilterValue) != -1) item.showing = 1;

					  };				      
				  };
			  };
		  });

		  this.refreshComponent();
      },

      refreshComponent(){
      	  this.counter++;
      },

      goEditJournal(item){

		  let sql = "exec sp_JournalOTK_GetRowData "+item.id+", null, null";
		  console.log(sql);

	      this.$store.dispatch(

	          'ServerRequest',
	          {
	              method: "sql",
	              sql: sql,
	              callback: (data) => {

			          /// получен корректный ответ
	                  console.log('...получен корректный ответ');
	                  console.log(data[0]);

			      	  this.curr_data = data[0];
			   	      this.curr_data.tip_id = item.tip;

				      this.editMode = 1; // редактирование
					  this.mode_head = "Редактирование журнала";
					  this.screen = 1; //
	              }
	          }
	      );

      },

      goNewJournal(item){

		console.log(item);
        this.curr_data = {};

		if (!item){
	      	  
			
	      	this.editMode = 0; // создание нового
	      	this.mode_head = "Создание нового журнала";
	      	this.screen = 1; //
	      	return;
		};



/// при непустом item - вызов идет с кнопки создания по образцу
		  let sql = "exec sp_JournalOTK_GetRowData "+item.id+", null, null";
		  console.log(sql);

	      this.$store.dispatch(

	          'ServerRequest',
	          {
	              method: "sql",
	              sql: sql,
	              callback: (data) => {

			          /// получен корректный ответ
	                  console.log('...получен корректный ответ');
	                  console.log(data[0]);
//			      	  this.curr_data = data[0];

//			      	  this.curr_data.first_pred_id = data[0].id;
//			      	  this.curr_data.num_pred      = '№ '+ data[0].num +' от ' + data[0].data + ' ' + data[0].naim + ' ' + data[0].Obozn + ' ' + data[0].vid_oper + ' зав. ' + data[0].zavnum_string; 
			      	  this.curr_data.date          = data[0].data.date;
					  this.curr_data.naim          = data[0].naim;
			      	  this.curr_data.Obozn         = data[0].Obozn;
			      	  this.curr_data.vid_oper      = data[0].vid_oper;
			      	  this.curr_data.zavnum_string = data[0].zavnum_string;
			      	  this.curr_data.kizd          = data[0].kizd;
			      	  this.curr_data.tip_name      = data[0].tip_name;
			      	  this.curr_data.tip_id        = item.tip;

			      	  this.editMode = 0; // создание нового
			      	  this.mode_head = "Создание нового журнала";
			      	  this.screen = 1; //
	              	  
	              }
	          }
	      );
      },

      async goResendJournal(item){

		  if (!item.first_pred_id){
		  	console.log('Отсутствует id первой подачи');
		  }

		  let sql = "exec sp_JournalOTK_GetRowData "+item.first_pred_id+", null, null";
		  console.log(sql);

	      const response = await axios({
              method: 'get',
              url: process.env.VUE_APP_URL,
              params: {
                  method: "sql",
                  sql: sql,
                  token: this.$store.state.token
              }
          });

          /// разбираем ответ сервера
          console.log('разбираем ответ сервера...');
          if ( Array.isArray(response.data.data) ){

              console.log(response.data.data);

	          if (response.data.data.length > 0 ){

		          /// получен корректный ответ
                  console.log('...получен корректный ответ');
		      	  
		      	  this.curr_data = response.data.data[0];

		      	  this.curr_data.id = 0;  /// сбрасываем, чтобы создать новую запись, а не обновить текущую

		      	  this.curr_data.first_pred_id = item.id;
  		      	  this.curr_data.tip_name = item.tip_name;
  		      	  this.curr_data.tip_id = item.tip;

		      	  this.curr_data.num_pred      = '№ '+ item.num +' от ' + item.data + ' ' + item.naim + ' ' + item.Obozn + ' ' + item.vid_oper + ' зав. ' + item.zavnum_string; 

		      	  this.editMode = 0; // создание нового
		      	  this.mode_head = "Переподача";
		      	  this.screen = 1; //
		
              } else {

              	  /// пользователь не найден
                  console.log('...Данные журнала не найдены');
              }
          } else {

          	  /// получена ошибка от сервера
              console.log('...получена ошибка от сервера');
              console.log(response.data.data);
          }
      	  
      },

      goResendJournal_(item){

      	  this.curr_data.first_pred_id = item.id;
      	  this.curr_data.num_pred      = '№ '+ item.num +' от ' + item.data + ' ' + item.naim + ' ' + item.Obozn + ' ' + item.vid_oper + ' зав. ' + item.zavnum_string; 
      	  this.curr_data.naim          = item.naim;
      	  this.curr_data.Obozn         = item.Obozn;
      	  this.curr_data.vid_oper      = item.vid_oper;
      	  this.curr_data.zavnum_string = item.zavnum_string;
      	  this.curr_data.kizd          = item.kizd;
      	  this.curr_data.tip_name      = item.tip_name;

      	  this.editMode = 0; // создание нового
      	  this.mode_head = "Создание нового журнала";
      	  this.screen = 1; //
      },

      onCancelEdit(){
      	  this.screen = 0;
      },

      onSaveEdit(data){
	      /// получаем данные журнала за выбранный период
	      this.GetJournalList();

      	  this.screen = 0;  
      },

	  goDelRow(item){
	      
	  	  let sql = "DECLARE @id int = "+item.id+";DELETE FROM JournalOTK_kizd WHERE rowid = @id;DELETE FROM JournalOTK_hist WHERE id = @id; DELETE FROM JournalOTK WHERE id = @id"; 

	      /// получаем данные текущего пользователя    
	      this.$store.dispatch(

	          'ServerRequest',
	          {
	              method: "sql",
	              sql: sql,
	              callback: (data) => {

	              	  this.GetJournalList();
	              	  
	              }
	          }
	      );


	  },
  },


  mounted(){

      
      /// получаем данные текущего пользователя    
      this.$store.dispatch(

          'ServerRequest',
          {
              method: "getWebUserData",
              callback: (data) => {

              	  // сохраняем данные в рабочий массив
                  this.user = data[0];

              }
          }
      );

      /// выставляем стартовый диапазон дат выборки журналов
      this.endDate = new Date();
      this.begDate = new Date();
      this.begDate.setMonth( this.endDate.getMonth() - 1 );

      /// получаем список журналов
      this.GetJournalKinds();

      /// получаем данные журнала за выбранный период
      this.GetJournalList();
  },
}
</script>

<style>
	.panel, .filter{
	    color: #30a1aa;
	    border-bottom: 1px solid #f0edf0; 
	    border-top: 1px solid #f0edf0; 
	    padding: 10px;
	    margin-bottom: 10px;
	    display:grid;
        grid-template-rows: 1fr;
        background-color: #fff;
	}
	.panel{
        grid-template-columns: 100px 100px 10px 100px 50px 30px 30px;	    		
	}
	.filter{
        position: sticky;
        top: 0;
        grid-template-columns: 30px 100px 250px 100px 200px 200px 30px 30px;	    		
	}
    .panel > *, .filter > *{
		align-self: center;
    }


    .vdp-datepicker input{
    	width: 100px;
    }
    .bordered{
		border-radius: 5px;
		border: 2px solid #30a1aa; 
    }
    .button{
    	height: 25px;
    	width: 25px;
    }
    .button img{
    	height: 25px;
    	width: 25px;
    }

    .button.large{
    	height: 36px;
    	width: 36px;
    }
    .button.large img{
    	height: 36px;
    	width: 36px;
    }


    table{
    	border-collapse: collapse;
    }

    table tr:nth-child(odd){
    	background-color: #f0edf0;
    }

	.card{
		display: inline-block;
		width: 400px;
		text-align: left;
		margin-bottom: 30px;
		margin: 5px;
		padding: 10px;
		border-radius: 10px;
		border: 1px solid #f0edf0; 
		box-shadow: 0 5px 5px rgba(0,0,0,0.15);
	}
	.card .cell:nth-child(1){
		border-bottom: 1px solid #f0edf0;
		margin-bottom: 5px;
		text-align: center;
	}

	.cell{
	    border-left: 0px solid white;
	    border-top: 0px solid white;
	    display: block;
	    text-align: left;
    }
    .cell > * {
    	display: inline-block;
    	margin-right: 10px;
    }
    .content{
      font-weight: bold;
    }
    .content:before{
	  display: inline-block;
	  width: 150px;
	  font-weight: normal;
	  text-align: right;
	  margin-right: 10px;
	}

	.card .cell:nth-child(2) .content:before  { content: "Дата: "; }  
	.card .cell:nth-child(3) .content:before  { content: "№ предъявл.: "; }  
	.card .cell:nth-child(4) .content:before  { content: "Наименование: "; }  
	.card .cell:nth-child(5) .content:before  { content: "Обозначение: "; }  
	.card .cell:nth-child(6) .content:before  { content: "Вид операции: "; }  
	.card .cell:nth-child(7) .content:before  { content: "Зав. № изделия: "; }  
	.card .cell:nth-child(8) .content:before  { content: "Зав. № детали: "; }  
	.card .cell:nth-child(9) .content:before  { content: "Геом. размеры: "; }  
	.card .cell:nth-child(10) .content:before  { content: "Материал: "; }  
	.card .cell:nth-child(11) .content:before  { content: "Кол-во предъявл.: "; }  
	.card .cell:nth-child(12) .content:before  { content: "Кол-во выборки: "; }  
	.card .cell:nth-child(13) .content:before  { content: "Кол-во годных: "; }  
	.card .cell:nth-child(14) .content:before  { content: "Кол-во возврата: "; }  
	.card .cell:nth-child(15) .content:before  { content: "Кол-во брака: "; }  
	.card .cell:nth-child(16) .content:before  { content: "Хар-тика дефектов: "; }  
	.card .cell:nth-child(17) .content:before  { content: "ФИО исп.: "; }  
	.card .cell:nth-child(18) .content:before  { content: "Орг./бригада: "; }  
	.card .cell:nth-child(19) .content:before  { content: "ФИО ОТК: "; }  
	.card .cell:nth-child(20) .content:before  { content: "Примечание: "; }  
	.card .cell:nth-child(21) .content:before  { content: "Без предъявл.: "; }  
	.card .cell:nth-child(22) .content:before  { content: "Сопр. лист: "; }  
	.card .cell:nth-child(23) .content:before  { content: "Карта контроля: "; }  

    @media all and (min-width: 501px) and (max-width: 950px){

		.filter{
	    	grid-template-rows: 1fr 1fr;
	        grid-template-columns: repeat(9, 1fr);	    		
	    }
	    /* grid-area: grid-row-start / grid-column-start / grid-row-end / grid-column-end */
	    .filter div:nth-child(1)  { grid-area: 1 / 1 / 3 / 2; } // кнопка добавления журнала {} 
	    .filter div:nth-child(2)  { grid-area: 1 / 2 / 2 / 3; } // надпись Журнал {} 
	    .filter div:nth-child(3)  { grid-area: 1 / 3 / 2 / 9;} // выпадающий типы журналов {} 

	    .filter div:nth-child(4)  { grid-area: 2 / 2 / 3 / 3; } // надпись Фильтр {} 
	    .filter div:nth-child(5)  { grid-area: 2 / 3 / 3 / 6; } // выпадающий типы полей {} 
	    .filter div:nth-child(6)  { grid-area: 2 / 6 / 3 / 9; } // значение фильтра {} 
	    .filter div:nth-child(7)  { grid-area: 2 / 9 / 3 / 10; margin-left: 10px;} // очистка фильтра {} 
        
        .filter select, .filter input{ width: 100%; }

        .filter p{margin-block-start: 0; margin-block-end: 0;}

    }

    @media all and (min-width: 0px) and (max-width: 500px){

		.filter{
	    	grid-template-rows: 1fr 1fr;
	        grid-template-columns: repeat(8, 1fr);	    		
	    }
	    /* grid-area: grid-row-start / grid-column-start / grid-row-end / grid-column-end */
	    .filter div:nth-child(1)  { grid-area: 1 / 1 / 3 / 2; } // кнопка добавления журнала {} 
	    .filter div:nth-child(2)  { display: none; } // надпись Журнал {} 
	    .filter div:nth-child(3)  { grid-area: 1 / 2 / 2 / 8;} // выпадающий типы журналов {} 

	    .filter div:nth-child(4)  { display: none; } // надпись Фильтр {} 
	    .filter div:nth-child(5)  { grid-area: 2 / 2 / 3 / 5; } // выпадающий типы полей {} 
	    .filter div:nth-child(6)  { grid-area: 2 / 5 / 3 / 8; } // значение фильтра {} 
	    .filter div:nth-child(7)  { grid-area: 2 / 8 / 3 / 9; margin-left: 10px;} // очистка фильтра {} 
        
        .filter select, .filter input{ width: 100%; }

        .panel > p:nth-child(1) {display: none;}
        .panel {
        	grid-template-columns: 100px 10px 100px 50px 30px 30px;	    		
        }
                

    }

</style>