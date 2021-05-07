<template>
	<div id="root">
	<div id="content">
		<div id="top">
			<div>
				<input type="radio" name="type" value="1" v-model="isByNaim">
				<p>Зав.№</p>
				<input type="radio" name="type" value="0" v-model="isByNaim">
				<p>Блоки</p>
			</div>
			<div>
				<select v-model="search_type">
					<option>Зав.№</option>
					<option>Обозначение/Наименование</option>
				</select>
				<input type="text" v-model="search_string">
				<img src="./../../assets/otk/search.png" @click="getData">
				<img src="./../../assets/otk/clear.png">
			</div>
		</div>
		<div id="zavfound">
			<div class="table zav">
				<div class="row header">
					<div class=cell><img src="./../../assets/otk/check.png"></div>
					<div class=cell>Зав.№</div>
					<div class=cell>Обозначение</div>
					<div class=cell>Наименование</div>
				</div>
				<div class="row" v-for="(item, index) in search_data">
					<div class=cell><img src="./../../assets/otk/check.png" @click="doSelect(index)"></div>
					<div class=cell>{{item.zavnum}}</div>
					<div class=cell>{{item.obizd}}</div>
					<div class=cell>{{item.naimizd}}</div>
				</div>
			</div>
		</div>
		<div id="zavselect">
			<p>Выбранные позиции</p>
			<div class="table zav">
				<div class="row header">
					<div class=cell><img src="./../../assets/otk/clear.png"></div>
					<div class=cell>Зав.№</div>
					<div class=cell>Обозначение</div>
					<div class=cell>Наименование</div>
				</div>
				<div class="row" v-for="(item, index) in selected_data">
					<div class=cell><img src="./../../assets/otk/clear.png" @click="doUnselect(index)"></div>
					<div class=cell>{{item.zavnum}}</div>
					<div class=cell>{{item.obizd}}</div>
					<div class=cell>{{item.naimizd}}</div>
				</div>
			</div>
		</div>	
		<div id="bottom">
			<button @click="onSelect">Выбрать</button>
			<button @click="onCancel">Закрыть</button>
		</div>
	</div>
	</div>
</template>


<script>
export default{
	
	props: [ 'isByProd' ],

	data(){
		return{
			search_data: [],      // массив найденных по текущим условиям блоков
			selected_data: [],    // массив выбранных блоков

			search_type: "Зав.№", // режим в выпадающем списке
			search_string: "",    // текущее значение по которому искать блоки
			isByNaim : this.isByProd, // режим в в радиогруппе: 1 = по заводскому, 0 = по наименованию
		}
	},

	methods:{

		onSelect(){
			
			if (this.selected_data.length != 0) {
				
				/// получаем список id 
				var selected_ids = this.selected_data.map( elem => elem.izdeli_id );

	            /// по ним получаем 
	            this.$store.dispatch(

	              'ServerRequest',
	              {
	                  method: "sql",
	                  sql: 'exec sp_JournalOTK_GetZavNums "' + selected_ids.join(',') + '", ' + this.isByNaim,
	                  callback: (data) => {

				      	this.$emit('onSelect', data[0].res, selected_ids.join(','), this.isByNaim != 1 );
				      		// isByNaim != 1 - возврат логического значения, выбирались ли блоки по заводским номерам

	                  }
	              }
	            );			

			}


			
		},

		onCancel(){
			this.$emit('onCancel');
		},

		getData(){
            
            if (!this.search_string || this.search_string == '') return;

            this.$store.dispatch(

              'ServerRequest',
              {
                  method: "sql",
                  sql: 'exec sp_JournalOTK_spisokIzd "' + this.search_string + '", null, ' + (this.search_type == "Зав.№" ? '1' : '0') + ', ' + this.isByNaim,
                  callback: (data) => {

                      this.search_data = data;

                  }
              }
           );			
		},

		doSelect(index){
			this.selected_data.push( this.search_data[index] );
			this.search_data.splice(index, 1);
		},
		doUnselect(index){
			this.selected_data.splice(index, 1);
		},
	}

}	
</script>

<style>

#content{ 
	grid-area: content; 
	padding: 10px;
	border-radius: 10px;
	border: 1px solid #f0edf0; 
	box-shadow: 0 5px 5px rgba(0,0,0,0.15);
	margin-bottom: 10px;	
}	
#root{
	display: grid;
	grid-template-areas: ". content .";
}

#top > div > *{
	display: inline-block;
	margin-right: 5px;
}
#top img{
	height: 25px;
	width: 25px;
	vertical-align: middle;
}
#top select{
	width: 150px;
}

.table.zav .row{
	display: grid;
	grid-template-columns: 1fr 1fr 2fr 4fr;
}	
.table.zav img{
	height: 20px;
	width: 20px;
}	
#zavselect{
	position: sticky;
	bottom: 40px;
	background-color: #fff;
	border-top: 1px solid #f0edf0;
}
#bottom{
	position: sticky;
	bottom: 0;
	background-color: #fff;
	height: 30px;
	padding-top: 10px;
}

@media all and (min-width: 0px) and (max-width: 600px){
#top {
	display: grid;
	grid-template-rows: 1fr 1fr;
}
}
</style>

