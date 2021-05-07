<template>
  <div id="app">
    <div id="top-panel" >
      <div id="home"><a href="#/"><img src="./assets/home.jpg" title="К списку программ"></a></div>
      <div id="user" v-if="isLogged && !isUserOptions"><img src="./assets/user.jpg"><a href="#" @click="onUserMenu">{{fio}}</a></div>
    </div>
    <UserPanel v-if="isLogged && isUserOptions" @onLogout="onLogout" @onUserMenu="onUserMenu" @onPassChange="onPassChange"/>
    <LoginForm v-if="!isLogged"/>
    <router-view v-if="isLogged"/>
  </div>
</template>

<script>
import LoginForm from '@/components/LoginForm.vue'  
import UserPanel from '@/components/UserPanel.vue'  

const axios = require('axios');

export default {
  data(){
    return {
       isUserOptions: false,
    }
  },
  computed: {
      isLogged () { return this.$store.state.token !== "" },
      fio () { return this.$store.getters.getFio || "" },
  },
  components: { LoginForm, UserPanel },
  methods: {
      onLogout(){
           this.$store.dispatch('removeToken');
           this.$store.dispatch('removeFio');
           this.$store.dispatch('removeAdmin');
           window.location.reload();
      },
      onUserMenu(){
         this.isUserOptions = !this.isUserOptions;
      },
      onPassChange(){
          this.comfirm = false;
          let context = this;

          this.$store.dispatch(
              'ServerRequest', 
              {    
                  method: "restore",
                  callback: (data) => { this.onLogout(); }
              }
          );
      }
  }
}

</script>

<style>

#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}

#top-panel{
  display: grid;
  grid-template-rows: 1fr;
  grid-template-columns: 50px 1fr 200px;
  grid-template-areas: "home . user";
}
#user{
  grid-area: user;
  display: grid;
  grid-template-columns: 40px 1fr;
  align-items: center;
}
#home img{
  width: 30px;
  height: 30px;
  grid-area: home;
}

  button{
    color: #af1b1b;
    background-color: #f0edf0;
    border-radius: 5px;
    border-width: 0;
    padding: 5px 10px;
    margin-right: 10px;
  } 

  button:disabled{
    color: white;
    background-color: #f0edf0;
  } 

  .table{
    margin-bottom: 10px;
  } 
  .row.header{
    font-weight: bold;
    background-color: #f0edf0;
    color: #30a1aa;
    border-top: 1px solid white; 
  }

  .row{ 
    padding: 5px;
    border-bottom: 1px solid white; 
    border-top: 1px solid white; 
  } 

  .row:hover, .row.tools{
    color: #30a1aa;
    border-bottom: 1px solid #f0edf0; 
    border-top: 1px solid #f0edf0; 
  }
  .row:nth-last-child(1), .row.tools{
    margin-bottom: 1px;
  }
  .main .cell:nth-child(3), .main .cell:nth-child(9){
    text-align: left;
  }

  .cell {
      display: grid;
      align-items: center;
  }
    .cell .content {
      overflow: hidden;  
  }


  .row.tools{
    display: grid;
    grid-template-areas: "legend . addButton";
    grid-template-rows: 1fr;
    grid-template-columns: 300px 1fr 200px;
  }


@media all and (max-width: 800px){

  button{
    grid-column: 1 / 3;
  }

}

</style>
