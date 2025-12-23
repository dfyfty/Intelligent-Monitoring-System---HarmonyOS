import { router } from "@kit.ArkUI"

@Entry
@Component
export struct Light {

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
        Text('亮度监测')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111827')
          .margin({ bottom: 8 })

        Text('亮度（照度）反映环境的光照强度，单位为勒克斯（lx）。')
          .fontSize(16)
          .fontColor('#1F2937')
          .margin({ top: 12 })
          .lineHeight(22)

        this.labelLine('适宜范围：', '普通工作区域照度应达到 300-750 lx，精密操作区域需要 750-1500 lx。', 12)

        this.labelLine('为什么重要：', '充足的照明可以减少操作失误，提高工作效率；某些场景需要严格控制光照条件。', 12)

        this.labelLine('监测意义：', '实时监测光照强度，可以自动调整照明系统，节约能耗并提高舒适度。', 12)

        this.labelLine('另一数据源：', '系统还支持外接光照传感器，用于比对不同位置的光照差异，帮助优化灯光布局。', 12)

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