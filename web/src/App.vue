<template>
  <v-app>
    <v-app-bar flat color="white">
      <div class="d-flex align-center justify-center">
        <v-img
          alt="Vuetify Logo"
          class="shrink mr-2"
          contain
          src="https://zylab.oss-cn-beijing.aliyuncs.com/chunshen/icon.png"
          transition="scale-transition"
          width="40"
        />

        <v-img
          alt="Vuetify Name"
          class="shrink mt-1"
          contain
          src="https://zylab.oss-cn-beijing.aliyuncs.com/chunshen/name.png"
          width="100"
        />
      </div>

      <v-spacer></v-spacer>

      <v-btn
        href="https://www.yuque.com/u21304031/fgpmte/xqkhgh"
        target="_blank"
        text
      >
        <span class="mr-2 color-gray">使用指南</span>
      </v-btn>
    </v-app-bar>

    <v-main>
      <Main v-if="!isMobile()"/>
      <main-mobile v-if="isMobile()"/>
    </v-main>
  </v-app>
</template>

<script>
import Main from "./components/Main";
import MainMobile from "./components/MainMobile";
import { isMobile } from "./utils/utils";

export default {
  name: "App",

  components: {
    Main,
    MainMobile,
  },

  data: () => ({
    //
  }),
  methods: {
    isMobile() {
      return isMobile(this);
    },
  },
};
</script>
<style>
.color-yellow {
  color: #f49405;
}
.color-gray {
  color: #777777;
}
</style>
