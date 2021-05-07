<template>
	<div>
      <h1>Установленное оборудование</h1>
      <div id="error">{{error}}</div>
      <div id="message">{{message}}</div>

<!-- Окно добавления/правки позиции -->
      <EditForm v-if="screen==1" :caption="caption" :data="curr_data" :measure_list="mount_measure" @onCancel="ShowMain" @onSave="onSaveNew"/>

<!-- Окно правки позиции + смена статуса -->
      <EditForm v-if="screen==2" :caption="caption" :data="curr_data" @onCancel="ShowMain" @onSave="doChangeMount"/>

<!-- Окно правки позиции с имеющейся картой замены + смена статуса на Установлено -->
      <EditKZForm v-if="screen==3" :data="curr_data" :IzdId="mount_block_id" @onCancel="ShowMain" @onOk="onKZChange" @showError="showError" @showMessage="showMessage"/>

<!-- Окно отмены карты замены позиции -->
      <CancelKZForm v-if="screen==4" :data="curr_data" @onCancel="ShowMain" @onSave="onSaveNew"/>

<!-- Окно удаления позиции -->
      <DeletePosForm v-if="screen==5" :data="curr_data" @onCancel="ShowMain" @onSave="onSaveNew"/>

<!-- Окно истории позиции -->
      <HistoryForm v-if="screen==6" :data="curr_data" @onCancel="ShowMain" @onError="showError"/>

<!-- Меню операции над позицией -->
      <OperationMenu v-if="screen==9" :data="curr_data" @onCancel="ShowMain" @onEdit="goEdit" @onMount="goMount" @onMountKZ="goMountKZ" @onUnMount="goUnMount" @onCancelKZ="goCancelKZ" @onDelete="goDelete" @onHistory="goHistory"/>

<!-- Основное окно программы -->
      <div id="main" v-if="screen == 0">

          <div id="select">

            <div id="zavnum-select">
             <label>Зав. №</label>
             <input type="text" v-model="mount_zavnum" @keyup.enter="onGetBlocks" autocomplete="on">
             <button @click="onGetBlocks">Выбрать</button>
            </div>

            <div id="block-select">
             <label>Блок изделия</label>
             <select @change="onBlockSelect(null)" v-model="mount_block_id">
                 <!-- Обработчику события передается null, поскольку ожидается экземпляр Vue, а если ничего не передавать,
                      в параметр подставляется объект события изменения select, что ломает выборку данных из базы -->              
                 <option v-for="block in mount_blocks" :value="block.id">{{block.izd}}</option>
             </select>
            </div>

          </div>

          
         
          <div class="navigation">
            <div class="tab" @click="onChangeSection(0)" v-bind:class="{ active: mount_section==0 }">КИП</div>
            <div class="tab" @click="onChangeSection(1)" v-bind:class="{ active: mount_section==1 }">Технология</div>
            <div class="tab" @click="onChangeSection(2)" v-bind:class="{ active: mount_section==2 }">ОПС</div>
            <div class="tab" @click="onChangeSection(3)" v-bind:class="{ active: mount_section==3 }">Вентиляция</div>
            <div class="tab" @click="onChangeSection(4)" v-bind:class="{ active: mount_section==4 }">АОВ</div>
          </div>

          <div class="table main">
            <div class="row header">
              <div class="cell"></div>
              <div class="cell">Обозначение</div>
              <div class="cell">Наименование</div>
              <div class="cell">Номенкл. №</div>
              <div class="cell">Кол.</div>
              <div class="cell">Ед. изм.</div>
              <div class="cell">Зав. №</div>
              <div class="cell">Примечание</div>
              <div class="cell">Первоначальное наименование</div>
              <div class="cell">Первоначальный номенкл. №</div>
              <div class="cell"></div>
            </div>

            <div class="row tools">
              <table id="legend">
                <tr>              
                  <td class="unmount"></td>
                  <td >Не установлено</td>
                  <td class="mount"></td>
                  <td >Установлено</td>
                </tr>
              </table>

              <div id="addButton">
                  <button @click="onAdd" :disabled="mount_block_id==0">Добавить позицию</button>    
              </div>
            </div>

            <div class="row" v-for="(row, index) in mount_table" v-if="row.division == mount_section" :class="{ unmount: row.State == 0, mount: row.State == 1 }" @click="onMenuOpen(index)" :id="index">
                    <div class="cell">
                      <div class="content">
                          <img src="./../assets/mount/KZExists.jpg" data-toggle='tooltip' title='Имеется карта замены' v-if="row.kzex !== 0">
                          <img src="./../assets/mount/Documented.jpg" data-toggle='tooltip' title='Обработано БТД' v-if="row.BtdState !== 0">
                          <img src="./../assets/mount/dismantle.jpg" data-toggle='tooltip' title='Демонтировать при транспортировке' v-if="row.dismantle && row.dismantle !== 0">
                      </div>  
                    </div>
                    <div class="cell">
                      <div class="content">{{row.obozn}}</div>  
                    </div>
                    <div class="cell">
                      <div class="content">{{row.CurMat}}</div>  
                    </div>
                    <div class="cell">
                      <div class="content">{{row.CurNomenkl}}</div>  
                    </div>
                    <div class="cell">
                      <div class="content">{{row.Cnt}}</div>  
                    </div>
                    <div class="cell">
                      <div class="content">{{row.EIzm}}</div>  
                    </div>
                    <div class="cell">
                      <div class="content">{{row.ZavNum}}</div>  
                    </div>
                    <div class="cell">
                      <div class="content">{{row.Comment}}</div>  
                    </div>
                    <div class="cell">
                      <div class="content">{{row.FirstMat}}</div>  
                    </div>
                    <div class="cell">
                      <div class="content">{{row.FirstNomenkl}}</div>  
                    </div>
                    <div class="cell">
                      <div class="content">
                        <button @click="onMenuOpen(index)">...</button>
                      </div>  
                    </div>
            </div>    
          </div>
      </div>
	</div>  
