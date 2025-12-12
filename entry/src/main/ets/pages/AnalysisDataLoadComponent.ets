import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
// 请确保这些引用路径在你项目中是正确的
import { SensorData } from './DeviceDetailPageLogic';
import { SERVER_HOST } from './WebSocketManager';
import { DeviceInfo } from './DevicesPageLogic';
import { LoadMode, TimeUnit, LoadParams, DataLoadCallback } from './DataLoadComponent';

// ----------------------------------------------------------------
// 1. 数据加载逻辑类 (保持不变)
// ----------------------------------------------------------------
class AnalysisDataLoader {
  private deviceId: string | null; // null表示全部设备
  private callback: DataLoadCallback;

  constructor(deviceId: string | null, callback: DataLoadCallback) {
    this.deviceId = deviceId;
    this.callback = callback;
  }

  getDeviceId(): string | null {
    return this.deviceId;
  }

  async load(params: LoadParams): Promise<void> {
    try {
      let url = `http://${SERVER_HOST}/api/history`;
      const queryParams: string[] = [];

      if (this.deviceId) {
        queryParams.push(`device_id=${this.deviceId}`);
      }

      switch (params.mode) {
        case LoadMode.COUNT:
          if (params.count !== undefined && params.count > 0) {
            queryParams.push(`limit=${params.count}`);
          }
          break;

        case LoadMode.TIME:
          if (params.timeValue !== undefined && params.timeUnit !== undefined) {
            const now = Date.now() / 1000;
            let startTime = now;
            switch (params.timeUnit) {
              case TimeUnit.MINUTE: startTime = now - params.timeValue * 60; break;
              case TimeUnit.HOUR: startTime = now - params.timeValue * 3600; break;
              case TimeUnit.DAY: startTime = now - params.timeValue * 86400; break;
              case TimeUnit.MONTH: startTime = now - params.timeValue * 2592000; break;
            }
            url = `http://${SERVER_HOST}/api/history/range`;
            queryParams.push(`start=${startTime}`);
            queryParams.push(`end=${now}`);
          }
          break;

        case LoadMode.RANGE:
          if (params.startTime !== undefined && params.endTime !== undefined) {
            url = `http://${SERVER_HOST}/api/history/range`;
            queryParams.push(`start=${params.startTime}`);
            queryParams.push(`end=${params.endTime}`);
          }
          break;

        case LoadMode.ALL:
          queryParams.push('limit=-1');
          break;
      }

      if (queryParams.length > 0) {
        url += '?' + queryParams.join('&');
      }

      console.info(`开始加载数据: ${url}`);
      const httpRequest: http.HttpRequest = http.createHttp();
      const response: http.HttpResponse = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json' }
      });

      httpRequest.destroy();

      if (response && response.responseCode === 200) {
        const result = JSON.parse(response.result as string) as Record<string, Object>;
        if (result['success'] === true && result['data']) {
          const dataArray = result['data'] as Array<Record<string, Object>>;
          const historyData: SensorData[] = [];
          dataArray.forEach((item: Record<string, Object>) => {
            if (item['type'] === 'reading') {
              historyData.push({
                ts: item['ts'] as number,
                temp: item['temp'] as number,
                hum: item['hum'] as number,
                lux: item['lux'] as number,
                smoke: item['smoke'] as number,
                pressure: item['pressure'] as number,
                temp2: item['temp2'] as number,
                rs_ro: item['rs_ro'] as number,
                device_id: item['device_id'] as string | undefined
              });
            }
          });
          this.callback.onDataLoaded(historyData, historyData.length);
        } else {
          const error = '数据加载失败或无数据';
          if (this.callback.onLoadError) this.callback.onLoadError(error);
        }
      } else {
        const error = `HTTP请求失败，状态码: ${response?.responseCode}`;
        if (this.callback.onLoadError) this.callback.onLoadError(error);
      }
    } catch (err) {
      const error = `数据加载异常: ${err}`;
      if (this.callback.onLoadError) this.callback.onLoadError(error);
    }
  }
}

