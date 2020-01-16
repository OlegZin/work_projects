<template>
	<div>
    	<h4>Удаление позиции</h4>
    	<p>Вы уверены, что хотите удалить позицию: {{data.CurMat}} ?</p>
		<button @click="onDelete">Отменить КЗ</button>
		<button @click="onCancel">Отмена</button>
	</div>
</template>

<script>
	export default {
		props: [ 'data' ],
		methods: {
            onCancel() {
            	this.$emit('onCancel');
            },
            onDelete() {
            	this.$emit('onDelete', this.data);
            }
		}
	}
</script>
<style>
</style>