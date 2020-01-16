<template>
  <div>
    <div id="user-menu">
        <img src="./../assets/user.jpg">{{fio}}
        <button @click="onLogout" >Разлогиниться</button>
        <button @click="confirm=true">Сменить пароль</button>
        <button :disabled="!isAdmin" @click="$router.push('AdminPanel')">Администрирование</button>
        <button @click="onUserMenu">Закрыть</button>
    </div>
    <div id="confirm" v-if="confirm">
      Вы действительно хотите разлогиниться и получить новый пароль? <span @click="confirm=false">Нет</span><span @click="onPassChange">Да</span>
    </div>
  </div>
</template>

<script>
export default {
  data(){
    return {
       confirm: false,    /// флаг показа строки подтверждения смены пароля
    }
  },
  computed: {
      fio () { return this.$store.getters.getFio || "" },
      isAdmin () { return this.$store.getters.getAdmin == "1" },
  },
  methods: {
      onLogout(){
           this.$emit('onLogout');
      },
      onUserMenu(){
           this.$emit('onUserMenu');
      },
      onPassChange(){
           this.$emit('onPassChange');
      }
  }
}

</script>

<style>

#user-menu{
  padding: 10px;
  border-top: 1px solid #f0edf0;
  border-bottom: 1px solid #f0edf0;
  display: grid;
  grid-template-columns: 30px 200px repeat(4, 1fr);
  align-items: center;
}

#confirm{
    border-bottom: 1px solid #f0edf0;
    padding: 10px;
}
#confirm span{
  display: inline-block;
  width: 50px;
  color: #af1b1b;;
  font-weight: bold;
}

@media all and (max-width: 800px){

  #user-menu{
    grid-template-columns: 2fr 1fr;
    grid-template-rows: repeat(5, 1fr);
  }

}
</style>
