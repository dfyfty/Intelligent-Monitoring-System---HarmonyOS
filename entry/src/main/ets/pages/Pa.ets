import { router } from "@kit.ArkUI"

@Entry
@Component
export struct Pa {
  @Builder
  labelLine(title: string, content: string, topMargin: number) {
    Text() {
      Span(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#22A35A')
      Span(content)
        .fontSize(18)
        .fontColor('#1F2937')
    }
    .lineHeight(24)
    .margin({ top: topMargin })
  }

  build() {
    Column() {
      Column() {
        Text('大气压监测')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111827')
          .margin({ bottom: 8 })

        Text('大气压是空气作用在单位面积上的力，单位为百帕（hPa）或千帕（kPa）。')
          .fontSize(16)
          .fontColor('#1F2937')
          .margin({ top: 12 })
          .lineHeight(22)

        this.labelLine('标准值：', '海平面标准大气压约为 1013 hPa（101.3 kPa），正常范围一般在 980-1040 hPa 之间。', 12)

        this.labelLine('为什么重要：', '大气压影响人体舒适度、液体沸点等参数。某些场景需要记录大气压以确保环境条件的稳定性。', 12)

        this.labelLine('气象关联：', '大气压变化与天气变化密切相关，低压通常伴随阴雨天气，高压则多晴朗天气。', 12)

        this.labelLine('监测意义：', '实时监测大气压可以帮助校准精密仪器，预测天气变化，保证环境条件的准确记录。', 12)

        Button('知道了')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#3B82F6')
          .borderRadius(10)
          .padding({ left: 18, right: 18, top: 8, bottom: 8 })
          .margin({ top: 18 })
          .alignSelf(ItemAlign.Center)
          .onClick(() => {
            router.back()
          })
      }
      .width('100%')
      .padding({ top: 24, left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
  }
}