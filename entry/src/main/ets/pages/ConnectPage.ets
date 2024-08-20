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

  // 创建端口,默认创建两个,一个用来发送消息,一个用来接收消息
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
    Column({ space: 10 }) {
      Button("发送消息")
        .id("btn1")

      TextInput({
        placeholder: '请输入内容',
        text: $$this.name
      })

      // 混合开发页面使用Web组件
      Web({
        src: $rawfile("index.html"),
        controller: this.controller
      }).onAlert((res) => {
        AlertDialog.show({ message: res.message })
        return true
      })
        .onPageEnd(() => {
          this.createPorts()
        })
    }
    .height('100%')
    .width('100%')
    .padding(20)
  }
}