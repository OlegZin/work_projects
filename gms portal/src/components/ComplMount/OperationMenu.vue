<template>
	<div>
          <div class="table main">
            <div class="row header">
              <div class="cell"></div>
              <div class="cell">Обозначение</div>
              <div class="cell">Наименование</div>
              <div class="cell">Номенкл. №</div>
              <div class="cell">Кол.</div>
              <div class="cell">Ед. изм.</div>
              <div class="cell">Зав. №</div>
              <div class="cell">Примечание</div>
              <div class="cell">Первоначальное наименование</div>
              <div class="cell">Первоначальный номенкл. №</div>
              <div class="cell"></div>
            </div>
            <div class="row" :class="{ unmount: data.State == 0, mount: data.State == 1 }">
                    <div class="cell">
                      <img src="./../../assets/mount/KZExists.jpg" data-toggle='tooltip' title='Имеется карта замены' v-if="data.kzex !== 0">
                      <img src="./../../assets/mount/Documented.jpg" data-toggle='tooltip' title='Обработано БТД' v-if="data.BtdState !== 0">
                    </div>
                    <div class="cell"><div class="content">{{data.obozn}}</div></div>
                    <div class="cell"><div class="content">{{data.CurMat}}</div></div>
                    <div class="cell"><div class="content">{{data.CurNomenkl}}</div></div>
                    <div class="cell"><div class="content">{{data.Cnt}}</div></div>
                    <div class="cell"><div class="content">{{data.EIzm}}</div></div>
                    <div class="cell"><div class="content">{{data.ZavNum}}</div></div>
                    <div class="cell"><div class="content">{{data.Comment}}</div></div>
                    <div class="cell"><div class="content">{{data.FirstMat}}</div></div>
                    <div class="cell"><div class="content">{{data.FirstNomenkl}}</div></div>
                    <div class="cell"></div>
            </div>
          </div> 

          <button @click="onMount"    v-if="(data.State == -1 && data.kzex == 0) || (data.BtdState == 0 && data.State == 0 && data.kzex == 0)">Установлено</button> 
          <button @click="onMountKZ"  v-if="(data.State == -1 && data.kzex == 1) || (data.BtdState == 0 && data.State == 0 && data.kzex == 1)">Установлено</button> 
          <button @click="onUnMount"  :disabled="data.State == 0 || ( data.State == 1 && data.BtdState !== 0 )">Не установлено</button> 
          <button @click="onEdit"     :disabled="data.State == -1 || ( data.State == 0 && data.BtdState !== 0 ) || ( data.State == 1 && data.BtdState == 0 )">Редактировать</button> 
          <button @click="onCancelKZ" :disabled="( data.FirstMatId == null || data.FirstMatId == data.CurMatId ) && data.BtdState == 0">Отменить КЗ</button> 
          <button @click="onDelete"   :disabled="data.State == -1 || data.BtdState == 1 ">Удалить</button> 
          <button @click="onHistory">История изменений</button> 
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
        onEdit() {
        	this.$emit('onEdit');
        },
        onMount() {
          this.$emit('onMount');
        },
        onMountKZ() {
          this.$emit('onMountKZ');
        },
        onUnMount() {
          this.$emit('onUnMount');
        },
        onCancelKZ() {
          this.$emit('onCancelKZ');
        },
        onDelete() {
          this.$emit('onDelete');
        },
        onHistory() {
          this.$emit('onHistory');
        }
		}
	}
</script>
<style>
  button{
    margin-right: 10px;
  }
</style>