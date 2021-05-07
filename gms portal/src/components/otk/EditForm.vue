<template>
<div>
	<SelectIspol v-if="screen == 3" :list="TextList" @onCancel="screen = 0" @onSelect="onSelectIspol"/>
	<SelectZavNum v-if="screen == 2" :isByProd="rec.isByProd" @onCancel="screen = 0" @onSelect="onSelectZav"/>
	<SelectTextForm v-if="screen == 1" :list="TextList" :titul="titul_field" @onSelect="onSelect" @onCancelSelect="onCancelSelect"/>
	<div class="root" v-if="screen == 0">
		<div id="card">
		    
		    <div id="head">	
				<h2>{{head}}</h2>
		    </div>

		    <div id="num">	
				<p :class="{required: isRequired('num')}">Номер</p>
				<input type="text" v-model="rec.num" :disabled="mode !== 2" :class="{missed: isMissed('num')}">
		    </div>

		    <div id="date">	
		   		<p :class="{required: isRequired('date')}">Дата</p>
				<datepicker :language="languages[language]" v-model="rec.date" format="dd.MM.yyyy" :class="{missed: isMissed('date')}"></datepicker>
		    </div>	

		    <div id="num_pred">	
				<p :class="{required: isRequired('num_pred')}">Первое предъявление</p>
				<input type="text" v-model="rec.num_pred" :disabled="mode !== 2" @ckick="firstpred_id = 0; " :class="{missed: isMissed('num_pred')}">
				<button @click="ClearFirstPred()">X</button>
		    </div>	

		    <div id="naim">	
				<p :class="{required: isRequired('naim')}">Наименование</p>
				<input type="text" v-model="rec.naim" :class="{missed: isMissed('naim')}">
				<button @click="showTextListForm('naim', 'naim')">...</button>
		    </div>	


		    <div id="vid_oper">	
				<p :class="{required: isRequired('vid_oper')}">Вид операции</p>
				<input type="text" v-model="rec.vid_oper"  :class="{missed: isMissed('vid_oper')}">
				<button @click="showTextListForm('vid_oper', 'vid_oper')">...</button>
		    </div>	

		    <div id="zavnumdetal">	
				<p  :class="{required: isRequired('zavnumdetal')}">Зав.№ детали</p>
				<input type="text" v-model="rec.zavnumdetal" :class="{missed: isMissed('zavnumdetal')}">
				<button @click="showTextListForm('zavnumdetal', 'zavnumdetal')">...</button>
		    </div>	

		    <div id="brigada_fio">	
				<p :class="{required: isRequired('brig_fio')}">Исполнитель МЦ, ЦМК</p>
				<input type="radio" name="contact" value="0" v-model="rec.brigada_type" @click="changeBrigadaType"> 
				<input type="text" v-model="rec.brig_fio" :disabled="rec.brigada_type == 1" :class="{missed: isMissed('brig_fio') && rec.brigada_type != 1}" readonly>
				<button @click="showIspolnitelList('brig_fio')" :disabled="rec.brigada_type == 1">...</button>
		    </div>	

		    <div id="brigada">	
				<p :class="{required: isRequired('brigada')}">Бригада</p>
				<input type="text" v-model="rec.brigada" :disabled="rec.brigada_type == 1" :class="{missed: isMissed('brigada') && rec.brigada_type != 1}">
				<button @click="showTextListForm('brigada', 'brigada')" :disabled="rec.brigada_type == 1">...</button>
		    </div>	

		    <div id="organization_fio">	
				<p :class="{required: isRequired('isp_fio')}">Исполнитель организации</p>
				<input type="radio" name="contact" value="1" v-model="rec.brigada_type" @click="changeBrigadaType">
				<input type="text" v-model="rec.isp_fio" :disabled="rec.brigada_type == 0" :class="{missed: isMissed('isp_fio') && rec.brigada_type != 0}">
				<button @click="showTextListForm('isp_fio', 'isp_fio')" :disabled="rec.brigada_type == 0">...</button>
		    </div>	

		    <div id="organization">	
				<p  :class="{required: isRequired('organization')}">Организация</p>
				<input type="text" v-model="rec.organization" :disabled="rec.brigada_type == 0" :class="{missed: isMissed('organization') && rec.brigada_type != 0}">
				<button @click="showOrganizationList('organization')" :disabled="rec.brigada_type == 0">...</button>
		    </div>	

		    <div id="soprlist">	
				<p :class="{required: isRequired('soprlist')}">Сопроводительный лист</p>
				<input type="text" v-model="rec.soprlist"  :class="{missed: isMissed('soprlist')}">
				<button @click="showTextListForm('soprlist', 'soprlist')">...</button>
		    </div>	

		    <div id="kartakontrol">	
				<p :class="{required: isRequired('kartakontrol')}">Карта контроля</p>
				<input type="text" v-model="rec.kartakontrol" :class="{missed: isMissed('kartakontrol')}">
				<button @click="showTextListForm('kartakontrol', 'kartakontrol')">...</button>
		    </div>	

		    <div id="tip_name">	
				<p :class="{required: isRequired('tip_name')}">Тип журнала</p>
				<select v-model="rec.tip_name"  :class="{missed: isMissed('tip_name')}">
			       	  <option v-for="item in journals">{{item.tip_name}}</option>
				</select>
		    </div>	

		    <div id="obozn">	
				<p :class="{required: isRequired('obozn')}">Обозначение</p>
				<input type="text" v-model="rec.obozn"  :class="{missed: isMissed('obozn')}">
				<button @click="showTextListForm('obozn', 'obozn')">...</button>
		    </div>	

		    <div id="geomrazmer">	
				<p :class="{required: isRequired('geomrazmer')}">Геометрические размеры</p>
				<input type="text" v-model="rec.geomrazmer"  :class="{missed: isMissed('geomrazmer')}">
				<button @click="showTextListForm('geomrazmer', 'geomrazmer')">...</button>
		    </div>	

		    <div id="zavnum_string">	
				<p :class="{required: isRequired('zavnum_string')}">Зав.№ изделия</p>
				<input type="text" v-model="rec.zavnum_string"  :class="{missed: isMissed('zavnum_string')}" readonly>
				<button @click="screen = 2">...</button>
		    </div>	

		    <div id="material">	
				<p :class="{required: isRequired('material')}">Материал</p>
				<input type="text" v-model="rec.material"  :class="{missed: isMissed('material')}">
				<button @click="showTextListForm('material', 'material')">...</button>
		    </div>	

		    <div id="kolvopredl">	
				<p :class="{required: isRequired('kolvopredl')}">Кол-во предъяв.</p>
				<input type="text" v-model="rec.kolvopredl"  :class="{missed: isMissed('kolvopredl')}">
		    </div>	

		    <div id="kolvovyborka">	
				<p  :class="{required: isRequired('kolvovyborka')}">Кол-во выборки</p>
				<input type="text" v-model="rec.kolvovyborka" :class="{missed: isMissed('kolvovyborka')}">
		    </div>	

		    <div id="kolvogodn">	
				<p :class="{required: isRequired('kolvogodn')}">Кол-во годных</p>
				<input type="text" v-model="rec.kolvogodn"  :class="{missed: isMissed('kolvogodn')}">
		    </div>	

		    <div id="kolvovozvrat">	
				<p :class="{required: isRequired('kolvovozvrat')}">Кол-во возврата</p>
				<input type="text" v-model="rec.kolvovozvrat" :class="{missed: isMissed('kolvovozvrat')}">
		    </div>	

		    <div id="kolvobrak">	
				<p :class="{required: isRequired('kolvobrak')}">Кол-во брака</p>
				<input type="text" v-model="rec.kolvobrak" :class="{missed: isMissed('kolvobrak')}">
		    </div>	

		    <div id="opisaniedefekt">	
				<p :class="{required: isRequired('opisaniedefekt')}">Характеристика дефектов</p>
				<button @click="showTextListForm('opisaniedefekt', 'opisaniedefekt')">...</button>
				<textarea v-model="rec.opisaniedefekt"  :class="{missed: isMissed('opisaniedefekt')}"></textarea>
		    </div>	

		    <div id="primech">	
				<p :class="{required: isRequired('primech')}">Примечание</p>
				<button @click="showTextListForm('primech', 'primech')">...</button>
				<textarea v-model="rec.primech"  :class="{missed: isMissed('primech')}"></textarea>
		    </div>	

		    <div id="noformula">	
		    	<input type="checkbox" v-model="rec.noformula"  :class="{missed: isMissed('noformula')}">
		    	<p :class="{required: isRequired('noformula')}">Приемка без предъявления</p>
		    </div>	

		    <div id="errors" v-if="showErrors && errors.length > 0">
		    	<button @click="showErrors = false">X</button>
                <div v-for="item in errors" >{{item}}</div>
		    </div>

		    <div id="buttons">	
		    	<div v-if="showDialog == 0">
				    <button @click="onSave">Сохранить</button>
				    <button @click="onCancel">Закрыть</button>
			    </div>
		    	<div v-if="showDialog == 1">
		    		<p>Не указано первое предъявление. Продолжить?</p>
				    <button @click="writeRecord">Да</button>
				    <button @click="showDialog = 0">Нет</button>
			    </div>
		    	<div v-if="showDialog == 2">
		    		<p>Данные успешно сохранены</p>
				    <button @click="onDone">Закрыть</button>
			    </div>
		    </div>	
		</div>
	</div>
