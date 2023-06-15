<template>
  <view-wrapper name="Orders" :loading="loading">
    <router-link class="button big primary white mt-3" to="addorder">Create new order</router-link>

    <expandabel-table class="mt-8" :columnsToNotSort="columnsToNotSort" :data="orders" :headers="headers" v-slot:child="{ child }">
      <div class="order-button-container">
        <grafokett-button class="small" @click="$router.push(`orders/${child.parentId}`)">Edit <i class="edit-symbol"/></grafokett-button>
        <grafokett-button class="small" @click="deleteOrder(child)">Delete</grafokett-button>
      </div>
      <p>Articles included</p>
      <div class="filter-and-sort-box test">
        <div class="table">
          <table class="filter-table">
            <thead>
              <tr>
                <th>Article name</th>
                <th>Maximum print quantity</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(article, key) in child.articles" :key="`article--${key}`">
                <td>{{ article.name }}</td>
                <td>{{ article.maxQuantity }} left</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <p>Assigned to groups</p>
      <div class="filter-and-sort-box test">
        <div class="table">
          <table class="filter-table">
            <tbody>
              <tr v-for="(group, key) in child.groups" :key="`group--${key}`">
                <td>{{ group.groupName }}</td>
                <td></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </expandabel-table>
  </view-wrapper>
</template>

<script>

export default {
  components: {
  },
  data() {
    return {
      loading: false,
      headers: {
        name: 'Order name', status: 'Order status'
      },
      columnsToNotSort: [ 'arrow' ],
      importResult: {
        show: false,
        type: 'success',
        heading: 'Success',
        description: 'Your order (s) have been queued for import and will shortly be available'
      }
    }
  },
  computed: {
    orders () {
      return this.$store.getters['ORDERS/ORDERS'].map(o => {
        return {
          id: o.id,
          name: o.orderReference,
          status: o.status,
          expandableData: {
            groups: o.groups,
            articles: o.articles
          }
        }
      })
    }
  },
  methods: {
    getData () {
      this.$store.dispatch('ORDERS/GET_ORDERS')
    },
    async deleteOrder (order) {
      await this.$store.$api.delete(`/api/orders/${order.parentId}`)
      this.getData()
    }
  },
  mounted () {
    this.getData()
  }
}
</script>
