<template>
  <view-wrapper prefix="Edit" name="Order" path="orders" :loading="loading">
    <wrapper class="mb-5" :checkForChildFocused="true">
      <grafokett-input v-if="orderToBeEdited" v-model="orderToBeEdited.orderReference" type="text" labelPlaceholder="Order number" :inline-save="true" @inlineSave="updateOrderReference"/>
    </wrapper>

    <wrapper :focus="addedArticles.length > 0" class="articels mb-4">
      <div v-if="addedArticles && addedArticles.length > 0" class="added-articels">
        <p>Articles in this order</p>
        <GenericAccordion :columnsToNotSort="columnsToNotSort" :types="types" :headers="addedArticlesHeaders" :data="addedArticles" @buttonClicked="removeArticle" :inputInlineSave="true" @inputInlineSave="updateOrderQuantity" />
        <br/>
      </div>
      <div>
        <p>Add articles to order</p>
        <GenericAccordion :columnsToNotSort="columnsToNotSort" :types="types" :headers="headers" :data="articles" @buttonClicked="addArticle"></GenericAccordion>
      </div>
    </wrapper>

    <assign-groups :groups="groups" v-model="parentGroup" @groupAdded="addGroup" @removeGroup="removeGroup"/>

    <div class="my-5 text-right">
      <grafokett-button class="big primary" @click="lockInGroups" :class="{ disable: !(parentGroup && parentGroup.length > 0) }">{{groupsLockedIn ? 'Edit' : 'Ok'}}</grafokett-button>
    </div>
  </view-wrapper>
</template>

<script>
export default {
  components: {
  },
  data() {
    return {
      orderToBeEdited: undefined,
      orderNumber: '',
      showPopUp: false,
      addedArticles: [],
      parentGroup: [],
      articlesLockedIn: false,
      groupsLockedIn: false,
      addedArticlesHeaders: {
        article: 'Article name', quantity: 'Maximum print quantity', remove: ''
      },
      headers: {
        article: 'Article name', quantity: 'Maximum print quantity', add: ''
      },
      columnsToNotSort: [ 'quantity', 'add', 'remove' ],
      types: {
        article: { type: 'string' },
        quantity: { type: 'input' },
        add: { type: 'button', classes: 'small', textAlign: 'right' },
        remove: { type: 'button', classes: 'small', textAlign: 'right' }
      },
      loading: false
    }
  },
  methods: {
    hasChangesBeenMade () {
      return this.orderNumber !== '' || this.addedArticles.length > 0 || this.parentGroup.length > 0
    },
    async updateOrderReference () {
      this.loading = true;
      await this.$store.$api.put('/api/orders/order-reference', { orderId: this.orderToBeEdited.id, orderReference: this.orderToBeEdited.orderReference });
      this.loading = false;
    },
    async updateOrderQuantity (article) {
      this.loading = true;
      await this.$store.$api.put('/api/orders/articles/max-quantity', { orderId: this.orderToBeEdited.id, articleId: article.id, maxQuantity: parseInt(article.quantity) });
      this.loading = false;
    },
    async addGroup(group){
      this.loading = true;
      await this.$store.$api.post('/api/orders/groups', { orderId: this.orderToBeEdited.id, groupId: group.id });
      this.loading = false;
    },
    async removeGroup(group) {
      this.loading = true;
      await this.$store.$api.post('/api/orders/groups/remove', { orderId: this.orderToBeEdited.id, groupId: group.groupId ? group.groupId : group.id });
      this.loading = false;
    },
    async getData () {
      this.loading = true;
      const response = await this.$store.$api.get(`/api/orders/${this.$route.params.orderId}`);
      await this.$store.dispatch('GROUPS/GET_AVAILABLE_GROUPS');
      await this.$store.dispatch('ARTICLES/GET_ARTICLES');
      this.orderToBeEdited = response.data.data;
      this.addedArticles = this.orderToBeEdited.articles.map(a => {
        return {
          article: a.name,
          quantity: a.maxQuantity ? a.maxQuantity.toString() : null,
          add: 'Add',
          remove: 'Remove',
          id: a.id
        }
      });

      this.orderToBeEdited.groups.forEach(group => {
        this.addParentGroup(group)
      });
      this.loading = false;
    },
    async addArticle (e) {
      if (e.button === 'add') {
        if (!this.addedArticles.find(x => x.id === e.data.id)) {
          this.loading = true;
          await this.$store.$api.post('/api/orders/articles', { orderId: this.orderToBeEdited.id, articleId: e.data.id, maxQuantity: parseInt(e.data.quantity) });
          this.addedArticles.push(e.data);
          this.loading = false;
        }
      }
    },
    async removeArticle (e) {
      if (e.button === 'remove') {
        this.loading = true;
        await this.$store.$api.post('/api/orders/articles/remove', { orderId: this.orderToBeEdited.id, articleId: e.data.id });
        this.addedArticles = this.addedArticles.filter(x => x.id !== e.data.id);
        this.loading = false;
      }
    },
    addParentGroup(group){
      if (this.doesGroupExist(group, this.parentGroup)) return
      const i = this.parentGroup.indexOf(group)
      if (i === -1 && !this.doesGroupExist(group, this.parentGroup)) {
        this.parentGroup.push(group);
        this.removeChildGroups(group)
      }
    },
    removeChildGroups(group) {
      if (group.children) {
        for (let i = 0; i < group.children.length; i++) {
          this.removeChildGroups(group.children[i])
          this.removeParentGroup(group.children[i])
        }
      }
    },
    removeParentGroup(group) {
      const i = this.parentGroup.indexOf(group)
      if (i !== -1) {
        this.parentGroup.splice(i, 1)
        this.groupsLockedIn = false
      }
    },
    doesGroupExist(group, children) {
      if (!children) return false
      let exists = children.find(g => g.id === group.id)
      if (exists) return true
      for (let i = 0; i < children.length; i++) {
        if (this.doesGroupExist(group, children[i].children)) return true
      }
    },
    groupClass(group) {
      return { 'added-tree-item': this.parentGroup.find(g => g.id === group.id) !== undefined }
    },
    lockInGroups() {
      if (this.parentGroup.length > 0) this.groupsLockedIn = !this.groupsLockedIn
    },
    lockInArticles() {
      if (this.addedArticles.length > 0) this.articlesLockedIn = !this.articlesLockedIn
    },
    async saveOrder() {
      var payload = {
        orderId: this.orderToBeEdited.orderId,
        orderNumber: this.orderToBeEdited.orderNumber,
        articles: this.addedArticles.map(a => {
          return {
            articleId: a.id,
            maxQuantity: parseInt(a.quantity, 10)
          }
        }),
        groups: this.parentGroup.map(a => a.id)
      }
      try {
        await this.$store.$api.put('/api/orders', payload)
      } catch (error) {
        console.error(error)
        throw error
      }

      this.$router.push({ name: 'orders' })
    }
  },
  computed: {
    articles () {
      return this.$store.getters['ARTICLES/ARTICLES'].map(a => {
        return {
          article: a.name,
          quantity: '1',
          add: 'Add',
          remove: 'Remove',
          id: a.id
        }
      })
    },
    groups () {
      return this.$store.getters['GROUPS/GROUPS']
    }
  },
  async mounted () {
    if (!this.$route.params.orderId) {
      this.$routers.push({ name: 'orders' })
    }
    await this.getData()
  }
}
</script>