</template>

<script>
import EditForm from '@/components/ComplMount/EditForm.vue'
import EditKZForm from '@/components/ComplMount/EditKZForm.vue'
import CancelKZForm from '@/components/ComplMount/CancelKZForm.vue'
import DeletePosForm from '@/components/ComplMount/DeletePosForm.vue'
import HistoryForm from '@/components/ComplMount/HistoryForm.vue'
import OperationMenu from '@/components/ComplMount/OperationMenu.vue'

export default {

    data() {
        return {
            // данные для модуля Установленное 
            mount_zavnum: '',   // текущий выбранный заводской номер
            old_mount_zavnum: '',

            mount_block_id: 0, // id текущего выбранного блока заводского номера
            mount_blocks: [],   // список всех блоков текущего выбранного заводского номера

            mount_section: 0,  // текущий выбранный раздел (КИП=0/Технология=1/ОПС=2/Вентиляция=3/АОВ=4)
            mount_table: [],    // данные по всем разделам текущего выбранного заводского номера и блоке

            mount_measure: [],  // набор единиц измерений для соответствующего выпадающего списка
            kz_list: [],        // набор позиций по карте замены для режима применения статуса Установлено (screen = 3)

            screen: 0,          // текущее отображаемое окно (режим работы)
            edit_mode: 0,       // текущий режим редактирования записи: 0 - редактирование, 1 - отмена карты замены, 2 - добавление 
            new_state: 0,       // новое значение для состояния( 0 - Не установлено, 1 - Установлено ) перед показом окна изменения статуса

            error: "",          // текущая ошибка
            message: "",          // текущее сообщение

            new_data:  // данные для нового добавляемого объекта
                { "id":null, 
                  "ZavNum":"", 
                  "Comment":"", 
                  "State":1,             // состояние: -1 - "Не обработано", 0 - Не установлено, 1 - Установлено
                  "division": 0,         // раздел (КИП=0/Технология=1/ОПС=2/Вентиляция=3/АОВ=4)
                  "CurMatId":-1,         // оригинальный id, если FirstMatId пуст, или id материал из карты замены
                  "CurMat":"", 
                  "CurNomenkl":"0", 
                  "EIzm":"шт", 
                  "FirstMatId":null,     // содержит id оригинального материала, если была применена карта замены
                  "FirstMat":null,       // содержит наименование оригинального материала, если была применена карта замены 
                  "FirstNomenkl":null,   // содержит номенклатурный номер оригинального материала, если была применена карта замены 
                  "Cnt":0,               // количество
                  "kzex": 0, 
                  "obozn": "", 
                  "BtdState": 0 
                },
            curr_data: {}, // данные текущего изменяемого объекта

            caption: "",
            edited_row: -1,
        }
    },

    components: { EditForm, EditKZForm, CancelKZForm, DeletePosForm, HistoryForm, OperationMenu },

    methods: {

        /// метод вызова окна со списком операциий для позиции на кнопку Обработать в списке
        onMenuOpen( val ){
            this.edited_row = val;
            this.curr_data = Object.assign({}, this.mount_table[val]); 
            this.screen = 9;
//            console.log( this.curr_data );
        },

        /// в меню операций была нажата кнопка Редактировать
        goEdit(){
            this.caption = "Редактирование позиции";
            this.edit_mode = 0;
            this.curr_data.BtdState = 2;
            this.screen = 1;
        },

        /// в меню операций была нажата кнопка Установлено
        goMount(){
            this.caption = "Применение статуса Установлено";
            this.new_state = 1;
            this.screen = 2;
        },

        /// в меню операций была нажата кнопка Установлено для позиции с картой замены
        goMountKZ(){
            this.curr_data.IzdId = this.mount_block_id;
            this.curr_data.Division = this.mount_section;
            this.new_state = 1;
            this.screen = 3;
        },

        onKZChange(){
            this.ShowMain();
            this.onBlockSelect(); 
        },

        /// в меню операций была нажата кнопка Не установлено
        goUnMount(){
            this.caption = "Применение статуса Не установлено";
            this.edit_mode = 0;
            this.new_state = 0;
            this.screen = 2;
        },

        doChangeMount( data ){
        /// метод вызывается из окна screen==2, изменение статуса на установлено или не установлено
            data.State = this.new_state;

            console.log('doChangeMount');
            if (data.id === null) {
                console.log('-> onSaveState');
                this.onSaveState( data );  
            } else {
                console.log('-> onSaveNew');
                this.onSaveNew( data );
            };
        },

        goCancelKZ(){
            this.edit_mode = 1;    /// режим удаления КЗ
            this.screen = 4;
        },

        goDelete(){
            this.curr_data.State = null;
            this.edit_mode = 0;    /// режим редактирования
            this.screen = 5;
        },

        goHistory(){
            this.curr_data.Izd = this.mount_block_id;
            this.screen = 6;
        },

        /// нажатие кнопки добавления позиции. показ формы
        onAdd(){
            this.caption = "Добавление позиции";

            /// обычное присвоение не прокатит, поскольку при редактировании пользователем изменится и this.new_data
            /// а эталон портить не стоит =)
            this.curr_data = Object.assign({}, this.new_data);
            this.edit_mode = 2;    /// режим добавления
            this.screen = 1;
        },
        

        onChangeSection(section){
            this.mount_section = section;
        },


        /// показ ошибки с установкой интервала до скрытия
        showError( error ) {
             /// показываем
             this.error = error;

             /// и прячем через некоторое время
             var owner = this;
             setTimeout(function(){owner.error = ""}, 5000);
        },

        /// показ сообщения с установкой интервала до скрытия
        showMessage( message ) {
             /// показываем
             this.message = message;

             /// и прячем через некоторое время
             var owner = this;
             setTimeout(function(){owner.message = ""}, 5000);
        },


        ShowMain(){
            this.error = "";
            this.screen = 0;
        },


        isNumber(n) { 
        
            return !isNaN(parseFloat(n)) && !isNaN(n - 0) 
        
        },

        /// нажатие кнопки сохранить на форме добавления/редактирования позиции
        /// на сервере хранимая процедура exec sp_vp_CMOTKRecEdit 
        onSaveNew( data ){

            /// проверяем введенные пользователем данные 
            if ((!data.CurMat) || (''+data.CurMat).trim() == "") { this.showError('Укажите наименование!');                      return; }
            if ((!data.Cnt) || (''+data.Cnt).trim() == "")       { this.showError('Укажите количество!');                        return; }
            if (!this.isNumber(data.Cnt))                        { this.showError('Укажите числовое значение количества!');      return; }
            if ((!data.EIzm) || data.EIzm.trim() == "")          { this.showError('Укажите единицу измерения!');                 return; }
            if (!this.edit_mode && this.edit_mode !== 0)         { this.showError('Укажите тип операции!');                      return; }

            console.log('[onSaveNew] data: '); 
            console.log(data); 
            console.log('[onSaveNew] mode: ' + this.edit_mode); 

            data.division = this.mount_section;
            data.Izd = this.mount_block_id;

            /// добавляем данные в базу
            var context = this; /// сохраняем контекст, поскольку this в callback не будет уже указывать на экземпляр Vue

            this.$store.dispatch(

                'ServerRequest', 
                {
                    method: "saveRecord",

                    data: data,
                    mode: this.edit_mode,    // режим работы с записью

                    callback: (data, error) => { 

                        if (error) {

                            /// не удалось добавить данные в базу 
                            context.showError( error );

                        } else {

                            /// при успешном внесении

                            /// перечитываем данные таблицы (тупо, но это проще всего. кодим на отябись)
                            context.onBlockSelect( context );

                            /// скрываем окно редактирования и показываем основное
                            context.showMessage('Успешно');
                            context.screen = 0;

                        }
                    }
                }
            );

        },


        /// нажатие кнопки сохранить на форме изменения статуса позиции
        /// на сервере хранимая процедура exec sp_vp_SetCMOTKRecState 
        onSaveState( data ){

            /// проверяем введенные пользователем данные 
            if ((!data.CurMat) || (''+data.CurMat).trim() == "") { this.showError('Укажите наименование!');                 return; }
            if ((!data.Cnt) || (''+data.Cnt).trim() == "")       { this.showError('Укажите количество!');                   return; }
            if (!this.isNumber(data.Cnt))                        { this.showError('Укажите числовое значение количества!'); return; }
            if ((!data.EIzm) || data.EIzm.trim() == "")          { this.showError('Укажите единицу измерения!');            return; }
            if (!this.edit_mode && this.edit_mode !== 0)         { this.showError('Укажите тип операции!');                 return; }
/*
            console.log('[onSaveState] data: '); 
            console.log(data); 
            console.log('[onSaveState] mode: ' + this.edit_mode); 
            console.log('[onSaveState] Izd: ' + this.mount_block_id); 
*/
            /// добавляем данные в локальную таблицу
            data.division = this.mount_section;
            data.State = this.new_state;
            data.Izd = this.mount_block_id;

            /// добавляем данные в базу
            var context = this; /// сохраняем контекст, поскольку this в callback не будет уже указывать на экземпляр Vue

            this.$store.dispatch(

                'ServerRequest', 
                {
                    method: "saveState",

                    data: data,

                    callback: (data, error) => { 

                        if (error) {

                            /// не удалось добавить данные в базу 
                            context.showError( error );

                        } else {

                            /// при успешном внесении

                            /// перечитываем данные таблицы (тупо, но это проще всего. кодим на отябись)
                            context.onBlockSelect( context );

                            /// скрываем окно редактирования и показываем основное
                            context.showMessage('Успешно');
                            context.screen = 0;

                        }
                    }
                }
            );

        },



        /// получение списка блоков текущего заводского номера
        /// источник данных на сервере процедура: sp_vp_get_CMOTKIzdBlocks
        onGetBlocks() {

            /// не будем запрашивать те же данные (заводской не изменился с последней выборки)
            if (this.old_mount_zavnum == this.mount_zavnum) return;

            /// сбрасываем id текущего выбранного блока. сейчас их состав изменится
            this.mount_block_id = 0;  

            /// сбрасываем данные ранее выбранного блока, поскольку он сейс обнулился
            this.mount_table = [];

            var context = this; /// сохраняем контекст, поскольку this в callback не будет уже указывать на экземпляр Vue

            this.$store.dispatch(

                'ServerRequest', 
                {
                    method: "getBlocks",

                    zavnum: this.mount_zavnum,

                    callback: (data, error) => { 

                        if (error) {

                            context.showError( error );

                        } else {

                            context.mount_blocks = data;   
                            context.old_mount_zavnum = context.mount_zavnum;
                        }
                    }
                }
            );

        },            

        /// при выборе блока, получаем данные об установленном оборудовании на по всем разделам.
        /// на стороне сервера за получение данных отвечает процедура sp_vp_get_CMOTKRecs 
        onBlockSelect( cnt ){

            var context = cnt || this; /// сохраняем контекст, поскольку this в callback не будет уже указывать на экземпляр Vue

            console.log('getMounted, mount_block_id = ' + this.mount_block_id);

            context.$store.dispatch(

                'ServerRequest', 
                {
                    method: "getMounted",

                    izdid: context.mount_block_id,

                    callback: (data, error) => { 

                        if (error) {

                            context.showError( error );

                        } else {

                            console.log('getMounted');
                            console.log(data);

                            context.mount_table = data; 

                            context.mount_table.forEach(function(item) {
                              item.ZavNum = '' + (item.ZavNum || '');
                            })  

                        }
                    }
                }
            );
        },

    },

    computed: {
    },

    updated: function () {
        /// после перерисовки компонента, если показан основной экран, а не вспомогательный
        /// производим переход на текущую рассматриваемую в списке запись
        /// ее индекс в массиве запоминается при щелчке по мтроке или кнопке для перехода на экран операций
      if ( this.screen == 0 )
      this.$nextTick(function () {
            var element = document.getElementById( this.edited_row );
            if (element) {
                var top = element.offsetTop;            
                window.scrollTo(0, top);
            }
    })
}    

}

