<template>
	<div>
		<div>
			<h4>Применение статуса Установлено</h4>
		</div>
		<div id="table-area">
			<div id="kz-table" class="table kz">
				<div class="row header">
					<div class="cell"><div class="content">Наименование</div></div>
					<div class="cell"><div class="content">Номенкл. №</div></div>
					<div class="cell"><div class="content">Ед. изм.</div></div>
					<div class="cell"><div class="content">Установить</div></div>
					<div class="cell"><div class="content">Зав. №</div></div>
					<div class="cell"><div class="content">Комментарий</div></div>
				</div>
				<div class="row" v-for="kz in kz_list">
					<div class="cell"><div class="content">{{kz.m}}</div></div>
					<div class="cell"><div class="content">{{kz.nomenkl}}</div></div>
					<div class="cell"><div class="content">{{kz.EIzm}}</div></div>
					<div class="cell"><div class="content"><input type="text" v-model="kz.Cnt"></div></div>
					<div class="cell"><div class="content"><input type="text" v-model="kz.ZavNum"></div></div>
					<div class="cell"><div class="content"><input type="text" v-model="kz.Comment"></div></div>
				</div>
			</div>
		</div>
		<button @click="onSave">Установить</button>
		<button @click="onCancel">Отмена</button>
	</div>
</template>

<script>
	export default {
        data(){
        	return {
        		kz_list: []
        	}
        },
        props: ['data', 'IzdId'],
		methods: {
			
            onCancel() {
            	this.$emit('onCancel');
            },

            onSave() {

	            let count = 0;
	            for(var item in this.kz_list){
	                count += this.kz_list[item].Cnt;
	            }

	            if (count > this.data.Cnt){
	                this.$emit('showError', 'Суммарное количество распределенных не может быть больше ' + this.data.Cnt + ' ' + this.data.EIzm);
	                return;
	            };

	            for(var item in this.kz_list){
	                let kz_item = this.kz_list[item];

	                this.$store.dispatch(

	                    'ServerRequest', 
	                    {
	                        method: "setMount",

	                        data: {
	                            Izd:        this.data.IzdId,       //    @IzdId int,                 --id изделия
	                            FirstMatId: this.data.CurMatId,    //    @FirstMatId int,            --id заменяемого покупного
	                            CurMatId:   kz_item.id,            //    @NewMatId int,              --id покупного, на которое заменяем
	                            Cnt:        kz_item.Cnt,           //    @Count float,               --количество устанавливаемого оборудования
	                            Division:   this.data.Division,    //    @div tinyint,               --0 - КИП, 1 - Технология, 2 - ОПС, 3 - Вентиляция, 5 - АОВ
	                            ZavNum:     kz_item.ZavNum || '',  //    @ZavNums nvarchar(500)='',  --заводские номера. null не допустим, иначе не склеится строка с текстом изменения
	                            Comment:    kz_item.Comment || '', //    @Comment nvarchar(200)='',  --примечание. null не допустим, иначе не склеится строка с текстом изменения
	                            BaseId:     this.data.id           //    @RecId int                  --id позиции, которая была ранее не установлена
	                        },

	                        callback: (data, error) => { 

	                            if (error) {

	                                /// не удалось получить данные 
	                                this.$emit('showError',  error );

	                            } else {

	                                /// при успешном получении данных
	                                this.$emit('showMessage', "Успешно");
	                                this.$emit('onCancel');

	                            }
	                        }
	                    }
	                );
	            }
            }
		},

		mounted(){

            console.log('IzdId: ' + this.IzdId);
            console.log('MatId: ' + this.data.CurMatId);
            
            this.$store.dispatch(

                'ServerRequest', 
                {
                    method: "getMat",

                    IzdId: this.IzdId,
                    MatId: this.data.CurMatId,

                    callback: (data, error) => { 

                        if (error) {

                            /// не удалось получить данные 
                            context.showError( error );

                        } else {

                            /// при успешном получении данных
                            this.kz_list = data;

                        }
                    }
                }
            );

		}
	}
</script>
<style>

  .kz .row{
  	display: grid;
    grid-template-rows: 1fr;
    grid-template-columns: 5fr 2fr 2fr 2fr 2fr 5fr;
  }

  .kz .row input{
    width: 90%; 
  }

  #table-area{
  	display: grid;
    grid-template-rows: 1fr;
    grid-template-columns: 10% 1fr 10%;
    grid-template-areas: ". kz-table .";
  }
  #kz-table{
  	grid-area: kz-table;
  }


@media all and (max-width: 1000px) {

  .kz .header { 
      display: none;
  } 

  .kz .row input{
    width: auto; 
  }

  .kz .cell{
    border-left: 0px solid white;
    border-top: 0px solid white;
    display: inline-block;
    text-align: left;
    padding-left: 30px;
  }

  .kz .cell .content{
      font-weight: bold;
  }

  .kz .cell .content:before{
    display: inline-block;
    width: 180px;
    font-weight: normal;
    text-align: right;
    margin-right: 10px;
  }

  .kz .row:not(.tools){
    grid-template-rows: repeat(6, minmax(auto, 1fr));
    grid-template-columns: 1fr;
  }

  .kz .cell:nth-child(1) .content:before  { content: "Наименование: "; }  
  .kz .cell:nth-child(2) .content:before  { content: "Номенкл. №: "; }  
  .kz .cell:nth-child(3) .content:before  { content: "Ед. изм.: "; }  
  .kz .cell:nth-child(4) .content:before  { content: "Количество: "; }  
  .kz .cell:nth-child(5) .content:before  { content: "Зав.№: "; }  
  .kz .cell:nth-child(6) .content:before  { content: "Примечание: "; }  
}    

</style>