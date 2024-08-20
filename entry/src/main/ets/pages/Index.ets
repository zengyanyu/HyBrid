import { promptAction } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Button("原生组件")
        .onClick(() => {
          promptAction.showToast({ message: "原生提示" })
        })
      Web({
        src: 'https://www.bilibili.com/',
        controller: new webview.WebviewController()
      })
        .width('100%')
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}