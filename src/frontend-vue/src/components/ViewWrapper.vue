<template>
  <div class="view-wrapper">
    <div>
    </div>

    <h1 :class="showBackButton || showCancel ? 'mt-5' : 'mt-16'">
      {{ prefix }} {{ prefix ? name.toLowerCase() : name }}
    </h1>

    <slot />

    <div class="pb-10">
      <grafokett-button
        v-if="deleteFunc"
        class="big primary"
        @click="modalDelete = !modalDelete"
        ><span class="text-gray-500">Delete {{ name }}</span></grafokett-button
      >
      <grafokett-button
        :disabled="validation !== undefined && validation() === false"
        v-if="addedFunc"
        class="big float-right"
        :class="validation === undefined || validation() ? 'light' : 'primary'"
        @click="onAdded"
      >
        <span>{{ addedText }}</span>
      </grafokett-button>
      <grafokett-button
        :disabled="validation !== undefined && validation() === false"
        v-if="saveFunc"
        class="big float-right"
        :class="validation === undefined || validation() ? 'light' : 'primary'"
        @click="onSave"
      >
        <span>{{ saveText }}</span>
      </grafokett-button>
    </div>

    <modal
      v-if="modalCancel"
      @close="modalCancel = !modalCancel"
      :type="'error'"
      :heading="'Cancel?'"
      :descriptions="[
        'Your work will not be saved.',
        'Are you sure you want to cancel?'
      ]"
    >
      <template v-slot:buttons>
        <div>
          <router-link
            class="button big bg-white border-primary text-primary"
            :to="`/${path}`"
            >Yes, cancel</router-link
          >
          <grafokett-button
            class="big ml-2 bg-primary text-textcolor"
            @click="modalCancel = !modalCancel"
            >Add new {{ name }}</grafokett-button
          >
        </div>
      </template>
    </modal>

    <modal
      v-if="isDeleted"
      :type="'success'"
      :heading="'Deleted!'"
      :description="'Printer has been successfully deleted'"
    >
      <template v-slot:close>
        <div />
      </template>
    </modal>

    <modal
      v-if="modalDelete"
      @close="modalDelete = !modalDelete"
      :type="'warning'"
      :heading="'Delete?'"
      :descriptions="[
        `Your are about to delete ${this.value}.`,
        'Are you sure you want to delete?'
      ]"
    >
      <template v-slot:buttons>
        <div>
          <grafokett-button
            class="big bg-white border-primary text-primary"
            @click="onDelete"
            >Yes, delete</grafokett-button
          >
          <grafokett-button
            class="big ml-2 bg-primary text-textcolor"
            @click="modalDelete = !modalDelete"
            >Go back</grafokett-button
          >
        </div>
      </template>
    </modal>

    <modal
      v-if="modalAdded"
      @close="modalAdded = !modalAdded"
      :type="'success'"
      :heading="'Added!'"
      :description="name + ' have been successfully added.'"
    >
      <template v-slot:buttons>
        <div>
          <grafokett-button class="big" @click="$router.go(0)"
            >Add new {{ name.toLowerCase() }}</grafokett-button
          >
          <router-link class="button big ml-10 primary-light" :to="'/' + path"
            >See {{ name.toLowerCase() }}</router-link
          >
        </div>
      </template>
    </modal>

    <modal
      v-if="modalSave"
      @close="modalSave = !modalSave"
      :type="'success'"
      :heading="'Saved!'"
      :description="`Your ${name} has been successfully saved.`"
    >
      <template v-slot:buttons>
        <div>
          <grafokett-button class="big" @click="$router.go(0)"
            >{{ editMode ? "See " : "Add new" }}
            {{ name.toLowerCase() }}</grafokett-button
          >
          <router-link
            class="button big ml-10 primary-light"
            :to="'/' + path"
            >{{
              backText !== "" ? backText : "Back to" + name.toLowerCase()
            }}</router-link
          >
        </div>
      </template>
    </modal>

    <modal
      v-if="error"
      @close="error = !error"
      :type="'error'"
      :heading="'Error'"
      description="An error occurred saving your changes"
    >
    </modal>

    <loading v-if="loading" heading="Loading" :description="loadingText" />
  </div>
</template>

<script>
import Modal from "../components/Modal";
import Loading from "./Loading";

export default {
  props: {
    value: {
      type: String,
      default: ""
    },
    prefix: {
      type: String
    },
    name: {
      type: String,
      required: true
    },
    addedFunc: {
      type: Function
    },
    addedText: {
      type: String,
      default: "Add"
    },
    saveFunc: {
      type: Function
    },
    saveText: {
      type: String,
      default: "Save"
    },
    path: {
      type: String,
      default: ""
    },
    showCancel: {
      type: Boolean,
      default: false
    },
    deleteFunc: {
      type: Function
    },
    validation: {
      type: Function
    },
    hasChangesBeenMade: {
      type: Function,
      default: () => false
    },
    showBackButton: {
      type: Boolean,
      default: true
    },
    loading: {
      type: Boolean,
      default: false
    },
    loadingText: {
      type: String,
      default: "Loading"
    },
    editMode: {
      type: Boolean,
      default: false
    },
    backText: {
      type: String,
      default: ""
    }
  },
  components: {
    Modal,
    Loading
  },
  data() {
    return {
      modalAdded: false,
      modalSave: false,
      modalCancel: false,
      modalDelete: false,
      isDeleted: false,
      isAdded: false,
      isSaved: false,
      error: false
    };
  },
  methods: {
    cancel() {
      if (this.hasChangesBeenMade()) this.modalCancel = !this.modalCancel;
      else this.$router.push(`/${this.path}`);
    },
    async postPrinter() {},
    onDelete() {
      this.modalDelete = false;
      try {
        this.deleteFunc();
        this.isDeleted = true;
        setTimeout(() => this.$router.push(`/${this.path}`), 5000);
      } catch (err) {
        console.error(err);
      }
    },
    onAdded() {
      try {
        if (this.validation && this.validation() === false) return;
        this.addedFunc();
        this.modalAdded = true;
      } catch (err) {
        console.error(err);
      }
    },
    async onSave() {
      try {
        if (this.validation && this.validation() === false) return;
        await this.saveFunc();
        this.modalSave = true;
      } catch (err) {
        this.error = true;
      }
    }
  }
};
</script>

<style lang="postcss">
.view-wrapper {
  max-width: 940px;
  @apply m-8;
}
</style>
