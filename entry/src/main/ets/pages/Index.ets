import { HomePage } from './HomePage';

@Entry
@ComponentV2
struct Index {
  @Local currentIndex: number = 0; // 当前选中的tab索引

  build() {
    Tabs({
      index: this.currentIndex,
      barPosition: BarPosition.End
    }) {
      TabContent() {
        HomePage()
      }
      .tabBar("实时")

      TabContent() {

      }
      .tabBar("分析")

      TabContent() {

      }
      .tabBar("消息")

      TabContent() {

      }
      .tabBar("关于")
    }
    .backgroundColor($r("app.color.home_background"))
    .padding({ left: 10, right: 10 })
    .width("100%")
    .height("100%")
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
