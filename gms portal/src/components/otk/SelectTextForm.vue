<template>
	<div>
		<div id="root">
			<div id="list">
				<div 
				    v-for="item in list" 

				    class="elem cell" 
				    :class="{selected: value == item[titul]}"

				    v-show="isVisible(item[titul])"

				    @click="value = item[titul]; id = item.id" 
				    @dblclick="onSelect" 

				>{{item[titul]}}</div>			
			</div>
		</div>
		<div class="buttons">
			<input type="text" v-model="search">
			<img src="./../../assets/otk/clear.png" @click="search = ''">
			<button @click="onSelect">Выбрать</button>
			<button @click="onCancelSelect">Закрыть</button>
	    </div>
	</div>
</template>

<style>

#list{
	grid-area: content;

	padding: 10px;
	border-radius: 10px;
	border: 1px solid #f0edf0; 
	box-shadow: 0 5px 5px rgba(0,0,0,0.15);
	margin-bottom: 10px;
}

#root{
	display: grid;
    grid-template-columns: 1fr minmax(0px, 600px) 1fr;	    		
	grid-template-areas: ". content ."
}

.elem{
	border-bottom: 1px solid #f0edf0; 
}

.elem:hover{
	color: #30a1aa;
}

.elem.selected{
	background-color: #f0edf0;
}

.buttons{
	background-color: #fff;
	position: sticky;
	bottom: 0;	
	padding: 10px 0;
	border-top: 1px solid #f0edf0; 
}
.buttons img{
	height: 25px;
	width: 25px;
	vertical-align: middle;
	margin-right: 20px;
}

</style>

<script>

export default {	

	props: [ 'list', 'titul' ],

	data(){
	    return{
	    	value: "",
	    	id: 0,
	    	search: "",
	    }	
	},

	methods:{
		onSelect(){
			this.$emit('onSelect', this.value, this.id);
		},
		onCancelSelect(){
			this.$emit('onCancelSelect');
		},

		isVisible(value){
			value = ''+value || '';
			return value.indexOf(this.search) !== -1;
		}
	}
}
	
</script>