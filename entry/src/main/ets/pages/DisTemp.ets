import { router } from "@kit.ArkUI"

@Entry
@Component
export struct DisTemp {
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
        Text('温度差值监测')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111827')
          .margin({ bottom: 8 })

        Text('温度差值显示两个温度传感器之间的温差。')
          .fontSize(16)
          .fontColor('#1F2937')
          .margin({ top: 12 })
          .lineHeight(22)

        this.labelLine('测量意义：', '通过对比两个位置的温度，可以了解环境温度分布的均匀性。', 12)

        this.labelLine('正常范围：', '同一空间内不同位置的温差通常应小于2°C，温差过大说明空调系统分布不均或存在局部热源。', 12)

        this.labelLine('应用场景：', '多点温度监测有助于发现温度死角，优化空调出风口位置，确保整体环境的一致性。', 12)

        Button('知道了')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#3B82F6')
          .borderRadius(10)
          .padding({ left: 18, right: 18, top: 8, bottom: 8 })
          .margin({ top: 18 })
          .alignSelf(ItemAlign.Center)
          .onClick(() => {
            router.back(

            )
          })
      }
      .width('100%')
      .padding({ top: 24, left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
  }
}