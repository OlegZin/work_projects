<template>
	<div id="history">
    	<h4>История изменений позиции</h4>
    	<div class="block">
            <div class="table history">
        		<div class="row header">
        			<div class="cell">Дата</div>
        			<div class="cell">Инициатор</div>
        		</div>
        		<div class="content">
                <div class="row" @click="onClick(index)" v-for="(item, index) in list" :class="{ selected: index == sel_index }">
        			<div class="cell">{{_date(item.Date)}}</div>
        			<div class="cell">{{item.name}}</div>
        		</div>
                </div>
        	</div>
        </div>

        <div class="block">
            <textarea readonly="true">{{message}}</textarea>
        </div>

        <div class="block">
    		<button @click="onCancel">Закрыть</button>
        </div>
	</div>
</template>

<script>
	export default {
		data(){
			return {
				list: [],
				message: "",
                sel_index: null,
			}
		},

		props: [ 'data' ],

		methods: {
            
            onCancel() {
            	this.$emit('onCancel');
            },
	
			_date(date) {

            	if ( date === undefined ) {
	            	return '';
            	} else {
            		
            		/// из базы дата приходит как объект с полями даты в теустовом виде, временной зоной и прочей требухой
            		/// об этом 
            		if ( date.date !== undefined ) { date = new Date(date.date); }

            		return date.toLocaleString("ru", { year: 'numeric', month: 'numeric', day: 'numeric', hour:"numeric", minute:"numeric", second:"numeric"});
            	}
            },

			onClick( index ){
				this.message = this.list[index].Mess;
                this.sel_index = index;
			}

		},


		mounted(){

/// есть проблема у AXIOS со знаками + при url кодировке. Это связано с некорректными библиотеками, неподдерживающими стандарт.
/// https://github.com/axios/axios/issues/1111    
/// для обхода проблемы, чтобы не перелопачивать логику, значимой строкой для поиска будет все от начала до первого найденного плюса,
/// или вся строке, если их нет.
            let obz = this.data.CurMat;
            if (obz.indexOf('+') > -1) obz = obz.slice(0, obz.indexOf('+')-1);

            this.$store.dispatch(

                'ServerRequest', 
                {
                    method: "getHistory",

                    Izd: this.data.Izd, 
                    obozn: obz,

                    callback: (data, error) => { 

                        if (error) {

                            this.$emit('onError', error);

                        } else {

                            this.list = data;   

                        }
                    }
                }
            );
		}

	}
</script>

<style>


  #history textarea{
    max-height: 300px;
    min-height: 300px;
  }
  #history .table{
      margin-left: auto; 
      margin-right: auto; 
  }  

  #history .row{
    display: grid;
    grid-template-columns: 1fr 1fr;
  }

  #history .row.selected{
    color: #af1b1b;
    font-weight: bold;
  }

  #history .content{
    max-height: 500px;
    overflow-y: scroll;
  }

@media (min-width: 1050px) {
  
  #history textarea, #history .table{
    max-width: 1000px;
    min-width: 1000px;
  }
}
    
@media (max-width: 1049px) {
  
  #history textarea, #history .table{
    max-width: 100%;
    min-width: 100%;
  }

@media (max-width: 500px) {
  
  #history .row{
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: 1fr 1fr;
  }
}

}

</style>