<template>
	<div>
		<div class="header">
			<h4>{{caption}}</h4>
		</div>

		<div id="body">

				<div>Обозначение</div>
				<div><input v-model="data.obozn" :disabled="isReadonly"></div>

				<div class="require">Наименование</div>
				<div><input v-model="data.CurMat" :disabled="isReadonly"></div>

				<div>Зав. №</div>
				<div><input v-model="data.ZavNum" autocomplete="on"></div>

				<div>Примечание</div>
				<div><input v-model="data.Comment"></div>

				<div class="require" for="Cnt">Кол.</div>
				<div><input type="number" v-model="data.Cnt" min='0.001' step='0.001'></div>

				<div class="require">Ед. изм.</div>
				<div>
					<select v-model="data.EIzm" :disabled="isReadonly">
				       <option v-for="measure in measure_list" :value="measure.Naimeb" :selected="{ selected: data.EIzm == measure.Naimeb }">{{measure.Naimeb}}</option>
				    </select>
			    </div>

		</div>

		<div class="footer">
			<button @click="onSave">Сохранить</button>
			<button @click="onCancel">Отмена</button>
		</div>
	</div>
</template>

<script>
	export default {
		data(){
			return {
				measure_list: []		
			}
		},

		props: [ 'caption', 'data' ],
		
		methods: {
            onCancel() {
            	this.$emit('onCancel');
            },
            onSave() {
            	///this.data.ZavNum = '{}'+this.data.ZavNum;
            	/// костыль, предотвращающий превращение значения этого поля в число при передаче на сервер,
            	/// когда у пользователей пропадают нолиси в начале числа, а это не допустимо
            	this.$emit('onSave', this.data);
            }
		},

		computed: {
			isReadonly: function(){ return (this.data.CurMatId) && (this.data.CurMatId !== -1) }
        },

	    mounted(){

	            
	            /// получаем список единиц измерения
	            var context = this; /// сохраняем контекст, поскольку this в callback не будет уже указывать на экземпляр Vue

	            this.$store.dispatch(

	                'ServerRequest', 
	                {
	                    method: "getMeasures",

	                    callback: (data, error) => { 

	                        if (error) {

	                            context.showError( error );

	                        } else {

	                            this.measure_list = data;   

	                        }
	                    }
	                }
	            );
	    }

	}
</script>
<style>

    #body{
    	display: grid;
	    grid-template-rows: repeat(6, 1fr);
	    grid-template-columns: 1fr 5fr;
    }
    #body *{
    	margin: 5px;
    }
    
    .require:after{
        content: "*";
        color: #af1b1b;
    }

    #body div:nth-child(odd){
        text-align: right;
        margin-right: 20px;
    }
    #body div:nth-child(even){
        text-align: left;
        width: 80%;
    }
    #body div:nth-child(even) *{
        width: 100%;
    }


</style>