// ----------------------------------------------------------------
// 2. 分析页数据加载组件
// ----------------------------------------------------------------
@ComponentV2
export struct AnalysisDataLoadComponent {
  @Require @Param deviceList: DeviceInfo[];
  @Require @Param selectedDeviceId: string | null;
  @Require @Param onDeviceChanged: (deviceId: string | null) => void;
  @Require @Param onDataLoaded: (data: SensorData[], count: number) => void;
  @Param shouldBounce: boolean = false; // 控制按钮弹跳动画

  @Local showLoadPanel: boolean = false;
  @Local showModeSelection: boolean = true;
  @Local selectedMode: LoadMode = LoadMode.COUNT;
  @Local loadCount: number = 1000;
  @Local timeValue: number = 1;
  @Local timeUnit: TimeUnit = TimeUnit.HOUR;
  @Local startDate: Date = new Date(Date.now() - 86400000);
  @Local endDate: Date = new Date();
  @Local isLoading: boolean = false;

  private loader: AnalysisDataLoader | null = null;

  aboutToAppear(): void {
    this.createLoader();
  }

  private createLoader(): void {
    this.loader = new AnalysisDataLoader(this.selectedDeviceId, {
      onDataLoaded: (data: SensorData[], count: number) => {
        this.isLoading = false;
        this.showLoadPanel = false;
        this.showModeSelection = true;
        try {
          promptAction.showToast({ message: `成功加载 ${count} 条数据`, duration: 2000 });
        } catch (e) {
          console.error('显示Toast失败:', e);
        }
        this.onDataLoaded(data, count);
      },
      onLoadError: (error: string) => {
        this.isLoading = false;
        try {
          promptAction.showToast({ message: `加载失败: ${error}`, duration: 2000 });
        } catch (e) {
          console.error('显示Toast失败:', e);
        }
      }
    });
  }

  private async executeLoad(): Promise<void> {
    if (this.isLoading || !this.loader) return;
    if (this.loader && this.loader.getDeviceId() !== this.selectedDeviceId) {
      this.createLoader();
    }
    this.isLoading = true;
    const params: LoadParams = { mode: this.selectedMode };
    switch (this.selectedMode) {
      case LoadMode.COUNT: params.count = this.loadCount; break;
      case LoadMode.TIME: params.timeValue = this.timeValue; params.timeUnit = this.timeUnit; break;
      case LoadMode.RANGE:
        params.startTime = Math.floor(this.startDate.getTime() / 1000);
        params.endTime = Math.floor(this.endDate.getTime() / 1000);
        break;
      case LoadMode.ALL: break;
    }
    await this.loader.load(params);
  }

  build() {
    Column({ space: 12 }) {
      // 1. 设备选择
      Column({ space: 8 }) {
        Text('设备选择')
          .fontSize(14)
          .fontColor($r("app.color.home_title_text"))
          .width('100%')

        Select(this.getDeviceOptions())
          .selected(this.getSelectedDeviceIndex())
          .value(this.getSelectedDeviceText())
          .width('100%')
          .onSelect((index: number) => {
            if (index === 0) this.onDeviceChanged(null);
            else {
              const device = this.deviceList[index - 1];
              this.onDeviceChanged(device.id || device.device_id || null);
            }
            this.createLoader();
          })
      }
      .width('100%')

      // 2. 加载按钮 (绑定弹窗 + 弹跳动画)
      Button('📥 加载数据')
        .width('100%')
        .fontSize(14)
        .fontColor(Color.White)
        .backgroundColor(this.shouldBounce ? '#ff6b6b' : '#2563eb')
        .scale({ 
          x: this.shouldBounce ? 1.05 : 1, 
          y: this.shouldBounce ? 1.05 : 1 
        })
        .shadow({
          radius: this.shouldBounce ? 12 : 4,
          color: this.shouldBounce ? '#4Fff6b6b' : '#1F2563eb',
          offsetX: 0,
          offsetY: 2
        })
        .animation({
          duration: 300,
          curve: Curve.EaseInOut,
          iterations: this.shouldBounce ? 3 : 1,
          playMode: PlayMode.Alternate
        })
        .onClick(() => {
          this.showModeSelection = true;
          this.showLoadPanel = true;
        })
        .bindSheet(this.showLoadPanel, this.buildLoadPanel(), {
          height: SheetSize.MEDIUM,
          dragBar: true,
          backgroundColor: $r("app.color.home_card_background"),
          onDisappear: () => {
            this.showLoadPanel = false;
          }
        })
    }
    .width('100%')
  }

