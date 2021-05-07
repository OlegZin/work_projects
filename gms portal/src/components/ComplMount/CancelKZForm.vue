<template>
	<div>
    	<h4>Удаление карты замены</h4>
    	<p>Вы уверены, что хотите отменить применённую карту замены у позиции: {{data.CurMat}} ?</p>
		<button @click="onCancelKZ">Отменить КЗ</button>
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
            onCancelKZ() {
            	this.$emit('onSave', this.data);
            }
		}
	}
</script>
<style>
</style>