</div>
</template>


<script>
import Datepicker from "vuejs-datepicker/dist/vuejs-datepicker.esm.js";
import * as lang from "vuejs-datepicker/src/locale";
import SelectTextForm from '@/components/otk/SelectTextForm.vue';
import SelectZavNum from '@/components/otk/SelectZavNum.vue';
import SelectIspol from '@/components/otk/SelectIspol.vue';
const axios = require('axios');

export default {

  components:{
      Datepicker, SelectTextForm, SelectZavNum, SelectIspol
  },

  props: [ 'data', 'mode', 'journals', 'head', 'user_id' ],

  data(){
  	return {
  		language: "ru",
  		languages: lang,

  		screen: 0,      // текущий экран: 0 = форма, 1 = SelectTextForm, 2 = SelectZavNum, 3 = SelectIspol
  		TextList: [],
  		data_field: "",
  		showErrors: false,

  		//user_id: 0,      // текущий залогиненый пользователь

  		showDialog: 0,    // текущий активный диалог 0 = сохранение изменений, 1 = продолжение сохранения без первой подачи

	    rec:  // данные для нового добавляемого объекта
	        { 
	          "id"            : this.data.id             || 0,        // id журнала из списка
              "num"           : this.data.num            || "АВТОНОМЕР",
	          "date"          : this.data.date           || new Date(),
	          "tip_name"      : this.data.tip_name       || "",
	          "num_pred"      : (this.data.first_pred_id !== this.data.id) ? "П" + this.data.num_pred : "",
	          "naim"          : this.data.naim           || "",
	          "obozn"         : this.data.Obozn          || "",
	          "vid_oper"      : this.data.vid_oper       || "",
	          "zavnum_string" : this.data.zavnum_string  || "",
	          "zavnumdetal"   : this.data.ZavNumDetal    || "",
              "geomrazmer"    : this.data.GeomRazmer     || "",
              "material"      : this.data.material       || "",
              "kolvopredl"    : this.data.KolvoPredl     || 0,
              "kolvovyborka"  : this.data.KolvoVyborka   || 0,
              "kolvogodn"     : this.data.KolvoGodn      || 0,
              "kolvovozvrat"  : this.data.KolvoVozvrat   || 0,
              "kolvobrak"     : this.data.KolvoBrak      || 0,
              "opisaniedefekt": this.data.OpisanieDefekt || "",
              "brigada"       : this.data.brigada        || "",
              "organization"  : this.data.organization   || "",

              "isp_fio"       : !this.data.isp_id        ? this.data.isp_FIO : "",       // строка фамилий исполнителей организации. 
              "post_id"       : this.data.postav_id      || 0,     // id поставщика (организации)

              "brig_fio"      : this.data.isp_id         ? this.data.isp_FIO : "",       // строка фамилий исполнителей бригады
              "isp_emplid"    : this.data.isp_id         || "",    // id исполнителя (бригада) (теперь это строка id через запятую)

              "fiootk"        : this.data.FioOtk         || "",
              "primech"       : this.data.Primech        || "",
              "noformula"     : this.data.NoFormula      || 0,
              "soprlist"      : this.data.SoprList       || "",
              "kartakontrol"  : this.data.KartaKontrol   || "",
              "otk_emplid"    : this.data.otk_emplid     || 0,
              "firstpred_id"  : this.data.first_pred_id  || 0,  // первая подача
              "kizd"          : this.data.kizd + ""      || "",          // id выбранных заводских номеров
              "isByProd"      : this.data.IsByProd       || 0,    // заводские номера изделия: true = выбирались по зав.№, false = по блокам
															   // имеет смысл для компонента SelectZavNum		
			  "tip_id"        : this.data.tip_id         || 0,    // id текеущего выбранного типа журнала												   	

              "brigada_type"  : this.data.isp_id         ? 0 : 1,    // радиогруппа организация = 1 / бригада = 0
              "name_pred"     : "",   // имя исходного предъявления
	        },

	    required: [ "tip_name","naim","obozn","vid_oper","zavnum_string","kolvopredl","kolvovyborka",
	                "kolvogodn","kolvovozvrat","kolvobrak","brigada","organization","isp_fio","brig_fio"],
	    // имена обязательных к заполнению полей

	    missed: [],
        // имена полей, относящимся к обязательным и пустые на момент проверки заполнения поля

        errors: [],
        // сообщения об обнаруженных ошибках
  	}
  },

  watch: {
  	rec: {
  	  handler(val){
  	  	 this.checkMissed();
         this.checkErrors();
  	  },
  	  deep: true /// позволяет отслеживать состояние полей объекта
  	},

  	'rec.tip_name'(val){

  		for (var i = 0; i < this.journals.length; i++) {
   		
  			if (this.journals[i].tip_name == val) {
  				this.rec.tip_id = this.journals[i].id;
  			}
  		}
  	}
  },

  methods: {
      
      checkErrors(){

          this.errors.splice(0, this.errors.length);

          /// проверяем заполнение обязательных полей
          if (this.missed.length > 0) 
          	  this.errors.push('Не заполнено обязательных полей: ' + this.missed.length);
          
          

          var n = this.rec.kolvopredl;	
          if (!(!isNaN(parseFloat(n)) && !isNaN(n - 0)))	
          	  this.errors.push(`Поле Кол-во предъявлений содержит не числовое значение.`);

          n = this.rec.kolvovyborka;	
          if (!(!isNaN(parseFloat(n)) && !isNaN(n - 0)))	
          	  this.errors.push(`Поле Кол-во выборки содержит не числовое значение.`);

          n = this.rec.kolvogodn;	
          if (!(!isNaN(parseFloat(n)) && !isNaN(n - 0)))
          	  this.errors.push(`Поле Кол-во годных содержит не числовое значение.`);

          n = this.rec.kolvovozvrat;	
          if (!(!isNaN(parseFloat(n)) && !isNaN(n - 0)))
          	  this.errors.push(`Поле Кол-во возврата содержит не числовое значение.`);

          n = this.rec.kolvobrak;	
          if (!(!isNaN(parseFloat(n)) && !isNaN(n - 0)))
          	  this.errors.push(`Поле Кол-во брака содержит не числовое значение.`);

          return this.errors.length > 0;

      },

      checkMissed(){
		/// перебираем обязательные поля и если они не заполнены в текущий момен, добавляем их в массив missed,
		/// что подсветит их в интерфейсе      	   	    
        this.missed.length = 0;

		for(var field in this.rec){
			if ( this.isRequired(field) && ( this.rec[field] == null || '' + this.rec[field] === '')){
				
				if (field == 'organization' && this.rec.brigada_type == 0) continue;
				if (field == 'isp_fio' && this.rec.brigada_type == 0) continue;

				if (field == 'brig_fio' && this.rec.brigada_type == 1) continue;
				if (field == 'brigada' && this.rec.brigada_type == 1) continue;

				this.missed.push(field);
			}
		}
	},

      /// определяет, является ли указанное поле обязательным к заполнению
      isRequired(field){
      	  for (var i = 0; i < this.required.length; i++) {
	      	   	if (this.required[i] == field) {
	      	   		return true;
	      	   	}
      	   	
      	  }
      	  return false; 
      },

      /// определяет, является ли указанное поле обязательным к заполнению
      isMissed(field){
      	  for (var i = 0; i < this.missed.length; i++) {
	      	   	if (this.missed[i] == field) {
	      	   		return true;
	      	   	}
      	   	
      	  }
      	  return false; 
      },

      onCancel() {
          this.$emit('onCancel');
      },

      onDone(){
      	  this.$emit('onSave');
      },

      async onSave() {
          /// проверяем корректность заполнения формы

          /// проверка на ошибки заплнения формы
          console.log('проверка на ошибки заплнения формы...');

          if (this.checkErrors()) {
  
            console.log('...обнаружены');
  
            this.showErrors = true;
          	return;
          }

          console.log('...успешно');


          /// пытаемся найти подходящую первую подачу
          if ((!this.rec.firstpred_id || this.rec.firstpred_id == 0) && (this.mode == 0 /* режим создания журнала */)){
		      
              console.log('пытаемся найти подходящую первую подачу...');

		      let sql = `exec sp_JournalOTK_FindFirstPred '${this.rec.naim}','${this.rec.obozn}','${this.rec.vid_oper}','${this.rec.kizd}'`;
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
                      this.rec.firstpred_id = response.data.data.id;
			          this.rec.num_pred = response.data.data.num_pred + ' ' + this.rec.naim + ' ' + this.rec.obozn + ' ' + this.rec.vid_oper + ' зав. ' + this.rec.zavnum_string;
	              } else {

	              	  /// первая подача не найдена. спрашиваем у пользователя будем ли продолжать
	              	  /// при утвердительном ответе будет выполнена функция this.writeRecord()
                      console.log('...первая подача не найдена. спрашиваем у пользователя будем ли продолжать');
	              	  this.showDialog = 1;
	              	  return;
	              }
              } else {

              	  /// получена ошибка от сервера
                  console.log('...получена ошибка от сервера');
                  console.log(response.data.data);
              	  this.errors.push(response.data.data);
              	  return;
              }

          }



          /// все в порядке, пишем данные в базу
          console.log('все в порядке, пишем данные в базу');
	      this.writeRecord();

      },

      /// метод вызывается после проведения всех проверок данных, когда нужно их записать в базу (редмктировать/новая запись)
      async writeRecord(){

      	  let sql = 
    	    "exec sp_JournalOTK_InsEditRow " + 
			        this.rec.id                                                             + "," +	//	@id int, 
			  "'" + this.rec.naim + "'"                                                     + "," +	//	@naim VARCHAR(500), 
			  "'" + this.rec.obozn + "'"                                                    + "," +	//	@obozn VARCHAR(200), 
			  "'" + this.rec.vid_oper + "'"                                                 + "," +	//	@vid_oper VARCHAR(200), 
			  "'" + this.rec.kizd + "'"                                                     + "," +	//	@kizd VARCHAR(500),
			       (this.rec.zavnumdetal ? "'" + this.rec.zavnumdetal + "'" : "null")       + "," +	//	@zavnumDetal VARCHAR(200), 
			       (this.rec.geomrazmer  ? "'" + this.rec.geomrazmer  + "'" : "null")       + "," +	//	@GeomRazmer VARCHAR(200), 
			       (this.rec.material    ? "'" + this.rec.material    + "'" : "null")       + "," +	//	@material VARCHAR(200),
			        this.rec.kolvopredl                                                     + "," +	//	@kolvoPredl float,
			        this.rec.kolvovyborka                                                   + "," +	//	@KolvoVyborka float, 
			        this.rec.kolvogodn                                                      + "," +	//	@kolvoGodn float, 
			        this.rec.kolvovozvrat                                                   + "," +	//	@kolvoVozvrat float, 
			        this.rec.kolvobrak                                                      + "," +	//	@kolvoBrak float, 
			       (this.rec.opisaniedefekt ? "'" + this.rec.opisaniedefekt + "'" : "null") + ",";	//	@OpisanieDefekt VARCHAR(500),


          // радиогруппа организация = 1 / бригада = 0
		  if (this.rec.brigada_type == 0) {
			
			sql += 
			       "null"                                                                   + "," +	//	@isp_fio VARCHAR(3000), 
			  "'" + this.rec.brigada + "'"                                                  + "," +	//	@brigada VARCHAR(200), 
			       "null"                                                                   + ",";   //	@postav_id int, 
   		  } else {

			sql +=
			  "'" + this.rec.isp_fio + "'"                                                  + "," +	//	@isp_fio VARCHAR(3000), 
			       "null"                                                                   + "," +	//	@brigada VARCHAR(200), 
			        this.rec.postav_id                                                      + ",";	//	@postav_id int, 
		  };

			sql +=
			       (this.user_id          || this.rec.otk_emplid)                           + "," +	//	@otk_emplid int, 
			       (this.rec.primech      ? "'" + this.rec.primech + "'" : "null")          + "," +	//	@primech VARCHAR(500), 
			       (this.rec.firstpred_id || "null")                                        + "," +	//	@firstpred_id int,
			        this.rec.tip_id                                                         + "," +	//	@tip smallint,
			        this.rec.otk_emplid                                                     + "," +	//	@CurEmplID int, 
			  "'" + this.rec.zavnum_string + "'"                                            + "," +	//	@zavnum_string VARCHAR(500), 
			       (this.rec.noformula == "Да" ? 1 : 0)                                     + "," +	//	@NoFormula bit=0,
			       "null"                                                                   + "," +	//	@data Datetime=null,
			       (this.rec.ByProdId == true ? "1" : "0")                                  + "," +	//	@ByProdId bit=0, 
			       (this.rec.soprlist     ? "'" + this.rec.soprlist + "'" : "null")         + "," +	//	@SoprList VARCHAR(200), 
 	 		       (this.rec.kartakontrol ? "'" + this.rec.kartakontrol + "'" : "null")     + ",";	//	@KartaKontrol VARCHAR(200), 

 	 		       

          // радиогруппа организация = 1 / бригада = 0
		  if (this.rec.brigada_type == 0) 
			sql +=
			 "'" + this.rec.isp_emplid + "'";                                                           //	@isp_id VARCHAR(500)=null

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

          this.showDialog = 2;
      },

      /// метод показывает форму поиска с уже имеющимся в таблице журналов текстов по указанному полю
      showTextListForm(field_name, data_field){
	      
	      this.data_field = data_field;
	      this.titul_field = "text";

	      this.$store.dispatch(

              'ServerRequest',
              {
                  method: "sql",
                  sql: "SELECT DISTINCT " + field_name + " as text From JournalOTK WHERE isDel=0 AND ISNULL('" + field_name + "','''')<>''''  ORDER BY text",
                  callback: (data) => {

                      this.TextList = data;
                	  this.screen = 1;

                  }
              }
           );

      },

      showIspolnitelList(data_field){
	      
	      this.data_field = data_field;
	      this.titul_field = "fio";

	      this.$store.dispatch(

              'ServerRequest',
              {
                  method: "sql",
                  sql: "exec sp_JournalOTK_GetIsp",
                  callback: (data) => {

                      this.TextList = data;
                	  this.screen = 3;

                  }
              }
           );

      },

      showOrganizationList(data_field){
	      
	      this.data_field = data_field;
	      this.titul_field = "text";

	      this.$store.dispatch(

              'ServerRequest',
              {
                  method: "sql",
                  sql: "select id, naim + ' (ИНН ' + iNN + ')' as text from Postav",
                  callback: (data) => {

                      this.TextList = data;
                	  this.screen = 1;

                  }
              }
           );

      },


      changeBrigadaType(){

      	if (this.rec.brigada_type == 1) { // исполнитель - бригада
              
              this.rec.isp_fio = "";
              this.rec.post_id = 0;
              this.rec.organization = "";

      	} else { // исполнитель - организация
              
              this.rec.brig_fio = "";
              this.rec.isp_emplid = "";
              this.rec.brigada = "";
      	}
      },

      onSelect(text){
      	  this.rec[ this.data_field ] = text;
      	  this.screen = 0;
      },

      onCancelSelect(){
          this.screen = 0;
      },


      onSelectZav(ids, kizd, isByProd){
      	  this.rec.zavnum_string = ids;
      	  this.rec.kizd = kizd;
      	  this.rec.isByProd = isByProd;
      	  this.screen = 0;
      },

      onSelectIspol(ids, fios){
      	  this.rec.isp_emplid = ids;
      	  this.rec.brig_fio = fios;
      	  this.screen = 0;
      },

      ClearFirstPred(){
      	  this.rec.first_pred_id = null;
      	  this.rec.num_pred = null;
      },
  },

  mounted(){
  	  this.checkMissed();
  }

}	
</script>