  // --- 弹窗面板 (已修改标题栏) ---
  @Builder
  buildLoadPanel() {
    Column() {
      // 标题栏：只保留一个 X
      Row() {
        Text('📊 加载历史数据')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r("app.color.home_value_text"))
          // .layoutWeight(1)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .padding({ top: 20, bottom: 12, left: 20, right: 10 }) // 右侧padding减小，因为X自带宽度
      // .border({ width: { bottom: 1 }, color: '#F0F0F0' })

      Scroll() {
        Column({ space: 16 }) {
          if (this.showModeSelection) {
            this.buildModeSelection()
          } else {
            this.buildDetailForm()
          }
        }
        .padding(20)
      }
      .layoutWeight(1)
      .width('100%')

      if (!this.showModeSelection) {
        Row({ space: 12 }) {
          Button('上一步')
            .fontColor('#2563eb')
            .backgroundColor(Color.Transparent)
            .layoutWeight(1)
            .onClick(() => {
              this.showModeSelection = true;
            })

          Button(this.isLoading ? '加载中...' : '开始加载')
            .fontColor(Color.White)
            .backgroundColor('#2563eb')
            .layoutWeight(2)
            .enabled(!this.isLoading)
            .onClick(() => {
              this.executeLoad();
            })
        }
        .padding(16)
        .width('100%')
        .backgroundColor($r("app.color.home_card_background"))
        .border({ width: { top: 1 }, color: '#F0F0F0' })
      }
    }
    .width('100%')
    .height('100%')
  }

  // --- 辅助方法 (保持不变) ---

  @Builder
  buildDetailForm() {
    Column({ space: 20 }) {
      if (this.selectedMode === LoadMode.COUNT) {
        this.buildCountForm()
      } else if (this.selectedMode === LoadMode.TIME) {
        this.buildTimeForm()
      } else if (this.selectedMode === LoadMode.RANGE) {
        this.buildRangeForm()
      }
    }
  }

  @Builder
  buildModeSelection() {
    Column({ space: 12 }) {
      this.buildModeOption('📝', '按最近条数加载', '加载最近的N条数据记录', () => {
        this.selectedMode = LoadMode.COUNT;
        this.showModeSelection = false;
      })
      this.buildModeOption('⏱️', '按最近时间加载', '加载最近几分钟/小时/天/月的数据', () => {
        this.selectedMode = LoadMode.TIME;
        this.showModeSelection = false;
      })
      this.buildModeOption('📅', '自定义时间范围', '选择开始和结束时间，精确加载', () => {
        this.selectedMode = LoadMode.RANGE;
        this.showModeSelection = false;
      })
      this.buildModeOption('⚠️', '加载全部数据', '加载数据库中的所有历史数据', () => {
        this.selectedMode = LoadMode.ALL;
        this.executeLoad();
      })
    }
  }

