<template>
  <div class="wrapper relative p-5 rounded" :class="{ focus: (focus || (checkForChildFocused && isChildFocused)), 'opacity-50': disabled }" @blur.capture="onBlur" @focus.capture="onFocus">
    <slot />
  </div>
</template>

<script>
export default {
  props: {
    focus: {
      type: Boolean,
      default: false
    },
    checkForChildFocused: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      isMounted: false,
      isChildFocused: false
    }
  },
  mounted () {
    this.isMounted = true
  },
  methods: {
    onBlur () {
      setTimeout(this.checkForFocused, 50)
    },
    onFocus () {
      setTimeout(this.checkForFocused, 50)
    },
    checkForFocused () {
      this.isChildFocused = this.$el.getElementsByClassName('focus').length > 0
    }
  }
}
</script>

<style lang="postcss" scoped>
.wrapper {
  background-color: theme('colors.primary');
}

.wrapper.light {
  background-color: theme('colors.primary-light');
}

.wrapper.focus {
  background-color: theme('colors.secondary');
}

.wrapper.focus.light {
  background-color: theme('colors.primary');
}
</style>
