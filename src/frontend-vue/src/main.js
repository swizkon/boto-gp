import Vue from 'vue'
import App from './App.vue'
import createRouter from './router'
import createStore from './store/store'
import ViewWrapper from './components/ViewWrapper.vue'
import Wrapper from './components/Wrapper.vue'

import './assets/scss/_styles.scss'
import './assets/css/tailwind-css.css'

Vue.config.productionTip = false

Vue.component('view-wrapper', ViewWrapper)
Vue.component('wrapper', Wrapper)
fetch('/config.json')
.then((res) => res.json()  )
.then((config) => {
  const store = createStore(config)
  const router = createRouter(store)
  new Vue({
    router,
    store,
    render: h => h(App)
  }).$mount('#app')
})
.catch((err) => console.log(err))
