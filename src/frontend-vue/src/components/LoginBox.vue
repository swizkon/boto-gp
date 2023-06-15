<template>
    <div class="loginbox">
        <div class="top-text">
            <slot name="header" />
        </div>
        <div class="mx-24 mt-8">
            <slot />
        </div>
    </div>
</template>

<script>

export default {
    name: 'login-box',
}
</script>

<style lang="postcss" scoped>
    .top-text {
        @apply h-32 relative text-center;
    }
</style>