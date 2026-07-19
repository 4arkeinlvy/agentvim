# vhs tape: dashboard + which-key screenshots
# run from repo root: vhs assets/tapes/dashboard.tape
Output .repro/vhs-dashboard.gif
Set Shell "bash"
Set FontFamily "JetBrainsMono Nerd Font"
Set FontSize 15
Set Width 1400
Set Height 800
Set Padding 12

Type "nvim"
Enter
Sleep 6s
Screenshot assets/screenshots/dashboard.png
Type " "
Sleep 2s
Screenshot assets/screenshots/which-key.png
Escape
Sleep 1s
Type "q"
Sleep 2s
