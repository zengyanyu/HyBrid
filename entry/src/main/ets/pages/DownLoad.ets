import { request, zlib } from '@kit.BasicServicesKit'
import { fileIo } from '@kit.CoreFileKit'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct DownLoad {
  async hotReload() {
    try {
      // 下载 沙箱目录 => 判断沙箱目录是否有重复的地址
      // toutiao.zip
      const fileName = "toutiao.zip"
      const filePath = getContext().filesDir + "/" + fileName
      // 检查一下 当下目录有没有相同的文件
      if (fileIo.listFileSync(getContext().filesDir).includes(fileName)) {
        // 此时说明已经存在这个文件了
        // 直接讲该文件重命名
        fileIo.renameSync(filePath, getContext().filesDir + "/toutiao.bak.zip")
      }
      const task = await request.downloadFile(getContext(), {
        url: 'https://gitee.com/shuiruohanyu/toutiao_net/raw/master/resources/toutiao.zip',
        filePath // 要存储的沙箱目录
      })
      task.on("complete", async () => {
        await zlib.decompressFile(filePath, getContext().filesDir)
        AlertDialog.show({ message: '解压完成' })
        router.pushUrl({
          url: 'pages/WebHybrid'
        })

      })
    } catch (error) {
      AlertDialog.show({ message: error.message })
    }
  }

  build() {
    RelativeContainer() {
      Button("热更新")
        .id('DownLoadHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.hotReload()
        })
    }
    .height('100%')
    .width('100%')
  }
}