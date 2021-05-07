<template>
	<div id="root">
	<div id="content">
		<div id="zavfound">
			<div class="table zav">
				<div class="row header">
					<div class=cell></div>
					<div class=cell>ФИО</div>
					<div class=cell>Отдел</div>
					<div class=cell>Должность</div>
				</div>
				<div class="row" v-for="(item, index) in list" v-show="isVisible(item.FIO)">
					<div class=cell><img src="./../../assets/otk/check.png" @click="doSelect(index)"></div>
					<div class=cell>{{item.FIO}}</div>
					<div class=cell>{{item.otdel}}</div>
					<div class=cell>{{item.post}}</div>
				</div>
			</div>
		</div>
		<div id="zavselect">
			<p>Выбранные сотрудники {{selected_data.length}}</p>
			<div class="table zav">
				<div class="row header">
					<div class=cell><img src="./../../assets/otk/clear.png" @click="doClear"></div>
					<div class=cell>ФИО</div>
					<div class=cell>Отдел</div>
					<div class=cell>Должность</div>
				</div>
				<div class="row" v-for="(item, index) in selected_data">
					<div class=cell><img src="./../../assets/otk/clear.png" @click="doUnselect(index)"></div>
					<div class=cell>{{item.FIO}}</div>
					<div class=cell>{{item.otdel}}</div>
					<div class=cell>{{item.post}}</div>
				</div>
			</div>
		</div>	
		<div class="buttons">
			<input type="text" v-model="search">
			<img src="./../../assets/otk/clear.png" @click="search = ''">
			<button @click="onSelect">Выбрать</button>
			<button @click="onCancel">Закрыть</button>
	    </div>
	</div>
	</div>
</template>


<script>
export default{
	
	props:[ 'list' ],

	data(){
		return{
			selected_data: [],    // массив выбранных исполнителей
			search: "",
		}
	},

	methods:{

		onSelect(){
			let ids = this.selected_data.map( elem => elem.id );
			let fios = this.selected_data.map( elem => elem.FIO );

			this.$emit('onSelect', ids.join(','), fios.join(', '));
		},

		onCancel(){
			this.$emit('onCancel');
		},

		doSelect(index){
			
			/// если привышен максимум выборки - игнорируем
			if (this.selected_data.length >= process.env.VUE_APP_ISPOL_MAX_COUNT) return;

			/// ищем повторы в выбранных
			let found = false;

			for (var i = 0; i < this.selected_data.length; i++) {
				if ( this.selected_data[i].FIO == this.list[index].FIO ){
					found = true;
					break;
				}
			}

			if (found) return;

			this.selected_data.push( this.list[index] );
		},
		doUnselect(index){
			this.selected_data.splice(index, 1);
		},

		doClear(){
			this.selected_data.splice(0, this.selected_data.length);
		},

		isVisible(value){
			value = ''+value || '';
			return value.indexOf(this.search) !== -1;
		}

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

#top > *{
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
	grid-template-columns: 50px 2fr 1fr 4fr;
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
</style>
