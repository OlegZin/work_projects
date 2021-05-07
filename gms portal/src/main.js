import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

Vue.config.productionTip = false

// https://jsfiddle.net/cg7z0Lkj/
// фильтр используется в телефонном спроавочнике для добавления кастомного номера телефона в конференцию
Vue.directive('phone', {
  bind(el) {  
    el.oninput = function(e) {
      if (!e.isTrusted) {
        return;
      }

      const x = this.value.replace(/\D/g, '').match(/(\d{0,11})/);
      this.value = x[1];//!x[2] ? x[1] : '(' + x[1] + ') ' + x[2] + (x[3] ? '-' + x[3] : '');
      el.dispatchEvent(new Event('input'));
    }
  },
});


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