<style>

#head            {grid-area: head;}
#num             {grid-area: num;}
#date            {grid-area: date;}
#num_pred        {grid-area: num_pred;}
#naim            {grid-area: naim;}
#vid_oper        {grid-area: vid_oper;}
#zavnumdetal     {grid-area: zavnumdetal;}
#brigada_fio     {grid-area: brigada_fio;}
#brigada         {grid-area: brigada;}
#organization_fio{grid-area: organization_fio;}
#organization    {grid-area: organization;}
#soprlist        {grid-area: soprlist;}
#kartakontrol    {grid-area: kartakontrol;}
#tip_name        {grid-area: tip_name;}
#obozn           {grid-area: obozn;}
#geomrazmer      {grid-area: geomrazmer;}
#zavnum_string   {grid-area: zavnum_string;}
#material        {grid-area: material;}
#kolvopredl      {grid-area: kolvopredl;}
#kolvovyborka    {grid-area: kolvovyborka;}
#kolvogodn       {grid-area: kolvogodn;}
#kolvovozvrat    {grid-area: kolvovozvrat;}
#kolvobrak       {grid-area: kolvobrak;}
#opisaniedefekt  {grid-area: opisaniedefekt;}
#primech         {grid-area: primech;}
#noformula       {grid-area: noformula;}
#errors          {grid-area: errors;}
#buttons         {grid-area: buttons;}

