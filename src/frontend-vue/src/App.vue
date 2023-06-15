<template>
  <div id="app" :class="appClasses">
    <grafokett-header style="grid-area: a;"/>
    <Sidebar v-if="!shouldNotHaveSidebar" style="grid-area: b;"/>
    <div style="grid-area: c; background: radial-gradient(#1f5b7f 0, #0f4164 150%);">
      <router-view/>
    </div>
  </div>
</template>
<script>
import GrafokettHeader from "components/Header.vue"
import Sidebar from "components/Sidebar.vue"

export default {
  name: 'app',
  components: {
    GrafokettHeader,
    Sidebar
  },
  computed: {
    shouldNotHaveSidebar() {
      return this.$route.name === 'login' || this.$route.name === 'policy' || this.$route.name === 'resetpassword' || this.$route.name === 'setupaccount'
    },
    appClasses(){
      return this.shouldNotHaveSidebar ? '' : 'has-sidebar'
    }
  }
}
</script>

<style lang="postcss">
#app {
  display: grid;
  min-height: 100vh;
  height: 100%;
  grid-template: 'a a a' 'c c c' 'c c c';
  grid-template-columns: 200px auto auto;
  grid-template-rows: 128px auto auto;

  &.has-sidebar{
    grid-template: 'a a a' 'b c c' 'b c c';
    grid-template-columns: 200px auto auto;
    grid-template-rows: 64px auto auto;
  }
}
</style>