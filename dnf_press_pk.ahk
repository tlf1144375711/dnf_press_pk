#Requires AutoHotkey v2.0
Persistent
#SingleInstance Force
#NoTrayIcon
CoordMode('Mouse', 'Screen')
CoordMode('ToolTip', 'Screen')
p := [0,0]
p[1] := IniRead('config_dnf_press_pk.ini', 'pos', 'x', '0')
p[2] := IniRead('config_dnf_press_pk.ini', 'pos', 'y', '0')

get_pos() {
    global p
    KeyWait('LButton', 'D')
    MouseGetPos(&x, &y)
    p := [x, y]
    ToolTip('坐标已记录', p[1], p[2])
    IniWrite(p[1],'config_dnf_press_pk.ini','pos','x')
    IniWrite(p[2],'config_dnf_press_pk.ini','pos','y')
    Sleep(2000)
    ToolTip
}


change(*) {
    global p
    Hotkey('~z', 'Off')
    btn.Enabled := false
    ; 允许用户采集坐标
    text.Text := '采集模式：鼠标左键点击拾取点位'
    get_pos()
    text.Text := '当前坐标：' . p[1] . ' ' . p[2]
    ; 应用了，用户可以使用热键了
    Hotkey('~z', 'On')
    btn.Enabled := true
}
; 长按z键1秒以上松开，则点击屏幕左下角
~z:: {
    global p
    KeyWait('z')
    ; OutputDebug A_ThisHotkey  '`t' A_TimeSinceThisHotkey '`n'
    if (A_TimeSinceThisHotkey > 1000) {
        SendEvent('{Click ' . p[1] . ' ' . p[2] . '}')
    }
}
G := Gui('+MaxSize300x150 +MinSize300x150 +Resize -MinimizeBox -MaximizeBox')
G.MarginX := 10, G.MarginY := 10
G.SetFont('S12', 'Microsoft YaHei UI')
text := G.AddText('W280', '当前坐标：' . p[1] . ' ' . p[2])
btn := G.AddButton('W280', '采集')
btn.OnEvent('Click', change)
G.AddLink('', '<a href="https://github.com/tlf1144375711/dnf_gatling_combo">Github</a>  <a href="https://space.bilibili.com/44763794">Bilibili</a>')
Version := '1.0'
G.AddStatusBar('', 'Version ' . Version)
G.Show()
G.OnEvent('Close', (*) => ExitApp())
; 因为dnfpkc无双匹配时不能按x键来实现匹配功能，我做了这么一个脚本
; 使用方法：长按z键1秒以上，松开后会点击屏幕指定坐标


; 自动编译
;@Ahk2Exe-IgnoreBegin
name := StrReplace(A_ScriptName,'.ahk') . '_' . Version . '.exe'
ico := StrReplace(A_ScriptName,'.ahk') . '.ico'
cmd := '"C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /base "C:\Program Files\AutoHotkey\v2\AutoHotkey32.exe" /in ' . A_ScriptName . ' /icon ' . ico . ' /out ' . name
; OutputDebug cmd
Run(cmd)
;@Ahk2Exe-IgnoreEnd