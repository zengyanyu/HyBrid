import { webview } from '@kit.ArkWeb'

/**
 * 混合开发-连接页面
 */
@Entry
@Component
struct ConnectPage {
  controller: webview.WebviewController = new webview.WebviewController()
  ports: webview.WebMessagePort[] = []
  @State
  @Watch("updateName")
  name: string = ""

  createPorts() {
    this.ports = this.controller.createWebMessagePorts() // 有两个端口
    if (this.ports.length) {
      this.controller.postMessage("trans_port", [this.ports[1]], "*")
      // 必须有接收才能发送
      this.ports[0].onMessageEvent((event) => {
        AlertDialog.show({ message: event.toString() })
      })
    }
  }

  // 只要内容变化 就会触发逻辑
  updateName() {
    this.ports[0].postMessageEvent(this.name)
  }

  build() {
    RelativeContainer() {
      Button("发送消息")
        .id("btn1")
      TextInput({
        placeholder: '请输入内容',
        text: $$this.name
      })
        .id("text1")
        .alignRules({
          top: {
            anchor: 'btn1',
            align: VerticalAlign.Bottom
          }
        })
      Web({
        src: $rawfile("index.html"),
        controller: this.controller
      })
        .alignRules({
          top: {
            anchor: 'text1',
            align: VerticalAlign.Bottom
          }
        })
        .onAlert((res) => {
          AlertDialog.show({ message: res.message })
          return true
        })
        .onPageEnd(() => {
          this.createPorts()
        })
    }
    .height('100%')
    .width('100%')
  }
}