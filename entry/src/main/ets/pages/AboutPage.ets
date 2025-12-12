import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

interface MyLogs {
  version: string
  date: string
  desc: string
  isLatest: boolean
}

@ComponentV2
export struct AboutPage {
  // --- 数据源 ---
  private techStack: string[] = ['ArkTS', 'STM32', 'MQTT', 'FastAPI', 'WebSocket', 'MySQL', 'Docker'];
  // 更新日志数据
  private changeLogs: MyLogs[] = [
    {
      version: 'Version 1.0.4',
      date: '2025.12.9',
      desc: '重写了 /api/status 的判断逻辑，解放前端压力。',
      isLatest: true
    },
    {
      version: 'Version 1.0.3',
      date: '2025.11.20',
      desc: '新增消息中心筛选功能，优化移动端布局。',
      isLatest: false
    }
  ];

  build() {
    Column() {
      // 沉浸式滚动区域
      Scroll() {
        Column() {
          // --- 1. 头部信息 ---
          Column() {
            Image("https://znhj.iepose.cn/resource/img.jpg")
              .width(80)
              .height(80)
              .borderRadius(40) // 圆形
              .objectFit(ImageFit.Cover)
              .backgroundColor($r('app.color.about_bg_image')) // 缺省底色
              .border({ width: 4, color: $r('app.color.start_window_background') }) // 白边框
              .shadow({ radius: 10, color: $r('app.color.about_shadow_light'), offsetY: 4 })
              .margin({ bottom: 16 })

            // App 名称
            Text("PengX 智能环境监测")
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.home_value_text'))
              .margin({ bottom: 4 })

            // 版本号
            Text("HarmonyOS Beta 4")
              .fontSize(12)
              .fontColor($r('app.color.about_text_secondary'))
              .margin({ bottom: 24 })

            // 社交链接行
            Row() {
              this.SocialButton("GitHub", $r('app.media.ic_github'))
              this.SocialButton("Gitee", $r('app.media.ic_gitee'))
              this.SocialButton("Web版本", $r('app.media.ic_html5'))
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceEvenly)
          }
          .width('100%')
          .padding({
            top: 48,
            bottom: 32,
            left: 24,
            right: 24
          })
          .backgroundColor($r('app.color.home_card_background'))
          .borderRadius({ bottomLeft: 24, bottomRight: 24 })
          .shadow({ radius: 20, color: $r('app.color.about_shadow_medium'), offsetY: 4 })

          // --- 2. 项目介绍卡片 ---
          Column() {
            // 标题
            Row({ space: 8 }) {
              Image($r('app.media.ic_info')) // 请替换为 info 图标
                .width(18)
                .height(18)
                .fillColor($r('app.color.about_primary_blue'))
              Text("项目介绍")
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.home_value_text'))
            }
            .width('100%')
            .margin({ bottom: 12 })

            // 介绍文本
            Text("本项目是一个基于 STM32 和物联网技术的智能环境监测系统，实现了温度、湿度、亮度、烟雾浓度和大气压等多参数实时监测。")
              .fontSize(13)
              .fontColor($r('app.color.home_title_text'))
              .lineHeight(20)
              .textAlign(TextAlign.Start)
              .margin({ bottom: 16 })

            // 技术栈标签
            Text("技术栈")
              .fontSize(11)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.about_text_secondary'))
              .margin({ bottom: 8 })
              .width('100%')

            Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
              ForEach(this.techStack, (tag: string) => {
                Text(tag)
                  .fontSize(11)
                  .fontColor($r('app.color.about_text_dark'))
                  .fontWeight(FontWeight.Medium)
                  .padding({
                    left: 10,
                    right: 10,
                    top: 4,
                    bottom: 4
                  })
                  .backgroundColor($r('app.color.about_bg_light'))
                  .border({ width: 1, color: $r('app.color.about_border_light') })
                  .borderRadius(6)
                  .margin({ right: 8, bottom: 8 })
              })
            }
          }
          .margin({ top: 16, left: 16, right: 16 })
          .padding(20)
          .backgroundColor($r('app.color.home_card_background'))
          .borderRadius(20)
          .alignItems(HorizontalAlign.Start)

          // --- 3. 更新日志卡片 ---
          Column() {
            // 标题
            Row({ space: 8 }) {
              Image($r('app.media.ic_public_todo')) // 替换为日志/文档图标
                .width(18)
                .height(18)
                .fillColor($r('app.color.about_icon_orange')) // Orange
              Text("更新日志")
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.home_value_text'))
            }
            .width('100%')
            .margin({ bottom: 20 })

            // 时间轴列表
            // 使用左边框模拟时间轴线
            Column() {
              ForEach(this.changeLogs, (log: MyLogs, index: number) => {
                this.LogItem(log, index === this.changeLogs.length - 1)
              })
            }
            .padding({ left: 2 }) // 微调给圆点留空间
          }
          .margin({ top: 16, left: 16, right: 16 })
          .padding(20)
          .backgroundColor($r('app.color.home_card_background'))
          .borderRadius(20)

          // --- 4. 退出登录按钮 ---
          Button() {
            Row({ space: 6 }) {
              Image($r('app.media.ic_public_cancel')) // 替换为退出图标
                .width(18)
                .height(18)
                .fillColor($r('app.color.about_error_red'))
              Text("退出登录")
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.about_error_red'))
            }
          }
          .width('92%')
          .height(52)
          .margin({ top: 24, bottom: 40 })
          .backgroundColor($r('app.color.about_error_bg')) // 红色淡背景
          .type(ButtonType.Normal)
          .borderRadius(16)
          .onClick(() => {
            // 处理退出逻辑
            AlertDialog.show({
              title: '提示',
              message: '确定要退出登录吗？',
              primaryButton: {
                value: '取消', action: () => {
                }
              },
              secondaryButton: {
                value: '确定', fontColor: $r('app.color.about_error_red'), action: () => {
                  console.info('Logout');
                }
              }
            })
          })

        }
        .width('100%')
      }
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.home_background'))
  }

