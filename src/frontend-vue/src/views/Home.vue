<template>
  <div class="home">
    <h1 v-text="getWelcomeText"></h1>
    <br/>
    <p>Set up users and groups.</p>
    <router-link class="button big primary white" to="users">Users</router-link>
    <router-link class="button big primary white" to="groups">Groups</router-link>
    <br/>
    <br/>
    <p>Set up labels. articles and orders.</p>
    <router-link class="button big primary white" to="labels">Labels</router-link>
    <router-link class="button big primary white" to="articles">Articles</router-link>
    <router-link class="button big primary white" to="orders">Orders</router-link>
    <br/>
    <router-link v-if="printerManager" class="button big primary white" to="printers">Printers</router-link>
    <br/>
    <br/>
    <p v-if="importEnabled" >Import articles and orders.</p>
    <import-data v-if="importEnabled" />
  </div>
</template>

<script>
export default {
  components: {
  },
  data: () => ({
    importEnabled: false
  }),
  methods: {
    async checkImportEnabled () {
      const response = await this.$store.$importService.get('/api/import/enabled');
      this.importEnabled = response.data.enabled;
    }
  },
  computed: {
    printerManager () {
      return this.$store.getters['AUTH/AUTH_GET_USER'] ? this.$store.getters['AUTH/AUTH_GET_USER'].UserPermission.includes('PrinterManager') : null
    },
    getWelcomeText () {
      var user = this.$store.getters['AUTH/AUTH_GET_USER']

      if (user === undefined)
        return ''

      return 'Welcome ' + user.firstname+'!'
    }
  },
  mounted() {
    this.checkImportEnabled();
  }
}
</script>
