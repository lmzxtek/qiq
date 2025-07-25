
echoT(){ FLAG=$1 && shift && echo -e "\033[39m$FLAG\033[39m$@";}
echoY(){ FLAG=$1 && shift && echo -e "\033[38;5;148m$FLAG\033[39m$@";}
echoG(){ FLAG=$1 && shift && echo -e "\033[38;5;71m$FLAG\033[39m$@"; }
echoB(){ FLAG=$1 && shift && echo -e "\033[38;1;34m$FLAG\033[39m$@" ;}
echoR(){ FLAG=$1 && shift && echo -e "\033[38;5;203m$FLAG\033[39m$@"; }

FCLS='\033[34m'        # 前景色：蓝色
FTCZ='\033[0m'         # 字体：重置所有
FTSS='\033[5m'         # 字体：闪烁

VLATEST="${FCLS}${FTSS}NEW${FTCZ}" # 蓝色闪烁字体
url_redir='https://sub.zwdk.org/qiq'
url_script='https://github.com/lmzxtek/qiq'
url_update='https://raw.githubusercontent.com/lmzxtek/qiq/refs/heads/main/src/log.sh'

clear
echoR " >>> " $(echoY "脚本更新日志") $(echoR "<<<") 
echoB " - " $(echoT $url_update)
echoT "--------------------------------"
echoT " -=> 2025-03-21   v0.7.2" " "
echoT "   1.日志文件接之前的版本"
echoT "   2.测试DD脚本项"
echoT "   3.修正测试项链接"
echoT "   4.完善Docker部署"
echoT "--------------------------------"
echoT " -=> 2025-03-25   v0.7.3" " "
echoT "   1.美化单栏菜单显示效果：左侧增加自定义Emoji表情"
echoT "   2.美化系统信息显示效果"
echoT "   3.修改双栏显示函数的调用方式，增加输入参数，控制显示效果"
echoT "   4.修改了仓库名称(qiq)，因为qiqtools仓库添加了大文件到仓库中，导致仓库体积过大"
echoT "   5.修改虚拟内存时显示当前虚拟内情情况"
echoT "   6.修正了时区调整显示问题"
echoT "   7.优化显示系统信息"
echoT "--------------------------------"
echoT " -=> 2025-03-30   v0.7.4" " "
echoT "   1.增加Code-Server的容器部署(LinuxServer and Official)"
echoT "   2.增加系统服务管理菜单"
echoT "   3.增加frp管理菜单"
echoT "--------------------------------"
echoT " -=> 2025-04-23   v0.7.5" " "
echoT "   1.增加NorthStar部署"
echoT "   2.增加Music-Tag(Docker)部署"
echoT "   3.修改AKtools(Docker)部署为最新版本，构建镜像本地"
echoT "   4.修正frp配置文件下载路径"
echoT "   5.修正frp菜单功能"
echoT "   6.添加nezha-v0安装脚本(win)"
echoT "   7.修正常用工具的安装"
echoT "   8.修正Docker网络IPv6的开启"
echoT "--------------------------------"
echoT " -=> 2025-05-31   v0.7.6" " "
echoT "   1.增加fnm安装脚本(linux)"
echoT "   2.修改默认自定义DD系统链接为2025-04的版本"
echoT "   3.修改Proxy链接为063643.xyz"
echoT "   4.增加OpenRestyManager部署(Host, Docker)"
echoT "   5.增加PhotoPea部署(Docker)"
echoT "   6.将Poetry安装的卸载分开 "
echoT "   7.更正NginxUI名称 "
echoT "   8.增加Nginx安装 "
echoT "   9.修复Alpine菜单显示问题 "
echoT "  10.添加RatPanel服务器管理面板安装 "
echoT "  11.修改DD系统时ISO镜像地址为重定向链接"
echoT "  12.DD系统时自定义链接添加获取真实地址功能"
echoT "--------------------------------"
echoR " -=> 2025-07-25   v0.7.7" " $VLATEST"
echoY "   1.修正系统安装时选项的序号"
echoY "   2.更新Caddy默认配置文件中的根路径"
echoY "   3.添加ufw的安装"
echoY "   4.添加开放8881:8888端口(ufw)"
echoT "--------------------------------"
echoR "" $(echoY "url") $(echoR ": $url_redir") 
echoR "" $(echoY "web") $(echoR ": $url_script") 

