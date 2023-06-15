import Vue from 'vue'
import Vuex from 'vuex'

// Modules
import Circuits from './circuits'

// Plugins
import axiosPlugin from './plugins/axios'
Vue.use(Vuex)

export default (config) => new Vuex.Store({
  state: {
    'CONFIG': config
  },
  getters: {
    'CONFIG': state => {
      return state.CONFIG
    }
  },
  modules: {
    'CIRCUITS': Circuits
  },
  plugins: [
    axiosPlugin()
  ]
})
