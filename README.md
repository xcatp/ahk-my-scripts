# 说明

此目录下所有脚本依赖于仓库`ahk-lib`，需要先`clone`该仓库。
克隆之后，还需修改此目录下脚本的`Include Path`：

第一步，运行`scripts/IncludeResolveGui.ahk`，修改第一个输入框值为克隆的`ahk-lib`仓库所在目录。

并可选的修改第二个输入框值为脚本输出目录，留空则原地替换脚本内容（推荐）。

第二步，拖入文件或**文件夹**到gui中。

# 介绍

在日常使用中，启动`main.ahk`即可。

## 目录

- bin : 编译成exe的脚本。
- gizmos ： 用得较少、只在特定场景下使用的脚本。
- resource : 资源目录，通常是图标。
- scripts : 常用的脚本，独立运行；被主脚本读取并显示在托盘菜单中。

## 脚本

| 名称                | 作用                           |
|---------------------|------------------------------|
| main                | 主脚本，包含了其他脚本          |
| blockMouse          | 锁定鼠标移动，在看视频时很有用  |
| lightCtrl           | 快捷控制屏幕亮度               |
| mediaCtrl           | 快捷控制媒体播放               |
| quickLook           | 快速查看资源管理器中选中的文件 |
| setDesktopIconState | 切换桌面图标显隐               |
| simpleMove          | 像vim一样移动光标              |
| volumeCtrl          | 快捷控制媒体音量               |
| windowTopCtrl       | 热键控制窗口置顶               |


在scripts目录下：
| 名称                   | 作用                                  |
|------------------------|-------------------------------------|
| _windowTransparentCtrl | 设置当前窗口的透明度                  |
| ahkProcessMgr          | 管理ahk脚本进程，可编辑、关闭和重启     |
| colorThief             | 取色器                                |
| IncludeResolveGui      | 批量修改脚本Include路径，特定于此仓库  |
| textProcessor          | 对文本执行预设的操作，如替换换行符为\n |
| visualKeyboard         | 悬浮屏幕键盘，实时显示击键信息         |

在gizmos目录下：
| 名称         | 作用                    |
|--------------|-----------------------|
| key-recorder | 击键录制器              |
| merge        | 合并使用Include的脚本   |
| wallpaper    | 使用vlc实现动态桌面壁纸 |