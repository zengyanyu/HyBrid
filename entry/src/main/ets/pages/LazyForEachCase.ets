@Entry
@Component
struct LazyForEachCase {
  @State
  list: ListDataSource = new ListDataSource()

  aboutToAppear(): void {
    // Array.from(Array(20)).forEach((item: number, index: number) => {
    //   this.list.pushData({ value: index + 1 } as Item)
    // })
    this.list.reloadData(Array.from(Array(20), (_: number, index: number) => {
      return { value: index + 1 } as Item
    }))
  }

  build() {
    Column({ space: 20 }) {
      /*
       * List Grid Swiper WaterFlow
       * 只能是这些组件可以使用LayForEach
       * */
      Text('LazyForEach 数据懒加载')
        .width('100%')
        .height(100)
        .fontColor(Color.Blue)
        .backgroundColor(Color.Red)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)

      List({ space: 20 }) {
        LazyForEach(this.list, (item: Item) => {
          ListItem() {
            Text(item.value.toString())
              .fontSize(30)
              .fontColor(Color.Red)
              .fontWeight(FontWeight.Bold)
              .width("100%")
              .textAlign(TextAlign.Center)
          }
          .width("100%")
          .height(100)
          .backgroundColor(Color.Pink)
          .onAppear(() => {
            console.log(item.value + "项开始渲染")
          })
          .onDisAppear(() => {
            console.log(item.value + "项开始销毁")
          })
        })
      }
    }
    .height('100%')
    .width('100%')
    .padding(20)
  }
}

// Basic implementation of IDataSource to handle data listener
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: object[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): object {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

// 封装自己的dataSource
class ListDataSource extends BasicDataSource {
  private dataArray: object[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): object {
    return this.dataArray[index];
  }

  public addData(index: number, data: object): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: object): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public reloadData(data: object[]): void {
    this.dataArray = data // 直接赋值
    this.notifyDataReload()
    // this.dataArray.push(data);
    // this.notifyDataAdd(this.dataArray.length - 1);
  }
}

class Item {
  value: number = 0
}