</script>

<style>
/*
    COLOR SCHEMA
    blue: #30a1aa
    gray: #f0edf0
    red: #af1b1b
    black: #2d2d28
*/

  h1{
    color: #30a1aa;
  }


  #error{
    color: red;
  } 
  #message{
    color: #cadaba;
  } 



  #select{
    color: #30a1aa;
    border-bottom: 1px solid #f0edf0; 
    border-top: 1px solid #f0edf0; 
    padding: 10px;
    margin-bottom: 10px;
  }
  #select div{
    display: inline-block;
  }
  #select *{
    padding-right: 10px;
  } 
  #zavnum-select input{
    width: 100px;
    font-size: 110%;
  }
  #block-select select{
    min-width: 500px;
    font-size: 110%;
  }

  #add{
    text-align: left;
  }


  #legend{
    width: 400px;
    float: right;
  }
  .unmount{
    background-color: #fddac6;
  }
  .mount{
    background-color: #cadaba;
  }
 
  #legend .mount, #legend .unmount{
    width: 50px;
  }  


  
  .navigation{
      height: 40px;    
      background-color: white;
      overflow: hidden;
  }
  .tab{
    display: inline-block;
    cursor: pointer;
    width: 20%;
    height: 100%;
    padding-top: 1%;
    color: #af1b1b;
  }
  .active{
      font-weight: bold;
      background-color: #f0edf0;
      border-radius: 10px 10px 0 0;
  }





  #legend {
      grid-area: legend;
  }
  #addButton{
      grid-area: addButton;   
  }


  .main .row{
    display: grid;
    grid-template-rows: 1fr;
    grid-template-columns: 1fr 3fr 5fr 2fr 1fr 2fr 2fr 5fr 5fr 3fr 1fr;
  }


