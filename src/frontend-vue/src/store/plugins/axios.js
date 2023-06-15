import axios from 'axios'
import router from '../../router';

export default function AxiosPlugin () {
  return store => {
    store.$api = axios.create({
      baseURL: store.state.CONFIG.apiUrl
    });

    const setAuthorization = () => {
      const authToken = window.localStorage.getItem('auth_token')
      const authExpires = window.parseInt(window.localStorage.getItem('auth_expires'))
      
      if (!authToken ||authExpires < window.Math.floor(window.Date.now() / 1000)) {
        delete store.$api.defaults.headers.common['Authorization']
        return
      }

      store.$api.defaults.headers.common['Authorization'] = `Bearer ${authToken}`
    }

    store.subscribe((mutation) => {
      
    })

    store.subscribeAction(() => {
      // Implement action listener instead of FIX_AUTH when this feature is implemented: https://github.com/vuejs/vuex/issues/1098#issuecomment-354311901
    })

    setAuthorization()
  }
}
