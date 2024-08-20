import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct WebHybrid {
  build() {
    Column() {
      Web({
        src: "file://" + getContext().filesDir + "/toutiao/index.html",
        controller: new webview.WebviewController()
      })
        .fileAccess(true)// 开启文件系统访问
        .domStorageAccess(true) // 开启本地存储
    }
    .height('100%')
    .width('100%')
  }
}