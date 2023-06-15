<template>
    <div class="modal-mask">
    <div class="modal-wrapper">
      <div class="modal-container">
        <div
          class="modal-header"
          v-bind:class="{ warning: type === 'warning', error: type === 'error'}"
        >
          <slot name="header">
              <span></span>
              <span></span>
              <span></span>
              <span></span>
              <span></span>
          </slot>
        </div>
        <div class="modal-body">
          <h3>{{ heading }}</h3>
          <p class="m-0">{{ description }}</p>
          <br/>
        </div>
        <div class="modal-footer"></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
    name: 'loading',
    props: {
    heading: String,
    description: String,
    type: { type: String, default: "info" }
  }
}
</script>

<style lang="scss">
    .modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 0;
  margin: 0;
  background: rgba(192, 221, 255, 0.852437);
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
  color: #0b3959;
  width: 474px;
  min-height: 300px;
}

.modal-header {
  height: 210px;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #255a80;
  &.success {
    background: #255a80;
  }
  &.warning,
  &.error {
    background: #ffb64d;
  }

    span {
        position: absolute;
        width: 20px;
        height: 20px;
        border-radius: 50%;
        background: white;
        animation: rotate 2s linear infinite both;
    }

    span:nth-of-type(1) {
    animation-delay: .2s;
    }

    span:nth-of-type(2) {
    animation: rotate 2s .4s linear infinite both;
    }

    span:nth-of-type(3) {
    animation: rotate 2s .6s linear infinite both;
    }

    span:nth-of-type(4) {
    animation-delay: .8s;
    } 

    span:nth-of-type(5) {
    animation-delay: 1s;
    }
  
}

.modal-body {
  text-align: center;
  padding: 36px;
   h3 {
    color: #0B3959;
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
  color: #0b3959;
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

    @keyframes rotate {
        from {
            transform: rotate(0deg)
            translateY(-200%)
            rotate(0deg)
            scale(0.2);

        }
        50% {
            transform: rotate(360deg)
            translateY(-200%) 
            rotate(-360deg)
            scale(1);
        }

        to {
            transform: rotate(360deg)
            translateY(-200%) 
            rotate(-360deg)
            scale(0);
        }
    }

</style>