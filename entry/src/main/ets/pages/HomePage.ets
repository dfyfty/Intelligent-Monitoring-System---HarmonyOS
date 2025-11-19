import { HomePageLogic, TrendResult } from './HomePageLogic';

// 顶层趋势行组件（避免作用域问题）
@Component
struct TrendRow {
  @Prop trend: TrendResult;

  build() {
    Row({ space: 4 }) {
      if (this.trend.direction === 'up') {
        Text('↑')
          .fontSize(14)
          .fontColor('#dc2626')
      } else if (this.trend.direction === 'down') {
        Text('↓')
          .fontSize(14)
          .fontColor('#16a34a')
      } else {
        Text('—')
          .fontSize(14)
          .fontColor('#64748b')
      }
      Text(this.trend.text)
        .fontSize(12)
        .fontColor(this.trend.direction === 'up' ? '#dc2626' :
          this.trend.direction === 'down' ? '#16a34a' : '#64748b')
    }

  }
}

// 顶层指标卡片组件
@Component
struct MetricCard {
  @Prop title: string;
  @Prop valueText: string;
  @Prop trend: TrendResult;
  @Prop valueFontSize: number;

  build() {
    Row({ space: 5 }) {
      Column() {
        Column({ space: 10 }) {
          Text(this.title)
            .fontSize(14)
            .fontColor($r("app.color.home_title_text"))
          Text(this.valueText)
            .fontSize(this.valueFontSize)
            .fontWeight(FontWeight.Bolder)
            .fontColor($r("app.color.home_value_text"))
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Start)

        TrendRow({ trend: this.trend })
      }
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width("100%")
    .height(100)
    .padding({
      left: 10,
      top: 10,
      right: 10,
      bottom: 10
    })
    .borderColor($r("app.color.home_card_border"))
    .borderWidth(1)
    .backgroundColor($r("app.color.home_card_background"))
    .borderRadius(12)
    .shadow({
      radius: 8,
      color: '#1F000000',
      offsetX: 0,
      offsetY: 2
    })
  }
}


@Component
export struct HomePage {
  // UI 状态
  @State wsConnected: boolean = false;
  @State temp: number | undefined = undefined;
  @State hum: number | undefined = undefined;
  @State lux: number | undefined = undefined;
  @State smoke: number | undefined = undefined;
  @State pressure: number | undefined = undefined;
  @State temp2: number | undefined = undefined;
  @State rs_ro: number | undefined = undefined;
  @State lastUpdateTime: string = '--:--:--';
  @State sampleCount: number = 0;
  // 趋势状态
  @State tempTrend: TrendResult = { direction: 'stable', value: 0, text: '趋势稳定' };
  @State humTrend: TrendResult = { direction: 'stable', value: 0, text: '趋势稳定' };
  @State luxTrend: TrendResult = { direction: 'stable', value: 0, text: '趋势稳定' };
  @State smokeTrend: TrendResult = { direction: 'stable', value: 0, text: '趋势稳定' };
  @State pressureTrend: TrendResult = { direction: 'stable', value: 0, text: '趋势稳定' };
  @State tempDiffTrend: TrendResult = { direction: 'stable', value: 0, text: '趋势稳定' };
  // 业务逻辑实例（负责 WebSocket 与数据处理）
  private logic: HomePageLogic | null = null;

  // 生命周期函数
  aboutToAppear() {
    if (this.logic === null) {
      this.logic = new HomePageLogic(this);
    }
    this.logic.aboutToAppear();
  }

  aboutToDisappear() {
    if (this.logic) {
      this.logic.aboutToDisappear();
    }
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Image($r("app.media.logo"))
          .width(150)
        Text("智能环境监测系统")
          .fontWeight(FontWeight.Bolder)
          .fontSize(20)
      }
      .justifyContent(FlexAlign.Center)
      .width("100%")
      .margin({ bottom: 10, right: 20 })

