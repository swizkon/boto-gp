<template>
  <div class="sidebar">
    <router-link
      class="button small"
      v-for="(link, key) in navigationLinks"
      :key="`link--${key}`"
      :to="link.to"
    >
      <span class="text-sm">
        {{ link.name }}
      </span>
    </router-link>
  </div>
</template>

<script>
export default { 
  name: "sidebar",
  data: () => ({
    navigationLinks: []
  }),
  methods: {
    async getNavigationLinks() {
      if (this.$store.getters["AUTH/AUTH_GET_USER"] === undefined)
       return;
      const userRoles = this.$store.getters["AUTH/AUTH_GET_USER"].UserRole;
      if (userRoles.includes("Administrator")) {
        this.navigationLinks.push({ to: "/", name: "Dashboard" });
      }
      if (userRoles.includes("User")) {
        
        this.navigationLinks.push({ to: "/myorders", name: "My orders" });
        this.navigationLinks.push({ to: "/print-articles", name: "My articles" });
        this.navigationLinks.push({ to: "/settings", name: "Settings" });
        this.navigationLinks.push({ to: "/printers", name: "Printers" });
      }
    }
  },
  computed: {
  },
  mounted() {
    this.getNavigationLinks();
  }
};
</script>

<style lang="postcss">
.sidebar {
  @apply bg-no-repeat bg-secondary bg-cover relative;

  .user-wrapper {
    @apply p-0 py-2 text-center;
  }
  a {
    @apply no-underline block py-3 px-4;
    &:hover:not(.router-link-exact-active) {
      @apply bg-white text-highlight opacity-75;
    }
    &.router-link-exact-active {
      @apply bg-white text-highlight;
    }
  }
}
</style>