.root{
	display:grid;
    grid-template-columns: 1fr 900px 1fr;	    		
    grid-template-areas: ". card .";
}



#head{
	color: #30a1aa;
	border-bottom: 1px solid #f0edf0;
}

#card, .card{
	padding: 10px;
	border-radius: 10px;
	border: 1px solid #f0edf0; 
	box-shadow: 0 5px 5px rgba(0,0,0,0.15);
}

#card > div > p{
	width: 100%;

    margin-block-end: 0;
    margin-block-start: 1.5em;

}	
#card > div > input{ 
	width: calc(100% - 50px);
}	
#card > div > select{
	width: 90%;
} 


#card > div > input[type="radio"]{
	width: 20px;
	margin: 0;
} 
#brigada_fio input[type="text"], 
#organization_fio input[type="text"]
{
	width: calc(100% - 50px - 20px);
} 

#opisaniedefekt p,
#primech p{
	width: calc(100% - 60px) !important;
	display: inline-block !important;
}

#card > div > button{
	width: 30px;
}	
#card .vdp-datepicker input{
	width: 90%;
}

#card textarea{
	height: 100px;
	width: 90%;
	resize: none;
}


#noformula{
	margin: 10px 0 !important;
}
#noformula input{
	width: 20px !important;
}
#noformula p{
	display: inline !important;
}

