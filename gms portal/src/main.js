import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App),

  mounted() {

    this.$store.state.programs = this.$store.state.programs_empty;
    this.$store.state.news = this.$store.state.news_empty;
    
    // получаем регистрационные данные текущего пользователя на фотосервере, если есть 
//    this.$store.dispatch('getPhotoUser');

    /// получаем данные программ (список)
    this.$store.dispatch('getProgsData');

    // получение списка новостей
    this.$store.dispatch('getNewsData');

  }  
}).$mount('#app')