  // --- 辅助组件：社交按钮 ---
  @Builder
  SocialButton(label: string, icon: Resource) {
    Column({ space: 6 }) {
      Column() {
        Image(icon)
          .width(20)
          .height(20)
      }
      .width(44)
      .height(44)
      .borderRadius(22)
      .backgroundColor($r('app.color.about_bg_light')) // 浅灰圆底
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Text(label)
        .fontSize(11)
        .fontColor($r('app.color.about_text_secondary'))
    }
    .onClick(() => {
      let url: string = '';
      if (label === 'GitHub') {
        url = 'https://github.com/longmxuc';
      } else if (label === 'Gitee') {
        url = 'https://gitee.com/Cdaozi';
      } else if (label === 'Web版本') {
        url = 'https://znhj.iepose.cn';
      }
      
      if (url) {
        try {
          let wantInfo: Want = {
            action: 'ohos.want.action.viewData',
            uri: url,
            type: 'text/plain'
          };
          let context = getContext(this) as common.UIAbilityContext;
          context.startAbility(wantInfo).then(() => {
            console.info(`成功打开 ${label}: ${url}`);
          }).catch((err: BusinessError) => {
            console.error(`打开 ${label} 失败: ${err.message}`);
            // 如果系统浏览器无法打开，尝试使用通用方式
            let fallbackWant: Want = {
              action: 'ohos.want.action.viewData',
              uri: url
            };
            context.startAbility(fallbackWant).catch((fallbackErr: BusinessError) => {
              console.error(`备用方式打开失败: ${fallbackErr.message}`);
            });
          });
        } catch (err) {
          console.error(`跳转失败: ${err}`);
        }
      }
    })
  }

  // --- 辅助组件：日志条目 ---
  @Builder
  LogItem(log: MyLogs, isLast: boolean) {
    Row() {
      // 左侧：时间轴
      Column() {
        // 圆点
        if (log.isLatest) {
          // 最新版本：实心蓝点 + 呼吸效果外圈
          Stack() {
            Circle({ width: 14, height: 14 }).fill($r('app.color.about_blue_alpha'))
            Circle({ width: 8, height: 8 }).fill($r('app.color.about_primary_blue'))
          }
          .margin({ top: 4 }) // 对齐文本
        } else {
          // 旧版本：灰色空心点
          Circle({ width: 9, height: 9 })
            .fill($r('app.color.about_timeline_dot'))
            .margin({ top: 6 })
        }

        // 竖线 (如果不是最后一个)
        if (!isLast) {
          Divider()
            .vertical(true)
            .strokeWidth(1)
            .color($r('app.color.about_timeline_line'))
            .height(50) // 线长，根据内容自动撑开会更好，但在 Row 里固定布局比较简单
            .margin({ top: 4 })
        }
      }
      .width(20)
      .alignItems(HorizontalAlign.Center)
      .margin({ right: 12 })

      // 右侧：内容
      Column() {
        Row() {
          Text(log.version)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(log.isLatest ? $r('app.color.home_value_text') : $r('app.color.about_text_secondary'))

          Blank()

          Text(log.date)
            .fontSize(11)
            .fontColor($r('app.color.about_text_tertiary'))
        }
        .width('100%')
        .margin({ bottom: 6 })

        Text(log.desc)
          .fontSize(12)
          .fontColor($r('app.color.home_title_text'))
          .lineHeight(18)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ bottom: isLast ? 0 : 24 }) // 条目间距
    }
    .alignItems(VerticalAlign.Top)
    .width('100%')
  }
}