下面是一版实现级 spec v0.1。仅覆盖 MVP，面向工程实现。

⸻

Hydrate Bar

macOS 菜单栏喝水提醒工具
Implementation Spec v0.1

⸻

1. 技术栈

语言
Swift

UI
SwiftUI

菜单栏
MenuBarExtra (macOS 13+)

通知
UserNotifications

本地存储
UserDefaults

定时器
Timer + Date 计算校准

⸻

2. 项目结构

HydrateBar/

App/
  HydrateBarApp.swift

MenuBar/
  MenuBarView.swift
  MenuBarState.swift

Reminder/
  ReminderManager.swift
  ReminderScheduler.swift

Notification/
  NotificationManager.swift

Settings/
  SettingsView.swift
  SettingsStore.swift

Model/
  AppSettings.swift
  ReminderState.swift

Utils/
  TimeUtils.swift

职责说明

App
应用入口

MenuBar
状态栏 UI

Reminder
提醒逻辑与调度

Notification
系统通知

Settings
设置管理

Model
核心数据结构

Utils
时间计算

⸻

3. 核心数据结构

AppSettings

struct AppSettings: Codable {

    var reminderIntervalMinutes: Int
    
    var startHour: Int
    var startMinute: Int
    
    var endHour: Int
    var endMinute: Int
    
    var enableNotification: Bool
    
    var enableMenuBarAlert: Bool
}

默认值

interval = 60

start = 09:00
end = 20:00

enableNotification = true
enableMenuBarAlert = true


⸻

ReminderState

struct ReminderState {

    var lastDrinkTime: Date?
    
    var nextReminderTime: Date?
    
    var isPausedToday: Bool
}


⸻

4. ReminderManager

核心职责
负责提醒状态管理与调度。

单例

class ReminderManager: ObservableObject

核心字段

@Published var nextReminderTime: Date?

var timer: Timer?


⸻

启动流程

App launch

load settings

calculateNextReminder()

start timer

Timer interval
60 秒

用于检查是否触发提醒。

⸻

5. 提醒计算逻辑

函数

func calculateNextReminder(now: Date)

逻辑

1 判断当前时间是否在提醒范围内

start <= now <= end

如果不在范围

nextReminder = nextStartTime

如果在范围

nextReminder = lastDrinkTime + interval

如果 lastDrinkTime 为空

nextReminder = now + interval


⸻

6. Timer Tick

每 60 秒执行

if now >= nextReminderTime
    triggerReminder()

然后重新计算

calculateNextReminder()


⸻

7. triggerReminder

行为

showMenuBarAlert()

if notificationEnabled
    showSystemNotification()


⸻

8. NotificationManager

权限申请

UNUserNotificationCenter.current()
.requestAuthorization

发送通知

title: "该喝水了"
body: "起来喝几口水吧"


⸻

9. MenuBar UI

使用

MenuBarExtra

状态栏 icon

建议使用

SF Symbol

drop.fill


⸻

Menu 内容

Next reminder: 14:20

Drink now
Snooze 10 minutes

Pause today

Settings

Quit


⸻

10. Menu 行为

Drink now

lastDrinkTime = now
recalculate reminder


⸻

Snooze 10 minutes

nextReminderTime = now + 10m


⸻

Pause today

isPausedToday = true
nextReminderTime = nil

午夜自动 reset

⸻

11. Settings UI

SettingsView

字段

Interval

30
45
60
90
custom

Reminder Time Range

Start Time
End Time

Reminder Mode

Menu Bar Alert
System Notification

按钮

Save

保存到

UserDefaults


⸻

12. 状态栏显示

Icon

drop

可选显示

next reminder countdown

例如

💧 25m

MVP 可不实现倒计时，仅 icon。

⸻

13. 时间范围处理

函数

func isWithinReminderWindow(now)

规则

start <= now <= end

如果跨天

例如

22:00 - 06:00

需要特殊处理

MVP 可以 不支持跨天时间段。

⸻

14. Mac Sleep 处理

监听

NSWorkspace.didWakeNotification

唤醒后

recalculateNextReminder()


⸻

15. 每日 reset

监听日期变化

Calendar.current.isDateInToday

如果日期变化

isPausedToday = false


⸻

16. 权限处理

如果通知权限关闭

设置界面提示

Enable notifications in System Settings


⸻

17. 错误与边界

1 interval < 5 分钟
限制最小 5

2 endTime < startTime
禁止保存

3 Mac 睡眠
重新计算 nextReminder

⸻

18. 未来扩展预留

可增加

Daily water count
Drink history
Charts
iCloud sync

但当前架构不需要修改核心 ReminderManager。

⸻

如果需要，我可以再给你一版 “1 小时能写完的最小 macOS 菜单栏 App 代码骨架”，基本复制粘贴就能跑。