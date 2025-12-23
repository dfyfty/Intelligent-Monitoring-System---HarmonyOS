import { router } from "@kit.ArkUI"

@Entry
@Component
export struct Wet {
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
        Text('湿度监测')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111827')
          .margin({ bottom: 8 })

        Text('湿度反映空气中水蒸气的含量，对环境舒适度至关重要。')
          .fontSize(16)
          .fontColor('#1F2937')
          .margin({ top: 12 })
          .lineHeight(22)

        this.labelLine('适宜范围：', '标准室内湿度应控制在 40-70% 之间。', 12)

        this.labelLine('为什么重要：', '湿度过高容易导致设备腐蚀、物品霉变；湿度过低则可能产生静电，影响人体舒适度和电子设备。', 12)

        this.labelLine('温湿度关系：', '温度和湿度相互影响，温度升高时相对湿度会降低，因此需要同时监测这两个参数。', 12)

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