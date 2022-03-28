<template>
  <v-container>
    <v-col class="text-center col-center">
      <v-col class="mb-4">
        <h1 class="display-1 font-weight-bold mb-3">
          读书不觉已春深
        </h1>

        <h3
          class="subheading font-weight-bold color-gray"
          style="margin-top: 30px"
        >
          重温比记录更有意义
        </h3>
      </v-col>

      <v-col>
        <v-btn color="gray text-none" rounded min-width="200px" v-on:click="downloadAndroid">
          <v-icon left> mdi-android </v-icon>
          Android
        </v-btn>
      </v-col>
      <v-col>
        <v-btn color="gray text-none" rounded min-width="200px" v-on:click="downloadiOS">
          <v-icon left> mdi-apple </v-icon>
          iOS
        </v-btn>
      </v-col>

      <p class="margin" />
      <div>
        <h2 class="text-h5 color-yellow">快速浏览</h2>
        <p class="margin-20 text-button color-gray">
          以重温为目的，内容列表式呈现，快速浏览<br />书本标签化，快速筛选书摘
        </p>
      </div>
      <v-img
        alt="Vuetify Logo"
        class="shrink mr-2"
        contain
        src="https://zylab.oss-cn-beijing.aliyuncs.com/chunshen/main.jpeg"
        transition="scale-transition"
        width="70%"
      />

      <p class="margin" />
      <div>
        <h2 class="text-h5 color-yellow">快速记录，简化操作</h2>
        <p class="margin-20 text-button color-gray">
          提供多种输入方式：文字、图片、OCR，操作简单，快速记录，不打断读书心流
        </p>
      </div>
      <v-img
        alt="Vuetify Logo"
        class="shrink mr-2"
        contain
        src="https://zylab.oss-cn-beijing.aliyuncs.com/chunshen/edit.png"
        transition="scale-transition"
        width="90%"
      />

      <p class="margin" />
      <div>
        <h2 class="text-h5 color-yellow">随机漫步，激发灵感</h2>
        <p class="margin-20 text-button color-gray">
          随机浏览之前记录的书摘，保持新鲜感，记忆更加深刻，也能激发灵感
        </p>
      </div>
      <v-img
        alt="Vuetify Logo"
        class="shrink mr-2"
        contain
        src="https://zylab.oss-cn-beijing.aliyuncs.com/chunshen/ramble.png"
        transition="scale-transition"
        width="90%"
      />
    </v-col>
  </v-container>
</template>

<script>
import { isMobile } from "../utils/utils";
export default {
  name: "MainMobile",

  data: () => ({}),
  methods: {
    isMobile() {
      return isMobile(this);
    },
    downloadAndroid() {
      window.open("https://zylab.oss-cn-beijing.aliyuncs.com/chunshen/yezishuzhai.apk")
    },
    downloadiOS() {
      window.open("https://apps.apple.com/cn/app/%E5%8F%B6%E5%AD%90%E4%B9%A6%E6%91%98/id1614131666")
    }
  },
};
</script>

<style>
.margin {
  margin-top: 50px;
}
.margin-20 {
  margin-top: 20px;
}
.margin-left {
  margin-left: 50px;
}
.col-center {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
.tip {
  max-width: 50%;
}
</style>