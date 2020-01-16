<template>
	<div class="list">
		<ListItem v-for="item in list" v-bind:item="item"/>
	</div>
</template>

<script>
	import ListItem from './ListItem'

	export default {
	  components: { ListItem },
	  props: [ 'list' ]
	}    
</script>

<style>
    .list{
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));        
        margin-top: 50px;
    }
</style>