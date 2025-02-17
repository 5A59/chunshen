## 项目介绍
这是一个书摘应用，包括客户端（Android + iOS）、后端、Web端（宣传页）。

客户端采用Flutter开发，后端采用Node.js开发，Web端采用Vue.js开发。

## 项目截图

![主页面](/images/main.png)

![输入界面](/images/input.png)

![漫步界面](/images/ramble.png)

![漫步界面备用](/images/ramble%20(1).png)

![编辑界面](/images/edit.png)

![引导页面](/images/guide.jpg)

## 项目结构
项目采用多端架构，主要包含以下目录：

### 前端 (web/)
- `src/`: 源代码目录
  - `components/`: Vue 组件目录
    - `Main.vue`: 主要页面组件（桌面版）
    - `MainMobile.vue`: 主要页面组件（移动版）
  - `plugins/`: 插件目录
    - `vuetify.js`: Vuetify UI 框架配置
  - `utils/`: 工具函数目录
  - `App.vue`: 应用程序根组件
  - `main.js`: 应用程序入口文件
- `public/`: 静态资源目录
  - `index.html`: 主页面模板
  - `privacy.html`: 隐私政策页面
  - `ydoc/`: 文档相关资源
    - `images/`: 图片资源目录
  - `icon.png`: 应用图标
- `guide/`: 项目指南文档
- `package.json`: 前端依赖配置
- `vue.config.js`: Vue 项目配置文件
- `babel.config.js`: Babel 配置文件
- `yarn.lock`: 依赖版本锁定文件

### 后端 (server/)
- `routes/`: 路由配置目录
  - `index.js`: 主路由配置
  - `api.js`: API 路由配置
  - `users.js`: 用户相关路由
- `views/`: 视图模板目录
- `config/`: 配置文件目录
- `public/`: 静态资源目录
- `bin/`: 可执行文件目录
- `chunshen/`: 业务逻辑目录
- `app.js`: 应用程序入口文件
- `package.json`: 后端依赖配置
- `package-lock.json`: 依赖版本锁定文件

### API (api/)
- API 接口定义和实现目录
  - RESTful API 接口
  - 数据模型定义
  - 接口文档

### Flutter 应用 (chunshen/)
- `lib/`: Dart 源代码目录
  - `main.dart`: 应用程序入口文件
  - `config.dart`: 配置文件
  - `base/`: 基础组件和工具
  - `main/`: 主要页面组件
  - `model/`: 数据模型定义
  - `net/`: 网络请求相关
  - `utils/`: 工具函数
  - `global/`: 全局状态管理
  - `user/`: 用户相关功能
  - `guide/`: 引导页面
  - `input/`: 输入相关组件
  - `ramble/`: 漫步相关功能
  - `excerpt/`: 摘录相关功能
  - `tag/`: 标签相关功能
  - `style/`: 样式定义
  - `bar/`: 导航栏组件
- `assets/`: 静态资源目录
  - 图片、字体等资源文件
- `android/`: Android 平台相关代码
- `ios/`: iOS 平台相关代码
- `web/`: Web 平台相关代码
- `test/`: 测试代码目录
- `pubspec.yaml`: Flutter 项目配置和依赖管理
- `pubspec.lock`: 依赖版本锁定文件
- `package.sh`: 打包脚本

### 其他目录
- `.vscode/`: VS Code 编辑器配置
  - 编辑器设置
  - 调试配置
- `.git/`: Git 版本控制目录
- `.gitignore`: Git 忽略文件配置
- `.metadata`: 项目元数据配置

## 技术栈
- 前端：Vue.js + Vuetify
- 后端：Node.js + Express
- 移动端：Flutter
- 构建工具：Yarn/NPM, Flutter SDK

## 开发环境要求
- Node.js
- Yarn/NPM
- Vue CLI
- Flutter SDK
- Android Studio / Xcode（移动端开发）
- VS Code（推荐的 IDE）
