import { router } from "@kit.ArkUI"

@Entry
@Component
export struct LBS {

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
        Text('设备定位')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111827')
          .margin({ bottom: 8 })

        Text('设备定位功能可以实时获取设备的精确地理位置信息。')
          .fontSize(16)
          .fontColor('#1F2937')
          .margin({ top: 12 })
          .lineHeight(22)

        this.labelLine('定位方式：', '系统使用 LBS（Location Based Service）基站定位技术，通过移动网络获取设备位置。', 12)

        this.labelLine('定位精度：', 'LBS 定位精度通常在几十到几百米范围内，适合大部分监测场景的需求。', 12)

        this.labelLine('使用场景：', '定位功能可以帮助你了解设备部署位置，在设备移动或异常时快速定位设备所在位置，便于维护和管理。', 12)

        this.labelLine('信号强度：', 'CSQ值表示信号强度，数值越大表示信号越好，通常CSQ值在20以上表示信号良好。', 12)

        this.labelLine('操作说明：', '点击“获取定位”按钮后，系统会向设备发送定位查询命令，设备返回定位数据后会自动在地图上标记位置。', 12)

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