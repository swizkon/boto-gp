<template>
  <div class="modal-mask">
    <div class="modal-wrapper">
      <slot name="close">
        <div class="modal-close" @click="$emit('close')">&times;</div>
      </slot>
      <div class="modal-container">
        <div
          class="modal-header"
          v-bind:class="{ warning: type === 'warning', error: type === 'error'}"
        >
          <slot name="header">
            <svg
              width="106"
              height="106"
              viewBox="0 0 106 106"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                v-if="type === 'success'"
                fill-rule="evenodd"
                clip-rule="evenodd"
                d="M53 0C23.744 0 0 23.744 0 53C0 82.256 23.744 106 53 106C82.256 106 106 82.256 106 53C106 23.744 82.256 0 53 0ZM73.9141 35.6143L45.6923 61.086L32.9892 48.5446L28 53.4841L45.6923 71L78.9033 40.5889L73.9141 35.6143ZM7 52.5C7 78.1913 27.8088 99 53.5 99C79.1913 99 100 78.1913 100 52.5C100 26.8088 79.1913 6 53.5 6C27.8088 6 7 26.8088 7 52.5Z"
                fill="white"
              />

              <svg
                v-if="type === 'warning'"
                width="106"
                height="106"
                viewBox="0 0 106 106"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M0 53C0 23.744 23.744 0 53 0C82.256 0 106 23.744 106 53C106 82.256 82.256 106 53 106C23.744 106 0 82.256 0 53ZM7 52.5C7 78.1913 27.8088 99 53.5 99C79.1913 99 100 78.1913 100 52.5C100 26.8088 79.1913 6 53.5 6C27.8088 6 7 26.8088 7 52.5Z"
                  fill="white"
                />
                <rect x="48" y="28" width="10" height="32" fill="white" />
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M53 78C56.3137 78 59 75.3137 59 72C59 68.6863 56.3137 66 53 66C49.6863 66 47 68.6863 47 72C47 75.3137 49.6863 78 53 78Z"
                  fill="white"
                />
              </svg>

              <path
                v-if="type === 'error'"
                fill-rule="evenodd"
                clip-rule="evenodd"
                d="M53 0C23.744 0 0 23.744 0 53C0 82.256 23.744 106 53 106C82.256 106 106 82.256 106 53C106 23.744 82.256 0 53 0ZM72 37.8271L68.1729 34L53 49.1729L37.8271 34L34 37.8271L49.1729 53L34 68.1729L37.8271 72L53 56.8271L68.1729 72L72 68.1729L56.8271 53L72 37.8271ZM7 53.5C7 79.1913 27.8088 100 53.5 100C79.1913 100 100 79.1913 100 53.5C100 27.8088 79.1913 7 53.5 7C27.8088 7 7 27.8088 7 53.5Z"
                fill="white"
              />
            </svg>
          </slot>
        </div>
        <div class="modal-body">
          <slot name="body">
            <h3>{{ heading }}</h3>
            <p class="m-0">{{ description }}</p>
            <p class="m-0" v-for="(description, index) in descriptions" :key="index">{{ description }}</p>
            <br/>
          </slot>
          <slot name="buttons"></slot>
        </div>
        <div class="modal-footer"></div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: "modal",
  props: {
    heading: String,
    description: String,
    descriptions: Array,
    type: { type: String, default: "info" }
  }
};
</script>

<style lang="scss" scoped>
.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 0;
  margin: 0;
  background: rgba(0, 0, 0, 0.3);
}

.modal-wrapper {
  position: absolute;
  transform: translate(-50%, -50%);
  top: 50%;
  left: 50%;
}

.modal-container {
  box-shadow: 0 0 50px rgba(0, 0, 0, 0.3);
  border-radius: 2px;
  background: #fff;
  color: theme('colors.textcolor-dark');
  min-width: 474px;
  width: 100%;
  min-height: 300px;
}

.modal-header {
  height: 210px;
  display: flex;
  justify-content: center;
  align-items: center;
    background: theme('colors.primary-light');
  &.success {
    background: theme('colors.primary-light');
  }
  &.warning,
  &.error {
    background: theme('colors.warning');
  }
}

.modal-body {
  text-align: center;
  padding: 36px;
  > h3 {
    color: theme('colors.textcolor-dark');
    font-size: 30px;
    margin-top: 0;
  }
}

.modal-close {
  position: absolute;
  right: -21px;
  top: -21px;
  background: #fff;
  width: 42px;
  height: 42px;
  color: theme('colors.textcolor-dark');
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  line-height: 1;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.3);
  cursor: pointer;
  font-weight: bold;
}
</style>
