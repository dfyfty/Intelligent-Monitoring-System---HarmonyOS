import { router } from "@kit.ArkUI"

@Entry
@Component
export struct ppm {
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
        Text('烟雾浓度监测')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111827')
          .margin({ bottom: 8 })

        Text('烟雾浓度反映空气中可燃气体和烟雾颗粒的含量，单位为 ppm（百万分之一）。')
          .fontSize(16)
          .fontColor('#1F2937')
          .margin({ top: 12 })
          .lineHeight(22)

        this.labelLine('安全阈值：', '正常环境应小于 50 ppm，超过 200 ppm 需要警惕，超过 500 ppm 属于危险范围。', 12)

        this.labelLine('为什么重要：', '这是环境安全的关键指标。有害气体或烟雾的及早发现可以防止火灾和中毒事故。', 12)

        this.labelLine('应急措施：', '当烟雾浓度异常升高时，系统会发出警报，应立即检查周围环境，开启通风系统，必要时疏散人员。', 12)

        this.labelLine('Rs/Ro值：', '这是MQ-2气体传感器的原始电阻比值（传感器电阻Rs与清洁空气中电阻R0的比值）。Rs/Ro值越小，说明气体浓度越高。这个原始数据经过转换计算后得到烟雾浓度的ppm值，显示Rs/Ro可以帮助了解传感器的工作状态和响应特性，便于校准和诊断传感器问题。', 12)

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