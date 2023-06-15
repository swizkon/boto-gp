import Vue from "vue";
import Router from "vue-router";

Vue.use(Router);

export default store => {
  const router = new Router({
    routes: [
      {
        path: "/",
        name: "home",
        component: () => import("./views/Home.vue")
      },
      {
        path: "/circuits",
        name: "circuitList",
        component: () => import("./views/CircuitList.vue")
      },
      {
        path: "/circuits/:circuitid",
        name: "circuitDetails",
        component: () => import("./views/CircuitDetails.vue")
      }
    ]
  });

  router.beforeEach(async (to, from, next) => {
    next();
  });

  return router;
};
