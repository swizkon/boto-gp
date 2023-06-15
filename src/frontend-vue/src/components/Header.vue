<template>
  <div class="header" :class="{ isFullWidth: isFullWidth }">
    Boto GP
  </div>
</template>

<script>
export default {
  computed: {
    isLogin() {
      return this.$route.name === "login";
    },
    isPolicy() {
      return this.$route.name === "policy";
    },
    isFullWidth() {
      return (
        this.$route.name === "login" ||
        this.$route.name === "policy" ||
        this.$route.name === "resetpassword" ||
        this.$route.name === "setupaccount"
      );
    },
    printerUrl() {
      return this.$store.getters["CONFIG"].printUrl;
    }
  },
  data() {
    return {
      showPrinterLink: false,
      hidePrinterIcon: false
    };
  },
  methods: {
    showDownloadBox() {
      this.showPrinterLink = !this.showPrinterLink;
    }
  }
};
</script>


<style lang="postcss" scoped>
.header {
  position: relative;
  height: theme("variables.header-size");
  background-color: theme("colors.primary");
  @apply w-full;
}

.header::before {
  content: "";
  background-image: linear-gradient(to bottom, #204a63, transparent);
  @apply w-full inset-0 absolute;
}

.header img:not(.isFullWidth) {
  position: relative;
  left: 1em;
  top: 50%;
  transform: translateY(-50%);
  height: 50%;
}

.header.isFullWidth {
  height: calc(theme("variables.header-size") * 2);
}

.header.isFullWidth img {
  position: relative;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  height: 25%;
}
</style>
