<template>
    <div id="item-body">
        <div class="item-caption">
			<a href="#" @click="onClick">
			    {{item.name}}
			</a>
	    </div>
        <div class="item-image">
            <a href="#" @click="onClick">
                <img :src="require(`./../assets/${item.icon}.jpg`)" class="listitem">    
            </a>
        </div>
	</div>
<!--
    <div id="item-body">
        <div id="item-image">
            <a href="#" @click="onClick">
                <img :src="_image" class="listitem">    
            </a>
        </div>
        <div id="item-hint">
            {{_date}}   
        </div>
        <div id="item-hint">
            {{item.hint}}   
        </div>
        <div id="item-caption">
            <a href="#" @click="onClick">
                {{item.name}}
            </a>
        </div>
        <div id="item-detail">
            {{item.detail}} 
        </div>
    </div>
-->
</template>


<script>
	export default {
		computed: {
            _image() {
                /// без require, webpack не сможет подменить пути на корректные при компиляции проекта
            	return require('@/assets/' + this.item.icon + '.jpg')
            },
            _date() {
            	if ( this.item.date === undefined ) {
	            	return '';
            	} else {
            		
            		/// в данных поумолчанию дата формируется средствами JS и изначально корректна
            		var _date = this.item.date;
            		
            		/// из базы дата приходит как объект с полями даты в теустовом виде, временной зоной и прочей требухой
            		/// об этом 
            		if ( this.item.date.date !== undefined ) { _date = new Date(this.item.date.date); }

            		return _date.toLocaleString("ru", { year: 'numeric', month: 'long', day: 'numeric'});
            	}
            }
        },

        methods: {

        	/// клик по ссылке будет перенаправлять на страницы внешних программ, если заданы
        	/// например, фотоархив. при этом в url-строке могут содержаться ссылки на текущие данные
        	/// которые следует передать для корректного прехода (наример, для автологина)
        	/// потому, перед переходом эти данные подставляются в url-строку
        	
        	onClick(){
                
                var url = (this.item.url === null) || (this.item.url == "") ? '#' : this.item.url;
                
                if (url) {
					url = url.replace('{token}', this.$store.getters.getToken);
                }

                // есть внешняя ссылка - переходим
        		if (url !== '#') location.href = url;
        	}
        },

	    props: [ 'item' ]
	}    
</script>

<style>
    .item-caption a{
        color: #af1b1b;
        font-weight: bold;
        text-decoration: none;
    }
</style>