  @Builder
  buildModeOption(icon: string, title: string, desc: string, onClick: () => void) {
    Row() {
      Column({ space: 4 }) {
        Row({ space: 8 }) {
          Text(icon).fontSize(20)
          Text(title)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor($r("app.color.home_value_text"))
        }
        Text(desc)
          .fontSize(12)
          .fontColor($r("app.color.home_status_text"))
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Text('›')
        .fontSize(24)
        .fontColor($r("app.color.home_status_text"))
        .fontWeight(FontWeight.Lighter)
    }
    .width('100%')
    .padding(16)
    .borderRadius(12)
    .borderWidth(1)
    .borderColor($r("app.color.home_card_border"))
    .backgroundColor($r("app.color.home_card_background"))
    .onClick(onClick)
  }

  @Builder
  buildCountForm() {
    Column({ space: 16 }) {
      Text('数据条数').fontSize(14).fontColor($r("app.color.home_title_text")).width('100%')
      Row({ space: 8 }) {
        TextInput({ text: this.loadCount.toString() })
          .type(InputType.Number)
          .fontSize(14)
          .layoutWeight(1)
          .onChange((value: string) => {
            const num = parseInt(value);
            if (!isNaN(num) && num > 0) this.loadCount = num;
          })
        Text('条').fontSize(14).fontColor($r("app.color.home_status_text"))
      }
      .width('100%')
    }
  }

  @Builder
  buildTimeForm() {
    Column({ space: 16 }) {
      Text('时间数量').fontSize(14).fontColor($r("app.color.home_title_text")).width('100%')
      Row({ space: 8 }) {
        TextInput({ text: this.timeValue.toString() })
          .type(InputType.Number)
          .fontSize(14)
          .width(100)
          .onChange((value: string) => {
            const num = parseInt(value);
            if (!isNaN(num) && num > 0) this.timeValue = num;
          })
        Select(this.getTimeUnitOptions())
          .selected(1)
          .value(this.getTimeUnitText())
          .layoutWeight(1)
          .zIndex(1000)
          .onSelect((index: number) => {
            switch (index) {
              case 0: this.timeUnit = TimeUnit.MINUTE; break;
              case 1: this.timeUnit = TimeUnit.HOUR; break;
              case 2: this.timeUnit = TimeUnit.DAY; break;
              case 3: this.timeUnit = TimeUnit.MONTH; break;
            }
          })
      }
      .width('100%')
    }
  }

  @Builder
  buildRangeForm() {
    Column({ space: 16 }) {
      Column({ space: 8 }) {
        Text('开始时间').fontSize(14).fontColor($r("app.color.home_title_text")).width('100%')
        DatePicker({ start: new Date('2020-01-01'), end: new Date(), selected: this.startDate })
          .onDateChange((value: Date) => { this.startDate = value; })
      }
      Column({ space: 8 }) {
        Text('结束时间').fontSize(14).fontColor($r("app.color.home_title_text")).width('100%')
        DatePicker({ start: new Date('2020-01-01'), end: new Date(), selected: this.endDate })
          .onDateChange((value: Date) => { this.endDate = value; })
      }
    }
  }

  private getDeviceOptions(): Array<SelectOption> {
    const options: Array<SelectOption> = [];
    const allDeviceOption: SelectOption = { value: '全部设备', icon: '' };
    options.push(allDeviceOption);
    this.deviceList.forEach(device => {
      const name = device.name || `设备 ${device.id || device.device_id}`;
      const deviceOption: SelectOption = { value: name, icon: '' };
      options.push(deviceOption);
    });
    return options;
  }

  private getSelectedDeviceIndex(): number {
    if (!this.selectedDeviceId) return 0;
    const index = this.deviceList.findIndex(device =>
    (device.id || device.device_id || '').trim().toUpperCase() === this.selectedDeviceId?.trim().toUpperCase()
    );
    return index >= 0 ? index + 1 : 0;
  }

  private getSelectedDeviceText(): string {
    if (!this.selectedDeviceId) return '全部设备';
    const device = this.deviceList.find(d =>
    (d.id || d.device_id || '').trim().toUpperCase() === this.selectedDeviceId?.trim().toUpperCase()
    );
    return device ? (device.name || `设备 ${device.id || device.device_id}`) : '全部设备';
  }

  private getTimeUnitText(): string {
    switch (this.timeUnit) {
      case TimeUnit.MINUTE: return '分钟';
      case TimeUnit.HOUR: return '小时';
      case TimeUnit.DAY: return '天';
      case TimeUnit.MONTH: return '月';
      default: return '小时';
    }
  }

  private getTimeUnitOptions(): Array<SelectOption> {
    return [
      { value: '分钟', icon: '' },
      { value: '小时', icon: '' },
      { value: '天', icon: '' },
      { value: '月', icon: '' }
    ];
  }
}