#errors{
	position: sticky;
	bottom: 60px;
	border: 1px solid red;
	background-color: white;
	padding: 5px;
}
#errors button{
	float: right;
	width: 30px;
}
#errors div{
	width: calc(100% - 40px);
}

#buttons{
	position: sticky;
	bottom: 0;
	background-color: #fff;

	padding: 15px 0;
	border-top: 1px solid #f0edf0;
	vertical-align: middle;
}
#buttons button{
	width: 200px !important;
	margin-right: 20px;
}


#card{
	grid-area: card;

	display:grid;
    grid-template-areas:
	"head head head head head head"
	"num     date     num_pred num_pred num_pred num_pred"
	"naim naim naim naim     tip_name tip_name"
	"vid_oper vid_oper     zavnumdetal zavnumdetal     obozn obozn"
	"brigada_fio brigada_fio     brigada brigada     geomrazmer geomrazmer"
	"organization_fio organization_fio     organization organization     zavnum_string zavnum_string"
	"soprlist soprlist     kartakontrol kartakontrol     material material"
	"kolvopredl     kolvovyborka     kolvogodn . kolvovozvrat      kolvobrak"
	"opisaniedefekt opisaniedefekt opisaniedefekt     primech primech primech"
	"noformula noformula . . . ."
	"errors errors errors errors errors errors"
	"buttons buttons buttons buttons buttons buttons"
	;
}

