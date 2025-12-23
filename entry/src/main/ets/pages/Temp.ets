import { router } from "@kit.ArkUI"

@Entry
@Component
export struct Temp {
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
          Text('🌡️温度监测')
            .fontSize(34)
            .fontWeight(FontWeight.Bold)
            .fontColor('#111827')
          Text('温度是影响环境舒适度的重要参数之一。')
            .fontSize(16)
            .fontColor('#1F2937')
            .margin({ top: 12 })
            .lineHeight(22)

          this.labelLine('适宜范围：', '一般室内温度应保持在 20-25℃ 之间。', 12)

          this.labelLine('为什么重要：', '温度过高或过低都会影响人体舒适度和设备运行稳定性，温度波动还会影响精密仪器的准确性。', 12)

          this.labelLine('监测意义：', '实时监测温度变化，可以及时调整空调系统，保证环境条件的稳定性。', 12)

          this.labelLine('另一数据源：', '系统配备了两个温度传感器（DHT11和BMP280），“另一数据源”显示的是第二个传感器的温度数据。通过对比两个传感器的数据，可以交叉验证测量准确性，并了解不同位置的温度分布情况，提高监测的可靠性。', 12)

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