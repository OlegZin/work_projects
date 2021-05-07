<template>
    <div id="item-body">
       <div v-for="item in data" v-if="((item.num_str.length > 10) && showMob == true) || (item.num_str.length < 10) || item.is_hidden == 0" class = contactPhone>
          <div class = phone>{{item.num_str | number_filter }}</div>
          <div class = toCall @click="onCall(item.empl_id, item.num)"><img src="./../../assets/phone/call.png"></div>
          <div class = toConf @click="onToConf(item.empl_id, item.num, item.num_str)"><img src="./../../assets/phone/conference.png"></div>
       </div> 
	</div>
</template>


<script>
	export default {
        data() {
          return {
          	data: {},
          }
        },

        methods: {
            onCall(empl_id, phoneNumber) {
            	this.$emit('onCall', empl_id, phoneNumber);
            },
            onToConf(empl_id, phoneNumber, phoneCaption) {
            	this.$emit('onToConf', empl_id, phoneNumber, phoneCaption);
            },
            showPhone(item){
              return 
                  // установлен флаг показывать мобильники и это мобильник
                  ((this.item.num_str.length > 10) && this.showMob == true) || 
                  
                  // это не мобильник
                  (this.item.num_str.length < 10) || 

                  // номер не является скрытым
                  this.item.is_hidden == 0;
            }
        },

	    props: [ 'showMob', 'id', 'phones' ],
	
		/// на загрузку получаем данные
	    mounted(){
        this.data = this.phones;	      
	    },

      filters: {
        number_filter: function(value){
           if  (value.length > 10) {return 'Моб.'} else {return value};
        }
      },
	}


</script>

<style>
  .contactPhone{
     display:grid;
     grid-template-columns: 130px 40px 30px; 
     grid-template-areas: "phone toCall toConf"
  }  

  .phone   { grid-area: phone; align-self: center; justify-self: end;}
  .toCall  { grid-area: toCall; align-self: center; cursor: pointer;}
  .toConf  { grid-area: toConf; align-self: center; cursor: pointer;}

</style>