.required:before{
	content: "* ";
	color: red;
	font-weight: bold;
	font-size: large;
}
.missed{
	border: 1px solid red;
}

@media all and (min-width: 0px) and (max-width: 920px){
.root{
	display:grid;
    grid-template-columns: 1fr;	    		
    grid-template-areas: "card";
}    
}

@media all and (min-width: 0px) and (max-width: 700px){
#card{
    grid-template-areas:
	"head head"
	"num date"
	"num_pred num_pred"
	"naim tip_name"
	"vid_oper zavnumdetal"
	"obozn obozn"
	"brigada_fio brigada"
	"organization_fio organization"
	"geomrazmer zavnum_string"
	"soprlist kartakontrol"
	"material material"
	"kolvopredl kolvovyborka"
	"kolvogodn kolvovozvrat"
	"kolvobrak kolvobrak"
	"opisaniedefekt opisaniedefekt"
	"primech primech"
	"noformula noformula"
	"errors errors"
	"buttons buttons"
	;
}
}

@media all and (min-width: 0px) and (max-width: 500px){
#card{
    grid-template-areas:
	"head"
	"num"
	"date"
	"num_pred"
	"naim"
	"tip_name"
	"vid_oper"
	"zavnumdetal"
	"obozn"
	"brigada_fio"
	"brigada"
	"organization_fio"
	"organization"
	"geomrazmer"
	"zavnum_string"
	"soprlist"
	"kartakontrol"
	"material"
	"kolvopredl"
	"kolvovyborka"
	"kolvogodn"
	"kolvovozvrat"
	"kolvobrak"
	"opisaniedefekt"
	"primech"
	"noformula"
	"errors"
	"buttons"
	;
}
#buttons button{
	width: 100px !important;
	margin-right: 20px;
}
}

</style>
