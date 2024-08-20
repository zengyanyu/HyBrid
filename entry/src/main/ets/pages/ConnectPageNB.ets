import { webview } from '@kit.ArkWeb'
import { cameraPicker as picker } from '@kit.CameraKit';
import { camera } from '@kit.CameraKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

let mContext = getContext(this) as common.Context;


@Entry
@Component
struct ConnectPageNB {
  // controller: webview.WebviewController = new webview.WebviewController()
  obj: WebSdk = new WebSdk()

  build() {
    Column({ space: 20 }) {
      Button("发送消息")

      Web({
        src: $rawfile("kit.html"),
        controller: this.obj.controller
      })
        .javaScriptProxy({
          name: 'hm', // 会注入到前端页面的html的全局对象上
          methodList: ["showToast", "takePhoto", "getLocation"], // 必须手动实现
          controller: this.obj.controller,
          object: this.obj // new 构造一个类
        })
        .fileAccess(true)// 开启文件路径访问权限
        .onAlert((res) => {
          AlertDialog.show({ message: res.message })
          return true
        })
        .onPageEnd(() => {
        })
    }
    .height('100%')
    .width('100%')
  }
}

class WebSdk {
  controller: webview.WebviewController = new webview.WebviewController() // 自己造一个controller

  // 弹窗
  showToast(message: string) {
    AlertDialog.show({ message })
  }

  // 拍照
  async takePhoto(funcName: string) {
    // 把拍照的照片给h5 去显示呢
    try {
      let pickerProfile: picker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      let pickerResult: picker.PickerResult = await picker.pick(mContext,
        [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO], pickerProfile);
      this.controller.runJavaScript(`${funcName}('${pickerResult.resultUri}')`)
      // AlertDialog.show({ message: JSON.stringify(pickerResult) })
    } catch (error) {
      let err = error as BusinessError;
      console.error(`the pick call failed. error code: ${err.code}`);
    }
  }

  // 获取定位
  getLocation() {
  }
}