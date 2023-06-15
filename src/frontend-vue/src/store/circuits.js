const state = {
  circuits: []
}

const mutations = {
  'SET_CIRCUITS' (state, val) {
    state.circuits = val
  },
}

const actions = {
  async 'GET' ({ commit }) {
    try {
      const response = await this.$api.get('/api/circuits')
      commit('SET_CIRCUITS', response.data.data)
    } catch (error) {
      throw error
    }
  },
  async 'UPDATE' (store, payload) {
    try {
      this.$api.put('/api/circuits', payload)
    } catch (error) {
      throw error
    }
  }
}

const getters = {
  'CIRCUITS': state => {
    return state.circuits
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
}