      // 状态栏
      Row({ space: 10 }) {
        // 连接状态
        Row({ space: 5 }) {
          Row()
            .backgroundColor(this.wsConnected ? "#4CA154" : "#E53E3E")
            .width(12)
            .height(12)
            .borderRadius(100)
          Text(this.wsConnected ? "已连接" : "未连接")
            .fontColor($r("app.color.home_status_text"))
            .fontSize(12)
        }
        .padding({
          left: 10,
          right: 10,
          top: 5,
          bottom: 5
        })
        .borderColor($r("app.color.home_border"))
        .borderWidth(1)
        .borderRadius(30)

        // 上次更新
        Row({ space: 5 }) {
          Text(`上次更新: ${this.lastUpdateTime}`)
            .fontColor($r("app.color.home_status_text"))
            .fontSize(12)
        }
        .padding({
          left: 10,
          right: 10,
          top: 5,
          bottom: 5
        })
        .borderColor($r("app.color.home_border"))
        .borderWidth(1)
        .borderRadius(30)

        // 样本数
        Row({ space: 5 }) {
          Text(`样本数: ${this.sampleCount}`)
            .fontColor($r("app.color.home_status_text"))
            .fontSize(12)
        }
        .padding({
          left: 10,
          right: 10,
          top: 5,
          bottom: 5
        })
        .borderColor($r("app.color.home_border"))
        .borderWidth(1)
        .borderRadius(30)
      }
      .width("100%")
      .justifyContent(FlexAlign.Center)
      // .backgroundColor(Color.Red)
      .padding({ left: 10, right: 10 })

      // 传感器数据展示区域（Grid 三列两行）
      Column() {
        Grid() {
          // 温度
          GridItem() {
            MetricCard({
              title: "温度",
              valueText: `${this.temp !== undefined && this.temp !== null ? this.temp.toFixed(2) : '--'} ℃`,
              trend: this.tempTrend,
              valueFontSize: 24
            })
          }

          // 温差 Δ
          GridItem() {
            MetricCard({
              title: "温度 Δ",
              valueText: `${this.temp !== undefined && this.temp !== null && this.temp2 !== undefined &&
                this.temp2 !== null ? Math.abs(this.temp - this.temp2).toFixed(2) : '--'} ℃`,
              trend: this.tempDiffTrend,
              valueFontSize: 24
            })
          }

          // 湿度
          GridItem() {
            MetricCard({
              title: "湿度",
              valueText: `${this.hum !== undefined && this.hum !== null ? this.hum.toFixed(2) : '--'} %`,
              trend: this.humTrend,
              valueFontSize: 24
            })
          }

          // 亮度
          GridItem() {
            MetricCard({
              title: "亮度",
              valueText: `${this.lux !== undefined && this.lux !== null ? this.lux.toFixed(1) : '--'} lux`,
              trend: this.luxTrend,
              valueFontSize: 24
            })
          }

          // 烟雾
          GridItem() {
            MetricCard({
              title: "烟雾",
              valueText: `${this.smoke !== undefined && this.smoke !== null ? this.smoke.toFixed(1) : '--'} ppm`,
              trend: this.smokeTrend,
              valueFontSize: 24
            })
          }

          // 大气压
          GridItem() {
            MetricCard({
              title: "大气压",
              valueText: `${this.pressure !== undefined && this.pressure !== null ? this.pressure.toFixed(1) :
                '--'} hPa`,
              trend: this.pressureTrend,
              valueFontSize: 22
            })
          }
        }
        .columnsTemplate("1fr 1fr")
        // .rowsTemplate("auto auto auto")
        .columnsGap(12)
        .rowsGap(12)
        .constraintSize({ maxWidth: 600 })
        .width("100%")
        .padding({
          // left: 15,
          // right: 15,
          top: 15
        })
      }
      .width("100%")
    }

    .backgroundColor($r("app.color.home_background"))
    .width("100%")
    .height("100%")
    .expandSafeArea()
  }
}