@media all and (min-width: 1201px) and (max-width: 1500px){
  .main .header .cell{
    border-left: 1px solid white;
    border-top: 1px solid white;
  }
  .main .cell{
    border-left: 1px solid #f0edf0;
    border-top: 1px solid #f0edf0;
  }
  .main .row{
    border-bottom: 1px solid #f0edf0;
  }

  .main .row:not(.tools){
    grid-template-rows: 1fr 1fr;
    grid-template-columns: 1fr 3fr 5fr 2fr 1fr 5fr 1fr;
  }

  /* grid-area: grid-row-start / grid-column-start / grid-row-end / grid-column-end */
  .main .cell:nth-child(1)  { grid-area: 1 / 1 / 3 / 2; } // иконки {} 
  .main .cell:nth-child(2)  { grid-area: 1 / 2 / 3 / 3; } // обозначение {}
  .main .cell:nth-child(3)  { grid-area: 1 / 3 / 2 / 4; } // наименование {}
  .main .cell:nth-child(9)  { grid-area: 2 / 3 / 3 / 4; } // наименование первоначальное {}
  .main .cell:nth-child(4)  { grid-area: 1 / 4 / 2 / 5; } // номенклатурный {}
  .main .cell:nth-child(10) { grid-area: 2 / 4 / 3 / 5; } // номенклатурный первоначальный {}
  .main .cell:nth-child(5)  { grid-area: 1 / 5 / 2 / 6; } // количество {}
  .main .cell:nth-child(6)  { grid-area: 2 / 5 / 3 / 6; } // единицы измерения {}
  .main .cell:nth-child(7)  { grid-area: 1 / 6 / 2 / 7; } // заводской номер {}
  .main .cell:nth-child(8)  { grid-area: 2 / 6 / 3 / 7; } // примечание {}
  .main .cell:nth-child(11) { grid-area: 1 / 7 / 3 / 8; } // кнопка {}
}





@media all and (min-width: 1001px) and (max-width: 1200px) {
  // кнопка {}

  .main .cell:nth-child(11){ 
      display: none;
  } 

  .main .row:not(.tools){
    grid-template-rows: 1fr 1fr;
    grid-template-columns: 1fr 3fr 5fr 2fr 1fr 5fr;
  }

  .main .header .cell{
    border-left: 1px solid white;
    border-top: 1px solid white;
  }
  .main .cell{
    border-left: 1px solid #f0edf0;
    border-top: 1px solid #f0edf0;
  }
}    





@media all and (max-width: 1000px) {

  .main .cell:nth-child(11), .main .header { 
      display: none;
  } 

  .main .cell{
    border-left: 0px solid white;
    border-top: 0px solid white;
    display: inline-block;
    text-align: left;
    padding-left: 30px;
  }

  .main .cell .content{
      font-weight: bold;
  }

  .main .cell .content:before{
    display: inline-block;
    width: 180px;
    font-weight: normal;
    text-align: right;
    margin-right: 10px;
  }

  .main .row:not(.tools){
    grid-template-rows: repeat(10, minmax(auto, 1fr));
    grid-template-columns: 1fr;
  }

  .main .cell:nth-child(1) .content:before  { content: "Статус: "; }  
  .main .cell:nth-child(2) .content:before  { content: "Обозначение: "; }  
  .main .cell:nth-child(3) .content:before  { content: "Наименование: "; }  
  .main .cell:nth-child(9) .content:before  { content: "Наим. первоначальное: "; }  
  .main .cell:nth-child(4) .content:before  { content: "Номенклатурный №: "; }  
  .main .cell:nth-child(10) .content:before  { content: "Номенкл. первонач. №: "; }  
  .main .cell:nth-child(5) .content:before  { content: "Количество: "; }  
  .main .cell:nth-child(6) .content:before  { content: "Ед. измерения: "; }  
  .main .cell:nth-child(7) .content:before  { content: "Заводской номер: "; }  
  .main .cell:nth-child(8) .content:before  { content: "Примечание: "; }  
}    

</style>
