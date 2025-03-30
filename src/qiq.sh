#!/bin/bash

#========================================================
#   System Required: CentOS 7+ | Debian 8+ | Ubuntu 16+ | Alpine 3+ |
#   Description: QiQ一键安装脚本
#   GitHub : https://github.com/lmzxtek/qiq
#   GitCode: https://gitcode.com/lmzxtek/qiq
#
#   一键安装命令如下：
#   $> wget -qO qiq.sh https://qiq.zwdk.im/sh && chmod +x qiq.sh && ./qiq.sh
#   $> wget -qO qiq.sh https://sub.zwdk.org/qiq && chmod +x qiq.sh && ./qiq.sh
#   $> curl -sSL -o qiq.sh https://qiq.zwdk.org/sh && chmod +x qiq.sh && ./qiq.sh
#   $> curl -sSL -o qiq.sh https://sub.zwdk.org/qiq && chmod +x qiq.sh && ./qiq.sh
# 
#   $> curl -sS -O https://raw.gitcode.com/lmzxtek/qiq/raw/main/src/qiq.sh && chmod +x qiq.sh && ./qiq.sh
#   $> curl -sS -O https://raw.githubusercontent.com/lmzxtek/qiq/refs/heads/main/src/qiq.sh && chmod +x qiq.sh && ./qiq.sh
#   $> wget -qN https://raw.githubusercontent.com/lmzxtek/qiq/refs/heads/main/src/qiq.sh && chmod +x qiq.sh && ./qiq.sh
#========================================================


#==== 脚本版本号 ===========
SRC_VER=v0.7.4
#==========================

URL_PROXY='https://proxy.zwdk.org/proxy/'
URL_REDIRECT='https://qiq.zwdk.org/sh'
URL_REDIRECT='https://sub.zwdk.org/qiq'
URL_SCRIPT='https://raw.githubusercontent.com/lmzxtek/qiq/refs/heads/main/src/qiq.sh'
URL_UPDATE='https://raw.githubusercontent.com/lmzxtek/qiq/refs/heads/main/src/log.sh'


# Emoji: 💡🧹🎉⚙️♻️🔧🛠️🏹💣🎯🧲🌍🌎🌏🌐🏡🏚️🏠🏯🗼🧭♨️💧📡👫
#        🐵🐒🐕🦍🫏🦒🦜🐔🐤🐓🦅🪿🐦‍⬛🐋🐬🪼🪲🌹🥀🌿🌱☘️🍓🍉
# Emoji: 😀😀😝😔🫨💥💯💤💫⭐🌟✨💦🛑⚓🎁🎀🏅🎖️🥇🥈🥉❗❕⚠️
# Emoji: 💔💖💝🩷❤️💗⛳🕹️🎨♥️♠️♣️♦️♟️🃏🔒🔓🔐🔏🔑🗝️
#        👌👍✌️👋👉👈👆👇👎✊👊🤛🤝👐👀👁️🦶🩸💊🩹
#        ⚠️🚸⛔🚫🚳📵☣️☢️🔅🔆✖️➕➖➗🟰♾️⁉️❓❔💲♻️🔱⚜️📛⭕❌✔️☑️✅❎✳️❇️✴️
#        🔛🔚🔙🔜🔝⬆️⬇️⬅️➡️↖️↕️↗️↪️↙️↩️⤴️⤵️↔️🔄🔃🔢🔢🔢🔡🔤⌨️

BOLD='\033[1m'
PLAIN='\033[0m'
RESET='\033[0m'

WORKING="\033[1;36m✨️${PLAIN}"
PRIGHT="\033[1;36m👉${PLAIN}"
SUCCESS="\033[1;32m✅${PLAIN}"
COMPLETE="\033[1;32m✔${PLAIN}"
WARN="\033[1;36m⚠️${PLAIN}"
ERROR="\033[1;31m✘${PLAIN}"
FAIL="\033[1;31m✘${PLAIN}"
TIP="\033[1;36m💡${PLAIN}"
_TAG_DEFAULT="\033[1;36m🌿${PLAIN}"


# 颜色定义：\033比\e的兼容性更好 
BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
PURPLE='\033[35m'
MAGENTA='\033[35m'
CYAN='\033[36m'
AZURE='\033[36m'
WHITE='\033[37m'
DEFAULT='\033[39m'

FCMR='\033[39m'        # 前景色：默认
FCBL='\033[30m'        # 前景色：黑色
FCRE='\033[31m'        # 前景色：红色
FCGR='\033[32m'        # 前景色：绿色
FCYE='\033[33m'        # 前景色：黄色
FCLS='\033[34m'        # 前景色：蓝色
FCZS='\033[35m'        # 前景色：紫色
FCTL='\033[36m'        # 前景色：天蓝
FCQH='\033[37m'        # 前景色：白色|浅灰

FCSH='\033[90m'        # 前景：深灰
FCHD='\033[91m'        # 前景：红灯
FCLG='\033[92m'        # 前景：浅绿
FCDH='\033[93m'        # 前景：淡黄
FCLB='\033[94m'        # 前景：浅蓝
FCYH='\033[95m'        # 前景：浅洋红
FCQQ='\033[96m'        # 前景：浅青色
FCBS='\033[97m'        # 前景：白色

BCMR='\033[49m'        # 背景色：默认
BCBL='\033[40m'        # 背景色：黑色
BCRE='\033[41m'        # 背景色：红色
BCGR='\033[42m'        # 背景色：绿色
BCYE='\033[43m'        # 背景色：黄色
BCLS='\033[44m'        # 背景色：蓝色
BCZS='\033[45m'        # 背景色：紫色
BCTL='\033[46m'        # 背景色：天蓝
BCQH='\033[47m'        # 背景色：白色|浅灰

BCSH='\033[100m'       # 背景：深灰
BCHD='\033[101m'       # 背景：红灯
BCLG='\033[102m'       # 背景：浅绿
BCDH='\033[103m'       # 背景：淡黄
BCLB='\033[104m'       # 背景：浅蓝
BCYH='\033[105m'       # 背景：浅洋红
BCQQ='\033[106m'       # 背景：浅青色
BCBS='\033[107m'       # 背景：白色

FTCZ='\033[0m'         # 字体：重置所有
FTCT='\033[1m'         # 字体：粗体
FTDH='\033[2m'         # 字体：淡化
FTXT='\033[3m'         # 字体：斜体
FTXH='\033[4m'         # 字体：下划线
FTSS='\033[5m'         # 字体：闪烁
FTFX='\033[7m'         # 字体：反显
FTYC='\033[8m'         # 字体：隐藏
FTHD='\033[9m'         # 字体：划掉

FDCT='\033[21m'        # 字体：取消粗体
FDDH='\033[22m'        # 字体：取消淡化
FDXT='\033[23m'        # 字体：取消斜体
FDXH='\033[24m'        # 字体：取消下划线
FDSS='\033[25m'        # 字体：取消闪烁
FDFX='\033[27m'        # 字体：取消反显
FDYC='\033[28m'        # 字体：取消隐藏
FDHD='\033[29m'        # 字体：取消划掉


## 报错退出
function output_error() {
    [ "$1" ] && echo -e "\n$ERROR $1\n"
    exit 1
}

## 权限判定
function permission_judgment() {
    if [ $UID -ne 0 ]; then
        output_error "权限不足，无法设置qiq快捷命令，请使用 Root 用户运行本脚本"
    fi
}

# 设置脚本的快捷命令为 `qiq`
function set_qiq_alias() {
    local is_set=${1:-0}
    if [ $UID -ne 0 ]; then
        echo -e "\n$WARN 权限不足，请使用 Root 用户运行本脚本 \n"
    else
        if command -v qiq &>/dev/null; then
            echo -e "\n $WARN qiq快捷命令已设置: $(whereis qiq) \n"
            if [[ $is_set -eq 1 ]]; then
                local CHOICE=$(echo -e "\n${BOLD}└─ 是否更新快捷命令？[Y/n]: ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                [[ -z "$INPUT" ]] &&  INPUT="Y"
                if [[ $INPUT == [Yy] || $INPUT == [Yy][Ee][Ss] ]]; then
                    sudo rm -f /usr/local/bin/qiq
                    sudo ln -sf ${PWD}/qiq.sh /usr/local/bin/qiq
                fi
            fi
        else
            echo -e "\n $WARN qiq 快捷命令未设置 ... \n"
            sudo ln -sf ${PWD}/qiq.sh /usr/local/bin/qiq
        fi
    fi
}
function del_qiq_alias(){
    if [ $UID -ne 0 ]; then
        echo -e "\n$WARN 权限不足，请使用 Root 用户运行本脚本 \n"
    else
        if command -v qiq &>/dev/null; then
            rm -f /usr/local/bin/qiq
            echo -e "\n $WARN qiq 快捷命令已删除 ... \n"
        else
            echo -e "\n $WARN qiq 快捷命令未设置 ... \n"
        fi
    fi
}

# 定义颜色渐变函数，返回带颜色的字符串
function gradient_text() {
  local text=$1
  local gradient=("${!2}") # 获取颜色渐变数组
  local length=${#text}
  local result=""

  for ((i = 0; i < length; i++)); do
    char=${text:i:1}
    color_code=${gradient[$((i % ${#gradient[@]}))]}
    result+=$(echo -en "\033[38;5;${color_code}m${char}\033[0m")
  done

  echo "$result"
}


function init_global_vars(){
    _REGION='Unknown' # 机器所在国家的区域代码
    blue_green_gradient=("118" "154" "82" "34" "36" "46" ) # 蓝色到绿色的渐变颜色代码
    CONSTSTR='QiQ Tools'
    CONSTSTR=$(gradient_text "${CONSTSTR}" blue_green_gradient[@])

    NUM_SPLIT=${NUM_SPLIT:-4}           # 左右栏的宽度间隔
    NUM_WIDTH=${NUM_WIDTH:-3}           # 序号最大宽度
    MAX_COL_NUM=${MAX_COL_NUM:-24}      # 单栏字符串最大宽度，默认为24
    ITEM_CAT_CHAR=${ITEM_CAT_CHAR:-'.'} # 序号与字符连接字符，默认为 '.'

    MAX_SPLIT_CHAR_NUM=${MAX_SPLIT_CHAR_NUM:-35} # 最大分割字符数量，默认为35
}


## 定义系统判定变量
SYSTEM_DEBIAN="Debian"
SYSTEM_UBUNTU="Ubuntu"
SYSTEM_KALI="Kali"
SYSTEM_DEEPIN="Deepin"
SYSTEM_LINUX_MINT="Linuxmint"
SYSTEM_ZORIN="Zorin"
SYSTEM_REDHAT="RedHat"
SYSTEM_RHEL="Red Hat Enterprise Linux"
SYSTEM_CENTOS="CentOS"
SYSTEM_CENTOS_STREAM="CentOS Stream"
SYSTEM_ROCKY="Rocky"
SYSTEM_ALMALINUX="AlmaLinux"
SYSTEM_FEDORA="Fedora"
SYSTEM_OPENCLOUDOS="OpenCloudOS"
SYSTEM_OPENCLOUDOS_STREAM="OpenCloudOS Stream"
SYSTEM_OPENEULER="openEuler"
SYSTEM_ANOLISOS="Anolis"
SYSTEM_OPENKYLIN="openKylin"
SYSTEM_OPENSUSE="openSUSE"
SYSTEM_ARCH="Arch"
SYSTEM_ALPINE="Alpine"
SYSTEM_GENTOO="Gentoo"
SYSTEM_NIXOS="NixOS"

## 定义系统版本文件
File_LinuxRelease=/etc/os-release
File_RedHatRelease=/etc/redhat-release
File_DebianVersion=/etc/debian_version
File_ArmbianRelease=/etc/armbian-release
File_openEulerRelease=/etc/openEuler-release
File_OpenCloudOSRelease=/etc/opencloudos-release
File_AnolisOSRelease=/etc/anolis-release
File_OracleLinuxRelease=/etc/oracle-release
File_ArchLinuxRelease=/etc/arch-release
File_AlpineRelease=/etc/alpine-release
File_GentooRelease=/etc/gentoo-release
File_openKylinVersion=/etc/kylin-version/kylin-system-version.conf
File_ProxmoxVersion=/etc/pve/.version



## 收集系统信息
function collect_system_info() {
    ## 定义系统名称
    SYSTEM_NAME="$(cat $File_LinuxRelease | grep -E "^NAME=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    grep -q "PRETTY_NAME=" $File_LinuxRelease && SYSTEM_PRETTY_NAME="$(cat $File_LinuxRelease | grep -E "^PRETTY_NAME=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    ## 定义系统版本号
    SYSTEM_VERSION_NUMBER="$(cat $File_LinuxRelease | grep -E "^VERSION_ID=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    SYSTEM_VERSION_NUMBER_MAJOR="${SYSTEM_VERSION_NUMBER%.*}"
    SYSTEM_VERSION_NUMBER_MINOR="${SYSTEM_VERSION_NUMBER#*.}"
    ## 定义系统ID
    SYSTEM_ID="$(cat $File_LinuxRelease | grep -E "^ID=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    ## 判定当前系统派系
    if [ -s $File_DebianVersion ]; then
        SYSTEM_FACTIONS="${SYSTEM_DEBIAN}"
    elif [ -s $File_OracleLinuxRelease ]; then
        # output_error "当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
        echo -e "$ERROR 当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
    elif [ -s $File_RedHatRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_REDHAT}"
    elif [ -s $File_openEulerRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_OPENEULER}"
    elif [ -s $File_OpenCloudOSRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_OPENCLOUDOS}" # 自 9.0 版本起不再基于红帽
    elif [ -s $File_AnolisOSRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_ANOLISOS}" # 自 8.8 版本起不再基于红帽
    elif [ -s $File_openKylinVersion ]; then
        SYSTEM_FACTIONS="${SYSTEM_OPENKYLIN}"
    elif [ -f $File_ArchLinuxRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_ARCH}"
    elif [ -f $File_AlpineRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_ALPINE}"
    elif [ -f $File_GentooRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_GENTOO}"
    elif [[ "${SYSTEM_NAME}" == *"openSUSE"* ]]; then
        SYSTEM_FACTIONS="${SYSTEM_OPENSUSE}"
    elif [[ "${SYSTEM_NAME}" == *"NixOS"* ]]; then
        SYSTEM_FACTIONS="${SYSTEM_NIXOS}"
    else
        # output_error "当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
        echo -e "$ERROR 当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
    fi
    ## 判定系统类型、版本、版本号
    case "${SYSTEM_FACTIONS}" in
    "${SYSTEM_DEBIAN}" | "${SYSTEM_OPENKYLIN}")
        local os_info=$(lsb_release -ds 2>/dev/null)
            
        if [ -z "$os_info" ]; then
            # 检查常见的发行文件
            if [ -f "/etc/os-release" ]; then
                os_info=$(source /etc/os-release && echo "$PRETTY_NAME")
            elif [ -f "/etc/debian_version" ]; then
                os_info="Debian $(cat /etc/debian_version)"
            elif [ -f "/etc/redhat-release" ]; then
                os_info=$(cat /etc/redhat-release)
            else
                os_info="Unknown"
            fi
            SYSTEM_JUDGMENT="${os_info}"
            SYSTEM_VERSION_CODENAME="${os_info}"
        else
            SYSTEM_JUDGMENT="$(lsb_release -is)"
            SYSTEM_VERSION_CODENAME="${DEBIAN_CODENAME:-"$(lsb_release -cs)"}"
        fi
        # if [ ! -x /usr/bin/lsb_release ]; then
        #     apt-get install -y lsb-release
        #     if [ $? -ne 0 ]; then
        #         # output_error "lsb-release 软件包安装失败\n\n本脚本依赖 lsb_release 指令判断系统具体类型和版本，当前系统可能为精简安装，请自行安装后重新执行脚本！"
        #         echo -e "$ERROR lsb-release 软件包安装失败\n\n本脚本依赖 lsb_release 指令判断系统具体类型和版本，当前系统可能为精简安装，请自行安装后重新执行脚本！"
        #     fi
        # fi
        ;;
    "${SYSTEM_REDHAT}")
        SYSTEM_JUDGMENT="$(awk '{printf $1}' $File_RedHatRelease)"
        ## 特殊系统判断
        # Red Hat Enterprise Linux
        grep -q "${SYSTEM_RHEL}" $File_RedHatRelease && SYSTEM_JUDGMENT="${SYSTEM_RHEL}"
        # CentOS Stream
        grep -q "${SYSTEM_CENTOS_STREAM}" $File_RedHatRelease && SYSTEM_JUDGMENT="${SYSTEM_CENTOS_STREAM}"
        ;;
    *)
        SYSTEM_JUDGMENT="${SYSTEM_FACTIONS}"
        ;;
    esac
    ## 判断系统及版本是否适配
    local is_supported="true"
    case "${SYSTEM_JUDGMENT}" in
    "${SYSTEM_DEBIAN}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" -lt 8 || "${SYSTEM_VERSION_NUMBER_MAJOR}" -gt 13 ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_UBUNTU}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" -lt 14 || "${SYSTEM_VERSION_NUMBER_MAJOR}" -gt 24 ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_LINUX_MINT}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != 19 && "${SYSTEM_VERSION_NUMBER_MAJOR}" != 2[0-2] && "${SYSTEM_VERSION_NUMBER_MAJOR}" != 6 ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_RHEL}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != [7-9] ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_CENTOS}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != [7-8] ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_CENTOS_STREAM}" | "${SYSTEM_ROCKY}" | "${SYSTEM_ALMALINUX}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != [8-9] ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_FEDORA}")
        if [[ "${SYSTEM_VERSION_NUMBER}" != [3-4][0-9] ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_OPENEULER}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != 2[1-4] ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_OPENCLOUDOS}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != [8-9] && "${SYSTEM_VERSION_NUMBER_MAJOR}" != 23 ]] || [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" == 8 && "$SYSTEM_VERSION_NUMBER_MINOR" -lt 6 ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_ANOLISOS}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != 8 && "${SYSTEM_VERSION_NUMBER_MAJOR}" != 23 ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_OPENSUSE}")
        case "${SYSTEM_ID}" in
        "opensuse-leap")
            if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != 15 ]]; then
                is_supported="false"
            fi
            ;;
        "opensuse-tumbleweed") ;;
        *)
            is_supported="false"
            ;;
        esac
        ;;
    "${SYSTEM_KALI}" | "${SYSTEM_DEEPIN}" | "${SYSTEM_ZORIN}" | "${SYSTEM_ARCH}" | "${SYSTEM_ALPINE}" | "${SYSTEM_GENTOO}" | "${SYSTEM_OPENKYLIN}" | "${SYSTEM_NIXOS}")
        # 理论全部支持或不作判断
        ;;
    *)
        # output_error "当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
        echo -e "$ERROR 当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
        ;;
    esac
    if [[ "${is_supported}" == "false" ]]; then
        # output_error "当前系统版本不在本脚本的支持范围内，请前往官网查看支持列表！"
        echo -e "$ERROR 当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
    fi
    ## 判定系统处理器架构
    case "$(uname -m)" in
    x86_64)
        DEVICE_ARCH="x86_64"
        ;;
    aarch64)
        DEVICE_ARCH="ARM64"
        ;;
    armv7l)
        DEVICE_ARCH="ARMv7"
        ;;
    armv6l)
        DEVICE_ARCH="ARMv6"
        ;;
    i686)
        DEVICE_ARCH="x86_32"
        ;;
    *)
        DEVICE_ARCH="$(uname -m)"
        ;;
    esac
    ## 定义软件源仓库名称
    if [[ -z "${SOURCE_BRANCH}" ]]; then
        ## 默认为系统名称小写，替换空格
        SOURCE_BRANCH="${SYSTEM_JUDGMENT,,}"
        SOURCE_BRANCH="${SOURCE_BRANCH// /-}"
        ## 处理特殊的仓库名称
        case "${SYSTEM_JUDGMENT}" in
        "${SYSTEM_DEBIAN}")
            case "${SYSTEM_VERSION_NUMBER_MAJOR}" in
            8 | 9 | 10)
                SOURCE_BRANCH="debian-archive" # EOF
                ;;
            *)
                SOURCE_BRANCH="debian"
                ;;
            esac
            ;;
        "${SYSTEM_UBUNTU}" | "${SYSTEM_ZORIN}")
            if [[ "${DEVICE_ARCH}" == "x86_64" || "${DEVICE_ARCH}" == *i?86* ]]; then
                SOURCE_BRANCH="ubuntu"
            else
                SOURCE_BRANCH="ubuntu-ports"
            fi
            ;;
        "${SYSTEM_RHEL}")
            case "${SYSTEM_VERSION_NUMBER_MAJOR}" in
            9)
                SOURCE_BRANCH="centos-stream" # 使用 CentOS Stream 仓库
                ;;
            *)
                SOURCE_BRANCH="centos-vault" # EOF
                ;;
            esac
            ;;
        "${SYSTEM_CENTOS}")
            if [[ "${DEVICE_ARCH}" == "x86_64" ]]; then
                SOURCE_BRANCH="centos-vault" # EOF
            else
                SOURCE_BRANCH="centos-altarch"
            fi
            ;;
        "${SYSTEM_CENTOS_STREAM}")
            # 自 CentOS Stream 9 开始使用 centos-stream 仓库，旧版本使用 centos 仓库
            case "${SYSTEM_VERSION_NUMBER_MAJOR}" in
            8)
                if [[ "${DEVICE_ARCH}" == "x86_64" ]]; then
                    SOURCE_BRANCH="centos-vault" # EOF
                else
                    SOURCE_BRANCH="centos-altarch"
                fi
                ;;
            *)
                SOURCE_BRANCH="centos-stream"
                ;;
            esac
            ;;
        "${SYSTEM_FEDORA}")
            if [[ "${SYSTEM_VERSION_NUMBER}" -lt 39 ]]; then
                SOURCE_BRANCH="fedora-archive"
            fi
            ;;
        "${SYSTEM_ARCH}")
            if [[ "${DEVICE_ARCH}" == "x86_64" || "${DEVICE_ARCH}" == *i?86* ]]; then
                SOURCE_BRANCH="archlinux"
            else
                SOURCE_BRANCH="archlinuxarm"
            fi
            ;;
        "${SYSTEM_OPENCLOUDOS}")
            # OpenCloudOS Stream
            grep -q "${SYSTEM_OPENCLOUDOS_STREAM}" $File_OpenCloudOSRelease
            if [ $? -eq 0 ]; then
                SOURCE_BRANCH="${SYSTEM_OPENCLOUDOS_STREAM,,}"
                SOURCE_BRANCH="${SOURCE_BRANCH// /-}"
            fi
            ;;
        "${SYSTEM_NIXOS}")
            SOURCE_BRANCH="nix-channels"
            ;;
        esac
    fi
    ## 定义软件源更新文字
    case "${SYSTEM_FACTIONS}" in
    "${SYSTEM_DEBIAN}" | "${SYSTEM_ALPINE}" | "${SYSTEM_OPENKYLIN}")
        SYNC_MIRROR_TEXT="更新软件源"
        ;;
    "${SYSTEM_REDHAT}" | "${SYSTEM_OPENEULER}" | "${SYSTEM_OPENCLOUDOS}" | "${SYSTEM_ANOLISOS}")
        SYNC_MIRROR_TEXT="生成软件源缓存"
        ;;
    "${SYSTEM_OPENSUSE}")
        SYNC_MIRROR_TEXT="刷新软件源"
        ;;
    "${SYSTEM_ARCH}" | "${SYSTEM_GENTOO}")
        SYNC_MIRROR_TEXT="同步软件源"
        ;;
    "${SYSTEM_NIXOS}")
        SYNC_MIRROR_TEXT="更新二进制缓存与频道源"
        ;;
    esac
    ## 判断是否可以使用高级交互式选择器
    CAN_USE_ADVANCED_INTERACTIVE_SELECTION="false"
    if [ ! -z "$(command -v tput)" ]; then
        CAN_USE_ADVANCED_INTERACTIVE_SELECTION="true"
    fi
}



## 计算输入字符串字符数量，检测中文字符和Emoji字符
function str_width_awk() {
    echo -n "$1" | awk '{
        len=0
        for (i=1; i<=length($0); i++) {
            c=substr($0, i, 1)
            if (c ~ /[一-龥]/) { len+=2 }  # 处理中文全角字符
            else if (c ~ /[\x{1F600}-\x{1F64F}]/) { len+=2 }  # 处理Emoji
            else { len+=1 }
        }
        print len
    }'
}


function get_split_list() {
    local items=("${@}")
    local result=()
    # local length=0
    
    for i in "${!items[@]}"; do
        # length=${#items[i]}
        if [[ ! "${items[i]}" =~ ^[0-9] ]]; then  # 只要不是数字开头的项，就作为分割线
            result+=("$i")  # 记录分隔符的位置索引
        fi
    done
    
    echo "${result[@]}"  # 输出所有分割线的位置索引
}

# 生成重复字符的分割行，并应用颜色
function generate_separator() {
    local separator_info="$1"
    local count=${2:-$MAX_SPLIT_CHAR_NUM}
    
    # 解析分割符和颜色
    IFS='|' read -r separator color <<< "$separator_info"
    
    # 颜色默认值（如果未提供颜色）
    color=${color:-$RESET}
    
    local first_char="${separator:0:1}"  # 取分割符的第一个字符
    
    # 颜色化输出分割线
    echo -e "${color}$(printf "%0.s$first_char" $(seq 1 "$count"))${RESET}"
}

function fill_array() {
    local -n arr=$1  # 使用命名引用传递数组
    local num=${2:-5}  # 默认填充5个空字符串
    local length=${#arr[@]}
    
    if (( length < num )); then
        for ((i=length; i<length+length; i++)); do
            arr[i]=""
        done
    fi
}

## 菜单项按1栏显示
function print_sub_items_1() {
    # local items=("${@}")
    local items=("${!1}")  # 传入数组
    # local ncol=${2:-$MAX_COL_NUM} # 

    local total_items=${#items[@]}
    for ((i=0; i<total_items; i++)); do
        local left_item=${items[i]}

        # 解析左栏
        IFS='|' read -r nn txt cc <<< "$left_item"
        cc=${cc:-$RESET}  # 默认颜色
        local txt_fmt="${cc}${ITEM_CAT_CHAR}${txt}${RESET}"

        printf "%${NUM_WIDTH}d%-b\n" $nn "$txt_fmt"
        # printf "%${NUM_WIDTH}d%-${ncol}b\n" $nn "$l_formatted"
    done
}

## 菜单项按2栏显示
function print_sub_items_2() {
    # local items=("${@}")
    local items=("${!1}")  # 传入数组
    local ncol=${2:-$MAX_COL_NUM} # 

    local total_items=${#items[@]}
    local half=$(( (total_items + 1) / 2 ))  # 计算左右分栏

    for ((i=0; i<half; i++)); do
        local left_item=${items[i]}
        local right_index=$((i + half))
        local right_item=${items[right_index]:-}  # 可能为空

        # 解析左栏
        IFS='|' read -r l_num l_text l_color <<< "$left_item"
        l_color=${l_color:-$RESET}  # 默认颜色
        local l_formatted="${l_color}${ITEM_CAT_CHAR}$l_text$RESET"
        # 计算中文字符数量
        chinese_left=$(echo -n "$l_formatted" | grep -oP '[\p{Han}]' | wc -l)
        # 计算Emoji数量
        emoji_count=$(echo -n "$l_formatted" | grep -oP "[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}]" | wc -l)
        adj_left_width=$((ncol + chinese_left + emoji_count))

        # adj_split_num=$((NUM_SPLIT - chinese_left - emoji_count ))
        if [[ $adj_split_num -lt 0 ]]; then 
            adj_split_num=0
        fi 

        # 解析右栏（如果有的话）
        if [ -n "$right_item" ]; then
            IFS='|' read -r r_num r_text r_color <<< "$right_item"
            r_color=${r_color:-$RESET}  # 默认颜色
            local r_formatted="${r_color}${ITEM_CAT_CHAR}$r_text$RESET"
            printf "%${NUM_WIDTH}d%-${adj_left_width}b%${adj_split_num}s%${NUM_WIDTH}d%-${ncol}b\n" \
                    $l_num "$l_formatted" "" $r_num "$r_formatted"
        else
            local r_formatted=""
            printf "%${NUM_WIDTH}d%-${adj_left_width}b\n" $l_num "$l_formatted"
        fi
    done
}


## 输出数组列表
function print_items_list(){
    local items=("${!1}")  # 传入数组
    local head="$2"
    # local tagd="${3:-${PRIGHT}}"
    # clear 
    [[ -n ${head} ]] && echo -e "\n${BOLD}${head}: \n${PLAIN}"
    for option in "${items[@]}"; do
        IFS='|' read -r l_text l_color tag <<< "$option"
        l_color=${l_color:-$RESET}   # 默认颜色
        tag=${tag:-$_TAG_DEFAULT}    # 默认标识符
        echo -e "${tag} ${l_color}${l_text}${RESET}"
    done
}

# 根据分割位置拆分数组，并用 n 个分割符号替换原始分割线
function split_menu_items() {
    local items=("${!1}")                     # 传入数组
    local is2check=${2:-1}                    # 是否检测元数个数: 当元素个数小于5时单栏显示，否则双栏显示
    local ncol=${3:-$MAX_COL_NUM}             # 双栏最大宽度, 
    local nmin_items=${4:-5}                  # 双栏最小元素
    # local nsp=${4:-$MAX_SPLIT_CHAR_NUM}       # 分割符宽度, 

    local nsp=$(( $ncol * 1 + $NUM_SPLIT * 3 ))
    # nsp=$(( $ncol * 2 + $NUM_SPLIT ))
    local split_indices=($(get_split_list "${items[@]}"))

    local sub_list=()
    local start=0

    for split in "${split_indices[@]}"; do
        # 取出当前子列表
        sub_list=("${items[@]:start:split-start}")
        local length=${#sub_list[@]}
        if [[ ${is2check} -eq 1 && length -lt ${nmin_items} ]] ; then
          # print_items_list sub_list[@] '' ''
          print_sub_items_1 sub_list[@]
        else 
          # print_sub_items "${sub_list[@]}"
          print_sub_items_2 sub_list[@] $ncol
        fi 
        
        # 生成新的分割行
        generate_separator "${items[split]}" "$nsp"
        
        start=$((split + 1))
    done

    # 处理最后一部分（如果还有剩余项）
    if [[ $start -lt ${#items[@]} ]]; then
        sub_list=("${items[@]:start}")
        local length=${#sub_list[@]}
        if [[ ${is2check} -eq 1 && length -lt ${nmin_items} ]] ; then
          # print_items_list sub_list[@] '' ''
          print_sub_items_1 sub_list[@]
        else 
          print_sub_items_2 sub_list[@] $ncol
        fi 
    fi
}


function check_ip_command() {
    if ! command -v ip &> /dev/null; then
        echo -e "$WARN 'ip' command not found. Attempting to install iproute2 package...\n"

        if command -v apt-get &> /dev/null; then
            # Debian/Ubuntu
            sudo apt-get update
            sudo apt-get install -y iproute2
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL
            sudo yum install -y iproute
        elif command -v dnf &> /dev/null; then
            # Fedora
            sudo dnf install -y iproute
        else
            echo -e "$ERROR Could not determine package manager. Please install iproute2 manually.\n"
            exit 1
        fi

        if ! command -v ip &> /dev/null; then
            echo -e "$ERROR Failed to install 'ip' command. Please install iproute2 manually.\n"
            exit 1
        else
            echo -e "$SUCCESS 'ip' command installed successfully.\n"
        fi
    fi
}

function check_ip_support() {
    # 检查IPv4支持
    if ip -4 addr show | grep -q "inet "; then
        export IPV4_SUPPORTED=1
    else
        export IPV4_SUPPORTED=0
    fi

    # 检查IPv6支持
    if ip -6 addr show | grep -q "inet6 "; then
        export IPV6_SUPPORTED=1
    else
        export IPV6_SUPPORTED=0
    fi
}

function check_warp_status() {
  local ip_version=$1

  if [[ "$ip_version" -ne 4 && "$ip_version" -ne 6 ]]; then
    echo -e "\n$WARN Invalid IP version. Please use 4 or 6!"
    return 1
  fi

  if [[ IPV${ip_version}_SUPPORTED -eq 0 ]]; then
    echo -e "$WARN IPv${ip_version} is not supported!"
    return 1
  fi 

  echo -e " $WORKING Check warp status for IPv${ip_version} ..."

  url="https://www.cloudflare.com/cdn-cgi/trace"
  response=$(curl -${ip_version} -sS --retry 2 --max-time 1 "$url")

  if [[ -z "$response" ]]; then
    echo -e "${WARN}  Failed to check warp for IPv${ip_version} from cloudflare.com \n"
    return 1
  fi

  local location_ip=$( echo -e "$response" | grep "loc="  | awk -F= '{print $2}')
  local warp_status=$( echo -e "$response"  | grep "warp=" | awk -F= '{print $2}')

  [[ -n "$location_ip" ]] && export WARP_LOC${ip_version}=${location_ip}

  # 设置全局变量
  if [[ "$warp_status" =~ ^on$ ]] ; then 
    # export WARP${ip_version}=$(echo -e "${location_ip}, ${RED}Warp${PLAIN}")
    export WARPSTATUS${ip_version}=1
  else 
    # export WARP${ip_version}=$(echo -e ${location_ip})
    export WARPSTATUS${ip_version}=0
  fi 
}

function get_region(){
    local country=$(curl -s --connect-timeout 1 --max-time 3 ipinfo.io/country)
    if [[ -n "$country" ]] ; then
        # echo -e "\n $SUCCESS ${GREEN}Get location region: ${RED}$country ${PLAIN}\n"
        _REGION=$country
    else 
        country="Unknown"
    fi
    echo "$country"
}

function check_ip_china() {
    local country=$(curl -s --connect-timeout 1 --max-time 3 ipinfo.io/country)
    [[ -n "$country" ]] && _REGION=$country
    if [ "$country" = "CN" ]; then
        _IS_CN=1
    else
        _IS_CN=0
    fi
}

## 判断IP所在地，给url设置代理 
function get_proxy_url() {
    local url="$1"
    local region=${2:-${_REGION}} 
    [ "$region" = 'Unknown' ] && region="$(get_region )"
    # check_ip_china
    # [[ $_IS_CN -eq 1 ]] && url="${URL_PROXY}${url}"
    [ "$region" = 'CN' ] && url="${URL_PROXY}${url}"
    echo "$url"
}

## 下载脚本并修改可执行权限 
function fetch_script_from_url() { 
    local url="$1"
    local file="$2"
    local is_proxy=${3:-1}
    local extra_par=$4

    [[ $is_proxy -eq 1 ]] && url=$(get_proxy_url "$url")
    if command -v curl &>/dev/null; then 
        curl -L -o ${file} "${url}" && chmod +x ${file} && bash ${file} $extra_par
    elif command -v wget &>/dev/null; then 
        wget -O ${file} ${url} && chmod +x ${file} && bash ${file} $extra_par
    else
        _BREAK_INFO=" 请先安装curl或wget!"
    fi
}

## 下载文件 
function download_file_url() {     
    local url="$1"
    local file="$2"
    local path="${3:-${PWD}}"
    local is_proxy=${3:-1}

    # 创建文件夹 
    [[ ! -d ${path} ]] && mkdir -p ${path} 

    [[ $is_proxy -eq 1 ]] && url=$(get_proxy_url "$url") 
    if command -v curl &>/dev/null; then 
        curl -sSL -o ${path}/${file} "${url}" 
    elif command -v wget &>/dev/null; then 
        wget -qO ${path}/${file} ${url} 
    else
        _BREAK_INFO=" 请先安装curl或wget!"
    fi
}

function download_github_realease() {
    # local app_name="$2"
    local REPO_URL="$1"
    local fpattern="$2"
    local is_proxy=${3:-1}
    local path="${4:-${PWD}}"

    # 获取系统架构和类型
    local ARCH=$(uname -m)
    local SYSTEM=$(uname -s | tr '[:upper:]' '[:lower:]')
    # 将架构转换为 frp 的命名格式
    case "$ARCH" in
        x86_64)    local FRP_ARCH="amd64" ;;
        i386|i686) local FRP_ARCH="386"   ;;
        aarch64)   local FRP_ARCH="arm64" ;;
        armv7l)    local FRP_ARCH="armv7" ;;
        *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
    esac

    # 获取最新发布的下载链接
    local OWNER_REPO=$(echo "$REPO_URL" | sed 's|https://github.com/||; s|[/ ]*$||')
    local OWNER=$(echo "$OWNER_REPO" | cut -d '/' -f1)
    local REPO=$(echo "$OWNER_REPO" | cut -d '/' -f2)

    # 构建GitHub API请求链接
    local RELEASE_API="https://api.github.com/repos/${OWNER}/${REPO}/releases/latest"
    [[ $is_proxy -eq 1 ]] && RELEASE_API=$(get_proxy_url "$RELEASE_API") 

    RELEASE_INFO=$(curl -sL $RELEASE_API)
    local ASSETS=$(echo "$RELEASE_INFO" | jq -r '.assets[].browser_download_url')
    
    # 匹配符合系统架构的文件
    if [[ -n "$fpattern" ]] ; then 
        echo -e "$TIP use pattern: $fpattern"
        local DOWNLOAD_URL=$(echo "$ASSETS" | grep -E "$fpattern" | head -n1)
    else
        local DOWNLOAD_URL=$(echo "$ASSETS" | grep -E ".*${SYSTEM}_.*${FRP_ARCH}\.tar\.gz$" | head -n1)
    fi

    # 检查依赖工具
    command -v curl >/dev/null 2>&1 || { echo "Error: curl 未安装"; app_install curl ; }
    command -v jq >/dev/null   2>&1 || { echo "Error: jq 未安装"; app_install jq ; }

    # 创建文件夹 
    [[ ! -d ${path} ]] && mkdir -p ${path} 
    if [ -z "$DOWNLOAD_URL" ]; then
        echo "No matching release found for $SYSTEM $FRP_ARCH."
        return 1
    else
        echo -e "$PRIGHT ${GREEN}File url: $DOWNLOAD_URL ${RESET}"
    fi
    [[ $is_proxy -eq 1 ]] && DOWNLOAD_URL=$(get_proxy_url "$DOWNLOAD_URL") 
    
    # 下载并解压文件
    local FILENAME=$(basename "$DOWNLOAD_URL")
    echo -e "$PRIGHT Downloading $FILENAME ..."
    curl -LO "$DOWNLOAD_URL" || { echo "Download failed";  return 1; }
    # echo -e "$PRIGHT  Extracting $FILENAME ..."
    # tar -zxf "$FILENAME"     || { echo "Extraction failed"; return 1; }

    echo -e "$SUCCESS Success! File Download: ${FILENAME%.tar.gz}"
}

function print_warp_ip_info() {
    local ip_version=$1
    local result=""

    if [ "$ip_version" -eq 4 ]; then
        local result="${GREEN}IPv4${PLAIN}: $WAN4 ${PURPLE}$WARP_LOC4${PLAIN}"
    elif [ "$ip_version" -eq 6 ]; then
        local result="${GREEN}IPv6${PLAIN}: $WAN6 ${PURPLE}$WARP_LOC6${PLAIN}"
    else
        echo -e " $WARN Invalid ip version. Please enter 4 or 6."
        return 1
    fi

    result=$(echo -en "${result}")
    [[ WARPSTATUS${ip_version} -eq 1 ]] && result+=$(echo -en ", ${RED}warp${PLAIN}")
    echo "$result"
}


function get_ip_info() {
    local ip_ver=$1

    if [[ "$ip_ver" -ne 4 && "$ip_ver" -ne 6 ]]; then
        echo -e "\n$WARN Invalid IP version. Please use 4 or 6!"
        return 1
    fi

    if [[ IPV${ip_ver}_SUPPORTED -eq 0 ]]; then
        echo -e "$WARN IPv${ip_ver} is not supported!"
        return 1
    fi 

    echo -e " $WORKING Check IPv${ip_ver} information ..."

    local url
    local response
    local loc_ip
    local loc_country
    local loc_asn  local loc_asn_org
    local ip_info

    url="https://ifconfig.co/json"
    response=$(curl -${ip_ver} -sS --retry 2 --max-time 1 "$url")

    if [[ -z "$response" ]]; then
        echo -e "${WARN}  Failed to fetch IPv${ip_ver} from ifconfig.co, try ip.sb ... \n"
        url="ip.sb"
        response=$(curl -${ip_ver} -sS --retry 2 --max-time 2 "$url")
        [[ -n "$response" ]] && export WAN${ip_ver}=$(printf "%s" ${response})
        return 1
    fi

    # loc_ip=$(echo "$response" | jq -r '.ip')
    # loc_country=$(echo "$response" | jq -r '.country')
    # loc_asn=$(echo "$response" | jq -r '.asn')
    # loc_asn_org=$(echo "$response" | jq -r '.asn_org')

    loc_ip=$(echo "$response" | grep -o '"ip": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')
    loc_asn=$(echo "$response" | grep -o '"asn": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')
    loc_asn_org=$(echo "$response" | grep -o '"asn_org": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')
    loc_country=$(echo "$response" | grep -o '"country": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')

    ip_info=$(echo -e "${loc_country}, ${loc_asn}, ${loc_asn_org}")

    # 设置全局变量
    [[ -n "$loc_ip" ]]      && export WAN${ip_ver}=$(printf "%s" ${loc_ip})
    [[ -n "$loc_country" ]] && export COUNTRY${ip_ver}=$loc_country
    [[ -n "$loc_asn_org" ]] && export ASNORG${ip_ver}=$loc_asn_org
    # [[ -n "$ip_info" ]]     && export IP_INFO${ip_ver}=$(printf "%s" ${ip_info})
    [[ -n "$ip_info" ]]     && export IP_INFO${ip_ver}=$loc_asn

}


function check_ip_status() {

    # 检查 'ip' 命令是否可用
    check_ip_command

    # 检查IPv4和IPv6支持
    check_ip_support

    # 示例调用
    if [[ $IPV4_SUPPORTED -eq 1 ]]; then
        get_ip_info 4
        check_warp_status 4
    else
        echo -e "$WARN IPv4 is not supported on this system.\n"
    fi

    if [[ $IPV6_SUPPORTED -eq 1 ]]; then
        get_ip_info 6
        check_warp_status 6
    else
        echo -e "$WARN IPv6 is not supported on this system.\n"
    fi
}

function print_menu_head() {
    local n=${1:-35}    # 传入分割符重复次数, 默认35
    echo ""
    local head=$(echo -e "${YELLOW}♧♧♧${PLAIN}  ${CONSTSTR} ${BLUE}${SRC_VER}${PLAIN}  ${YELLOW}♧♧♧${PLAIN}")
    printf "%2s%s\n${RESET}" "" "$head"
    generate_separator "~|$AZURE" "$n" # 另一个分割线    
    print_warp_ip_info 4
    print_warp_ip_info 6
    generate_separator "=|$YELLOW" "$n" # 另一个分割线
}

function print_sys_title() {
    local system_name="${SYSTEM_PRETTY_NAME:-"${SYSTEM_NAME} ${SYSTEM_VERSION_NUMBER}"}"
    local arch="${DEVICE_ARCH}"
    local date_time time_zone
    date_time="$(date "+%Y-%m-%d %H:%M")"
    time_zone="$(timedatectl status 2>/dev/null | grep "Time zone" | awk -F ':' '{print$2}' | awk -F ' ' '{print$1}')"

    echo -e "运行环境: ${BLUE}${system_name} ${arch}${PLAIN}"
    echo -e "系统时间: ${BLUE}${date_time} ${time_zone}${PLAIN}"
}

function print_sub_head() {
    local head="$1"
    local n=${2:-35}    # 传入分割符重复次数, 默认35
    local is_machine_info_show=${3:-0}
    local is_ip_info_show=${4:-1} 

    echo "" 
    printf "${BOLD}%1s%s\n${RESET}" "" "$head"
    generate_separator "=|$AZURE" "$n" # 另一个分割线
    
    if [[ $is_machine_info_show -eq 1 ]]; then
        collect_system_info
        print_sys_title
        generate_separator "~|$AZURE" "$n" # 另一个分割线
    fi

    if [[ $is_ip_info_show -eq 1 ]]; then
        print_warp_ip_info 4
        print_warp_ip_info 6
        generate_separator "=|$YELLOW" "$n" # 另一个分割线
    fi
}


## 输出菜单尾项 
function print_main_menu_tail() {
    local n=${1:-35}    # 传入分割符重复次数, 默认35

    generate_separator "=|$AZURE" "$n" # 另一个分割线
    emoji_count=1
    chinese_width=4
    # adj_width=$((MAX_COL_NUM + chinese_width + emoji_count + chinese_width + emoji_count))
    adj_width=$((MAX_COL_NUM + chinese_width + emoji_count))

    s_exit=${RED}'退出脚本'${RED}"✘"${RESET}
    s_restart=${WHITE}'重启系统'${BLUE}"☋"${RESET}
    printf "%${NUM_WIDTH}s.%-${adj_width}b%${NUM_SPLIT}s%${NUM_WIDTH}s.%-${MAX_COL_NUM}b\n${RESET}" \
            '0' $s_exit "" 'xx' $s_restart

    generate_separator "…" "$n"
    emoji_count=1
    chinese_width=4
    # adj_width=$((MAX_COL_NUM + chinese_width + emoji_count + chinese_width + emoji_count))
    adj_width=$((MAX_COL_NUM + chinese_width + emoji_count ))

    s_update=${GREEN}'脚本更新'${PURPLE}"ღ"${RESET}
    s_qiq=${BLUE}'✟✟'${ITEM_CAT_CHAR}${RESET}'快捷命令☽_'${YELLOW}"qiq"${BLUE}${RESET}"_☾"
    printf "%${NUM_WIDTH}s${ITEM_CAT_CHAR}%-${adj_width}b%${NUM_SPLIT}s%-${MAX_COL_NUM}b\n\n${RESET}" \
        '00' $s_update "" $s_qiq
}

## 输出子菜单尾项 
function print_sub_menu_tail() {
    local n=${1:-35}    # 传入分割符重复次数, 默认35

    generate_separator "=|$AZURE" "$n" # 另一个分割线
    emoji_count=1
    chinese_width=4
    # adj_width=$((MAX_COL_NUM + chinese_width + emoji_count + chinese_width + emoji_count))
    adj_width=$((MAX_COL_NUM + chinese_width + emoji_count))

    s_exit=${BLUE}'返回'${RED}"🔙"${RESET}
    s_restart=${BLUE}'重启系统'${RED}"☋"${RESET}
    printf "%${NUM_WIDTH}s.%-${adj_width}b%${NUM_SPLIT}s%${NUM_WIDTH}s.%-${MAX_COL_NUM}b\n\n${RESET}" \
            '0' $s_exit "" 'xx' $s_restart

}

function check_sys_virt() {
    if [ $(type -p systemd-detect-virt) ]; then
        VIRT=$(systemd-detect-virt)
    elif [ $(type -p hostnamectl) ]; then
        VIRT=$(hostnamectl | awk '/Virtualization/{print $NF}')
    elif [ $(type -p virt-what) ]; then
        VIRT=$(virt-what)
    fi
    VIRT=${VIRT^^} || VIRT="UNKNOWN"
}


## 显示系统基本信息 
function print_system_info() {    
    # collect_system_info 

    DEVICE_ARCH=$(uname -m)
    # 判断虚拟化
    check_sys_virt

    local hostname=$(hostname)
    local kernel_version=$(uname -r)

    local cpu_cores=$(nproc)
	local cpu_freq=$(cat /proc/cpuinfo | grep "MHz" | head -n 1 | awk '{printf "%.1fGHz\n", $4/1000}')
    if [ "$(uname -m)" == "x86_64" ]; then
      local cpu_info=$(cat /proc/cpuinfo | grep 'model name' | uniq | sed -e 's/model name[[:space:]]*: //')
    else
      local cpu_info=$(lscpu | grep 'BIOS Model name' | awk -F': ' '{print $2}' | sed 's/^[ \t]*//')
    fi
	local cpu_usage_percent=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf "%.0f\n", (($2+$4-u1) * 100 / (t-t1))}' \
		<(grep 'cpu ' /proc/stat) <(sleep 1; grep 'cpu ' /proc/stat))

    local os_info=$(lsb_release -ds 2>/dev/null)
    # 如果 lsb_release 命令失败，则尝试其他方法
    if [ -z "$os_info" ]; then
      # 检查常见的发行文件
      if [ -f "/etc/os-release" ]; then
        local os_info=$(source /etc/os-release && echo "$PRETTY_NAME")
      elif [ -f "/etc/debian_version" ]; then
        local os_info="Debian $(cat /etc/debian_version)"
      elif [ -f "/etc/redhat-release" ]; then
        local os_info=$(cat /etc/redhat-release)
      else
        local os_info="Unknown"
      fi
    fi
	local load=$(uptime | awk '{print $(NF-2), $(NF-1), $NF}')
    local mem_info=$(free -b | awk 'NR==2{printf "%.2f/%.2f MB (%.2f%%)", $3/1024/1024, $2/1024/1024, $3*100/$2}')
    local disk_info=$(df -h | awk '$NF=="/"{printf "%s/%s (%s)", $3, $2, $5}')
    
    local swap_used=$(free -m | awk 'NR==3{print $3}')
    local swap_total=$(free -m | awk 'NR==3{print $2}')    
    if [ "$swap_total" -eq 0 ]; then
        local swap_percentage=0
    else
        local swap_percentage=$((swap_used * 100 / swap_total))
    fi
    local swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

    clear 
	echo ""
	echo -e " ⚙️  系统信息 "
    generate_separator "↓|$FCYE" 40 # 割线
	echo -e "${FCQH}虚拟类型:  ${FCRE}$VIRT"
	echo -e "${FCYE}内核版本:  ${FCGR}$kernel_version"
	echo -e "${FCQH}系统版本:  ${FCTL}$os_info"
	echo -e "${FCQH}主机名称:  ${FCGR}$hostname"
    generate_separator "…|$AZURE" 40 # 割线
	echo -e "${FCQH}CPU架构:   ${FCTL}$DEVICE_ARCH"
	echo -e "${FCQH}CPU核数:   ${FCGR}$cpu_cores@${FCGR}$cpu_freq"
	echo -e "${FCQH}CPU型号:   ${FCTL}$cpu_info"
    generate_separator "…|$AZURE" 40 # 割线
	echo -e "${FCQH}CPU占用:   ${FCTL}$cpu_usage_percent%"
	echo -e "${FCQH}系统负载:  ${FCTL}$load"
	echo -e "${FCQH}硬盘占用:  ${FCTL}$disk_info"
	echo -e "${FCLS}物理内存:  ${FCTL}$mem_info"
	echo -e "${FCYE}虚拟内存:  ${FCGR}$swap_info"
    generate_separator "…|$FCYE" 40 # 割线
	echo -e "${FCQH}运营商家:  ${FCTL}$ASNORG4"

    if [[ $IPV4_SUPPORTED -eq 1 ]]; then
		echo -e "${FCHD}IPv4地址:  ${FCGR}$WAN4"
        [[ -n "$WAN4" ]] && echo -e "${FCQH}地理位置:  ${BLUE}$COUNTRY4,$IP_INFO4,$ASNORG4"
    else
		echo -e "${FCHD}IPv4地址:  ${FCGR} Not Supported "
	fi

    if [[ $IPV6_SUPPORTED -eq 1 ]]; then
		echo -e "${FCHD}IPv6地址:  ${FCGR}$WAN6"
        [[ -n "$WAN6" ]] && echo -e "${FCQH}地理位置:  ${BLUE}$COUNTRY6,$IP_INFO6,$ASNORG6"
    else
		echo -e "${FCHD}IPv6地址:  ${FCGR} Not Supported "
	fi

    generate_separator "~|$AZURE" 40 # 割线
	local dns_addresses=$(awk '/^nameserver/{printf "%s, ", $2} END {print ""}' /etc/resolv.conf)
	local congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
	local queue_algorithm=$(sysctl -n net.core.default_qdisc)
	echo -e "${FCQH}DNS地址:  ${BLUE}$dns_addresses"
	echo -e "${FCHD}网络算法:  ${FCRE}$congestion_algorithm $queue_algorithm"

    generate_separator "…|$AZURE" 40 # 割线
    local date_time="$(date "+%Y-%m-%d %H:%M")"
    local time_zone="$(timedatectl status 2>/dev/null | grep "Time zone" | awk -F ':' '{print$2}' | awk -F ' ' '{print$1}')"
    local runtime=$(cat /proc/uptime | awk -F. '{run_days=int($1 / 86400);run_hours=int(($1 % 86400) / 3600);run_minutes=int(($1 % 3600) / 60); if (run_days > 0) printf("%d天 ", run_days); if (run_hours > 0) printf("%d时 ", run_hours); printf("%d分\n", run_minutes)}')
	echo -e "${FCQH}运行时长:  ${FCTL}$runtime"
	echo -e "${FCQH}系统时间:  ${FCTL}$date_time ${FCZS}$time_zone "
    generate_separator "↑|$FCYE" 40 # 割线

    _BREAK_INFO=" 系统信息获取完成"
    _IS_BREAK="true"
}



function interactive_select_mirror() {
    _SELECT_RESULT=""
    local options=("$@")
    local message="${options[${#options[@]} - 1]}"
    unset options[${#options[@]}-1]
    local selected=0
    local start=0
    local page_size=$(($(tput lines) - 3)) # 减去1行用于显示提示信息
    function clear_menu() {
        tput rc
        for ((i = 0; i < ${#options[@]} + 1; i++)); do
            echo -e "\r\033[K"
        done
        tput rc
    }
    function cleanup() {
        clear_menu
        tput rc
        tput cnorm
        tput rmcup
        exit
    }
    function draw_menu() {
        tput clear
        tput cup 0 0
        echo -e "${message}"
        local end=$((start + page_size - 1))
        if [ $end -ge ${#options[@]} ]; then
            end=${#options[@]}-1
        fi
        for ((i = start; i <= end; i++)); do
            if [ "$i" -eq "$selected" ]; then
                echo -e "\033[34;4m➤ ${options[$i]%@*}\033[0m"
            else
                echo -e "  ${options[$i]%@*}"
            fi
        done
    }
    function read_key() {
        IFS= read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            IFS= read -rsn2 key
            key="$key"
        fi
        echo "$key"
    }
    tput smcup              # 保存当前屏幕并切换到新屏幕
    tput sc                 # 保存光标位置
    tput civis              # 隐藏光标
    trap "cleanup" INT TERM # 捕捉脚本结束时恢复光标
    draw_menu               # 初始化菜单位置
    # 处理选择
    while true; do
        key=$(read_key)
        case "$key" in
        "[A" | "w" | "W")
            # 上箭头 / W
            if [ "$selected" -gt 0 ]; then
                selected=$((selected - 1))
                if [ "$selected" -lt "$start" ]; then
                    start=$((start - 1))
                fi
            fi
            ;;
        "[B" | "s" | "S")
            # 下箭头 / S
            if [ "$selected" -lt $((${#options[@]} - 1)) ]; then
                selected=$((selected + 1))
                if [ "$selected" -ge $((start + page_size)) ]; then
                    start=$((start + 1))
                fi
            fi
            ;;
        "")
            # Enter 键
            tput rmcup
            break
            ;;
        *) ;;
        esac
        draw_menu
    done
    # clear_menu # 清除菜单
    tput cnorm # 恢复光标
    tput rmcup # 恢复之前的屏幕
    # tput rc    # 恢复光标位置
    # 处理结果
    _SELECT_RESULT="${options[$selected]}"
}

function interactive_select_boolean() {
    _SELECT_RESULT=""
    local selected=0
    local message="$1"
    function clear_menu() {
        tput rc
        for ((i = 0; i < 2 + 2; i++)); do
            echo -e "\r\033[K"
        done
        tput rc
    }
    function cleanup() {
        clear_menu
        tput rc
        tput cnorm
        tput rmcup
        exit
    }
    function draw_menu() {
        tput rc
        echo -e "╭─ ${message}"
        echo -e "│"
        if [ "$selected" -eq 0 ]; then
            echo -e "╰─ \033[32m●\033[0m 是\033[2m / ○ 否\033[0m"
        else
            echo -e "╰─ \033[2m○ 是 / \033[0m\033[32m●\033[0m 否"
        fi
    }
    function draw_menu_confirmed() {
        tput rc
        echo -e "╭─ ${message}"
        echo -e "│"
        if [ "$selected" -eq 0 ]; then
            echo -e "╰─ \033[32m●\033[0m \033[1m是\033[0m\033[2m / ○ 否\033[0m"
        else
            echo -e "╰─ \033[2m○ 是 / \033[0m\033[32m●\033[0m \033[1m否\033[0m"
        fi
    }
    function read_key() {
        IFS= read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            IFS= read -rsn2 key
            key="$key"
        fi
        echo "$key"
    }
    tput sc                 # 保存光标位置
    tput civis              # 隐藏光标
    trap "cleanup" INT TERM # 捕捉脚本结束时恢复光标
    draw_menu               # 初始化菜单位置
    # 处理选择
    while true; do
        key=$(read_key)
        case "$key" in
        "[D" | "a" | "A")
            # 左箭头 / A
            if [ "$selected" -gt 0 ]; then
                selected=$((selected - 1))
            fi
            ;;
        "[C" | "d" | "D")
            # 右箭头 / D
            if [ "$selected" -lt 1 ]; then
                selected=$((selected + 1))
            fi
            ;;
        "")
            # Enter 键
            draw_menu_confirmed
            break
            ;;
        *) ;;
        esac
        draw_menu
    done
    # clear_menu # 清除菜单
    tput cnorm # 恢复光标
    # tput rc    # 恢复光标位置
    # 处理结果
    if [ "$selected" -eq 0 ]; then
        _SELECT_RESULT="true"
    else
        _SELECT_RESULT="false"
    fi
}


## 处理break，显示信息或直接跳过 
function case_end_tackle() {
    _IS_BREAK=${_IS_BREAK:-"false"}
    _BREAK_INFO=${_BREAK_INFO:-" 操作完成"}

    echo -e "\n${TIP}${_BREAK_INFO}${RESET}"
    if ${_IS_BREAK} == "true"; then
        echo "└─ 按任意键继续 ..."
        read -n 1 -s -r -p ""
    fi
    _IS_BREAK="true"
    _BREAK_INFO="操作完成"
    # echo -e "${RESET}"
}

## 重启系统，需要用户确认
function sys_reboot() {

    local CHOICE=$(echo -e "\n${BOLD}└─ 是否要重启系统? [Y/n] ${PLAIN}")
    read -rp "${CHOICE}" INPUT
    [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
    case "${INPUT}" in
    [Yy] | [Yy][Ee][Ss])
        echo -e "\n$TIP 重启系统 ...\n"
        _BREAK_INFO=" 系统重启中 ..."
        reboot 
        exit 0 
        ;;
    [Nn] | [Nn][Oo])
        echo -e "\n$TIP 取消重启系统！"
        ;;
    *)
        echo -e "\n$WARN 输入错误！"
        _BREAK_INFO=" 输入错误，不重启系统！"
        _IS_BREAK="true"
        case_end_tackle
        ;;
    esac
}


# 修复dpkg中断问题
function fix_dpkg() {
	pkill -9 -f 'apt|dpkg'
	rm -f /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock
	DEBIAN_FRONTEND=noninteractive dpkg --configure -a
}

# 安装应用程序
function app_install() {
    if [ $# -eq 0 ]; then
        echo "未提供软件包参数!"
        return 1
    fi

	for package in "$@"; do
		if ! command -v "$package" &>/dev/null; then
			echo -e "${gl_huang}正在安装 $package...${gl_bai}"
			if command -v dnf &>/dev/null; then
				dnf -y update
				dnf install -y epel-release
				dnf install -y "$package"
			elif command -v yum &>/dev/null; then
				yum -y update
				yum install -y epel-release
				yum install -y "$package"
			elif command -v apt &>/dev/null; then
				sudo apt update -y
				sudo apt install -y "$package"
			elif command -v apk &>/dev/null; then
				apk update
				apk add "$package"
			elif command -v pacman &>/dev/null; then
				pacman -Syu --noconfirm
				pacman -S --noconfirm "$package"
			elif command -v zypper &>/dev/null; then
				zypper refresh
				zypper install -y "$package"
			elif command -v opkg &>/dev/null; then
				opkg update
				opkg install "$package"
			elif command -v pkg &>/dev/null; then
				pkg update
				pkg install -y "$package"
			else
				echo "未知的包管理器!"
				return 1
			fi
		fi
	done
}

function app_remove() {
    if [ $# -eq 0 ]; then
        echo "未提供软件包参数!"
        return 1
    fi

	for package in "$@"; do
		echo -e "${PRIGHT}正在卸载 $package...${RESET}"
		if command -v dnf &>/dev/null; then
			dnf remove -y "$package"
		elif command -v yum &>/dev/null; then
			yum remove -y "$package"
		elif command -v apt &>/dev/null; then
			sudo apt purge -y "$package"
		elif command -v apk &>/dev/null; then
			apk del "$package"
		elif command -v pacman &>/dev/null; then
			pacman -Rns --noconfirm "$package"
		elif command -v zypper &>/dev/null; then
			zypper remove -y "$package"
		elif command -v opkg &>/dev/null; then
			opkg remove "$package"
		elif command -v pkg &>/dev/null; then
			pkg delete -y "$package"
		else
			echo "未知的包管理器!"
			return 1
		fi
	done
}

function sys_update() {
    _BREAK_INFO=" 系统更新完成！"
    _IS_BREAK="true"
    
	echo -e "\n${WORKING}${GREEN}正在系统更新...${RESET}"
	if command -v dnf &>/dev/null; then
		dnf -y update
	elif command -v yum &>/dev/null; then
		yum -y update
	elif command -v apt &>/dev/null; then
		fix_dpkg
		DEBIAN_FRONTEND=noninteractive apt update -y
		DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
	elif command -v apk &>/dev/null; then
		apk update && apk upgrade
	elif command -v pacman &>/dev/null; then
		pacman -Syu --noconfirm
	elif command -v zypper &>/dev/null; then
		zypper refresh
		zypper update
	elif command -v opkg &>/dev/null; then
		opkg update
	else
		echo -e "$WARN 未知的包管理器!"
        _BREAK_INFO=" 系统更新失败！"
		return
	fi
}

function sys_clean() {
    _IS_BREAK="true"
    _BREAK_INFO=" 系统清理完成！"
	echo -e "\n${WORKING}${RED}正在系统清理...${RESET}"
	if command -v dnf &>/dev/null; then
		rpm --rebuilddb
		dnf autoremove -y
		dnf clean all
		dnf makecache
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v yum &>/dev/null; then
		rpm --rebuilddb
		yum autoremove -y
		yum clean all
		yum makecache
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v apt &>/dev/null; then
		fix_dpkg
		apt autoremove --purge -y
		apt clean -y
		apt autoclean -y
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v apk &>/dev/null; then
		echo "清理包管理器缓存..."
		apk cache clean
		echo "删除系统日志..."
		rm -rf /var/log/*
		echo "删除APK缓存..."
		rm -rf /var/cache/apk/*
		echo "删除临时文件..."
		rm -rf /tmp/*

	elif command -v pacman &>/dev/null; then
		pacman -Rns $(pacman -Qdtq) --noconfirm
		pacman -Scc --noconfirm
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v zypper &>/dev/null; then
		zypper clean --all
		zypper refresh
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v opkg &>/dev/null; then
		echo "删除系统日志..."
		rm -rf /var/log/*
		echo "删除临时文件..."
		rm -rf /tmp/*

	elif command -v pkg &>/dev/null; then
		echo "清理未使用的依赖..."
		pkg autoremove -y
		echo "清理包管理器缓存..."
		pkg clean -y
		echo "删除系统日志..."
		rm -rf /var/log/*
		echo "删除临时文件..."
		rm -rf /tmp/*

	else
		echo -e "$WARN 未知的包管理器!"
        _BREAK_INFO=" 系统清理失败！"
		return
	fi
	return
}

postgresql_usage(){
  
echo -e '\nPostgreSQL使用说明'
echo -e 'Start the database server using: pg_ctlcluster 11 main start'
echo -e '============================================================'
echo -e 'apt show postgresql         # 查看已经安装的postgresql版本 '
echo -e 'service postgresql status   # 检查PostgreSQL是否正在运行   '
echo -e 'su - postgresql             # 登录账户                    '
echo -e 'psql                        # 启动PostgreSQL Shell        '
echo -e '\q                          # 退出PosqgreSQL Shell        '
echo -e '\l                          # 查看所有表                   '
echo -e '\du                         # 查看PostSQL用户             '
echo -e '==========================================================='
echo -e "ALTER USER postgres WITH PASSWORD 'my_password';  # 更改任何用户的密码 "
echo -e "CREATE USER my_user WITH PASSWORD 'my_password';  # 创建一个用户 "
echo -e 'ALTER USER my_user WITH SUPERUSER;                # 给用户添加超级用户权限 '
echo -e 'DROP USER my_user;                                # 删除用户 '
echo -e 'CREATE DATABASE my_db OWNER my_user;              # 创建数据库，并指定所有者 '
echo -e 'DROP DATABASE my_db;                              # 删除数据库 '
echo -e '==========================================================='
echo -e 'select current_database();                        # 查看当前数据库 '
echo -e '\c - next_db;                                     # 切换数据库 '
echo -e 'psql -U my_user                                   # \q退出后，使用my_user登录 '
echo -e 'psql -U my_user -d my_db                          # 使用-d参数直接连接数据库 '
echo -e '==========================================================='
echo -e ' >>> 找到数据库bin目录./pg_ctl执行: 启停服务 '
echo -e 'systemctl stop postgresql.service                 # 停止 '
echo -e 'systemctl start postgresql.service                # 启动 '
}


# 定义性能测试数组
MENU_TEST_ITEMS=(
    # "1|ChatGPT解锁状态|$WHITE"
    # "2|Region流媒体状态|$WHITE"
    # "3|yeahwu流媒体状态|$WHITE"
    # "………………………|$WHITE" 
    # "11|三网测速(Superspeed)|$CYAN"
    # "12|三网回程(bestrace)|$WHITE"
    # "13|回程线路(mtr_trace)|$WHITE" 
    # "21|单线程测速|$WHITE"
    # "22|带宽性能(yabs)|$WHITE"
    # "………………………|$WHITE" 
    # "31|性能测试(bench)|$CYAN"
    # "32|融合怪测评(spiritysdx)|$CYAN"
    "………………………………………………………………💡||💡" 
    "IP解锁状态检测|$GREEN|🌏"
    " 1.ChatGPT解锁状态"
    " 2.Region流媒体状态"
    " 3.yeahwu流媒体状态"
    " 4.流媒体地区限制检测|$BLUE"
    "………………………………………………………………💡||💡" 
    "网络线路测速|$GREEN|🌐"
    "11.三网测速(Superspeed)"
    "12.三网回程(bestrace)"
    "13.回程线路(mtr_trace)" 
    "21.单线程测速"
    "22.带宽性能(yabs)"
    "………………………………………………………………💡||💡" 
    "综合测试|$GREEN|🌏"
    "31.性能测试(bench)|$RED"
    "32.融合怪测评(spiritysdx)"
)
function system_test_menu(){
    function print_menu_system_test(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ 性能测试 " $MAX_SPLIT_CHAR_NUM 1 1 
        print_items_list MENU_TEST_ITEMS[@] ' ⚓ 性能测试脚本 '
        # print_main_menu_tail $MAX_SPLIT_CHAR_NUM
        print_sub_menu_tail $MAX_SPLIT_CHAR_NUM
    }

    while true; do
        _IS_BREAK="true"
        print_menu_system_test
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) bash <(curl -Ls https://cdn.jsdelivr.net/gh/missuo/OpenAI-Checker/openai.sh) ;;
        2) bash <(curl -L -s check.unlock.media) ;;
        3) 
            url=$(get_proxy_url "https://github.com/yeahwu/check/raw/main/check.sh")
            wget -qO- ${url} | bash ;;
        4)  
            url=$(get_proxy_url " https://raw.githubusercontent.com/1-stream/RegionRestrictionCheck/main/check.sh")
            bash <(curl -L -s ${url}) ;;
        11) bash <(curl -Lso- https://git.io/superspeed_uxh) ;;
        12) wget -qO- git.io/besttrace | bash ;;
        13) 
            url=$(get_proxy_url "https://raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh")
            # wget -qO- ${url} | bash ;;
            curl ${url} | bash ;;
        21) bash <(fetch https://bench.im/hyperspeed) ;;
        22) curl -sL yabs.sh | bash -s -- -i -5 ;;
        31) curl -Lso- bench.sh | bash ;;
        32) curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh ;;
        xx) sys_reboot ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" && break ;;
        *)  _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！" && _IS_BREAK="true" ;;
        esac
        case_end_tackle
    done

}


function check_crontab_installed() {
	if ! command -v crontab >/dev/null 2>&1; then
		install_crontab
	fi
}


function install_crontab() {

	if [ -f /etc/os-release ]; then
		. /etc/os-release
		case "$ID" in
			ubuntu|debian|kali)
				apt update
				apt install -y cron
				systemctl enable cron
				systemctl start cron
				;;
			centos|rhel|almalinux|rocky|fedora)
				yum install -y cronie
				systemctl enable crond
				systemctl start crond
				;;
			alpine)
				apk add --no-cache cronie
				rc-update add crond
				rc-service crond start
				;;
			arch|manjaro)
				pacman -S --noconfirm cronie
				systemctl enable cronie
				systemctl start cronie
				;;
			opensuse|suse|opensuse-tumbleweed)
				zypper install -y cron
				systemctl enable cron
				systemctl start cron
				;;
			iStoreOS|openwrt|ImmortalWrt|lede)
				opkg update
				opkg install cron
				/etc/init.d/cron enable
				/etc/init.d/cron start
				;;
			FreeBSD)
				pkg install -y cronie
				sysrc cron_enable="YES"
				service cron start
				;;
			*)
				echo "不支持的发行版: $ID"
				return
				;;
		esac
	else
		echo "无法确定操作系统。"
		return
	fi

	echo -e "$PRIGHT crontab 已安装且 cron 服务正在运行。"
}



function iptables_rules_save() {
	mkdir -p /etc/iptables
	touch /etc/iptables/rules.v4
	iptables-save > /etc/iptables/rules.v4
	check_crontab_installed
	crontab -l | grep -v 'iptables-restore' | crontab - > /dev/null 2>&1
	(crontab -l ; echo '@reboot iptables-restore < /etc/iptables/rules.v4') | crontab - > /dev/null 2>&1
}


function iptables_open() {
	app_install iptables
	iptables_rules_save
	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -F

	ip6tables -P INPUT ACCEPT
	ip6tables -P FORWARD ACCEPT
	ip6tables -P OUTPUT ACCEPT
	ip6tables -F

}


function add_swap() {
    local new_swap=$1  # 获取传入的参数

    # 获取当前系统中所有的 swap 分区
    local swap_partitions=$(grep -E '^/dev/' /proc/swaps | awk '{print $1}')

    # 遍历并删除所有的 swap 分区
    for partition in $swap_partitions; do
        swapoff "$partition"
        wipefs -a "$partition"
        mkswap -f "$partition"
    done

    # 确保 /swapfile 不再被使用
    swapoff /swapfile

    # 删除旧的 /swapfile
    rm -f /swapfile

    # 创建新的 swap 分区
    fallocate -l ${new_swap}M /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile

    sed -i '/\/swapfile/d' /etc/fstab
    echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

    if [ -f /etc/alpine-release ]; then
        echo "nohup swapon /swapfile" > /etc/local.d/swap.start
        chmod +x /etc/local.d/swap.start
        rc-update add local
    fi

    echo -e "虚拟内存大小已调整为${gl_huang}${new_swap}${gl_bai}M"
}

function check_swap() {
    local swap_total=$(free -m | awk 'NR==3{print $2}')
    # 判断是否需要创建虚拟内存
    [ "$swap_total" -gt 0 ] || add_swap 1024 
}


function bbr_on() {
    cat > /etc/sysctl.conf << EOF
net.ipv4.tcp_congestion_control=bbr
EOF
    sysctl -p
}

function srv_install(){
    local srv_name=${1:-""}
    local srv_cmd=${2:-""}
    local is2start=${3:-""}
    local is2enable=${3:-""}
    if ! command -v systemctl >/dev/null 2>&1; then
        echo -e "$PRIGHT systemctl 未安装，正在安装中..."
        app_install systemctl
    fi
    
    if [[ -z "${srv_name}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入服务名称(eg.: frps): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        if [[ -z "${INPUT}" ]] ; then
            echo -e "$PRIGHT 服务名称不能为空！" 
            return 0 
        fi 
        srv_name=$INPUT 
    fi 

    local srv_dir='/etc/systemd/system'
    local srv_path=${srv_dir}/${srv_name}.service
    if [ -f ${srv_path} ]; then
        echo -e "$PRIGHT ${srv_name}服务已存在，请勿重复安装！"
        return 0
    fi
    
    if [[ -z "${srv_cmd}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入服务服务运行命令(eg.: /usr/bin/frps -c /usr/bin/frps.toml): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        if [[ -z "${srv_cmd}" ]] ; then
            echo -e "$PRIGHT ${srv_name}服务运行命令不能为空！"
            return 0 
        fi
        srv_cmd=$INPUT 
    fi 

    cat > ${srv_path} << EOF
[Unit]
Description=${srv_name}
After=network.target syslog.target
Wants = network.target

[Service]
Type=simple
ExecStart=${srv_cmd}
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    echo -e "$PRIGHT ${srv_name}服务配置信息创建成功！"

    case "$is2start" in
    1) INPUT="Y" ;;
    0) INPUT="N" ;;
    *)  
        local CHOICE=$(echo -e "\n${BOLD}└─ 是否立即启动${srv_name}服务(Y/n): ${PLAIN}")
        read -rp "${CHOICE}" INPUT 
        [[ -z "${INPUT}" ]] && INPUT="Y" 
        ;;
    esac
    case "$INPUT" in
    [Yy] | [Yy][Ee][Ss])
        sudo systemctl start ${srv_name} 
        _BREAK_INFO=" 已启动${app_name}服务!"
        ;;
    [Nn] | [Nn][Oo])
        _BREAK_INFO=" 不启动${app_name}服务!" 
        ;;
    *)  ;;
    esac
    
    case "$is2enable" in
    1) INPUT="Y" ;;
    0) INPUT="N" ;;
    *)  
        local CHOICE=$(echo -e "\n${BOLD}└─ 是否设置${srv_name}服务自启动(Y/n): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "${INPUT}" ]] && INPUT="Y" 
        ;;
    esac
    case "$INPUT" in
    [Yy] | [Yy][Ee][Ss])
        sudo systemctl enable ${srv_name} 
        _BREAK_INFO=" 设置${app_name}服务自启动!" 
        ;;
    [Nn] | [Nn][Oo])
        _BREAK_INFO=" 不设置${app_name}服务自启动!" 
        ;;
    *)  ;;
    esac
}
function srv_uninstall(){
    local srv_name=${1:-""}
    if ! command -v systemctl >/dev/null 2>&1; then
        echo -e "$PRIGHT systemctl 未安装，请先安装！"
        return 0
    fi
    
    if [[ -z "${srv_name}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入服务名称(eg.: docker): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        if [[ -z "${INPUT}" ]] ; then 
            echo -e "$PRIGHT 服务名称不能为空！" 
            return 0 
        fi 
        srv_name=$INPUT
    fi 
    
    local srv_path=''
    local resp=$(systemctl list-unit-files --type-service | grep ${srv_name} )
    if [[ -n resp ]] ; then 
        sudo systemctl stop ${srv_name}
        sudo systemctl disable ${srv_name}

        srv_path=/etc/systemd/system/${srv_name}.service
        [[ -f ${srv_path} ]] && sudo rm -f ${srv_path}
        srv_path=/lib/systemd/system/${srv_name}.service
        [[ -f ${srv_path} ]] && sudo rm -f ${srv_path}

        echo -e "$PRIGHT ${srv_name} 服务已卸载！"
    else
        echo -e "$PRIGHT 未找到 ${srv_name} 服务"
    fi 
}
function srv_status(){
    local srv_name=${1:-""}
    if ! command -v systemctl >/dev/null 2>&1; then
        echo -e "$PRIGHT systemctl 未安装，请先安装！"
        return 0
    fi
    
    if [[ -z "${srv_name}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入服务名称(eg.: docker): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        if [[ -z "${INPUT}" ]] ; then 
            echo -e "$PRIGHT 服务名称不能为空！" 
            return 0 
        fi 
        srv_name=$INPUT
    fi 
    
    local resp=$(systemctl list-unit-files --type-service | grep ${srv_name} )
    if [[ -n resp ]] ; then 
        sudo systemctl status ${srv_name}
    else
        echo -e "$PRIGHT 未找到 ${srv_name} 服务"
    fi 
}
function srv_stop(){
    local srv_name=${1:-""}
    if ! command -v systemctl >/dev/null 2>&1; then
        echo -e "$PRIGHT systemctl 未安装，请先安装！"
        return 0
    fi
    
    if [[ -z "${srv_name}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入服务名称(eg.: docker): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        if [[ -z "${INPUT}" ]] ; then 
            echo -e "$PRIGHT 服务名称不能为空！" 
            return 0 
        fi 
        srv_name=$INPUT
    fi 
    local resp=$(systemctl list-unit-files --type-service | grep ${srv_name} )
    if [[ -n resp ]] ; then 
        sudo systemctl stop ${srv_name}
    else
        echo -e "$PRIGHT 未找到 ${srv_name} 服务"
    fi 
}
function srv_start(){
    local srv_name=${1:-""}
    if ! command -v systemctl >/dev/null 2>&1; then
        echo -e "$PRIGHT systemctl 未安装，请先安装！"
        return 0
    fi
    
    if [[ -z "${srv_name}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入服务名称(eg.: docker): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        if [[ -z "${INPUT}" ]] ; then 
            echo -e "$PRIGHT 服务名称不能为空！" 
            return 0 
        fi 
        srv_name=$INPUT
    fi 
    local resp=$(systemctl list-unit-files --type-service | grep ${srv_name} )
    if [[ -n resp ]] ; then 
        if [ "$(sudo systemctl is-active ${srv_name})" = "active" ]; then
            echo -e "$PRIGHT ${srv_name} 服务已启动！"
            local CHOICE=$(echo -e "\n${BOLD}└─ $WARN ${srv_name} 服务已启动, 是否先停止服务(Y/n): ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "${INPUT}" ]] && INPUT="Y" 
            case "$INPUT" in                    
            [Yy] | [Yy][Ee][Ss])
                sudo systemctl stop ${srv_name} ;;
            [Nn] | [Nn][Oo])
                _BREAK_INFO=" 取消安装${app_name}!" ;;
            *)  ;;
            esac
        fi
        sudo systemctl start ${srv_name}
    else
        echo -e "$PRIGHT 未找到 ${srv_name} 服务"
    fi 
}
function srv_restart(){
    local srv_name=${1:-""}
    if ! command -v systemctl >/dev/null 2>&1; then
        echo -e "$PRIGHT systemctl 未安装，请先安装！"
        return 0
    fi
    
    if [[ -z "${srv_name}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入服务名称(eg.: docker): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        if [[ -z "${INPUT}" ]] ; then 
            echo -e "$PRIGHT 服务名称不能为空！" 
            return 0 
        fi 
        srv_name=$INPUT
    fi 
    local resp=$(systemctl list-unit-files --type-service | grep ${srv_name} )
    if [[ -n resp ]] ; then 
        sudo systemctl restart ${srv_name}
    else
        echo -e "$PRIGHT 未找到 ${srv_name} 服务"
    fi 
}

# 系统服务管理 
function srv_manage_menu(){
    local srv_items_list=(
        "1|安装服务👈|$WHITE"
        "2|卸载服务👎|$WHITE"
        "3|查看服务💡|$YELLOW"
        "4|启动服务✅|$WHITE"
        "5|停止服务⛔|$WHITE"
        "6|重启服务♻️|$WHITE"
        "=========|$GREEN" 
        "0|返回🔙|$BLUE"
    )
    function print_menu_srv_manage(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        print_sub_head " 💫 系统服务工具 " $MAX_SPLIT_CHAR_NUM 1 0 
        split_menu_items srv_items_list[@] 
        # print_main_menu_tail $MAX_SPLIT_CHAR_NUM
        # print_sub_menu_tail $MAX_SPLIT_CHAR_NUM
    }

    while true; do 
        clear
        _IS_BREAK="true" 
        print_menu_srv_manage
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case $INPUT in
        1)  srv_install   ;;
        2)  srv_uninstall ;;
        3)  srv_status    ;;
        4)  srv_start     ;;
        5)  srv_stop      ;;
        6)  srv_restart   ;;
        # xx) sys_reboot ;;
        0)  echo -e "\n$TIP 返回 ..." && _IS_BREAK="false" && break ;;
        *)  _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！" && _IS_BREAK="true" ;;
        esac
        case_end_tackle
    done
}

function system_dd_usage(){
echo -e " "
echo -e "$PRIGHT DD脚本使用说明 "
echo -e "—————————————————————————————————————"
echo -e "       Linux : ${BLUE}root${red}@${yellow}LeitboGi0ro${PLAIN}"
echo -e "     Windows : ${BLUE}Administrator${red}@${yellow}Teddysun.com"
echo -e "  @bin456789 : ${BLUE}root|Administrator${red}@${yellow}123@@@"
echo -e "   ${white}(Windows need mininumn 15G Storage)${PLAIN}"
echo -e '   (当administrator无法登录时, 可尝试.\\administrator)\n'
echo -e "  bash InstallNET.sh -windows 10 -lang 'en'"
echo -e "  bash InstallNET.sh -windows 11 -lang 'cn'\n"
echo -e "  reinstall.sh alma 8|9"
echo -e "  reinstall.sh rocky 8|9"
echo -e "  reinstall.sh debian 9|10|11|12"
echo -e "  reinstall.sh ubuntu 24.04 [--minimal]"
echo -e "  reinstall.sh alpine 3.17|3.18|3.19|3.20\n"
echo -e "      reinstall.bat windows --image-name='windows server 2022 serverdatacenter' --lang=zh-cn "
echo -e "  bash reinstall.sh windows --image-name 'Windows 10 Enterprise LTSC 2021'--lang en-us "
echo -e "  bash reinstall.sh windows --image-name 'windows 11 pro' --lang zh-cn \n"
echo -e "  bash reinstall.sh windows --image-name 'windows 11 business 23h2'"
echo -e "                            --iso 'https://drive.massgrave.dev/zh-cn_windows_11_business_editions_version_23h2_updated_aug_2024_x64_dvd_6ca91c94.iso' \n"
echo -e "  bash reinstall.sh windows --image-name 'Windows 10 business 22h2'"
echo -e "                            --iso 'https://drive.massgrave.dev/zh-cn_windows_10_business_editions_version_22h2_updated_aug_2024_x86_dvd_8d7e500f.iso'\n"
echo -e "  bash reinstall.sh dd --img https://example.com/xx.xz"
echo -e "  bash reinstall.sh alpine --hold=1"
echo -e "  bash reinstall.sh netboot.xyz\n"
echo -e "  注意: Windows 10 LTSC 2021 zh-cn 的wsappx进程会长期占用CPU, 需要更新系统补丁。\n"
}

# 定义系统工具数组
MENU_SYSTEM_TOOLS_ITEMS=(
    "1|修改ROOT密码|$WHITE"
    "2|开启ROOT登录|$WHITE"
    "3|禁用ROOT用户|$WHITE"
    "4|系统源管理|$MAGENTA"
    "5|DNS管理|$CYAN"
    "6|改主机名|$WHITE"
    "7|时区调整|$WHITE" 
    "8|用户管理|$BLUE"
    "9|端口管理|$WHITE"
    "10|服务管理|$YELLOW"
    "………………………|$WHITE" 
    "21|DD系统|$GREEN"
    "22|虚拟内存|$CYAN"
    "23|开启SSH转发|$WHITE"
    "24|切换v4/v6|$WHITE"
    "25|BBRv3加速|$WHITE"
    "26|定时任务|$WHITE"
    "27|命令行美化|$YELLOW"
    "28|设置qiq命令|$CYAN"
    "29|删除qiq命令|$WHITE"
)
function system_tools_menu(){
    function print_menu_system_tools(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ 系统工具 " $MAX_SPLIT_CHAR_NUM 1 0 
        split_menu_items MENU_SYSTEM_TOOLS_ITEMS[@] 
        # print_main_menu_tail $MAX_SPLIT_CHAR_NUM
        print_sub_menu_tail $MAX_SPLIT_CHAR_NUM
    }

    function sys_setting_change_root_password(){
            # local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
            # read -rp "${CHOICE}" INPUT
            echo "设置ROOT密码" && passwd            
    }
    function sys_setting_enable_root(){
            sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
            sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
            service sshd restart

            _BREAK_INFO=" ROOT登录设置完毕"
            _IS_BREAK="true"
            
    }
    function sys_setting_disable_root(){
            app_install sudo 

            # 提示用户输入新用户名
            echo -e "$TIP 禁用Root用户，需要创建新的用户 ..."
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入新用户名: ${PLAIN}")
            read -rp "${CHOICE}" new_username

            # 创建新用户并设置密码
            echo -e "$TIP 设置新用户的密码 ..."
            sudo useradd -m -s /bin/bash "$new_username"
            sudo passwd "$new_username"

            # 赋予新用户sudo权限
            echo -e "$TIP 设置新用户sudo权限 ..."
            echo "$new_username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

            # 禁用ROOT用户登录
            echo -e "$TIP 禁用Root用户 ..."
            sudo passwd -l root
            
            _BREAK_INFO=" 禁用ROOT用户完毕"
            _IS_BREAK="true"
            
    }
    function sys_setting_change_change_hostname(){
        local cur_hostname=$(hostname)

        # 询问用户是否要更改主机名
        echo "当前主机名: $cur_hostname"
        read -p "是否要更改主机名？(y/n): " answer

        if [ "$answer" == "y" ]; then
            # 获取新的主机名
            read -p "请输入新的主机名: " new_hostname
            if [ -n "$new_hostname" && [ "$new_hostname" != "0" ]]; then
                if [ -f /etc/alpine-release ]; then
                    # Alpine
                    echo "$new_hostname" > /etc/hostname
                    hostname "$new_hostname"
                else
                    # 其他系统，如 Debian, Ubuntu, CentOS 等
                    hostnamectl set-hostname "$new_hostname"
                    sed -i "s/$cur_hostname/$new_hostname/g" /etc/hostname
                    systemctl restart systemd-hostnamed
                fi
                
                if grep -q "127.0.0.1" /etc/hosts; then
                    sed -i "s/127.0.0.1 .*/127.0.0.1       $new_hostname localhost localhost.localdomain/g" /etc/hosts
                else
                    echo "127.0.0.1       $new_hostname localhost localhost.localdomain" >> /etc/hosts
                fi

                if grep -q "^::1" /etc/hosts; then
                    sed -i "s/^::1 .*/::1             $new_hostname localhost localhost.localdomain ipv6-localhost ipv6-loopback/g" /etc/hosts
                else
                    echo "::1             $new_hostname localhost localhost.localdomain ipv6-localhost ipv6-loopback" >> /etc/hosts
                fi

                echo "主机名更改为: $new_hostname"
            else
                echo "无效主机名。未更改主机名。"
                continue 
            fi
        else
            echo "未更改主机名。"
        fi
        
    }
    
    function sys_setting_users_manage(){
        local users_items_list=(
            "1.显示用户列表|$GREEN|🕺"
            "2.新建普通账户||"
            "3.新建高级账户|$YELLOW|➕"
            "4.设置最高权限||🌹"
            "5.取消最高权限||🥀"
            "6.删除账号|$RED|❌"
            "0.返回|$BLUE|🔙"
        )
        function print_items_users(){
            echo "用户列表"
            generate_separator "=|$WHITE" 
            printf "%-24s %-34s %-20s %-10s\n" "用户名" "用户权限" "用户组" "sudo权限"
            while IFS=: read -r username _ userid groupid _ _ homedir shell; do
                groups=$(groups "$username" | cut -d : -f 2)
                sudo_status=$(sudo -n -lU "$username" 2>/dev/null | grep -q '(ALL : ALL)' && echo "Yes" || echo "No")
                printf "%-20s %-30s %-20s %-10s\n" "$username" "$homedir" "$groups" "$sudo_status"
            done < /etc/passwd
            generate_separator "=|$WHITE" 
        }
        function users_add_new(){
            print_items_users
            # echo "新普通账户"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入新用户名(普通账户): ${PLAIN}")
            read -rp "${CHOICE}" new_username
            useradd -m -s /bin/bash "$new_username"
            passwd "$new_username"
            print_items_users
        }
        function users_add_sudo(){
            print_items_users
            # echo "新高级账户"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入新用户名(高级账户): ${PLAIN}")
            read -rp "${CHOICE}" new_username
            useradd -m -s /bin/bash "$new_username"
            passwd "$new_username"
            usermod -aG sudo "$new_username"
            print_items_users
        }
        function users_set_sudo(){
            print_items_users
            # echo "设置最高权限"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入用户名(设置最高权限): ${PLAIN}")
            read -rp "${CHOICE}" username
            usermod -aG sudo "$username"
            print_items_users
        }
        function users_unset_sudo(){
            print_items_users
            # echo "取消最高权限"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入用户名(取消最高权限): ${PLAIN}")
            read -rp "${CHOICE}" username
            gpasswd -d "$username" sudo
            print_items_users
        }
        function users_delete(){
            print_items_users
            # echo "删除账号"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入用户名(删除账号): ${PLAIN}")
            read -rp "${CHOICE}" username
            userdel -r "$username"
            print_items_users
        }

        #=============================================================
        while true; do
            # 询问用户是否要更改主机名
            clear 
            _IS_BREAK="true"
            print_items_list users_items_list[@] " 👯 用户管理:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) print_items_users ;;
            2) users_add_new ;;
            3) users_add_sudo ;;
            4) users_set_sudo ;;
            5) users_unset_sudo ;;
            6) users_delete ;;
            0) echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" && break ;;
            *) _BREAK_INFO=" 请输入正确选项！" ;;
            esac 
            case_end_tackle
        done
    }
    function sys_setting_alter_timezone(){
        local cur_timezone=$(timedatectl show --property=Timezone --value)
        local cur_time=$(date +"%Y-%m-%d %H:%M:%S")
        
        local tz_items_regions=(
            "1.亚洲|$GREEN"
            "2.欧洲|$WHITE"
            "3.美洲|$WHITE"
            "4.UTC|$WHITE"
            "0.返回|$WHITE"
        )
        local tz_items_asian=(
            "1.中国上海|$GREEN"
            "2.中国香港|$WHITE"
            "3.日本东京|$WHITE"
            "4.韩国首尔|$WHITE"
            "5.新加坡|$WHITE"
            "6.印度加尔各答|$WHITE"
            "7.阿联酋迪拜|$WHITE"
            "8.澳大利亚悉尼|$WHITE"
            "9.泰国曼谷|$WHITE"
            "0.返回|$WHITE"
        )
        local tz_items_eu=(
            "1.英国伦敦|$GREEN"
            "2.法国巴黎|$WHITE"
            "3.德国柏林|$WHITE"
            "4.俄罗斯莫斯科|$WHITE"
            "5.荷兰尤特赖赫特|$WHITE"
            "6.西班牙马德里|$WHITE"
            "0.返回|$WHITE"
        )
        local tz_items_us=(
            "1.美国西部|$GREEN"
            "2.美国东部|$WHITE"
            "3.加拿大|$WHITE"
            "4.墨西哥|$WHITE"
            "5.巴西|$WHITE"
            "6.阿根廷|$WHITE"
            "0.返回|$WHITE"
        )

        function set_timedate() {
            local tz="$1"
            if grep -q 'Alpine' /etc/issue; then
                app_install tzdata
                cp /usr/share/zoneinfo/${tz} /etc/localtime
                hwclock --systohc
            else
                timedatectl set-timezone ${tz}
            fi
        }
        function tz_alter_asia(){
            echo -e "$PRIGHT 当前时区" 
            # 显示时区和时间
            echo "当前时区：$cur_timezone"
            echo "当前时间：$cur_time"

            print_items_list tz_items_asian[@] " ⚓ 亚太地区列表:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择时区(默认为1): ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] && INPUT=1
            case "${INPUT}" in
            1) set_timedate Asia/Shanghai ;;
            2) set_timedate Asia/Hong_Kong ;;
            3) set_timedate Asia/Tokyo ;;
            4) set_timedate Asia/Seoul ;;
            5) set_timedate Asia/Singapore ;;
            6) set_timedate Asia/Kolkata ;;
            7) set_timedate Asia/Dubai ;;
            8) set_timedate Australia/Sydney ;;
            9) set_timedate Asia/Bangkok ;;
            0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" ;;
            *)  _BREAK_INFO=" 请输入正确选项！" ;;
            esac 
        }
        function tz_alter_eu(){
            echo -e "$PRIGHT 系统时间信息" 
            # 显示时区和时间
            echo "当前系统时区：$cur_timezone"
            echo "当前系统时间：$cur_time"

            print_items_list tz_items_eu[@] " ⚓ 欧洲地区列表:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择时区: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] && INPUT=1
            case "${INPUT}" in
            1) set_timedate Europe/London ;;
            2) set_timedate Europe/Paris ;;
            3) set_timedate Europe/Berlin ;;
            4) set_timedate Europe/Moscow ;;
            5) set_timedate Europe/Amsterdam ;;
            6) set_timedate Europe/Madrid ;;
            0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" ;;
            *)  _BREAK_INFO=" 请输入正确选项！" ;;
            esac 
        }
        function tz_alter_us(){
            echo -e "$PRIGHT 系统时间信息" 
            # 显示时区和时间
            echo "当前系统时区：$cur_timezone"
            echo "当前系统时间：$cur_time"

            print_items_list tz_items_us[@] " ⚓ 美洲地区列表:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择时区(默认为1): ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] && INPUT=1
            case "${INPUT}" in
            1) set_timedate America/Los_Angeles ;;
            2) set_timedate America/New_York ;;
            3) set_timedate America/Vancouver ;;
            4) set_timedate America/Mexico_City ;;
            5) set_timedate America/Sao_Paulo ;;
            6) set_timedate America/Argentina/Buenos_Aires  ;;
            0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" ;;
            *)  _BREAK_INFO=" 请输入正确选项！" ;;
            esac 
        }

        echo -e "$PRIGHT 系统时间信息" 
        # 显示时区和时间
        echo "当前系统时区：$cur_timezone"
        echo "当前系统时间：$cur_time"

        print_items_list tz_items_regions[@] " ⚓ 时区地区列表:"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择时区所属区域(默认为1): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && INPUT=1
        case "${INPUT}" in
        1) tz_alter_asia ;;
        2) tz_alter_eu ;;
        3) tz_alter_us ;;
        4) set_timedate UTC ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" ;;
        *)  _BREAK_INFO=" 请输入正确选项！" ;;
        esac 
    }
    function sys_setting_alter_sources(){
        local source_list_options=(
            "1.大陆地区"
            "2.教育网"
            "3.海外地区"
            "0.返回"
        )

        _IS_BREAK="true"
        _BREAK_INFO=" 已修改系统源！"
        print_items_list source_list_options[@] " ⚓ 系统源地区选择:"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择(默认为1): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && INPUT=1
        case "${INPUT}" in
        1)  bash <(curl -sSL https://linuxmirrors.cn/main.sh)          && _BREAK_INFO=" 已修改系统源为大陆地区！" ;;
        2)  bash <(curl -sSL https://linuxmirrors.cn/main.sh) --edu    && _BREAK_INFO=" 已修改系统源为教育网！ " ;;
        3)  bash <(curl -sSL https://linuxmirrors.cn/main.sh) --abroad && _BREAK_INFO=" 已修改系统源为海外地区！" ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" ;;
        *)  _BREAK_INFO=" 请输入正确选项！" ;;
        esac 
    }
    function sys_setting_change_ports_manage(){
        local ports_management_options=(
            "1.查看端口状态"
            "2.开放所有端口"
            "3.关闭所有端口"
            "4.开放指定端口"
            "5.关闭指定端口"
            "0.退出"
        )

        _IS_BREAK="true"
        _BREAK_INFO=" 由端口管理子菜单返回！"
        print_items_list ports_management_options[@] " ⚓ 选择:"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1)  clear  && ss -tulnape ;;
        2) 
            # permission_judgment 
            if [ "$EUID" -ne 0 ] ; then 
                # echo -e "$WARN 该操作需要root权限！"
                _BREAK_INFO=" 开放所有端口需要root权限"
                case_end_tackle 
                # continue 
            fi 
            iptables_open 
            app_remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1
            _BREAK_INFO=" 已开放全部端口"
            ;;
        3) 
            current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')
            cat > /etc/iptables/rules.v4 << EOF
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A FORWARD -i lo -j ACCEPT
-A INPUT -p tcp --dport $current_port -j ACCEPT
COMMIT
EOF
            iptables-restore < /etc/iptables/rules.v4
            _BREAK_INFO=" 已关闭所有端口！"
            ;;
        4) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入要开放的端口号: ${PLAIN}")
            read -rp "${CHOICE}" INPUT

            sed -i "/COMMIT/i -A INPUT -p tcp --dport $INPUT -j ACCEPT" /etc/iptables/rules.v4
            sed -i "/COMMIT/i -A INPUT -p udp --dport $INPUT -j ACCEPT" /etc/iptables/rules.v4
            iptables-restore < /etc/iptables/rules.v4
            _BREAK_INFO=" 已开放端口: $INPUT！"
            ;;
        5) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入要关闭的端口号: ${PLAIN}")
            read -rp "${CHOICE}" INPUT

            sed -i "/--dport $INPUT/d" /etc/iptables/rules.v4
            iptables-restore < /etc/iptables/rules.v4
            _BREAK_INFO=" 已关闭端口: $INPUT！"
            ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" ;;
        *) _BREAK_INFO=" 请输入正确选项！" ;;
        esac 
    }
    function sys_setting_dns_manage(){
            local dns_list_options=(
                "1.国外DNS"
                "2.国内DNS"
                "3.自定义DNS"
                "0.返回"
            )
            
            function set_dns() {
                local dns1_ipv4="$1"
                local dns2_ipv4="$2"
                local dns1_ipv6="$3"
                local dns2_ipv6="$4"

                cp /etc/resolv.conf /etc/resolv.conf.bak
                rm /etc/resolv.conf
                touch /etc/resolv.conf
                if [ $IPV6_SUPPORTED -eq 1 ]; then
                    echo "nameserver $dns1_ipv6" >> /etc/resolv.conf
                    echo "nameserver $dns2_ipv6" >> /etc/resolv.conf
                fi
                if [ $IPV4_SUPPORTED -eq 1 ]; then
                    echo "nameserver $dns1_ipv4" >> /etc/resolv.conf
                    echo "nameserver $dns2_ipv4" >> /etc/resolv.conf
                fi
            }

            _IS_BREAK="true"
            _BREAK_INFO=" 已修改DNS！"
            
            clear 
            echo -e "\n\n$TIP 当前DNS地址: \n"
            cat /etc/resolv.conf
            generate_separator "=|$WHITE" 

            print_items_list dns_list_options[@] " ⚓ DNS切换:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                local dns1_ipv4="1.1.1.1"
                local dns2_ipv4="8.8.8.8"
                local dns1_ipv6="2606:4700:4700::1111"
                local dns2_ipv6="2001:4860:4860::8888"
                set_dns ${dns1_ipv4} ${dns2_ipv4} ${dns1_ipv6} ${dns2_ipv6}
                _BREAK_INFO=" DNS 已切换为海外DNS！"
                ;;
            2) 
                local dns1_ipv4="223.5.5.5"
                local dns2_ipv4="183.60.83.19"
                local dns1_ipv6="2400:3200::1"
                local dns2_ipv6="2400:da00::6666"
                set_dns ${dns1_ipv4} ${dns2_ipv4} ${dns1_ipv6} ${dns2_ipv6}
                _BREAK_INFO=" DNS 已切换为国内DNS！"
                ;;
            3) 
                app_install nano
                nano /etc/resolv.conf
                _BREAK_INFO=" 已手动修改DNS！"
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;;
            esac 
            
    }
    function sys_setting_dd_system(){
        local sys_dd_options=(
            "1.Leitbogioro"
            "2.MoeClub"
            "3.0oVicero0"
            "4.mowwom"
            "5.bin456789"
            "0.返回"
        )         
        
        local sys_lang_options=(
            "1.中文(CN)"
            "2.英文(EN)"
        ) 
        function get_system_language(){
            local sys_lang='CN'
            # print_items_list sys_lang_options[@] " ⚓ 系统语言选择:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择语言(默认为中文)[CN/en]: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) sys_lang='CN' ;;
            2) sys_lang='EN' ;; 
            *) sys_lang='CN' ;; 
            esac 
            echo ${sys_lang}
        }

        local systems_list=(
            "1|Alpine Edge|$WHITE"
            "2|Alpine 3.20|$WHITE"
            "3|Alpine 3.19|$WHITE"
            "4|Alpine 3.18|$WHITE"
            "…………………………………|$WHITE" 
            "11|Debian 12|$YELLOW"
            "12|Debian 11|$WHITE"
            "13|Debian 10|$WHITE"
            "14|Ubuntu 24.04|$YELLOW"
            "15|Ubuntu 22.04|$WHITE"
            "16|Ubuntu 20.04|$WHITE"
            "…………………………………|$WHITE" 
            "21|AlmaLinux 9|$WHITE"
            "22|AlmaLinux 8|$WHITE"
            "23|RockyLinux 9|$WHITE"
            "24|RockyLinux 8|$WHITE"
            "…………………………………|$WHITE" 
            "31|Windows 2025|$YELLOW"
            "32|Windows 2022|$WHITE"
            "33|Windows 2019|$WHITE"
            "34|Windows 11|$WHITE"
            "35|Windows 10|$WHITE"
            "36|Windows 7|$WHITE"
            "…………………………………|$WHITE" 
            "77|自定义(Win)|$WHITE"
            "88|41合一脚本|$WHITE"
            "99|脚本说明|$WHITE"
        )            

        _IS_BREAK="true"
        _BREAK_INFO=" DD系统！"

        check_sys_virt 
        if [[ "$VIRT" != *"KVM"* ]]; then
            # 如果系统虚拟化不是KVM，则使用OsMutation进行DD系统
            local fname='OsMutation.sh' 
            local url=$(get_proxy_url 'https://raw.githubusercontent.com/LloydAsp/OsMutation/main/OsMutation.sh')
            if command -v curl &>/dev/null; then 
                curl -sL -o ${fname} "${url}" && chmod u+x ${fname} && bash ${fname}
            elif command -v wget &>/dev/null; then 
                wget -qO ${fname} $url && chmod u+x ${fname} &&  bash ${fname}
            else
                _BREAK_INFO=" 请先安装curl或wget！"
            fi
            return 0   
        fi 
        
        function dd_print_login_info(){
            local username=$1
            local password=$2
            local port=$3
            echo -e "\n$TIP DD系统登录信息:"
            echo -e "============================="
            echo -e "$BOLD  用户: ${username}"
            echo -e "$BOLD  密码: ${password}"
            echo -e "$BOLD  端口: ${port}"
            echo -e "============================="
        }
        function dd_get_mollylau(){
            local weburl='https://github.com/leitbogioro/Tools'
            local fname='InstallNET.sh' 
            local url=$(get_proxy_url 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh')
            if command -v curl &>/dev/null; then 
                curl -sL -o ${fname} "${url}" && chmod a+x ${fname}
            elif command -v wget &>/dev/null; then 
                wget -qO ${fname} $url && chmod a+x ${fname} 
            else
                _BREAK_INFO=" 请先安装curl或wget！"
                _IS_BREAK="true"
                return 0
            fi 
            return 1 
        }
        
        function dd_get_bin456789(){
            local weburl='https://github.com/bin456789/reinstall'
            local fname='reinstall.sh' 
            local url=$(get_proxy_url 'https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh')
            if command -v curl &>/dev/null; then 
                curl -sL -o ${fname} "${url}" && chmod a+x ${fname}
            elif command -v wget &>/dev/null; then 
                wget -qO ${fname} $url && chmod a+x ${fname} 
            else
                echo -e " 请先安装curl或wget！"
                return 0
            fi 
            return 1 
        }
        
        #=============================================================
        while true; do
            clear 
            local num_split=40
            print_sub_head " DD系统 " $num_split 1 0 
            # print_items_list sys_dd_options[@] " ⚓ DD系统脚本选择:"
            split_menu_items systems_list[@] 0 
            print_sub_menu_tail $num_split
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择要DD的系统: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                dd_get_mollylau 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                bash InstallNET.sh -alpine 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            2) 
                dd_get_mollylau 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                bash InstallNET.sh -alpine  3.20
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            3) 
                dd_get_mollylau 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                bash InstallNET.sh -alpine  3.19
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            4) 
                dd_get_mollylau 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                bash InstallNET.sh -alpine  3.18
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            11) 
                dd_get_mollylau 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                bash InstallNET.sh -debian 12
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            12) 
                dd_get_mollylau 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                bash InstallNET.sh -debian 11
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            13) 
                dd_get_mollylau 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                bash InstallNET.sh -debian 10
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            14) 
                dd_get_mollylau 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                bash InstallNET.sh -ubuntu 24.04
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            15) 
                dd_get_mollylau 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                bash InstallNET.sh -ubuntu 22.04
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            16) 
                dd_get_mollylau 
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                bash InstallNET.sh -ubuntu  20.04
                dd_print_login_info 'root' 'LeitboGi0ro' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            21) 
                dd_get_bin456789
                dd_print_login_info 'root' '123@@@' '22'
                bash reinstall.sh almalinux 9
                dd_print_login_info 'root' '123@@@' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            22) 
                dd_get_bin456789
                dd_print_login_info 'root' '123@@@' '22'
                bash reinstall.sh almalinux 8
                dd_print_login_info 'root' '123@@@' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            23) 
                dd_get_bin456789
                dd_print_login_info 'root' '123@@@' '22'
                bash reinstall.sh rocky 9
                dd_print_login_info 'root' '123@@@' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            24) 
                dd_get_bin456789
                dd_print_login_info 'root' '123@@@' '22'
                bash reinstall.sh rocky 8
                dd_print_login_info 'root' '123@@@' '22'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            31) 
                dd_get_bin456789
                dd_print_login_info 'Administrator' 'Teddysun.com' '3389'
                bash reinstall.sh dd --img "https://dl.lamp.sh/vhd/zh-cn_win2025.xz"
                dd_print_login_info 'Administrator' 'Teddysun.com' '3389'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            32) 
                dd_get_mollylau
                print_items_list sys_lang_options[@] " ⚓ 系统语言选择:"
                local lang=$(get_system_language) 
                dd_print_login_info 'Administrator' 'Teddysun.com' '3389'
                bash InstallNET.sh -windows 2022 $lang 
                dd_print_login_info 'Administrator' 'Teddysun.com' '3389'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            33) 
                dd_get_mollylau
                print_items_list sys_lang_options[@] " ⚓ 系统语言选择:"
                local lang=$(get_system_language) 
                dd_print_login_info 'Administrator' 'Teddysun.com' '3389'
                bash InstallNET.sh -windows 2019 $lang 
                dd_print_login_info 'Administrator' 'Teddysun.com' '3389'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            34) 
                print_items_list sys_lang_options[@] " ⚓ 系统语言选择:"
                local lang=$(get_system_language) 
                dd_print_login_info 'Administrator' 'Teddysun.com' '3389'
                bash InstallNET.sh -windows 11 $lang 
                dd_print_login_info 'Administrator' 'Teddysun.com' '3389'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            35) 
                dd_get_mollylau
                print_items_list sys_lang_options[@] " ⚓ 系统语言选择:"
                local lang=$(get_system_language) 
                dd_print_login_info 'Administrator' 'Teddysun.com' '3389'
                bash InstallNET.sh -windows 10 $lang 
                dd_print_login_info 'Administrator' 'Teddysun.com' '3389'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            36) 
                dd_get_bin456789
                print_items_list sys_lang_options[@] " ⚓ 系统语言选择:"
                local lang=$(get_system_language) 
                local sys_lang='en-us'
                [[ $lang -eq 'CN' ]] && sys_lang='zh-cn'
                dd_print_login_info 'Administrator' '123@@@' '3389'
                bash reinstall.sh windows --image-name='Windows 7 PROFESSIONAL' --iso="https://drive.massgrave.dev/cn_windows_7_professional_with_sp1_x64_dvd_u_677031.iso"
                dd_print_login_info 'Administrator' '123@@@' '3389'
                _IS_BREAK="false" 
                sys_reboot 
                ;;
            77) 
                dd_get_bin456789 
                print_items_list sys_lang_options[@] " ⚓ 系统语言选择:"
                local lang=$(get_system_language) 
                local sys_lang='zh-cn'
                [[ $lang -eq 'EN' ]] && sys_lang='en-us'
                
                local CHOICE=$(echo -e "\n${BOLD}└─ 请输入统版本(默认: Windows Server 2025 SERVERDATACENTER): ${PLAIN}\n")
                read -rp "${CHOICE}" INPUT 
                img_name=${INPUT:-"Windows Server 2025 SERVERDATACENTER"}
                
                local CHOICE=$(echo -e "\n${BOLD}└─ 请输镜像链接(默认: https://alistus.zwdk.im/d/qbd/zh-cn_windows_server_2025_updated_feb_2025_x64_dvd_3733c10e.iso): ${PLAIN}\n")
                read -rp "${CHOICE}" INPUT
                url_iso=${INPUT:-"https://alistus.zwdk.im/d/qbd/zh-cn_windows_server_2025_updated_feb_2025_x64_dvd_3733c10e.iso"}
                
                echo -e " "
                generate_separator "=|$WHITE" 40
                echo -e "$PRIGHT 系统语言： ${sys_lang} "
                echo -e "$PRIGHT 系统版本： ${img_name} "
                echo -e "$PRIGHT 镜像链接： ${url_iso}  "
                generate_separator "=|$WHITE" 40
                local CHOICE=$(echo -e "\n${BOLD}└─ 是否继续DD? [Y/n] ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
                case "$INPUT" in
                [Yy] | [Yy][Ee][Ss])
                    dd_print_login_info 'Administrator' '123@@@' '3389'
                    bash reinstall.sh windows --image-name "${img_name}" --iso "${url_iso}" --lang $sys_lang
                    dd_print_login_info 'Administrator' '123@@@' '3389'
                    _IS_BREAK="false" 
                    sys_reboot 
                    ;;
                [Nn] | [Nn][Oo])
                    _BREAK_INFO=" 取消DD系统！" 
                    _IS_BREAK="false"
                    ;;
                *)
                    _BREAK_INFO=" 无效的选择。"
                    _IS_BREAK="true"
                    ;;
                esac

                ;;
            88) 
                sys_update 

                _BREAK_INFO=" 从 41合一脚本DD系统 返回"
                local fname='NewReinstall.sh' 
                local url=$(get_proxy_url 'https://raw.githubusercontent.com/fcurrk/reinstall/master/NewReinstall.sh')
                if command -v curl &>/dev/null; then 
                    curl -sL -o ${fname} "${url}" && chmod a+x ${fname} && bash ${fname}
                elif command -v wget &>/dev/null; then 
                    wget -qO ${fname} $url && chmod a+x ${fname} &&  bash ${fname}
                else
                    _BREAK_INFO=" 请先安装curl或wget！"
                fi
                # wget --no-check-certificate -O NewReinstall.sh https://raw.githubusercontent.com/fcurrk/reinstall/master/NewReinstall.sh && chmod a+x NewReinstall.sh && bash NewReinstall.sh
                ;;
            99) system_dd_usage && _BREAK_INFO=" DD系统说明 " ;; 
            0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" && break ;;
            xx) sys_reboot && exit 0 ;;
            *)  _BREAK_INFO=" 请输入正确选项！" ;;
            esac 
            case_end_tackle
        done
    }
    function sys_setting_alter_swap(){
        local swap_used=$(free -m  | awk 'NR==3{print $3}')
        local swap_total=$(free -m | awk 'NR==3{print $2}')
        local swap_info=$(free -m  | awk 'NR==3{used=$3; total=$2; if (total == 0) {percentage=0} else {percentage=used*100/total}; printf "%dM/%dM (%d%%)", used, total, percentage}')

        local swap_size_options=(
            "1.1024M|$YELLOW|⭐"
            "2.2048M||✅"
            "3.4096M||"
            "4.8192M||"
            "5.自定义|$GREEN|🔢"
            "0.返回|$RED|❎"
        )           
        
        _IS_BREAK="true"
        echo -e "\n$PRIGHT 当前虚拟内存: $swap_info "
        print_items_list swap_size_options[@] " 🖥️ 设置虚拟内存:"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1)  add_swap 1024 && _BREAK_INFO=" 已设置1G虚拟内存！" ;;
        2)  add_swap 2048 && _BREAK_INFO=" 已设置2G虚拟内存！" ;;
        3)  add_swap 4096 && _BREAK_INFO=" 已设置4G虚拟内存！" ;;
        4)  add_swap 8192 && _BREAK_INFO=" 已设置8G虚拟内存！" ;;
        5) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入要设置的虚拟内存大小(M): ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            if [[ $INPUT =~ ^[0-9]+$ ]]; then
                add_swap $INPUT 
                _BREAK_INFO=" 已设置${INPUT}M虚拟内存！"
            else
                _BREAK_INFO=" 虚拟内存大小输入错误，格式有误，应为数字！"
            fi
            ;;
        0)  _BREAK_INFO=" 返回 " && _IS_BREAK="false" ;;
        *)  _BREAK_INFO=" 请输入正确选项！" ;;
        esac 
    }
    function sys_setting_enable_ssh_reproxy(){
        # 这项功能主要用于将服务器作为中转站，进行网络请求的转发 
        sed -i 's/^#\?AllowTcpForwarding.*/AllowTcpForwarding yes/g' /etc/ssh/sshd_config;
        sed -i 's/^#\?GatewayPorts.*/GatewayPorts yes/g' /etc/ssh/sshd_config;
        service sshd restart
        _BREAK_INFO=" 已开启SSH转发功能"
        _IS_BREAK="true"
    }
    function sys_setting_alter_priority_v4v6(){
        function print_v4v6_priority(){
            local ipv6_disabled=$(sysctl -n net.ipv6.conf.all.disable_ipv6)
            if [ "$ipv6_disabled" -eq 1 ]; then
                echo -e "\n${PRIGHT} 当前网络: IPv4 优先\n"
            else
                echo -e "\n${PRIGHT} 当前网络: IPv6 优先\n"
            fi
        }
        local net_1st_options=(
            "1.IPv4优先"
            "2.IPv6优先|$GREEN"
            "3.IPv6修复|$BLUE"
            "0.返回|$RED"
        )
        
        _IS_BREAK="true"
        print_v4v6_priority
        print_items_list net_1st_options[@] " 🚀 功能菜单:"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) 
            sysctl -w net.ipv6.conf.all.disable_ipv6=1 > /dev/null 2>&1
            echo "已切换为 IPv4 优先"
            _BREAK_INFO=" 已切换为 IPv4 优先！"
            ;;
        2) 
            sysctl -w net.ipv6.conf.all.disable_ipv6=0 > /dev/null 2>&1
            echo "已切换为 IPv6 优先"
            _BREAK_INFO=" 已切换为 IPv6 优先！"
            ;;
        3) 
            bash <(curl -L -s jhb.ovh/jb/v6.sh)
            # echo "该功能由jhb大神提供，感谢他！"
            _BREAK_INFO=" IPv6 修复成功！(jhb脚本)"
            ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" ;;
        *)  _BREAK_INFO=" 请输入正确选项！" ;;
        esac 
    }
    function sys_setting_bbrv3_manage(){        
        local cpu_arch=$(uname -m)
        if [ "$cpu_arch" = "aarch64" ]; then
            bash <(curl -sL jhb.ovh/jb/bbrv3arm.sh)
            _BREAK_INFO=" 系统为ARM架构,已使用jhb的bbrv3arm.sh安装BBRv3内核" 
            _IS_BREAK="true" 
            case_end_tackle 
            continue 
        fi

        if dpkg -l | grep -q 'linux-xanmod'; then
            local bbrv3_1st_options=(
                "1.更新BBRv3"
                "2.卸载BBRv3"
                "0.返回"
            )
            
            _IS_BREAK="true"
            local kernel_version=$(uname -r)
            echo -e "\n$TIP 系统已安装xanmod的BBRv3内核"
            echo -e "\n$PRIGHT 当前内核版本: $kernel_version"
            print_items_list bbrv3_1st_options[@] " ⚓ BBRv3功能选项:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                apt purge -y 'linux-*xanmod1*'
                update-grub

                # wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
                wget -qO - ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

                # 步骤3：添加存储库
                echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

                # version=$(wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')
                local version=$(wget -q ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

                apt update -y
                apt install -y linux-xanmod-x64v$version

                echo "XanMod内核已更新。重启后生效"
                rm -f /etc/apt/sources.list.d/xanmod-release.list
                rm -f check_x86-64_psabi.sh*

                _BREAK_INFO=" 已更新 linux-xammod1内核 ！"
                _IS_BREAK="false"
                case_end_tackle 
                sys_reboot 
                continue 
                ;;
            2) 
                apt purge -y 'linux-*xanmod1*'
                update-grub 
                echo "XanMod内核已卸载。重启后生效"
                _BREAK_INFO=" XanMod内核已卸载。重启后生效"
                _IS_BREAK="false"
                case_end_tackle 
                sys_reboot 
                continue 
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;; 
            esac 
        else
            clear
            echo -e "$PRIGHT 设置BBR3加速 "
            echo -e "========================================================="
            echo -e " 仅支持[Debian|Ubuntu|Alpine]"
            echo -e " 请备份数据，将为你升级Linux内核开启BBR3"
            echo -e " 若系统内存为${RED}512M${RESET}，请提前添加1G虚拟内存，以防机器失联！"
            echo -e "========================================================="
            local CHOICE=$(echo -e "\n${BOLD}└─ 确定继续安装BBRv3? [Y/n] ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
            case "$INPUT" in
            [Yy] | [Yy][Ee][Ss])
                if [ -r /etc/os-release ]; then
                    . /etc/os-release
                    if [ "$ID" == "alpine" ]; then
                        bbr_on
                        _BREAK_INFO=" 当前为Alpine系统"
                        _IS_BREAK="false"
                        case_end_tackle
                        sys_reboot
                        continue
                    elif [ "$ID" != "debian" ] && [ "$ID" != "ubuntu" ]; then
                        _BREAK_INFO=" 当前环境不支持, 仅支持Alpine,Debian和Ubuntu系统"
                        _IS_BREAK="true"
                        case_end_tackle
                        continue
                    fi                        
                else
                    echo "无法确定操作系统类型"
                    _BREAK_INFO=" 无法确定操作系统类型"
                    _IS_BREAK="true"
                    case_end_tackle
                    continue
                fi

                check_swap
                app_install wget gnupg

                local url=$(get_proxy_url "https://raw.githubusercontent.com/kejilion/sh/main/archive.key")
                wget -qO - ${url} | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

                # 步骤3：添加存储库
                echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

                local url=$(get_proxy_url "https://raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh")
                local version=$(wget -q ${url} && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

                apt update -y
                apt install -y linux-xanmod-x64v$version

                bbr_on

                rm -f /etc/apt/sources.list.d/xanmod-release.list
                rm -f check_x86-64_psabi.sh*
                _BREAK_INFO=" XanMod内核安装并BBR3启用成功。重启后生效"
                _IS_BREAK="false"
                sys_reboot
                continue
                ;;
            [Nn] | [Nn][Oo])
                _BREAK_INFO=" 已取消"
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 无效的选择。"
                _IS_BREAK="true"
                ;;
            esac
        fi             
    }
    function sys_setting_beautify_cmd_style(){
            function print_better_cmd_style_options(){
                echo -e ""
                # echo -e "  1. \033[1;32mroot@\033[1;34mlocalhost \033[1;31m~ ${RESET}#"
                # echo -e "  2. \033[1;35mroot@\033[1;36mlocalhost \033[1;33m~ ${RESET}#"
                # echo -e "  3. \033[1;31mroot@\033[1;32mlocalhost \033[1;34m~ ${RESET}#"
                # echo -e "  4. \033[1;36mroot@\033[1;33mlocalhost \033[1;37m~ ${RESET}#"
                # echo -e "  5. \033[1;37mroot@\033[1;31mlocalhost \033[1;32m~ ${RESET}#"
                # echo -e "  6. \033[1;33mroot@\033[1;34mlocalhost \033[1;35m~ ${RESET}#"
                echo -e "  1. ${FCGR}root@${FCLS}localhost ${FCRE}~ ${RESET}#"  # 绿，  蓝， 红
                echo -e "  2. ${FCZS}root@${FCTL}localhost ${FCYE}~ ${RESET}#"  # 紫，天蓝， 黄 
                echo -e "  3. ${FCRE}root@${FCGR}localhost ${FCLS}~ ${RESET}#"  # 红，  绿， 蓝
                echo -e "  4. ${FCTL}root@${FCYE}localhost ${FCQH}~ ${RESET}#"  # 天蓝，黄，浅灰
                echo -e "  5. ${FCQH}root@${FCRE}localhost ${FCGR}~ ${RESET}#"  # 浅灰，红， 绿
                echo -e "  6. ${FCYE}root@${FCLS}localhost ${FCZS}~ ${RESET}#"  # 黄，  蓝， 紫
                echo -e "  7. root@localhost ~ #"
                echo -e "  0. 返回"
            }
            
            function shell_custom_style_profile() {
                local ss="$1"
                if command -v dnf &>/dev/null || command -v yum &>/dev/null; then
                    sed -i '/^PS1=/d' ~/.bashrc
                    echo "${ss}" >> ~/.bashrc
                    # source ~/.bashrc
                else
                    sed -i '/^PS1=/d' ~/.profile
                    echo "${ss}" >> ~/.profile
                    # source ~/.profile
                fi
                hash -r
            }

            _IS_BREAK="true"
            print_better_cmd_style_options
            local CHOICE=$(echo -e "\n${BOLD}└─ 选择命令行样式? ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                local bianse="PS1='\[\033[1;32m\]\u\[\033[0m\]@\[\033[1;34m\]\h\[\033[0m\] \[\033[1;31m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(绿，  蓝， 红)，重启终端后生效"
                ;;
            2) 
                local bianse="PS1='\[\033[1;35m\]\u\[\033[0m\]@\[\033[1;36m\]\h\[\033[0m\] \[\033[1;33m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(紫，天蓝， 黄 )，重启终端后生效"
                ;;
            3) 
                local bianse="PS1='\[\033[1;31m\]\u\[\033[0m\]@\[\033[1;32m\]\h\[\033[0m\] \[\033[1;34m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(红，绿， 蓝)，重启终端后生效"
                ;;
            4) 
                local bianse="PS1='\[\033[1;36m\]\u\[\033[0m\]@\[\033[1;33m\]\h\[\033[0m\] \[\033[1;37m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(天蓝，黄，浅灰 )，重启终端后生效"
                ;;
            5) 
                local bianse="PS1='\[\033[1;37m\]\u\[\033[0m\]@\[\033[1;31m\]\h\[\033[0m\] \[\033[1;32m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(浅灰，红， 绿 )，重启终端后生效"
                ;;
            6) 
                local bianse="PS1='\[\033[1;33m\]\u\[\033[0m\]@\[\033[1;34m\]\h\[\033[0m\] \[\033[1;35m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(黄，  蓝， 紫 )，重启终端后生效"
                ;;
            7) 
                shell_custom_style_profile ''
                _BREAK_INFO=" 命令行无样式，重启终端后生效"
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;; 
            esac 
    }

    while true; do
        print_menu_system_tools
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1 ) sys_setting_change_root_password ;;
        2 ) sys_setting_enable_root ;;
        3 ) sys_setting_disable_root ;;
        4 ) sys_setting_alter_sources ;;
        5 ) sys_setting_dns_manage ;;
        6 ) sys_setting_change_change_hostname ;;
        7 ) sys_setting_alter_timezone ;;
        8 ) sys_setting_users_manage ;;
        9 ) sys_setting_change_ports_manage ;;
        10) srv_manage_menu ;;
        21) sys_setting_dd_system ;;
        22) sys_setting_alter_swap ;;
        23) sys_setting_enable_ssh_reproxy ;;
        24) sys_setting_alter_priority_v4v6 ;;
        25) sys_setting_bbrv3_manage ;;
        27) sys_setting_beautify_cmd_style ;;
        28) set_qiq_alias 1 && _BREAK_INFO=" 成功设置qiq快捷命令 " ;;
        29) del_qiq_alias && _BREAK_INFO=" 成功删除qiq快捷命令 " ;;
        xx) sys_reboot ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" && break ;;
        *)  _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！" && _IS_BREAK="true" ;;
        esac
        case_end_tackle
    done

}


# 定义性能测试数组
MENU_COMMONLY_TOOLS_ITEMS=(
    "1|curl|$WHITE"
    "2|wget|$WHITE"
    "3|gdu|$MAGENTA"
    "4|btop|$WHITE"
    "5|htop|$WHITE"
    "6|iftop|$WHITE"
    "7|unzip|$WHITE"
    "8|Fail2Ban|$YELLOW"
    "9|SuperVisor|$YELLOW"
    "………………………|$WHITE" 
    "21|安装常用|$CYAN"
    "22|安装指定|$WHITE" 
    "23|卸载指定|$WHITE"
    "24|全部安装|$CYAN"
    "25|全部卸载|$WHITE"
    "………………………|$WHITE" 
    "31|贪吃蛇|$WHITE"
    "32|俄罗期方块|$WHITE"
    "33|太空入侵者|$WHITE"
    "34|跑火车屏保(sl)|$WHITE"
    "35|黑客帝国屏保(cmatrix)|$WHITE"
    "36|最新天气☀|$WHITE"
)

function commonly_tools_menu(){
    function print_menu_common_tools(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        # local num_split=$MAX_SPLIT_CHAR_NUM
        local num_split=40
        print_sub_head "▼ 常用工具 " $num_split 1 0 
        split_menu_items MENU_COMMONLY_TOOLS_ITEMS[@]
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    while true; do
        print_menu_common_tools
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) 
            local app_name='curl'
            app_install ${app_name}
            echo -e "\n $PRIGHT ${app_name}已安装："
            _IS_BREAK='true'
            ;;
        2) 
            local app_name='wget'
            app_install ${app_name}
            echo -e "\n $PRIGHT ${app_name}已安装："
            app_install wget 
            _IS_BREAK='true'
            ;;
        3) 
            local app_name='gdu'
            app_install ${app_name}
            echo -e "\n $PRIGHT ${app_name}已安装："
            app_install gdu 
            _IS_BREAK='true'
            ;;
        4) 
            local app_name='btop'
            app_install ${app_name}
            echo -e "\n $PRIGHT ${app_name}已安装："
            app_install btop 
            _IS_BREAK='true'
            ;;
        5) 
            local app_name='htop'
            app_install ${app_name}
            echo -e "\n $PRIGHT ${app_name}已安装："
            app_install htop 
            _IS_BREAK='true'
            ;;
        6) 
            local app_name='iftop'
            app_install ${app_name}
            echo -e "\n $PRIGHT ${app_name}已安装："
            app_install iftop 
            _IS_BREAK='true'
            ;;
        7) 
            local app_name='unzip'
            app_install ${app_name}
            echo -e "\n $PRIGHT ${app_name}已安装："
            app_install unzip 
            _IS_BREAK='true'
            ;;
        8) 
            local app_name='fail2ban'
            local resp=$(systemctl list-unit-files --type-service | grep ${app_name} )
            if [[ -z resp ]]; then
                app_install ${app_name}
                app_install rsyslog 
                sudo systemctl start ${app_name}
                sudo systemctl enable ${app_name}
                sudo systemctl status ${app_name}
            fi
            echo -e "\n $PRIGHT ${app_name}已安装："
            _IS_BREAK='true'
            ;;
        9) 
            local app_name='supervisor'
            if ! systemctl status ${app_name} > /dev/null 2>&1; then
                app_install ${app_name}
            fi
            echo -e "\n $PRIGHT ${app_name}已安装："
            _IS_BREAK='true'
            ;;
        21) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 是否要安装常用的工具(curl wget btop gdu supervisor fail2ban)? [Y/n]: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z $INPUT ]] && INPUT='Y'
            if [[ $INPUT == [Yy] || $INPUT == [Yy][Ee][Ss] ]]; then
                app_install curl 
                app_install wget 
                app_install btop 
                app_install gdu 
                
                app_install supervisor 
                app_install fail2ban 
                app_install rsyslog 
                sudo systemctl start fail2ban
                sudo systemctl enable fail2ban
                sudo systemctl status fail2ban
            fi

            echo -e "\n $PRIGHT 已安装常用工具：(curl wget btop gdu supervisor fail2ban)"
            _IS_BREAK='true'
            ;;
        24) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 是否要安装常用的工具(wget btop gdu supervisor fail2ban)? [Y/n]: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z $INPUT ]] && INPUT='Y'
            if [[ $INPUT == [Yy] || $INPUT == [Yy][Ee][Ss] ]]; then
                # app_install curl 
                app_install wget 
                app_install btop 
                app_install gdu 
                
                app_install supervisor 
                app_install fail2ban 
                app_install rsyslog 
                sudo systemctl start fail2ban
                sudo systemctl enable fail2ban
                sudo systemctl status fail2ban
            fi

            echo -e "\n $PRIGHT 已安装常用工具：(wget btop gdu supervisor fail2ban)"
            _IS_BREAK='true'
            ;;
        25) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 是否要卸载常用的工具(wget btop gdu supervisor fail2ban)? [Y/n]: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z $INPUT ]] && INPUT='Y'
            if [[ $INPUT == [Yy] || $INPUT == [Yy][Ee][Ss] ]]; then
                # app_remove curl 
                app_remove wget 
                app_remove btop 
                app_remove gdu 
                
                app_remove supervisor 
                sudo systemctl stop fail2ban
                app_remove fail2ban 
                app_remove rsyslog 

                sys_clean
            fi

            echo -e "\n $PRIGHT 已卸载常用工具：(wget btop gdu supervisor fail2ban)"
            _IS_BREAK='true'
            ;;
        22) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 输入要安装的名称: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -n $INPUT ]] && app_install $INPUT
            echo -e "\n $PRIGHT ${INPUT}已安装："
            _IS_BREAK='true'
            ;;
        23) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 输入要卸载的名称: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -n $INPUT ]] && app_remove $INPUT
            echo -e "\n $PRIGHT ${INPUT}已卸载："
            _IS_BREAK='true'
            ;;
        31) 
            app_install nsnake 
            clear 
            /usr/games/nsnake
            ;;
        32) 
            app_install bastet 
            clear 
            /usr/games/bastet
            ;;
        33) 
            app_install ninvaders 
            clear 
            /usr/games/ninvaders
            ;;
        34) 
            app_install sl 
            clear 
            /usr/games/sl
            ;;
        35) 
            app_install cmatrix 
            clear 
            cmatrix
            ;;
        36) 
            clear 
            curl wttr.in 
            _IS_BREAK="true"
            _BREAK_INFO=" > curl wttr.in "
            ;;
        xx) sys_reboot ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" && break ;;
        *)  _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！" && _IS_BREAK="true" ;;
        esac
        case_end_tackle
    done

}


# 常用面板和软件 
MENU_SERVICE_TOOLS_ITEMS=(
    "1|1Panel|$YELLOW"
    "2|aaPanel|$WHITE"
    "3|Ajenti|$WHITE"
    "4|Cockpit|$WHITE"
    "5|VestaCP|$WHITE"
    "6|HestiaCP|$CYAN"
    "7|CloudPanel|$CYAN"
    "8|Cyberpanel|$WHITE"
    "9|NginxGUI|$GREEN"
    "10|OpenLiteSpeed|$WHITE"
    "………………………|$WHITE" 
    "21|Redis|$CYAN"
    "22|MySQL|$WHITE"
    "23|MariaDB|$WHITE"
    "24|PostgreSQL|$WHITE"
    "25|frps|$WHITE"
    "26|frpc|$WHITE"
    "27|Lucky|$WHITE"
    "28|Nezha|$WHITE"
    "29|Chrome|$WHITE"
    "30|Coder|$WHITE"
    "31|Code Server|$YELLOW"
    "32|Akile Monitor|$WHITE"
    "………………………|$WHITE" 
    "41|RustDesk|$WHITE"
    "42|SubLinkX|$WHITE"
    "43|DeepLX|$WHITE"
    "44|iyCMS|$GREEN"
    "45|V2RayA|$WHITE"
    "46|Singbox(@farsman)|$YELLOW"
    "47|Singbox(@ygkkk)|$WHITE"
    "48|Warp(@farsman)|$YELLOW"
    "49|Warp(@ygkkk)|$YELLOW"
    "50|Warp(@hamid)|$WHITE"
)

function service_tools_menu(){
    function print_menu_service_tools(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        # local num_split=$MAX_SPLIT_CHAR_NUM
        local num_split=40
        print_sub_head "▼ 服务工具 " $num_split 1 0 
        split_menu_items MENU_SERVICE_TOOLS_ITEMS[@] 1 30
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }
    
    # 获取当前系统类型
    function get_system_type() {
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [ "$ID" == "centos" ]; then
                echo "centos"
            elif [ "$ID" == "ubuntu" ]; then
                echo "ubuntu"
            elif [ "$ID" == "debian" ]; then
                echo "debian"
            else
                echo "unknown"
            fi
        else
            echo "unknown"
        fi
    }

    function tools_install_1panel(){
        _IS_BREAK="true"
        local app_name='1Panel'
        if command -v 1pctl &> /dev/null; then
            ## 系统已安装1Panel
            _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
        else 
            ## 系统未安装1Panel
            local system_type=$(get_system_type)
            local CHOICE=$(echo -e "\n${BOLD}└─ 确定安装${app_name}吗? (Y/n): ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "${INPUT}" ]] && INPUT="Y" 
            case "$INPUT" in
            [Yy] | [Yy][Ee][Ss])
                # sys_update 
                _BREAK_INFO=" 成功安装${app_name}!"
                if [ "$system_type" == "centos" ]; then
                    curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
                elif [ "$system_type" == "ubuntu" ]; then
                    curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
                elif [ "$system_type" == "debian" ]; then
                    curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
                else
                    bash <(curl -sSL https://linuxmirrors.cn/docker.sh) && curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
                fi
                ;;
            [Nn] | [Nn][Oo])
                _BREAK_INFO=" 取消安装${app_name}!"
                ;;
            *) 
                _BREAK_INFO=" 输入错误，请重新输入!"
                ;;
            esac
        fi     
    }

    function tools_install_aaPanel(){
        _IS_BREAK="true"
        local app_name='aaPanel'
        if [ -f "/etc/init.d/bt" ] && [ -d "/www/server/panel" ]; then
            _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
        else 
            local system_type=$(get_system_type)
            local CHOICE=$(echo -e "\n${BOLD}└─ 确定安装${app_name}吗? (Y/n): ${PLAIN}")
            [[ -z "${INPUT}" ]] && INPUT="Y" 
            read -rp "${CHOICE}" INPUT
            case "$INPUT" in
            [Yy] | [Yy][Ee][Ss])
                # sys_update 
                app_install wget 
                _BREAK_INFO=" 成功安装: ${app_name}!"
                if [ "$system_type" == "centos" ]; then
                    yum install -y wget && wget -O install.sh http://www.aapanel.com/script/install_6.0_en.sh && bash install.sh aapanel
                elif [ "$system_type" == "ubuntu" ]; then
                    wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh aapanel
                elif [ "$system_type" == "debian" ]; then
                    wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh aapanel
                else
                    _BREAK_INFO=" 不支持的系统类型(Debian|Ubuntu|CentOS), aaPanel安装取消!"
                fi
                ;;
            [Nn] | [Nn][Oo])
                _BREAK_INFO=" 取消安装: ${app_name}!"
                ;;
            *) 
                _BREAK_INFO=" 输入错误，请重新输入!"
                ;;
            esac
        fi        
    }

    function tools_install_ajenti(){
            _IS_BREAK="true"
            local app_name='Ajenti'
            if systemctl status ajenti.service &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            else 
                local system_type=$(get_system_type)
                local CHOICE=$(echo -e "\n${BOLD}└─ 确定安装${app_name}吗? (Y/n): ${PLAIN}")
                [[ -z "${INPUT}" ]] && INPUT="Y" 
                read -rp "${CHOICE}" INPUT
                case "$INPUT" in
                [Yy] | [Yy][Ee][Ss])
                    _BREAK_INFO=" 成功安装${app_name}!"
                    # https://docs.ajenti.org/en/latest/man/install.html
                    # curl https://raw.githubusercontent.com/ajenti/ajenti/master/scripts/install-venv.sh | sudo bash -s -
                    local url=$(get_proxy_url 'https://raw.githubusercontent.com/ajenti/ajenti/master/scripts/install.sh')
                    curl $url | sudo bash -s -

                    ;;
                [Nn] | [Nn][Oo])
                    _BREAK_INFO=" 取消安装${app_name}!"
                    ;;
                *) 
                    _BREAK_INFO=" 输入错误，请重新输入!"
                    ;;
                esac
            fi        

    }
    function tools_install_cockpit(){
            _IS_BREAK="true"
            local app_name='Cockpit'
            if systemctl status cockpit.socket &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            else 
                local system_type=$(get_system_type)
                local CHOICE=$(echo -e "\n${BOLD}└─ 确定安装${app_name}吗? (Y/n): ${PLAIN}")
                [[ -z "${INPUT}" ]] && INPUT="Y" 
                read -rp "${CHOICE}" INPUT
                case "$INPUT" in
                [Yy] | [Yy][Ee][Ss])
                    _BREAK_INFO=" 成功安装${app_name}!"
                    # https://cockpit-project.org/running.html
                    # http://localip:9090
                    # systemctl start --now cockpit.socket
                    # systemctl enable --now cockpit.socket
                    sys_update 
                    app_install cockpit && systemctl start --now cockpit.socket && systemctl enable --now cockpit.socket
                    # app_install cockpit* # 安装所有相关的插件 
                    ;;
                [Nn] | [Nn][Oo])
                    _BREAK_INFO=" 取消安装${app_name}!"
                    ;;
                *) 
                    _BREAK_INFO=" 输入错误，请重新输入!"
                    ;;
                esac
            fi        
        
    }

    function tools_install_vestacp(){
            _IS_BREAK="true"
            local app_name='HestiaCP'
                    _BREAK_INFO=" 尚未实现VestaCP的安装!"
        
    }

    function tools_install_hestiacp(){
            _IS_BREAK="true"
            local app_name='HestiaCP'
            # if [ -f "/etc/init.d/bt" ] && [ -d "/www/server/panel" ]; then
            #     _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            # else 
                local system_type=$(get_system_type)
                local CHOICE=$(echo -e "\n${BOLD}└─ 确定安装${app_name}吗? (Y/n): ${PLAIN}")
                [[ -z "${INPUT}" ]] && INPUT="Y" 
                read -rp "${CHOICE}" INPUT
                case "$INPUT" in
                [Yy] | [Yy][Ee][Ss])
                    # https://hestiacp.com/docs/introduction/getting-started.html
                    # https://hestiacp.com/install 
                    # sys_update 
                    app_install wget 
                    local url=$(get_proxy_url 'https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh')
                    wget $url && apt-get update && apt-get install ca-certificates && bash hst-install.sh
                    _BREAK_INFO=" 成功安装: ${app_name}!"

                    ;;
                [Nn] | [Nn][Oo])
                    _BREAK_INFO=" 取消安装: ${app_name}!"
                    ;;
                *) 
                    _BREAK_INFO=" 输入错误，请重新输入!"
                    ;;
                esac
            # fi        
    }

    function tools_install_cloudpanel(){
            _IS_BREAK="true"
            local app_name='CloudPanel'
            if systemctl status ajenti.service &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            else 
                local system_type=$(get_system_type)
                local CHOICE=$(echo -e "\n${BOLD}└─ 确定安装${app_name}吗? (Y/n): ${PLAIN}")
                [[ -z "${INPUT}" ]] && INPUT="Y" 
                read -rp "${CHOICE}" INPUT
                case "$INPUT" in
                [Yy] | [Yy][Ee][Ss])
                    _BREAK_INFO=" 成功安装${app_name}!"
                    # https://www.cloudpanel.io/docs/v2/getting-started/other/
                    # https://yourIpAddress:8443
                    echo -e "$PRIGHT 1. MySQL 8.0"
                    echo -e "$PRIGHT 2. MariaDB 11.4"
                    local CHOICE=$(echo -e "\n${BOLD}└─ 请选择要安装的数据库(默认MySQL): ${PLAIN}")
                    read -rp "${CHOICE}" INPUT
                    [[ -z "$INPUT" ]] && INPUT="1"
                    case "$INPUT" in
                    1) 
                        local url=$(get_proxy_url 'https://installer.cloudpanel.io/ce/v2/install.sh')
                        curl -sS $url -o install.sh; \
                        echo "a3ba69a8102345127b4ae0e28cfe89daca675cbc63cd39225133cdd2fa02ad36 install.sh" | \
                        sha256sum -c && sudo bash install.sh
                        _BREAK_INFO=" 成功安装${app_name}(MySQL 8.0)!"
                        ;;
                    2) 
                        local url=$(get_proxy_url 'https://installer.cloudpanel.io/ce/v2/install.sh')
                        curl -sS $url -o install.sh; \
                        echo "a3ba69a8102345127b4ae0e28cfe89daca675cbc63cd39225133cdd2fa02ad36 install.sh" | \
                        sha256sum -c && sudo bash install.sh
                        _BREAK_INFO=" 成功安装${app_name}(MariaDB 11.4)!"
                        ;;
                    *) 
                        _BREAK_INFO=" 输入错误，请重新输入!"
                        ;;
                    esac 

                    # 安装MariaDb数据库 
                    # curl -sS $url -o install.sh; \
                    # echo "a3ba69a8102345127b4ae0e28cfe89daca675cbc63cd39225133cdd2fa02ad36 install.sh" | \
                    # sha256sum -c && sudo DB_ENGINE=MARIADB_11.4 bash install.sh
                    ;;
                [Nn] | [Nn][Oo])
                    _BREAK_INFO=" 取消安装${app_name}!"
                    ;;
                *) 
                    _BREAK_INFO=" 输入错误，请重新输入!"
                    ;;
                esac
            fi        
        
    }

    function tools_install_cyberpanel(){
            _IS_BREAK="true"
            local app_name='CyberPanel'
            if systemctl status ajenti.service &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            else 
                local system_type=$(get_system_type)
                local CHOICE=$(echo -e "\n${BOLD}└─ 确定安装${app_name}吗? (Y/n): ${PLAIN}")
                [[ -z "${INPUT}" ]] && INPUT="Y" 
                read -rp "${CHOICE}" INPUT
                case "$INPUT" in
                [Yy] | [Yy][Ee][Ss])
                    _BREAK_INFO=" 成功安装${app_name}!"
                    # https://cyberpanel.net/KnowledgeBase/home/install-cyberpanel/
                    # https://github.com/usmannasir/cyberpanel
                    # https://yourIpAddress:8443
                    # Ubuntu 18.04, Ubuntu 20.04, AlmaLinux 8, AlmaLinux 9, Ubuntu 22.04, CloudLinux 8. 1024MB RAM, or higher
                    local url_install='https://cyberpanel.net/install.sh'
                    local url_update=$(get_proxy_url 'https://raw.githubusercontent.com/usmannasir/cyberpanel/stable/preUpgrade.sh')
                    sh <(curl $url_install || wget -O - $url_install)
                    # sh <(curl $url_update || wget -O - $url_update)
                    ;;
                [Nn] | [Nn][Oo])
                    _BREAK_INFO=" 取消安装${app_name}!"
                    ;;
                *) 
                    _BREAK_INFO=" 输入错误，请重新输入!"
                    ;;
                esac
            fi        
    }

    function tools_install_redis(){
            local app_name='Redis'
            local app_cmd='redis'
            _IS_BREAK="true"
            _BREAK_INFO=" 由${app_name}返回！"
            function print_app_usage(){
                echo -e "\n${BOLD} ${PRIGHT} ${app_name}使用说明: ${PLAIN}\n"
                # echo -e " > WebURL: https://coder.com/   "
                echo ""
                [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:6379 "
                [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:6379 "
            }
            
            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}数据库，无需重复安装!"
                # print_app_usage
            else 
                curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
                apt update
                apt install redis
                systemctl start redis-server
                systemctl enable redis-server
                # print_app_usage
                _BREAK_INFO=" 成功安装${app_name}数据库！"
            fi 
    }
    function tools_install_mysql(){
            local app_name='MySQL'
            local app_cmd='mysql'
            _IS_BREAK="true"
            _BREAK_INFO=" 由${app_name}返回！"
            # function print_app_usage(){
            #     echo -e "\n${BOLD} ${POINTING} ${app_name}使用说明: ${PLAIN}\n"
            #     # echo -e " > WebURL: https://coder.com/   "
            #     echo ""
            #     [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:6379 "
            #     [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:6379 "
            # }
            
            # if command -v ${app_cmd} &> /dev/null; then
            #     _BREAK_INFO=" 系统已安装${app_name}数据库，无需重复安装!"
            #     # print_app_usage
            # else 
            #     curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
            #     echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
            #     apt update
            #     apt install redis
            #     systemctl start redis-server
            #     systemctl enable redis-server
            #     # print_app_usage
            #     _BREAK_INFO=" 成功安装${app_name}数据库！"
            # fi 
                _BREAK_INFO=" 尚未实现安装${app_name}数据库！"
        
    }
    function tools_install_mariadb(){
            local app_name='MariaDB'
            local app_cmd='mariadb'
            _IS_BREAK="true"
            _BREAK_INFO=" 由${app_name}返回！"
            
            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}数据库，无需重复安装!"
            else                 
                apt install apt-transport-https curl
                mkdir -p /etc/apt/keyrings
                curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'

                cat > /etc/apt/sources.list.d/mariadb.sources << EOF
X-Repolib-Name: MariaDB
Types: deb
# deb.mariadb.org is a dynamic mirror if your preferred mirror goes offline. See https://mariadb.org/mirrorbits/ for details.
URIs: https://deb.mariadb.org/11.2/ubuntu
Suites: jammy
Components: main main/debug
Signed-By: /etc/apt/keyrings/mariadb-keyring.pgp
EOF

                apt update
                apt install mariadb-server
                systemctl start mariadb
                systemctl enable mariadb
                mariadb-secure-installation

                _BREAK_INFO=" 成功安装${app_name}数据库！"
            fi 
    }
    function tools_install_postgresql(){
            local app_name='PostgreSQL'
            local app_cmd='postgresql'
            _IS_BREAK="true"
            _BREAK_INFO=" 由${app_name}返回！"
            
            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}数据库，无需重复安装!"
                postgresql_usage
            else 
                install postgresql-client && apt update && install postgresql
                postgresql_usage
                _BREAK_INFO=" 成功安装${app_name}数据库！"
            fi 
    }
    function tools_install_frps(){
        _IS_BREAK="true"
        local app_name='frps'
        local app_cmd='frps'
        function print_app_usage(){
            echo -e "\n${BOLD} ${PRIGHT} ${app_name}使用说明: ${PLAIN}\n"
            echo -e " - GitHub: https://github.com/fatedier/frp/ "
            echo -e "" 
            echo -e " > systemctl status ${app_cmd}      # 查看${app_name}服务运行状态"
            echo -e " > systemctl start ${app_cmd}       # 查看${app_name}服务运行状态"
            echo -e " > systemctl stop ${app_cmd}        # 查看${app_name}服务运行状态"
            echo -e " > systemctl restart ${app_cmd}     # 查看${app_name}服务运行状态"
            echo ""
            [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:7500 "
            [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:7500 "
            echo ""
        }
        function download_frp(){
            local arch=$(uname -m)
            local url='https://api.github.com/repos/fatedier/frp/releases/latest'
            local frp_v=$(curl -s $(get_proxy_url $url) | grep -oP '"tag_name": "v\K.*?(?=")')

            if [[ "$arch" == "x86_64" ]]; then
                url=$(get_proxy_url 'https://github.com/fatedier/frp/releases/download')
                curl -L ${url}/v${frp_v}/frp_${frp_v}_linux_amd64.tar.gz -o frp_${frp_v}_linux_amd64.tar.gz
            elif [[ "$arch" == "armv7l" || "$arch" == "aarch64" ]]; then
                curl -L ${url}/v${frp_v}/frp_${frp_v}_linux_arm.tar.gz -o frp_${frp_v}_linux_amd64.tar.gz
            else
                echo " 不支持当前CPU架构: $arch"
                _BREAK_INFO=" 不支持当前CPU架构: $arch!"
                return 1 
            fi

            # 解压 .tar.gz 文件
            app_install tar
            tar -zxvf frp_*.tar.gz
            dir_name=$(tar -tzf frp_*.tar.gz | head -n 1 | cut -f 1 -d '/')
            mv "$dir_name" frp_${frp_v}_linux_amd64
        }

        if systemctl status ${app_cmd} > /dev/null 2>&1; then
            _BREAK_INFO=" ${app_name}服务已安装，无需重复安装!"
            print_app_usage
        else 
            
            print_app_usage
            _BREAK_INFO=" 成功安装: ${app_name}!"
        fi 
        
    }
    function tools_install_frpc(){
        _IS_BREAK="true"
        local app_name='frpc'
        local app_cmd='frpc -c frpc.toml'

        download_github_realease "https://github.com/fatedier/frp" 
        # download_github_realease "https://github.com/fatedier/frp" ".*linux_amd64.tar.gz"
        _BREAK_INFO=" 安装成功: ${app_name}!"
        
    }
    function tools_manage_frp(){
        function print_tools_manage_frp(){
            echo -e ""
            echo -e "$PRIGHT frp内网穿透"
            generate_separator "=" 40
            echo -e " 1.下载最新frp程序"
            echo -e " 2.安装服务frps(服务端)"
            echo -e " 3.卸载服务frps(服务端)"
            echo -e " 4.重启服务frps(服务端)"
            echo -e " 5.查看配置frps(服务端)"
            echo -e " 6.安装服务frpc(客户端)"
            echo -e " 7.卸载服务frpc(客户端)"
            echo -e " 8.重启服务frpc(客户端)"
            echo -e " 9.查看配置frpc(客户端)"
            echo -e " 0.返回"
            generate_separator "=" 40
        }
        while true; do
            _IS_BREAK="true"
            print_tools_manage_frp
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择？(默认官方): ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] &&  INPUT=1
            case "${INPUT}" in 
            1) docker_install_official ;; 
            2) bash <(curl -sSL https://linuxmirrors.cn/docker.sh) ;; 
            3) bash <(curl -sSL https://raw.githubusercontent.com/SuperManito/LinuxMirrors/main/DockerInstallation.sh) ;; 
            4) bash <(curl -sSL https://gitee.com/SuperManito/LinuxMirrors/raw/main/DockerInstallation.sh) ;; 
            5) bash <(curl -sSL https://cdn.jsdelivr.net/gh/SuperManito/LinuxMirrors@main/DockerInstallation.sh) ;; 
            0) _IS_BREAK='false' ;; 
            *) echo -e "\n$WARN 输入错误,返回！"  ;; 
            esac 
            case_end_tackle
        done

    }
    function tools_install_lucky(){
        _IS_BREAK="true"
        local app_name='Lucky'
        local app_cmd='lucky'
        function print_app_usage(){
            echo -e "\n${BOLD} ${PRIGHT} ${app_name}使用说明: ${PLAIN}\n"
            echo -e " > WebURL: https://lucky666.cn "
            echo -e " > GitHub: https://github.com/gdy666/lucky "
            echo -e "" 
            echo -e " > systemctl status ${app_cmd}      # 查看${app_name}服务运行状态"
            echo -e " > systemctl start ${app_cmd}       # 查看${app_name}服务运行状态"
            echo -e " > systemctl stop ${app_cmd}        # 查看${app_name}服务运行状态"
            echo -e " > systemctl restart ${app_cmd}     # 查看${app_name}服务运行状态"
            echo ""
            [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:16601 "
            [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:16601 "
            echo ""
            echo -e " > Login account: 666@666"
            echo ""
        }

        if command -v ${app_cmd} &> /dev/null; then
            _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            print_app_usage
        else 
            local file="lucky.sh"
            local url="https://release.ilucky.net:66/install.sh"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $file 0
            
            print_app_usage
            _BREAK_INFO=" 成功安装: ${app_name}!"
        fi 
        # URL="https://release.ilucky.net:66"; curl -o /tmp/install.sh "$URL/install.sh" && sh /tmp/install.sh "$URL"
        # URL="https://release.ilucky.net:66"; wget -O  /tmp/install.sh "$URL/install.sh" && sh /tmp/install.sh "$URL"
        # curl -o /tmp/install.sh https://6.666666.host:66/files/golucky.sh  && sh /tmp/install.sh https://6.666666.host:66/files 2.11.2
    }
    function tools_install_neza(){
        local app_name='NeZha Monitor'
        local app_cmd='nz'
        _IS_BREAK="true"
        
        local fname="nezha.sh"
        local url="https://raw.githubusercontent.com/nezhahq/scripts/refs/heads/main/install.sh"
        echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
        fetch_script_from_url $url $fname 1
        _BREAK_INFO=" 从${app_name}返回！"
        echo -e "\n $TIP 后续可直接运行脚本: ./${fname}\n"
        # curl -L https://raw.githubusercontent.com/nezhahq/scripts/refs/heads/main/install.sh -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh 
    }
    function tools_install_chrome(){
        _IS_BREAK="true"
        local app_name='Chrome'
        local app_cmd='chrome'

        if command -v ${app_cmd} &> /dev/null; then
            _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
        else 
            _BREAK_INFO=" 成功安装${app_name}！"
            local fname="google-chrome-stable_current_amd64.deb"
            local url="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
            sudo apt-get install -f -y && wget ${url} && sudo dpkg -i ${fname}
            # sudo apt-get install -f -y
            # wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 
            # sudo dpkg -i google-chrome-stable_current_amd64.deb
        fi         
    }
    function tools_install_coder(){
        local app_name='Coder Server'
        local app_cmd='coder server'
        _IS_BREAK="true"
        function print_app_usage(){
            echo -e "\n${BOLD} ${PRIGHT} ${app_name}使用说明: ${PLAIN}\n"
            echo -e " > WebURL: https://coder.com/   "
            echo -e " > WebURL: https://github.com/coder/coder   "
            echo -e " > Docker: https://github.com/coder/coder/blob/main/docker-compose.yaml   "
            echo -e "\n > ${app_cmd}      # 临时启动${app_name}"
            echo -e "\n > sudo systemctl enable --now code-server@$USER # 以当前用户开启${app_name}服务"
            echo ""
            [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:3000 "
            [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:3000 "
        }
        
        if command -v ${app_cmd} &> /dev/null; then
            _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            print_app_usage
        else 
            _BREAK_INFO=" 成功安装${app_name}服务！"

            local file="coder.sh"
            local url="https://coder.com/install.sh"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $file 0
            
            print_app_usage
        fi 
        # curl -L https://coder.com/install.sh | sh ;;
    }
    function tools_install_codeserver(){
        local app_name='Code Server'
        local app_cmd='code-server'
        _IS_BREAK="true"
        function print_app_usage(){
            echo -e "\n${BOLD} ${PRIGHT} ${app_name}使用说明: ${PLAIN}\n"
            echo -e " > WebURL: https://coder.com/   "
            echo -e " > WebURL: https://github.com/coder/coder   "
            echo -e " > GitHub: https://github.com/coder/code-server  "
            echo -e "\n > ${app_cmd}      # 临时启动${app_name}"
            echo -e "\n > sudo systemctl enable --now code-server@$USER # 以当前用户开启${app_name}服务"
            echo ""
            [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:8080 "
            [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:8080 "
        }
        
        if command -v ${app_cmd} &> /dev/null; then
            _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            print_app_usage
        else 
            _BREAK_INFO=" 成功安装${app_name}服务！"

            local file="code-server.sh"
            local url="https://code-server.dev/install.sh"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $file 0
            
            print_app_usage
        fi 
        # curl -fsSL https://code-server.dev/install.sh | sh  ;;
    }
    function tools_install_akilemonitor(){
        local app_name='Akile Monitor'
        local app_cmd='akm'
        _IS_BREAK="true"
        _BREAK_INFO=" 由${app_name}返回！"
        local file="ak-setup.sh"
        local url="https://raw.githubusercontent.com/akile-network/akile_monitor/refs/heads/main/${file}"
        echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
        fetch_script_from_url $url $file 1
    }
    function tools_install_rustdesk(){
        _IS_BREAK="true"
        local app_name='RustDesk'
        local app_cmd='rustdesk'
            _BREAK_INFO=" 由${app_name}返回！"
        local fname="rustdesk.sh"
        local url="https://raw.githubusercontent.com/dinger1986/rustdeskinstall/master/install.sh"
        echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
        fetch_script_from_url $url $fname 0 
        # wget https://raw.githubusercontent.com/dinger1986/rustdeskinstall/master/install.sh && chmod +x install.sh && ./install.sh ;;
    }
    function tools_install_sublinkx(){
        _IS_BREAK="true"
        local app_name='SubLinkX'
        local app_cmd='sublink'
        function print_app_usage(){
            echo -e "\n${BOLD} ${PRIGHT} ${app_name}使用说明: ${PLAIN}"
            echo -e "\n - GitHub: https://github.com/gooaclok819/sublinkX"
            echo -e "\n - ${app_cmd}      # 查看${app_name}管理菜单"
            echo ""
            [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:8000 "
            [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:8000 "
        }

        if command -v ${app_cmd} &> /dev/null; then
            _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            print_app_usage
        else 
            _BREAK_INFO=" 成功安装${app_name}服务！"
            local fname="sublinkx.sh"
            local url="https://raw.githubusercontent.com/gooaclok819/sublinkX/main/install.sh"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 1 
            
            print_app_usage
        fi 
        # curl -s https://raw.githubusercontent.com/gooaclok819/sublinkX/main/install.sh | sudo bash
    }
    function tools_install_deeplx(){
        _IS_BREAK="true"
        local app_name='DeepLX'
        local app_cmd='deeplx'
        function print_app_usage(){
            echo -e "\n${BOLD} ${PRIGHT} ${app_name}使用说明: ${PLAIN}\n"
            echo -e " - WebURL: https://deeplx.owo.network/"
            echo -e " - GitHub: https://github.com/OwO-Network/DeepLX"
            echo ""
            echo -e " > ${app_cmd}      # 查看${app_name}运行状态"
            echo ""
            if [[ -n "$WAN4" ]] ; then
                echo ""
                echo -e " URL: http://$WAN4:1188"
                echo -e " URL: http://$WAN4:1188/translate"
                echo -e " URL: http://$WAN4:1188/v1/translate"
                echo -e " URL: http://$WAN4:1188/v2/translate"
            fi
            if [[ -n "$WAN6" ]] ; then
                echo ""
                echo -e " URL: http://[$WAN6]:1188"
                echo -e " URL: http://[$WAN6]:1188/translate"
                echo -e " URL: http://[$WAN6]:1188/v1/translate"
                echo -e " URL: http://[$WAN6]:1188/v2/translate"
            fi
            # [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:1188 "
        }

        if command -v deeplx &> /dev/null; then
            _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            print_app_usage
        else 
            _BREAK_INFO=" 成功安装${app_name}服务！"
            local fname="deeplx.sh"
            local url="https://raw.githubusercontent.com/OwO-Network/DeepLX/main/install.sh"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 1 
            
            print_app_usage
        fi 
        # bash <(curl -Ls https://ssa.sx/dx)
        # bash <(curl -Ls https://raw.githubusercontent.com/OwO-Network/DeepLX/main/install.sh)
    }
    function tools_install_iycms(){
        _IS_BREAK="true"
        local app_name='爱影CMS'
        local app_cmd='iycms'
        function print_app_usage(){
            echo -e "\n${BOLD} ${PRIGHT} ${app_name}使用说明: ${PLAIN}\n"
            echo -e " - WebURL: https://iycms.com/index.html"
            echo -e "" 
            echo -e " > systemctl status ${app_cmd}      # 查看${app_name}服务运行状态"
            echo -e " > systemctl start ${app_cmd}       # 查看${app_name}服务运行状态"
            echo -e " > systemctl stop ${app_cmd}        # 查看${app_name}服务运行状态"
            echo -e " > systemctl restart ${app_cmd}     # 查看${app_name}服务运行状态"
            echo ""
            [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:21007 "
            [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:21007 "
        }

        if systemctl status iycms > /dev/null 2>&1; then
            _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            print_app_usage
        else 
            local file="lucky.sh"
            local url="https://www.iycms.com/api/static/down/linux/ubuntu/install_x86_64.sh"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $file 0
            
            print_app_usage
            _BREAK_INFO=" 成功安装: ${app_name}"
        fi 
    }
    function tools_install_v2raya(){
        _IS_BREAK="true"
        local app_name='V2RayA'
        local app_cmd='v2raya'
            _BREAK_INFO=" 由${app_name}返回！"
        function print_app_usage(){
            echo -e "\n${BOLD} ${PRIGHT} ${app_name}使用说明: ${PLAIN}\n"
            echo -e " - WebURL: https://v2raya.org/"
            echo -e " - GitHub: https://github.com/v2rayA/v2rayA-installer"
            echo ""
            echo -e " > ${app_cmd}      # 查看${app_name}管理菜单"
            echo -e " > sudo systemctl start v2raya.service      # 启动${app_name}服务"
            echo -e " > sudo systemctl enable v2raya.service     # 设置${app_name}自启动"
            echo -e " > v2raya-reset-password                    # 重新设置${app_name}密码"
            echo -e " > /usr/local/etc/v2raya                    # 配置文件目录"
            echo ""
            [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:2017 "
            [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:2017 "
        }

        # wget -qO - https://apt.v2raya.org/key/public-key.asc | sudo tee /etc/apt/keyrings/v2raya.asc
        # echo "deb [signed-by=/etc/apt/keyrings/v2raya.asc] https://apt.v2raya.org/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list
        # sudo apt update
        # sudo apt install v2raya v2ray ## 也可以使用 xray 包
        # sudo systemctl start v2raya.service
        # sudo systemctl enable v2raya.service
        function start_v2ray_service(){
            
            local CHOICE=$(echo -e "\n${BOLD}└─ 是否启动${app_name}服务? [Y/n] ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
            case "${INPUT}" in
            [Yy] | [Yy][Ee][Ss])
                echo -e "\n$TIP 启动服务 ...\n"
                sudo systemctl start v2raya.service
                _BREAK_INFO=" 服务启动中 ..."
                ;;
            [Nn] | [Nn][Oo])
                echo -e "\n$TIP 不启动服务！"
                ;;
            *)
                echo -e "\n$WARN 输入错误！"
                _BREAK_INFO=" 输入错误，不重启系统！"
                _IS_BREAK="true"
                ;;
            esac

            local CHOICE=$(echo -e "\n${BOLD}└─ 是否设置${app_name}服务自启动? [Y/n] ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
            case "${INPUT}" in
            [Yy] | [Yy][Ee][Ss])
                echo -e "\n$TIP 设置自启动服务 ...\n"
                sudo systemctl enable v2raya.service
                _BREAK_INFO=" 设置服务自启动成功 ..."
                ;;
            [Nn] | [Nn][Oo])
                echo -e "\n$TIP 不启动服务！"
                ;;
            *)
                echo -e "\n$WARN 输入错误！"
                _BREAK_INFO=" 输入错误，不重启系统！"
                _IS_BREAK="true"
                ;;
            esac
        }

        local v2raya_options_list=(
            "1. 安装 V2RayA(v2ray)"
            "2. 安装 V2RayA(xray)"
            "3. 卸载 V2RayA"
            "0. 退出"
        )

        local fname="v2raya-installer.sh"
        local url="https://github.com/v2rayA/v2rayA-installer/raw/main/installer.sh"
        url=$(get_proxy_url "$url")

        print_items_list v2raya_options_list[@] " ⚓ ${app_name}菜单"
        local CHOICE=$(echo -e "\n${BOLD}└─ 输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) 
            _BREAK_INFO=" 成功安装${app_name}(v2ray内核)！"                
            sudo sh -c "$(wget -qO- ${url})" @ --with-v2ray
            print_app_usage
            start_v2ray_service
            ;;
        2) 
            _BREAK_INFO=" 成功安装${app_name}(xray内核)！"
            sudo sh -c "$(wget -qO- ${url})" @ --with-xray
            print_app_usage
            start_v2ray_service
            ;;
        3) 
            local fname="v2raya-uninstaller.sh"
            local url="https://github.com/v2rayA/v2rayA-installer/raw/main/uninstaller.sh"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 1 

            # sudo sh -c "$(wget -qO- ${url})"
            _BREAK_INFO=" 成功卸载${app_name}！"
            ;;
        0) 
            echo -e "\n$TIP 返回主菜单 ..."
            _IS_BREAK="false"
            ;;
        *)
            _BREAK_INFO=" 请输入正确选项！"
            ;;
        esac             
    }
    function tools_install_sbfarsman(){
        _IS_BREAK="true"
        local app_name='Singbox'
        local app_cmd='sb'
            _BREAK_INFO=" 由${app_name}返回！"
        local fname="sing-box.sh"
        local url="https://raw.githubusercontent.com/fscarmen/sing-box/main/${fname}"
        echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
        fetch_script_from_url $url $fname 1
    }
    function tools_install_sbygkkk(){
        _IS_BREAK="true"
        local app_name='Singbox(yg)'
        local app_cmd='sb'
            _BREAK_INFO=" 由${app_name}返回！"
        local fname="sb.sh"
        local url="https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh"
        echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
        fetch_script_from_url $url $fname 1 
    }
    function tools_install_warpfarsman(){
        _IS_BREAK="true"
        local app_name='Warp'
        local app_cmd='warp'
            _BREAK_INFO=" 由${app_name}返回！"
        local fname="menu.sh"
        local url="https://gitlab.com/fscarmen/warp/-/raw/main/${fname}"
        echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
        fetch_script_from_url $url $fname 0 
    }
    function tools_install_warpygkkk(){
        _IS_BREAK="true"
        local app_name='Warp(yg)'
        local app_cmd='sb'
            _BREAK_INFO=" 由${app_name}返回！"
        local fname="sb-yg.sh"
        local url="https://gitlab.com/rwkgyg/CFwarp/raw/main/CFwarp.sh"
        echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
        fetch_script_from_url $url $fname 0 
    }
    function tools_install_warphamid(){
        _IS_BREAK="true"
        local app_name='Warp(hamid)'
        local app_cmd='warp'
            _BREAK_INFO=" 由${app_name}返回！"
        local fname="warp_proxy.sh"
        local ghurl="https://github.com/hamid-gh98"
        local url="https://raw.githubusercontent.com/hamid-gh98/x-ui-scripts/main/install_warp_proxy.sh"
        echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
        fetch_script_from_url $url $fname 1  
    }
    function tools_install_openlitespeed(){
        _IS_BREAK="true"
        local app_name='OpenLiteSpeed(ols1clk)'
        local app_cmd='openlitespeed'
            _BREAK_INFO=" 由${app_name}返回！"
        local fname="ols1clk.sh"
        local ghurl="https://github.com/litespeedtech/ols1clk"
        local url="https://raw.githubusercontent.com/litespeedtech/ols1clk/master/ols1clk.sh"
        echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
        fetch_script_from_url $url $fname 1  
        # bash <( curl -k https://raw.githubusercontent.com/litespeedtech/ols1clk/master/ols1clk.sh )
    }
    function tools_install_nginxgui(){
        _IS_BREAK="true"
        local app_name='NginxGUI'
        local app_cmd='nginxgui'
            _BREAK_INFO=" 由${app_name}返回！"
        local fname="nginxgui_install.sh"
        local ghurl="https://github.com/0xJacky/nginx-ui"
        local url="https://raw.githubusercontent.com/0xJacky/nginx-ui/main/install.sh"
        echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
        fetch_script_from_url $url $fname 1  " @ install"
        # bash -c "$(curl -L https://raw.githubusercontent.com/0xJacky/nginx-ui/main/install.sh)" @ install
    }

    while true; do
        print_menu_service_tools

        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1 ) tools_install_1panel ;;
        2 ) tools_install_aaPanel ;;
        3 ) tools_install_ajenti ;;
        4 ) tools_install_cockpit ;;
        6 ) tools_install_hestiacp ;;
        7 ) tools_install_cloudpanel ;;
        8 ) tools_install_cyberpanel ;;
        9 ) tools_install_nginxgui  ;;
        10) tools_install_openlitespeed ;;
        21) tools_install_redis ;; 
        22) tools_install_mysql ;; 
        23) tools_install_mariadb ;; 
        24) tools_install_postgresql ;; 
        25) tools_install_frps ;; 
        26) tools_install_frpc ;; 
        27) tools_install_lucky ;; 
        28) tools_install_neza ;; 
        29) tools_install_chrome ;; 
        30) tools_install_coder ;; 
        31) tools_install_codeserver ;; 
        32) tools_install_akilemonitor ;; 
        41) tools_install_rustdesk ;; 
        42) tools_install_sublinkx ;; 
        43) tools_install_deeplx ;; 
        44) tools_install_iycms ;; 
        45) tools_install_v2raya ;; 
        46) tools_install_sbfarsman ;; 
        47) tools_install_sbygkkk;; 
        48) tools_install_warpfarsman ;; 
        49) tools_install_warpygkkk ;; 
        50) tools_install_warphamid ;; 
        xx) sys_reboot ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" && break ;;
        *)  _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！" && _IS_BREAK="true" ;;
        esac
        case_end_tackle
    done

}


# 其他常用脚本 
MENU_OTHER_SCRIPTS_ITEMS=(
    "1|KijiLion|$YELLOW"
    "2|YiDian(docker)|$WHITE"
    "3|YiDian(Nginx)|$WHITE"
    "4|YiDian(Serv00)|$WHITE"
    "5|LinuxMirrors|$MAGENTA"
    "6|LinuxMirrors(edu)|$WHITE"
    "7|LinuxMirrors(abroad)|$WHITE"
    "8|LinuxMirrors(docker)|$WHITE"
    "………………………|$WHITE" 
    "21|Sky-Box|$WHITE" 
)


function other_scripts_menu(){
    function print_menu_other_scripts(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        local num_split=$MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ 其他脚本 " $num_split 1 0 
        split_menu_items MENU_OTHER_SCRIPTS_ITEMS[@]
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    while true; do
        print_menu_other_scripts
        _IS_BREAK="true"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) bash <(curl -sL kejilion.sh) && _BREAK_INFO=" 从 kejilion 返回 ... " ;;
        2)
            local app_name='1keji_docker'
            local app_cmd='1keji_docker'
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="1keji_docker.sh"
            local url="https://pan.1keji.net/f/rRi2/${fname}"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 0 

            # echo -e " 1keji_docker.sh 脚本下载中...\n"
            # wget -qO 1keji_docker.sh "https://pan.1keji.net/f/rRi2/1keji_docker.sh" && chmod +x 1keji_docker.sh && ./1keji_docker.sh
            ;;
        3) 
            local app_name='1keji_docker'
            local app_cmd='1keji_docker'
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="1keji_nznginx.sh"
            local url="https://pan.1keji.net/f/YJTA/${fname}"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 0 
            # clear 
            # echo -e " 1keji_nznginx.sh 脚本下载中...\n"
            # wget -qO 1keji_nznginx.sh "https://pan.1keji.net/f/YJTA/1keji_nznginx.sh" && chmod +x 1keji_nznginx.sh && ./1keji_nznginx.sh
            ;;
        4) 
            local app_name='1keji_docker'
            local app_cmd='1keji_docker'
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="1kejiV01.sh"
            local url="https://pan.1keji.net/f/ERGcp/${fname}"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 0 
            # clear 
            # echo -e " 1kejiV01.sh 脚本下载中...\n"
            # wget -qO 1kejiV01.sh "https://pan.1keji.net/f/ERGcp/1kejiV01.sh" && chmod +x 1kejiV01.sh && ./1kejiV01.sh
            ;;
        5)  bash <(curl -sSL https://linuxmirrors.cn/main.sh)          && _BREAK_INFO=" 从 linuxmirrors 返回 ... " ;;
        6)  bash <(curl -sSL https://linuxmirrors.cn/main.sh) --edu    && _BREAK_INFO=" 从 linuxmirrors(edu) 返回 ... " ;;
        7)  bash <(curl -sSL https://linuxmirrors.cn/main.sh) --abroad && _BREAK_INFO=" 从 linuxmirrors(abroad) 返回 ... " ;;
        8)  bash <(curl -sSL https://linuxmirrors.cn/docker.sh)        && _BREAK_INFO=" 从 linuxmirrors(docker) 返回 ... " ;;
        21) 
            # local country=$(curl -s --connect-timeout 1 --max-time 3 ipinfo.io/country)
            local url=$(get_proxy_url "https://raw.githubusercontent.com/BlueSkyXN/SKY-BOX/main/box.sh")
            if command -v wget &> /dev/null ; then 
                wget -O box.sh "${url}" && chmod +x box.sh && clear && ./box.sh
            elif command -v curl &> /dev/null ; then 
                curl -sSL -o box.sh "${url}" && chmod +x box.sh && clear && ./box.sh
            else 
                echo -e "\n${ERROR} 很抱歉，你的系统不支持 wget 或 curl 命令！${NC}"
            fi 
            _BREAK_INFO=" 从 SKY-BOX 工具箱返回 ... "
            ;;
        xx) sys_reboot ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" && break ;;
        *)  _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！" ;;
        esac
        case_end_tackle
    done

}

# 安装最新版本的python
function python_update_to_latest() {
    # 系统检测
    local OS=$(cat /etc/os-release | grep -o -E "Debian|Ubuntu|CentOS" | head -n 1)

    if [[ $OS == "Debian" || $OS == "Ubuntu" || $OS == "CentOS" ]]; then
        echo -e "检测到你的系统是 ${YELLOW}${OS}${NC}"
    else
        echo -e "${RED}很抱歉，你的系统不受支持！${NC}"
        return 1 
    fi

    # 检测安装Python3的版本
    VERSION=$(python3 -V 2>&1 | awk '{print $2}')

    # 获取最新Python3版本
    PY_VERSION=$(curl -s https://www.python.org/ | grep "downloads/release" | grep -o 'Python [0-9.]*' | grep -o '[0-9.]*')

    # 卸载Python3旧版本
    if [[ $VERSION == "3"* ]]; then
        echo -e "${YELLOW}你的Python3版本是${NC}${RED}${VERSION}${NC}，${YELLOW}最新版本是${NC}${RED}${PY_VERSION}${NC}"
        read -p "是否确认升级最新版Python3？默认不升级 [y/N]: " CONFIRM
        if [[ $CONFIRM == "y" ]]; then
            if [[ $OS == "CentOS" ]]; then
                echo ""
                rm-rf /usr/local/python3* >/dev/null 2>&1
            else
                apt --purge remove python3 python3-pip -y
                rm-rf /usr/local/python3*
            fi
        else
            echo -e "${YELLOW}已取消升级Python3${NC}"
            return 1
        fi
    else
        echo -e "${RED}检测到没有安装Python3。${NC}"
        read -p "是否确认安装最新版Python3？默认安装 [Y/n]: " CONFIRM
        if [[ $CONFIRM != "n" ]]; then
            echo -e "${GREEN}开始安装最新版Python3...${NC}"
        else
            echo -e "${YELLOW}已取消安装Python3${NC}"
            return 1 
        fi
    fi

    # 安装相关依赖
    if [[ $OS == "CentOS" ]]; then
        yum update
        yum groupinstall -y "development tools"
        yum install wget openssl-devel bzip2-devel libffi-devel zlib-devel -y
    else
        apt update
        apt install wget build-essential libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev -y
    fi

    # 安装python3
    cd /root/
    wget https://www.python.org/ftp/python/${PY_VERSION}/Python-"$PY_VERSION".tgz
    tar -zxf Python-${PY_VERSION}.tgz
    cd Python-${PY_VERSION}
    ./configure --prefix=/usr/local/python3
    make -j $(nproc)
    make install
    if [ $? -eq 0 ];then
        rm -f /usr/local/bin/python3*
        rm -f /usr/local/bin/pip3*
        ln -sf /usr/local/python3/bin/python3 /usr/bin/python3
        ln -sf /usr/local/python3/bin/pip3 /usr/bin/pip3
        clear
        echo -e "${YELLOW}Python3安装${GREEN}成功，${NC}版本为: ${NC}${GREEN}${PY_VERSION}${NC}"
    else
        clear
        echo -e "${RED}Python3安装失败！${NC}"
        exit 1
    fi
    cd /root/ && rm -rf Python-${PY_VERSION}.tgz && rm -rf Python-${PY_VERSION}

}


# 安装指定版本的python
function python_install_version() {
    local python_version="$1"

    if ! grep -q 'export PYENV_ROOT="\$HOME/.pyenv"' ~/.bashrc; then
        if command -v yum &>/dev/null; then
            yum update -y && yum install git -y
            yum groupinstall "Development Tools" -y
            yum install openssl-devel bzip2-devel libffi-devel ncurses-devel zlib-devel readline-devel sqlite-devel xz-devel findutils -y

            curl -O https://www.openssl.org/source/openssl-1.1.1u.tar.gz
            tar -xzf openssl-1.1.1u.tar.gz
            cd openssl-1.1.1u
            ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib
            make
            make install
            echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl-1.1.1u.conf
            ldconfig -v
            cd ..

            export LDFLAGS="-L/usr/local/openssl/lib"
            export CPPFLAGS="-I/usr/local/openssl/include"
            export PKG_CONFIG_PATH="/usr/local/openssl/lib/pkgconfig"

        elif command -v apt &>/dev/null; then
            apt update -y && apt install git -y
            apt install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev libgdbm-dev libnss3-dev libedit-dev -y
        elif command -v apk &>/dev/null; then
            apk update && apk add git
            apk add --no-cache bash gcc musl-dev libffi-dev openssl-dev bzip2-dev zlib-dev readline-dev sqlite-dev libc6-compat linux-headers make xz-dev build-base  ncurses-dev
        else
            # echo "未知的包管理器!"
            _BREAK_INFO=" 未知的包管理器，无法安装Python${python_version}！"
            _IS_BREAK="true"
            return
        fi

        curl https://pyenv.run | bash
        cat << EOF >> ~/.bashrc

export PYENV_ROOT="\$HOME/.pyenv"
if [[ -d "\$PYENV_ROOT/bin" ]]; then
  export PATH="\$PYENV_ROOT/bin:\$PATH"
fi
eval "\$(pyenv init --path)"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"

EOF

    fi

    sleep 1
    source ~/.bashrc
    sleep 1
    pyenv install $python_version
    pyenv global $python_version

    rm -rf /tmp/python-build.*
    rm -rf $(pyenv root)/cache/*

    local VERSION=$(python -V 2>&1 | awk '{print $2}')
    _BREAK_INFO=" 成功安装Python${VERSION}！"
    _IS_BREAK="true"
}

# Python管理
MENU_PYTHON_ITEMS=(
    "1|安装Python|$WHITE" 
    "2|安装Poetry|$WHITE" 
    "3|安装pipenv|$WHITE"
    "4|安装miniForge|$YELLOW" 
    "5|安装miniConda|$WHITE"  
    "6|设置pip源|$WHITE" 
    "7|设置conda源|$WHITE" 
    "8|设置poetry源|$WHITE" 
    "………………………|$WHITE"
    "31|安装hypercorn|$WHITE" 
    "32|安装gunicorn|$WHITE" 
    "33|安装julia|$WHITE" 
    "34|安装dash|$WHITE"
)

function python_management_menu(){
    function print_menu_python(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        local num_split=$MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ Python管理 " $num_split 0 0 
        local VERSION=$(python3 -V 2>&1 | awk '{print $2}')
        echo -e "\n $PRIGHT 当前Python: $VERSION\n"
        generate_separator "…|$AZURE" $num_split # 另一个分割线
        split_menu_items MENU_PYTHON_ITEMS[@]
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }
    local py_vesions_list=(
        "1.升级为最新版本|$RED|👉"
        "2.Python3.12.7|$CYAN|👍"
        "3.Python3.11"
        "4.Python3.10"
        "5.Python3.9"
        "9.指定版本|$BLUE"
        "0.退出|$RED|❌"
    )
    local pip_sources_list=(
        "1.官方源"
        "2.阿里云"
        "3.腾讯云"
        "4.清华镜像"
        "5.中科大镜像"
        "6.豆瓣IO"
        "9.自定义镜像"
        "0.退出"
    )
    local conda_sources_list=(
        "1.官方源"
        "2.阿里云"
        "3.清华镜像"
        "4.中科大镜像"
        "0.退出"
    )

    function py_subitem_set_source_conda(){
        if command -v conda &>/dev/null; then
            function conda_sources_backup(){
                conda config --show-sources > conda_sources_backup.txt
            }
            function conda_sources_remove(){
                conda config --remove-key channels
            }
            function conda_sources_default(){
                conda config --remove-key channels
                conda config --add channels defaults
            }

            local is_to_set=1
            local url=""
            local host=""
            _BREAK_INFO=" 设置conda镜像源成功！"

            print_items_list conda_sources_list[@] " ⚓ conda镜像列表"
            local CHOICE=$(echo -e "\n${BOLD}└─ 选择镜像源: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                conda_sources_default
                _BREAK_INFO=" 设置Conda源为默认源！"
                ;;
            2) 
                conda config --add channels http://mirrors.aliyun.com/anaconda/pkgs/main/
                conda config --add channels http://mirrors.aliyun.com/anaconda/pkgs/r/
                conda config --add channels http://mirrors.aliyun.com/anaconda/pkgs/msys2/
                conda config --set show_channel_urls yes
                conda clean -i 
                _BREAK_INFO=" 设置Conda源成功: 阿里云镜像！"
                ;;
            3) 
                conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
                conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
                conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
                conda config --set show_channel_urls yes
                conda clean -i 
                _BREAK_INFO=" 设置Conda源成功: 清华大学镜像！"
                ;;
            4) 
                conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main
                conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/r
                conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/msys2
                conda config --set show_channel_urls yes
                conda clean -i 
                _BREAK_INFO=" 设置Conda源成功: 中科大镜像！"
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                is_to_set=0
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                is_to_set=0
                ;;
            esac 

        else
            _BREAK_INFO=" conda尚未安装！"
        fi
    }
    function py_subitem_set_source_pip(){
        if command -v pip &>/dev/null; then
            local is_to_set=1
            local url=""
            local host=""
            _BREAK_INFO=" 设置pip镜像源成功！"
            print_items_list pip_sources_list[@] " ⚓ pip镜像列表"
            local CHOICE=$(echo -e "\n${BOLD}└─ 选择镜像源: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                url="https://pypi.org/simple"
                host="pypi.org"
                ;;
            2) 
                url="https://mirrors.aliyun.com/simple"
                host="mirrors.aliyun.com"
                ;;
            3) 
                url="https://mirrors.cloud.tencent.com/pypi/simple"
                host="mirrors.cloud.tencent.com"
                ;;
            4) 
                url="https://pypi.tuna.tsinghua.edu.cn/simple"
                host="pypi.tuna.tsinghua.edu.cn"
                ;;
            5) 
                url="https://pypi.mirrors.ustc.edu.cn/simple"
                host="pypi.mirrors.ustc.edu.cn"
                ;;
            6) 
                url="https://pypi.doubanio.com/simple"
                host="pypi.doubanio.com/simple"
                ;;
            9) 
                local CHOICE=$(echo -e "\n${BOLD}└─ 请输入镜像源地址: \n ${PLAIN}")
                read -rp "${CHOICE}" INPUT 
                [[ -z "${INPUT}" ]] && url=$INPUT 
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                is_to_set=0
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                is_to_set=0
                ;;
            esac 

            if [[ ${is_to_set} -eq 1 ]]; then
                # if [[ -f "/etc/pip.conf" ]]; then
                #     sed -i "s|index-url=.*|index-url=${url}|g" /etc/pip.conf
                # else
                #     echo "index-url=${url}" > /etc/pip.conf
                # fi
                [[ -n $url ]] && pip config set global.index-url  $url
                [[ -n $host ]] && pip config set global.trusted-host $host
                pip config set global.timeout 30
                pip config set global.disable-pip-version-check true
                _BREAK_INFO=" 设置pip镜像源成功: ${url}"
            fi
        else
            _BREAK_INFO=" pip尚未安装！"
        fi
    }
    function py_subitem_set_source_poetry(){
        if ! command -v poetry &>/dev/null; then
            echo -e "\n$TIP poetry尚未安装, 请先安装 poetry ...\n"
        else            
            print_items_list pip_sources_list[@] " ⚓ poetry源列表"
            local CHOICE=$(echo -e "\n${BOLD}└─ 输入选项: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) poetry source add pypi      "https://pypi.org/simple/"                       --default ;; 
            2) poetry source add aliyun    "https://mirrors.aliyun.com/pypi/simple/"        --default ;; 
            3) poetry source add tencent   "https://mirrors.cloud.tencent.com/pypi/simple/" --default ;; 
            4) poetry source add tsinghua  "https://pypi.tuna.tsinghua.edu.cn/simple/"      --default ;; 
            5) poetry source add ustc      "https://pypi.mirrors.ustc.edu.cn/simple/"       --default ;; 
            6) poetry source add doubanio  "https://pypi.doubanio.com/simple/"              --default ;; 
            9) 
                local CHOICE=$(echo -e "\n${BOLD}└─ 输入源URL: ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                if [[ -n "$INPUT" ]]; then
                    poetry source add custom $INPUT
                else
                    _BREAK_INFO=" $WARN 请输入源URL为空 ..."
                fi
                ;;
            0) echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" ;;
            *) _BREAK_INFO=" 请输入正确选项！" ;;
            esac 
        fi
    }
    function py_subitem_install_python(){
        print_items_list py_vesions_list[@] " ⚓ Python版本列表"
        local CHOICE=$(echo -e "\n${BOLD}└─ 输入你要安装选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) python_update_to_latest ;;
        2) python_install_version 3.12.7 ;;
        3) python_install_version 3.11 ;;
        4) python_install_version 3.10 ;;
        5) python_install_version 3.9 ;;
        9) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 选择Python版本: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            if [[ "$INPUT" == "0" ]]; then
                _BREAK_INFO=" 取消安装Python ..."
            else
                python_install_version $INPUT
            fi
            ;;
        0) echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" ;;
        *) _BREAK_INFO=" 请输入正确选项！" ;;
        esac 
    }
    function py_subitem_install_pipenv(){
        if command -v pipenv &>/dev/null; then
            _BREAK_INFO=" pipenv已安装，无需重新安装！"
        else
            sys_update && app_install pipenv 
            _BREAK_INFO=" pipenv安装成功！"
        fi
    }
    function py_subitem_install_poetry(){
        if command -v poetry &>/dev/null; then
            _BREAK_INFO=" poetry已安装，无需重新安装！"
            echo -e "\n$TIP poetry卸载方式: \n"
            echo -e "   1. 官方 "
            echo -e "   2. pip "
            echo -e "   0. 返回"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项(默认0): ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] &&  INPUT="0"
            case "${INPUT}" in
            1 ) curl -sSL https://install.python-poetry.org | python3 - --uninstall  ;;
            2 )  pip uninstall poetry ;;
            0 )  echo -e "\n$WARN 返回 ${RESET}" && _IS_BREAK="false"  && return 0  ;;
            *)  _BREAK_INFO=" 请输入正确先项！" && _IS_BREAK="true" && return 0;;
            esac
            _BREAK_INFO=" poetry安装成功！"
        else
            echo -e "\n$TIP poetry安装方式: \n"
            echo -e "   1. 官方 "
            echo -e "   2. 安装到用户 "
            echo -e "   3. 全局安装"
            echo -e "   0. 返回"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] &&  INPUT="1"
            case "${INPUT}" in
            1 )  
                curl -sSL https://install.python-poetry.org | python3 -  
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc  # 或 ~/.zshrc
                source ~/.bashrc
                ;;
            2 )  pip install --user poetry ;;
            3 )  sudo pip install peotry  ;;
            0 )  echo -e "\n$WARN 返回 ${RESET}" && _IS_BREAK="false"  && return 0  ;;
            *)  _BREAK_INFO=" 请输入正确先项！" && _IS_BREAK="true" && return 0;;
            esac
            _BREAK_INFO=" poetry安装成功！"
        fi
    }
    function py_subitem_install_miniforge(){
        if command -v conda &>/dev/null; then
            _BREAK_INFO=" 系统已安装conda！"
        else
            local file="Miniforge3-$(uname)-$(uname -m).sh"
            local url="https://github.com/conda-forge/miniforge/releases/latest/download/$file"
            url=$(get_proxy_url $url)

            _BREAK_INFO=" miniForge安装成功！"
            if command -v curl &>/dev/null; then
                curl -L -O "${url}" && bash ${file}
            elif command -v wget &>/dev/null; then
                wget "${url}" && bash ${file} 
            else
                _BREAK_INFO=" 请先安装curl或wget！"
            fi
        fi 
    }
    function py_subitem_install_miniconda(){
        if command -v conda &>/dev/null; then
            _BREAK_INFO=" 系统已安装conda！"
        else
            local file="Miniconda3-latest-$(uname)-$(uname -m).sh"
            local url="https://repo.anaconda.com/miniconda/$file"
            url=$(get_proxy_url $url)

            _BREAK_INFO=" miniConda安装成功！"
            if command -v curl &>/dev/null; then
                curl -L -O "${url}" && bash ${file}
            elif command -v wget &>/dev/null; then
                wget "${url}" && bash ${file} 
            else
                _BREAK_INFO=" 请先安装curl或wget！"
            fi
        fi
    }
    function py_subitem_install_dash(){
        _BREAK_INFO=" dash安装成功！"
        if command -v pip &>/dev/null; then
            pip install dash 
        elif command -v conda &>/dev/null; then
            conda install dash 
        else
            _BREAK_INFO=" conda或pip未安装！"
        fi
        
    }
    function py_subitem_install_julia(){
        function jill_usage(){
            generate_separator '=' $MAX_SPLIT_CHAR_NUM
            echo -e "\n$TIP jill Usage:"
            echo -e "   > jill upstream                       # Check available Julia upstream sources"
            echo -e "   > jill install --upstream USTC        # Install Julia from USTC source"
            echo -e "   > jill install --install_dir './'     # Install Julia to current directory"
            generate_separator '=' $MAX_SPLIT_CHAR_NUM
        }
        jill_usage
        _BREAK_INFO=" Julia安装成功！"
        if  command -v julia &>/dev/null; then
            _BREAK_INFO=" julia已安装！"
        else
            if ! command -v jill &>/dev/null; then
                # echo -e "\n$TIP 先安装jill ..."
                if command -v pip &>/dev/null; then
                    pip install jill
                else 
                    echo -e "$ERROR  jill未安装, 请先安装pip！"
                fi
            fi 
            if command -v jill &>/dev/null; then
                echo -e "\n$TIP 安装Julia ..."
                jill install 
            else 
                _BREAK_INFO=" jill未安装, Julia安装失败！"
            fi
        fi
    }
    function py_subitem_install_gunicorn(){
        _BREAK_INFO=" gunicorn安装成功！"
        if  command -v gunicorn &>/dev/null; then
            _BREAK_INFO=" gunicorn已安装！"
        else
            if command -v pip &>/dev/null; then
                pip install gunicorn greenlet eventlet gevent
            elif command -v conda &>/dev/null; then
                conda install gunicorn greenlet eventlet gevent
            else
                _BREAK_INFO=" pip或conda未安装！"
            fi 
        fi
    }
    function py_subitem_install_hypercorn(){
        _BREAK_INFO=" hypercorn安装成功！"
        if  command -v hypercorn &>/dev/null; then
            _BREAK_INFO=" hypercorn已安装！"
        else
            if command -v pip &>/dev/null; then
                pip install hypercorn 
            elif command -v conda &>/dev/null; then
                conda install hypercorn 
            else
                _BREAK_INFO=" pip或conda未安装！"
            fi 
        fi
    }

    while true; do
        _IS_BREAK="true"
        print_menu_python
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1 ) py_subitem_install_python ;;
        2 ) py_subitem_install_poetry ;;
        3 ) py_subitem_install_pipenv ;;
        4 ) py_subitem_install_miniforge ;;
        5 ) py_subitem_install_miniconda ;;
        6 ) py_subitem_set_source_pip ;;
        7 ) py_subitem_set_source_poetry ;;
        8 ) py_subitem_set_source_conda ;;
        31) py_subitem_install_hypercorn ;;
        32) py_subitem_install_gunicorn ;;
        33) py_subitem_install_julia ;;
        34) py_subitem_install_dash ;;
        xx) sys_reboot ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false" && break ;;
        *)  _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！" && _IS_BREAK="true" ;;
        esac
        case_end_tackle
    done
}


function caddy_install(){
    if command -v caddy >/dev/null 2>&1; then  
        echo -e "\n$TIP Caddy已安装: $(caddy --version)"        
        return 0 
    fi

    # 准备目录和主页文件
    # mkdir -p /home/web/{caddy,html}
    local dir_root=${1:-'/home/caddy_data'}
    local dir_main=${dir_root}'/caddy'
    local dir_html=${dir_root}'/html'
    local dir_logs=${dir_root}'/log'

    echo -e "$PRIGHT 1.创建配置文件目录 ... "

    [[ -d "${dir_root}" ]] || mkdir -p "${dir_root}"
    [[ -d "${dir_main}" ]] || mkdir -p "${dir_main}"
    [[ -d "${dir_html}" ]] || mkdir -p "${dir_html}"
    [[ -d "${dir_logs}" ]] || mkdir -p "${dir_logs}"

    echo -e "$PRIGHT 2.切换至当前目录到: ${dir_root} ... "
    cd "$dir_main"
    echo -e "$PRIGHT 3.下载主页和默认配置文件 ... "
    local url_caddy_index=$(get_proxy_url 'https://raw.githubusercontent.com/lmzxtek/qiq/refs/heads/main/scripts/caddy/index.html')
    local url_caddy_conf=$(get_proxy_url  'https://raw.githubusercontent.com/lmzxtek/qiq/refs/heads/main/scripts/caddy/default.conf')
    [[ -f "${dir_html}/index.html"   ]] || curl -sSL -o ${dir_html}/index.html   $url_caddy_index || wget -qO ${dir_html}/index.html   $url_caddy_index
    [[ -f "${dir_main}/default.conf" ]] || curl -sSL -o ${dir_main}/default.conf $url_caddy_conf  || wget -qO ${dir_main}/default.conf $url_caddy_conf

	if [ -f /etc/os-release ]; then
		. /etc/os-release
		case "$ID" in
			ubuntu|debian|raspbian)
                echo -e "$PRIGHT 4.开始安装Caddy ... "
                sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl && \
                curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg && \
                curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list && \
                sudo apt update && sudo apt install -y caddy                
				;;
			centos|rhel|almalinux|rocky|fedora)
                echo -e "$PRIGHT 4.开始安装Caddy ... "
				dnf install 'dnf-command(copr)'
                dnf copr enable @caddy/caddy
                dnf install caddy
                ## For RHEL/CentOS 7
                # yum install yum-plugin-copr
                # yum copr enable @caddy/caddy
                # yum install caddy
				;;
			# alpine) ;;
			arch|manjaro) 
                pacman -Syu caddy
                ;;
			# opensuse|suse|opensuse-tumbleweed) ;;
			# iStoreOS|openwrt|ImmortalWrt|lede) ;;
			# FreeBSD) ;;
			*) echo -e "$WARN 不支持的发行版: $ID" && return ;;
		esac
	else
		echo -e "$WARN 无法确定操作系统。"
		return
	fi

    echo -e "$PRIGHT 5.完成安装Caddy. "

}


# 更新域名信息
function caddy_new_caddyfile(){
    local dir_caddy=${1:-'/home/caddy_data/caddy'}

    if [ -z "$(find ${dir_caddy} -name "*.conf")" ]; then
        echo -e "${WARN} No *.conf files found in ${dir_caddy}"
    else
        echo -e " >>> Join all *.conf files into: /etc/caddy/Caddyfile"
        caddy_cfg_backup 
        find ${dir_caddy} -name "*.conf" -exec cat {} + > /etc/caddy/Caddyfile
        cd /etc/caddy
        caddy fmt --overwrite
        cd - &>/dev/null
    fi
}

## 重新加载Caddy，使新的配置文件生效 
function caddy_reload(){ 
    caddy_install; 
    cd /etc/caddy; 
    # caddy_new_caddyfile; 
    caddy reload; 
    cd - &>/dev/null ; 
}

## 备份Caddy配置信息 
function caddy_cfg_backup(){
    local path_cfg='/etc/caddy/Caddyfile'
    if [ ! -f "${path_cfg}" ]; then
        echo -e "$WARN Caddy配置文件不存在($path_cfg)。"
        return 1 
    fi
    cp "${path_cfg}" "${path_cfg}.bak" 
    echo -e "$WARN 成功备份Caddy配置文件: ($path_cfg).bak"
}

# 更换站点域名 
function caddy_alter_domain(){
    local domain_new=$1
    local domain_old=$2
    local dir_caddy=${3:-'/home/caddy_data/caddy'}
    
    if [[ -z "${domain_new}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入新域名: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        domain_new=$INPUT 
    fi 
    [[ -z "$domain_new" ]] && echo -e "$WARN 新域名不能为空。" && return 1 

    if [[ -z "${domain_old}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入需要替换的域名: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        domain_old=$INPUT 
    fi 
    [[ -z "$domain_old" ]] && echo -e "$WARN 要替换的域名不能为空。" && return 1 

    mv ${dir_caddy}/$domain_old.conf ${dir_caddy}/$domain_new.conf
    sed -i "s/$domain_old/$domain_new/g" ${dir_caddy}/$domain_new.conf

    echo -e "\n${BOLD}└─ 更换域名成功: ${PLAIN}$domain_old -> $domain_new\n"
    ## 刷新Caddy配置信息，并重启Caddy，使反代生效 
    caddy_new_caddyfile
    caddy_reload

}

# 删除站点域名 
function caddy_del_domain(){
    local domain_new=$1
    local dir_caddy=${2:-'/home/caddy_data/caddy'}
    
    if [[ -z "${domain_new}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入要删除的域名: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        domain_new=$INPUT 
    fi 
    [[ -z "$domain_new" ]] && echo -e "$WARN 新域名不能为空。" && return 1 

    if [[ -f "${dir_caddy}/$domain_new.conf" ]] ; then 
        echo -e "$INFO 删除站点 $domain_new ..."
        rm -f ${dir_caddy}/$domain_new.conf 

        echo -e "\n$TIP 删除域名成功: $domain_new\n"
        ## 刷新Caddy配置信息，并重启Caddy，使反代生效 
        caddy_new_caddyfile
        caddy_reload
    else 
        echo -e "$WARN 站点${domain_new}的域名配置文件不存在: ${dir_caddy}/${domain_new}.conf)"
    fi
}


function caddy_domain_list(){
    local dir_caddy=${1:-'/home/caddy_data/caddy'}
    # ls -t /home/web/caddy | grep -v "default.conf" | sed 's/\.[^.]*$//'
    local dm_list=$(ls -t ${dir_caddy} | grep -v "default.conf" | sed 's/\.[^.]*$//')
    # clear
    echo -e "$PRIGHT 站点列表\n${PLAIN}============================"
    echo "${list[@]}" | tr ' ' '\n' | nl -w2 -s'. '

    num=0
    for dm_file in $dm_list; do
        num+=1
        printf " (%2d) %-s\n"  ${num} "$dm_file"
    done
    echo -e "\n${PLAIN}============================\n"

    # echo "${dm_list[@]}"
}


# 清空站点域名 
function caddy_clean_all_domain(){
    local dir_caddy=${1:-'/home/caddy_data/caddy'}
    
    
    if [ -z "$(find ${dir_caddy} -name "*.conf")" ]; then
        echo -e "${WARN} 配置文件目录没有站点配置文件 in ${dir_caddy}"
    else
        echo -e " >>> Join all *.conf files into: /etc/caddy/Caddyfile"
        rm -f ${dir_caddy}/$domain_new.conf 
        echo -e "\n$TIP 成功删除全部域名: $domain_new\n"
        ## 刷新Caddy配置信息，并重启Caddy，使反代生效 
        caddy_new_caddyfile
        caddy_reload        
    fi

}

# 添加域名反代
function caddy_add_reproxy(){
    local domain="$1"
    local ip="$2"
    local port="$3"
    local to_check=${4:-1}
    local dir_caddy=${5:-'/home/caddy_data/caddy'}

    if [[ -z "${domain}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入需反代的域名: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && echo -e "$WARN 输入的域名不能为空。" && return 1 
        domain=$INPUT 
    fi 
    if [[ -z "${ip}" ]] ; then
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入反代的目标IP(默认: 127.0.0.1): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT="127.0.0.1"
        ip=$INPUT
    fi
    if [[ -z "${port}" ]] ; then
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入反代的目标端口(默认: 3000): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT=3000
        port=$INPUT
    fi
    
    if [[ ${to_check} -eq 1 ]] ; then 
        echo -e ''
        echo -e "${BOLD}└─ 请确认反代信息是否有误: ${PLAIN}\n"
        echo -e "${BOLD}   域名: ${PLAIN}$domain"
        echo -e "${BOLD}   反代: ${PLAIN}$ip:$port"
        local CHOICE=$(echo -e "\n${BOLD}└─ 以上信息正确吗？[Y/n]: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT="Y"
        case "${INPUT}" in
        [Yy] | [Yy][Ee][Ss]) ;;
        [Nn] | [Nn][Oo])  
            echo -e "\n$TIP 反代信息有误！" 
            return 1 
            ;;
        *)   
            echo -e "\n$WARN 输入错误[Y/n],请重试！"
            return 1 
            ;;
        esac
    fi 
    
    cat > "${dir_caddy}/${domain}.conf" << EOF
$domain {
    reverse_proxy $ip:$port
    encode gzip
}
EOF

    echo -e "\n${BOLD}└─ ${GREEN}添加反代成功: ${RED}${domain}${PLAIN} -> $ip:${BLUE}${port}${PLAIN}\n"
    ## 刷新Caddy配置信息，并重启Caddy，使反代生效 
    caddy_new_caddyfile
    caddy_reload
}

# 添加负载均衡
function caddy_add_url_balance(){
    local domain=$1
    local dir_caddy=${1:-'/home/caddy_data/caddy'}

    if [[ -z "${domain}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入需反代的域名: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && echo -e "$WARN 输入的域名不能为空。" && return 1 
        domain=$INPUT 
    fi 

    local url_list=()
    echo -e "\n$WORKING 按顺序输入需要进行负载均衡的链接: \n" 
    while true; do
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入负载均衡的链接(IP:PORT),直接回车结束输入:: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && break
        url_list+=("$INPUT")
    done

    if [ ${#url_list[@]} -eq 0 ]; then
        echo -e "$WARN 负载均衡目标链接列表为空，返回。"
        return -1 
    fi
    
    local strategy='least_conn'
    echo -e "${BOLD}└─ 请选择负载均衡策略: ${PLAIN}\n"
    echo -e "  1. 轮询(Round Robin)(默认)"
    echo -e "  2. IP哈希(Source Hash)"
    echo -e "  3. 最少连接(Least Connections)"
    echo -e "  4. 权重随机(Random)"
    print_items_list "${url_list[@]}" " ⚓ 负载均衡链接列表"
    local CHOICE=$(echo -e "\n${BOLD}└─ 以上信息正确吗？[Y/n]: ${PLAIN}")
    read -rp "${CHOICE}" INPUT
    [[ -z "$INPUT" ]] &&  INPUT=1
    case "${INPUT}" in 
    1) strategy='least_conn';; 
    2) strategy='round_robin';; 
    3) strategy='ip_hash';; 
    4) 
        strategy='random'
        print_items_list "${url_list[@]}" " ⚓ 负载均衡链接列表"            
        local CHOICE=$(echo -e "\n${BOLD}└─ 请按序输入每个链接的权重值(1-100): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT=1
        ;; 
    *)   
        echo -e "\n$WARN 输入错误,返回！"
        return 1 
        ;;
    esac

    
    if [[ ${to_check} -eq 1 ]] ; then 
        echo -e ''
        echo -e "${BOLD}└─ 请确认负载均衡数据是否有误: ${PLAIN}\n"
        echo -e "${BOLD}   域名: ${PLAIN}$domain"
        print_items_list "${url_list[@]}" " ⚓ 负载均衡链接列表"
        echo -e ''
        echo -e "${BOLD}   负载均衡策略: ${strategy} ${PLAIN}\n"

        local CHOICE=$(echo -e "\n${BOLD}└─ 以上信息正确吗？[Y/n]: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT="Y"
        case "${INPUT}" in 
        [Yy] | [Yy][Ee][Ss]) ;; 
        [Nn] | [Nn][Oo]) 
            echo -e "\n$TIP 信息有误，直接返回！" 
            return 1 
            ;;
        *)   
            echo -e "\n$WARN 输入错误[Y/n],请重试！"
            return 1 
            ;;
        esac
    fi 
    
    cat > "${dir_caddy}/${domain}.conf" << EOF
$domain {
    reverse_proxy "${list[*]}" {
        lb_policy ${strategy}  

        health_uri /health    
        health_interval 10s   
        health_timeout 2s     
    }
}
EOF

    echo -e "\n${BOLD}└─ 添加负载均衡成功: ${PLAIN}$domain \n"
    print_items_list "${url_list[@]}" " ⚓ 负载均衡链接列表"
    echo -e "" 

    ## 刷新Caddy配置信息，并重启Caddy，使反代生效 
    caddy_new_caddyfile
    caddy_reload
}

# 添加重定向
function caddy_add_url_redirect(){
    local domain=$1
    local redirurl=$2
    local dir_caddy=${3:-'/home/caddy_data/caddy'}

    if [[ -z "${domain}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输重定向域名: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && echo -e "$WARN 输入的域名不能为空。" && return 1 
        domain=$INPUT 
    fi 
    if [[ -z "${redirurl}" ]] ; then
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输重定向的目标链接: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  echo -e "$WARN 输入的目标链接不能为空。" && return 1 
        redirurl=$INPUT
    fi

    if [[ ${to_check} -eq 1 ]] ; then 
        echo -e ''
        echo -e "${BOLD}└─ 请确认重定向信息是否有误: ${PLAIN}\n"
        echo -e "${BOLD}   域名: ${PLAIN}$domain"
        echo -e "${BOLD}   链接: ${PLAIN}$redirurl"
        local CHOICE=$(echo -e "\n${BOLD}└─ 以上信息正确吗？[Y/n]: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT="Y"
        case "${INPUT}" in
        [Yy] | [Yy][Ee][Ss]) ;;
        [Nn] | [Nn][Oo])  
            echo -e "\n$TIP 重定向信息有误！" 
            return 1 
            ;;
        *)   
            echo -e "\n$WARN 输入错误[Y/n],请重试！"
            return 1 
            ;;
        esac
    fi 

    cat > "${dir_caddy}/${domain}.conf" << EOF
$domain {
    redir $redirurl{uri}
}
EOF

    echo -e "\n${BOLD}└─ 添加重定向成功: ${PLAIN}$domain -> $redirurl\n"
    ## 刷新Caddy配置信息，并重启Caddy，使重定向生效 
    caddy_new_caddyfile
    caddy_reload

}


# 静态网站
function caddy_add_static_web(){
    local domain=$1
    local abspath=$2
    local dir_caddy=${3:-'/home/caddy_data/caddy'}

    if [[ -z "${domain}" ]] ; then 
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输重定向域名: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && echo -e "$WARN 输入的域名不能为空。" && return 1 
        domain=$INPUT 
    fi 
    if [[ -z "${abspath}" ]] ; then
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输重定向的目标链接: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  echo -e "$WARN 输入的目标链接不能为空。" && return 1 
        abspath=$INPUT
    fi

    if [[ ${to_check} -eq 1 ]] ; then 
        echo -e ''
        echo -e "${BOLD}└─ 请确认重定向信息是否有误: ${PLAIN}\n"
        echo -e "${BOLD}   域名: ${PLAIN}$domain"
        echo -e "${BOLD}   路径: ${PLAIN}$abspath"
        local CHOICE=$(echo -e "\n${BOLD}└─ 以上信息正确吗？[Y/n]: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT="Y"
        case "${INPUT}" in
        [Yy] | [Yy][Ee][Ss]) ;;
        [Nn] | [Nn][Oo])  
            echo -e "\n$TIP 静态站点信息有误！" 
            return 1 
            ;;
        *)   
            echo -e "\n$WARN 输入错误[Y/n],请重试！"
            return 1 
            ;;
        esac
    fi 

    cat > "${dir_caddy}/${domain}.conf" << EOF
$domain {
    root * $abspath
    encode gzip
    file_server
}
EOF

    echo -e "\n${BOLD}└─ 添加重定向成功: ${PLAIN}$domain -> $redirurl\n"
    ## 刷新Caddy配置信息，并重启Caddy，使静态站点生效 
    caddy_new_caddyfile
    caddy_reload

}

function get_valid_domain() {
    local domain
    local regex='^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$'

    read -p " └─ 请输入域名: " domain
    if [[ $domain =~ $regex ]]; then
        # echo -e "Valid domain"
        echo $domain
    else
        # echo -e "$WARN Invalid domain: $domain"
        echo ''
    fi
}

# Caddy管理
MENU_CADDY_ITEMS=(
    "1|安装Caddy|$WHITE"
    "2|卸载Caddy|$WHITE"
    "3|更新Caddy|$WHITE"
    "4|重启Caddy|$WHITE"
    "5|查看状态|$YELLOW"
    "6|查看端口|$WHITE"
    "7|站点列表|$CYAN" 
    "8|重置配置|$WHITE"
    "…………………………|$WHITE" 
    "21|添加反代|$YELLOW" 
    "22|添重定向|$WHITE" 
    "23|添静态站|$WHITE" 
    "24|负载均衡|$CYAN" 
    "25|修改域名|$WHITE" 
    "26|删除站点|$RED" 
    "27|清空站点|$WHITE" 
    "28|容器管理|$BLUE" 
)
function caddy_management_menu(){
    function print_menu_caddy(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        local num_split=$MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ Caddy管理 " $num_split 0 0 
        split_menu_items MENU_CADDY_ITEMS[@]
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    while true; do
        _IS_BREAK='true' 
        print_menu_caddy
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT 
        case "${INPUT}" in 
        1)  caddy_install ;;
        2)  echo -e "\n$TIP Caddy卸载暂未实现 ..." ;;
        3)  echo -e "\n$TIP Caddy更新暂未实现 ..." ;;
        4)  caddy_reload ;;
        5)  systemctl status caddy ;;
        6)  clear && ss -tulpn && _BREAK_INFO=" 端口列表 " && _IS_BREAK="true" ;;
        7)  caddy_domain_list ;;
        8)  caddy_new_caddyfile && caddy_reload ;;
        21) caddy_add_reproxy && caddy_domain_list ;;
        22) caddy_add_url_redirect && caddy_domain_list ;;
        23) caddy_add_static_web && caddy_domain_list ;;
        24) caddy_add_url_balance && caddy_domain_list ;;
        25) caddy_domain_list && caddy_alter_domain && caddy_domain_list ;;
        26) caddy_domain_list && caddy_del_domain && caddy_domain_list ;;
        27) caddy_domain_list && caddy_clean_all_domain && caddy_domain_list ;;
        28) docker_management_menu && _IS_BREAK="false"  ;;
        xx) sys_reboot ;;
        0)  echo -e "\n$TIP 返回 ..." && _IS_BREAK='false' && break ;;
        *)  _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！" && _IS_BREAK="true" ;;
        esac
        case_end_tackle
    done

}

# 容器部署管理
MENU_DOCKER_DEPLOY_ITEMS=(
    "1|WatchTower|$Yellow"
    "2|RustDesk|$WHITE"
    "3|NginxGUI|$WHITE"
    "4|OpenLiteSpeed|$WHITE"
    "5|DeepLX|$WHITE"
    "6|AKTools|$CYAN"
    "7|SubLinkX|$WHITE"
    "8|Lucky|$WHITE"
    "9|Alist|$WHITE"
    "10|IPTVa|$WHITE"
    "11|IPTVd|$WHITE"
    "12|Docker-win|$WHITE"
    "13|Docker-mac|$WHITE"
    "14|WeChat(web)|$WHITE"
    "………………………|$WHITE" 
    "21|Dash.|$WHITE" 
    "22|MyIP|$WHITE" 
    "23|Neko|$WHITE" 
    "24|IT-Tools|$YELLOW" 
    "25|Stirling PDF|$WHITE" 
    "26|OpenCode Server|$WHITE" 
    "27|Code Server(LinuxServer)|$YELLOW" 
    "28|Code Server(Official,NOT recommend)|$WHITE" 
)
function docker_deploy_menu(){
    function print_menu_docker_deploy(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        local num_split=$MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ Docker部署 " $num_split 0 0 
        split_menu_items MENU_DOCKER_DEPLOY_ITEMS[@] 
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    function dc_set_domain_reproxy(){
        local port=$1

        if command -v caddy >/dev/null 2>&1; then
            # echo -e "\n$TIP 检测到系统已安装Caddy，是否给${dc_desc}添加域名反代？ ... \n"
            local CHOICE=$(echo -e "\n${BOLD}└─ 系统已安装Caddy，是否添加域名反代？[y/N]: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] &&  INPUT="N"
            case "${INPUT}" in 
            [Yy] | [Yy][Ee][Ss]) 
                local domain=$(get_valid_domain)
                [[ -n "$domain" ]] && caddy_add_reproxy "${domain}" '127.0.0.1' $port 0
                ;; 
            [Nn] | [Nn][Oo]) 
                echo -e "\n$TIP 取消域名反代！" 
                ;;
            *)  echo -e "\n$WARN 输入错误,不进行域名反代！" ;;
            esac
        else
            echo -e "\n$TIP 系统已未安装Caddy，不进行域名反代 \n"
        fi
    }
    
    function dc_deploy_watchtower(){    
        local base_root="/home/dcc.d"
        local dc_port=40000
        local dc_name='watchtower'
        local dc_imag=corentinth/it-tools:latest
        local dc_desc="IT-Tools常用工具箱"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        # local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        # read -rp "${CHOICE}" INPUT
        # [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        cat > "$fyml" << EOF
services:
  watchtower:
    image: containrrr/watchtower
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        # [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        # [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        # [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        # [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        # [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd - &>/dev/null # 返回原来目录 
    }

    function dc_deploy_alist(){    
        local base_root="/home/dcc.d"
        local dc_port=45244
        local dc_name='alist'
        local dc_imag=xhofe/alist
        local dc_desc="Alist聚合网盘"
        local urlgit='https://github.com/AlistGo/alist'
        local urldoc='https://alist.nn.ci/zh/guide'
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        local imgver='2025'
        echo -e ""
        echo -e "$PRIGHT 1.Latest"
        echo -e "$PRIGHT 2.aio(ffmpen+aria2)"
        echo -e "$PRIGHT 3.aria2"
        echo -e "$PRIGHT 4.Custom(eg.:3.41.0)"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择镜像版本(默认为: Latest): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && INPUT=1        
        case "${INPUT}" in
        1) imgver='latest' ;;
        2) imgver='aio' ;;
        3) imgver='ffmpeg' ;;
        4) imgver='aria2' ;;
        4) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入镜像Tag: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] && INPUT="latest"
            imgver=$INPUT 
            ;;
        *) echo -e "\n$WARN 输入错误,设置为默认latest"  ;;
        esac

        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: ${dc_imag}:${imgver}
        volumes:
        - '${fdat}:/opt/alist/data'
        ports:
        - '$dc_port:5244'
        environment:
        - PUID=0
        - PGID=0
        - UMASK=022
        restart: unless-stopped
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "
        [[ -n $urldoc ]]  && content+="\nDocumentat  : $urldoc  "
        content+="\n # 随机生成一个密码:  docker exec -it alist ./alist admin random " 
        content+="\n # 手动设置一个密码: docker exec -it alist ./alist admin set NEW_PASSWORD  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd - &>/dev/null # 返回原来目录 
    }
    function dc_deploy_code_linuxserver(){    
        local base_root="/home/dcc.d"
        local dc_port=41003
        local dc_name='code_server_linuxserver'
        local dc_imag=lscr.io/linuxserver/code-server:latest
        local dc_desc="Code-Server"
        local urlgit='https://github.com/coder/deploy-code-server'
        local urldoc='https://docs.linuxserver.io/images/docker-code-server'
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml 
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        local login_password="password"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入登录密码(默认为:${login_password}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && login_password=$INPUT
        
        local admin_password="password"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入root密码(默认为:${admin_password}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && admin_password=$INPUT
        
        local path_config="${fdat}"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入配置目录(默认为:${path_config}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && admin_password=$INPUT

        cat > "$fyml" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: ${dc_imag}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - PASSWORD=$login_password   #optional
      # - HASHED_PASSWORD=    #optional
      - SUDO_PASSWORD=$admin_password #optional
      # - SUDO_PASSWORD_HASH= #optional
      # - PROXY_DOMAIN=code-server.my.domain  #optional
      - DEFAULT_WORKSPACE=/config/workspace #optional
    volumes:
      - ${path_config}:/config
    ports:
      - '${dc_port}:8443'
    restart: unless-stopped
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "
        [[ -n $urldoc ]]  && content+="\nDocumentat  : $urldoc  "
        # content+="\n # Update: docker-compose up -d $dc_name  "
        content+="\n # Password     : $login_password "
        content+="\n # Root password: $admin_password "
        content+="\n # Config path  : $path_config    "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd - &>/dev/null # 返回原来目录 
    }
    function dc_deploy_code_official(){    
        local base_root="/home/dcc.d"
        local dc_port=41004
        local dc_name='code_server_official'
        local dc_imag=bencdr/code-server-deploy-container:latest
        local dc_desc="Code-Server"
        local urlgit='https://github.com/coder/deploy-code-server'
        local urldoc='https://github.com/coder/deploy-code-server/tree/main/deploy-container'
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml 
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        local dc_user="$USER"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入账户(默认为:${dc_user}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_user=$INPUT
        
        local user_password="password"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入登录密码(默认为:${user_password}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && user_password=$INPUT
        
        local path_config="${fdat}"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入项目目录(默认为:${path_config}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && admin_password=$INPUT

        cat > "$fyml" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: ${dc_imag}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - PASSWORD=$user_password 
      - START_DIR=/home/coder/project #optional
    volumes:
      - ${path_config}:/home/coder/project
    ports:
      - '${dc_port}:8080'
    restart: unless-stopped
EOF
        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "
        [[ -n $urldoc ]]  && content+="\nDocumentat  : $urldoc  "
        # content+="\n # Update: docker-compose up -d $dc_name  "
        content+="\n # DOCKER_USER  : $dc_user       "
        content+="\n # User password: $user_password "
        content+="\n # START_DIR    : $path_config   "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd - &>/dev/null # 返回原来目录 
    }
    function dc_deploy_opencode_server(){    
        local base_root="/home/dcc.d"
        local dc_port=41005
        local dc_name='opencode_server'
        local dc_imag=gitpod/openvscode-server
        # local dc_imag=gitpod/openvscode-server:nightly
        local dc_desc="Code-Server"
        local urlgit='https://github.com/gitpod-io/openvscode-server'
        local urldoc='www.gitpod.io/'
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml 
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        local dc_user="$USER"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入账户(默认为:${dc_user}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_user=$INPUT
        
        local user_password="password"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入登录密码(默认为:${user_password}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && user_password=$INPUT
        
        local path_config="${fdat}"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入项目目录(默认为:${path_config}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && admin_password=$INPUT

        cat > "$fyml" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: ${dc_imag}
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - PASSWORD=$user_password 
      - START_DIR=/home/coder/project #optional
    volumes:
      - ${path_config}:/home/workspace:cached
    ports:
      - '${dc_port}:3000'
    restart: unless-stopped
EOF
        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "
        [[ -n $urldoc ]]  && content+="\nDocumentat  : $urldoc  "
        # content+="\n # Update: docker-compose up -d $dc_name  "
        content+="\n # DOCKER_USER  : $dc_user       "
        content+="\n # User password: $user_password "
        content+="\n # START_DIR    : $path_config   "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd - &>/dev/null # 返回原来目录 
    }
    function dc_deploy_ittools(){    
        local base_root="/home/dcc.d"
        local dc_port=45380
        local dc_name='ittools'
        local dc_imag=corentinth/it-tools:latest
        local dc_desc="IT-Tools常用工具箱"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        ports:
            - '$dc_port:80'
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd - &>/dev/null # 返回原来目录 
    }
    function dc_deploy_nginxgui(){    
        local base_root="/home/dcc.d"
        local dc_port=49000
        local dc_name='nginxgui'
        local dc_imag=uozi/nginx-ui:latest
        local dc_desc="NginxGUI"
        local urlgit='https://openlitespeed.org/#install'
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc}(PS: 需要先安装 Nginx ) ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        ports:
            - '80:80'
            - '443:443'
            - '$dc_port:9000'
        volumes:
            - /etc/nginx:/etc/nginx
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd - &>/dev/null # 返回原来目录 
    }
    function dc_deploy_openlitespeed(){    
        local base_root="/home/dcc.d"
        local dc_port=47080
        local dc_name='openlitespeed'
        local dc_imag=litespeedtech/openlitespeed:latest
        local dc_desc="OpenLiteSpeed"
        local urlgit='https://openlitespeed.org/#install'
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        ports:
            - '80:80'
            - '443:443'
            - '$dc_port:7080'
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd - &>/dev/null # 返回原来目录 
    }
    function dc_deploy_deeplx(){    
        local base_root="/home/dcc.d"
        local dc_port=45188
        local dc_name='deeplx'
        local dc_imag=ghcr.io/owo-network/deeplx:latest
        local dc_desc="DeepLX(Free API)"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        ports:
            - '$dc_port:1188'
        restart: always
        # environment:
        # - TOKEN=helloworld
        # - AUTHKEY=xxxxxxx:fx
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd - &>/dev/null # 返回原来目录 
    }
    function dc_deploy_sublinkx(){    
        local base_root="/home/dcc.d"
        local dc_port=45088
        local dc_name='sublinkx'
        local dc_imag=jaaksi/sublinkx
        local dc_desc="SubLinkX"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/db"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        ports:
            - '$dc_port:8000'
        restart: always
        volumes:
            - $LFLD/db:/app/db
            - $LFLD/template:/app/template
            - $LFLD/logs:/app/logs
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd - &>/dev/null # 返回原来目录 
    }
    function dc_deploy_aktools(){    
        local base_root="/home/dcc.d"
        local dc_port=45088
        local dc_name='aktools'
        local dc_imag=registry.cn-shanghai.aliyuncs.com/akfamily/aktools:1.8.95
        local dc_desc="AKTools"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/db"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT
        
        SITE_PASSWORD=''
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入网站密码: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && SITE_PASSWORD=$INPUT

        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        environment:
            - SITE_PASSWORD=$SITE_PASSWORD
        ports:
            - '$dc_port:8080'
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }
    function dc_deploy_rustdesk(){    
        local base_root="/home/dcc.d"
        local dc_port=45115
        local dc_name='rustdesk'
        local dc_imag=rustdesk/rustdesk-server-s6:latest
        local dc_desc="RustDesk-Server"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        # local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        # read -rp "${CHOICE}" INPUT
        # [[ -n "$INPUT" ]] && dc_port=$INPUT
        HOST_ADDRESS='127.0.0.1'
        PANEL_APP_PORT_HBBR=''
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入IP/域名: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && PANEL_APP_PORT_HBBR=$INPUT

        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        volumes:
            - "${fdat}:/data"
        environment:
            - "RELAY=${HOST_ADDRESS}:${PANEL_APP_PORT_HBBR}"
            - "ENCRYPTED_ONLY=1"
        ports:
            - "21115:21115"
            - "21116:21116"
            - "21116:21116/udp"
            - "21117:21117"
            - "21118:21118"
            - "21119:21119"
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }
    function dc_deploy_lucky(){    
        local base_root="/home/dcc.d"
        local dc_port=45661
        local dc_name='lucky'
        local dc_imag=gdy666/lucky
        local dc_desc="Lucky"
        local urlgit='https://github.com/gdy666/lucky'
        local urlweb='https://lucky666.cn/'
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT

        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        volumes:
            - "${fdat}:/goodluck"
        network_mode: host
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "
        [[ -n $urlweb ]]  && content+="\nWebSite     : $urlweb  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }
    function dc_deploy_iptva(){    
        local base_root="/home/dcc.d"
        local dc_port=45455
        local dc_name='iptva'
        local dc_imag=youshandefeiyang/allinone
        local dc_desc="IPTv(Allinone)"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT

        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        volumes:
            - "${fdat}:/downloads"
        ports:
            - '$dc_port:35455'
        privileged: true
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }
    function dc_deploy_iptvd(){    
        local base_root="/home/dcc.d"
        local dc_port=45427
        local dc_name='iptvd'
        local dc_imag=doubebly/doube-itv:latest
        local dc_desc="IPTv(doubebly)"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT

        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        volumes:
            - "${fdat}:/downloads"
        ports:
            - '$dc_port:5000'
        privileged: true
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 
        
        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }
    function dc_deploy_spdf(){    
        local base_root="/home/dcc.d"
        local dc_port=45427
        local dc_name='spdf'
        local dc_imag=frooodle/s-pdf:latest
        local dc_desc="Stirling PDF"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT

        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        volumes:
            - $fdat:/usr/share/tesseract-ocr/5/tessdata
            - $lfld/extraConfigs:/configs
            - $lfld/logs:/logs
        ports:
            - '$dc_port:8080'
        privileged: true
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 

        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }
    function dc_deploy_myip(){    
        local base_root="/home/dcc.d"
        local dc_port=45966
        local dc_name='myip'
        local dc_imag=ghcr.io/jason5ng32/myip:latest
        local dc_desc="MyIP-IP Checking"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT

        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        ports:
            - '$dc_port:18966'
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 

        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }
    function dc_deploy_dashdot(){    
        local base_root="/home/dcc.d"
        local dc_port=44009
        local dc_name='dashdot'
        local dc_imag=mauricenino/dashdot:latest
        local dc_desc="Dash."
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT

        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: ${dc_name}
        image: $dc_imag
        privileged: true
        ports:
            - '$dc_port:3001'
        volumes:
            - /:/mnt/host:ro
        restart: unless-stopped
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 

        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }
    function dc_deploy_wechat(){    
        local base_root="/home/dcc.d"
        local dc_port=45800
        local dc_vnc=45900
        local dc_name='wechat'
        local dc_imag=ricwang/docker-wechat:latest
        local dc_desc="WeChat(web)"
        local urlgit=''
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT

        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入VNC端口(默认为:${dc_vnc}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_vnc=$INPUT

        cat > "$fyml" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
      - ${fdat}:/root/downloads
      - /dev/snd:/dev/snd
      - ${lfld}/.xwechat:/root/.xwechat
      - ${lfld}/xwechat_files:/root/xwechat_files
    ports:
      - "$dc_port:5800"
      - "$dc_vnc:5900"
    environment:
      - LANG=zh_CN.UTF-8
      - USER_ID=0
      - GROUP_ID=0
      - WEB_AUDIO=1
      - TZ=Asia/Shanghai
    privileged: true
    restart: unless-stopped
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 

        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }
    function dc_deploy_neko(){    
        local base_root="/home/dcc.d"
        local dc_port=45427
        local dc_name='neko'
        local dc_imag=m1k1o/neko:microsoft-edge
        # local dc_imag=m1k1o/neko:firefox
        # local dc_imag=m1k1o/neko:chromium
        local dc_desc="Neko-Browser"
        local urlgit='https://neko.m1k1o.net/#/getting-started/quick-start'
        local domain=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) && cd $lfld
        [[ -f "$fyml"  ]] || touch $fyml

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT

        brkernel='microsoft-edge'
        echo -e ""
        echo -e "$PRIGHT 1.Edge(dafault)"
        echo -e "$PRIGHT 2.Firefox"
        echo -e "$PRIGHT 3.Chromium"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择浏览器内核(默认为:Edge): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && INPUT=1
        
        case "${INPUT}" in
        1) brkernel='microsoft-edge' ;;
        2) brkernel='firefox' ;;
        3) brkernel='chromium' ;;
        *) echo -e "\n$WARN 输入错误[Y/n],设置为默认Edge浏览器内核"  ;;
        esac
        
        local memsize=2
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入内存大小(默认为:${memsize}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && memsize=$INPUT

        local pssuser=neko
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入登录密码(默认为:${pssuser}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && pssuser=$INPUT

        local pssadmin=admin
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入管理员密码(默认为:${pssadmin}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && pssadmin=$INPUT

        cat > "$fyml" << EOF
services:
    ${dc_name}:
        container_name: m1k1o/neko:${brkernel}
        image: $dc_imag
        shm_size: "${memsize}gb"
        environment:
            NEKO_SCREEN: 1920x1080@30
            NEKO_PASSWORD: ${pssuser}
            NEKO_PASSWORD_ADMIN: ${pssadmin}
            NEKO_EPR: 52000-52100
            NEKO_ICELITE: 1
        ports:
            - '${dc_port}:8080'
            - "52000-52100:52000-52100/udp"
        restart: always
EOF

        docker-compose up -d 
        dc_set_domain_reproxy $dc_port 

        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $urlgit ]]  && content+="\nGitHub      : $urlgit  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }

    function dc_deploy_docker_win(){    
        local base_root="/home/dcc.d"
        local dc_port=48006
        local dc_name='docker_win'
        local dc_imag=dockurr/windows
        local dc_desc="Docker(win)"
        local domain=''
        local urlgit=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入VNC监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT

        local macver='2025'
        echo -e ""
        echo -e "$PRIGHT 1.2025(Windows Server 2025)"
        echo -e "$PRIGHT 2.2022(Windows Server 2022)"
        echo -e "$PRIGHT 3.2019(Windows Server 2019)"
        echo -e "$PRIGHT 4.win11(Windows 11)"
        echo -e "$PRIGHT 5.win10(Windows 10)"
        echo -e "$PRIGHT 6.tiny11(Tiny 11)"
        echo -e "$PRIGHT 7.tiny10(Tiny 10)"
        echo -e "$PRIGHT 8.Custom iso url "
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择Windows版本(默认为: Win2025): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && INPUT=1        
        case "${INPUT}" in
        1) macver='2025' ;;
        2) macver='2022' ;;
        3) macver='2019' ;;
        4) macver='win11' ;;
        5) macver='win10' ;;
        6) macver='tiny11' ;;
        7) macver='tiny10' ;;
        8) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入ISO镜像链接: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] && INPUT="2025"
            macver=$INPUT 
            ;;
        *) echo -e "\n$WARN 输入错误[Y/n],设置为默认2025"  ;;
        esac
        
        local lang="Chinese"
        echo -e "\n" " 可选择的语言 "
        echo -e "  " " 1.Chinese "
        echo -e "  " " 2.English "
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择Windows语言(默认为: Chinese): ${PLAIN}")
        read -rp "${CHOICE}" INPUT 
        [[ -z "$INPUT" ]] && INPUT=1 
        case "${INPUT}" in
        1) lang='Chinese' ;;
        2) lang='English' ;;
        *) echo -e "\n$WARN 输入错误[Y/n],设置为${lang}"  ;;
        esac
        
        local numcpu=4
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入CPU核心数(默认为:${numcpu}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && numcpu=$INPUT

        local memsize=4
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入内存大小(默认为:${memsize}GB): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && memsize=$INPUT

        local disksize=30
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入硬盘大小(默认为:${disksize}GB): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && disksize=$INPUT

        local user='dd'
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入登录账户(默认为:${user}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && user=$INPUT

        local pass='dd543212345'
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入登录密码(默认为:${pass}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && pass=$INPUT


        cat > "$fyml" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/kvm
    environment:
      VERSION: "${macver}"
      LANGUAGE: "${lang}"
      CPU_CORES: "${numcpu}"
      RAM_SIZE: "${memsize}"
      DISK_SIZE: "${disksize}"
      USERNAME: "${user}"
      PASSWORD: "${pass}"
    volumes:
      - $lfld/$dc_name/dcwin_disk:/storage
      - $lfld/$dc_name/dcwin_share:/shared
      # - ./example.iso:/custom.iso 
    ports:
      - ${dc_port}:8006
      - 5000:5000
      - 3389:3389/tcp
      - 3389:3389/udp
    stop_grace_period: 2m
    restart: unless-stopped
EOF

        local CHOICE=$(echo -e "\n${BOLD}└─ ${dc_name}配置文件已生成是否启动容器？[y/N]: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT="N"
        case "${INPUT}" in 
        [Yy] | [Yy][Ee][Ss]) 
            docker-compose up -d 
            ;; 
        [Nn] | [Nn][Oo]) 
            echo -e "$TIP 手动启动容器: " 
            echo -e "$TIP 配置目录: ${lfld}" 
            echo -e "$TIP 配置文件: ${fyml}" 
            echo -e "$TIP 运行命令: docker-compose up -d " 
            echo -e "$TIP 自定义镜像: docker-compose.yml > volumes:  - ./example.iso:/custom.iso " 
            ;;
        *)  echo -e "\n$WARN 输入错误！" ;;
        esac

        dc_set_domain_reproxy $dc_port 

        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $dc_desc ]] && content+="\nGitHub : # ${urlgit}  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }
    function dc_deploy_docker_mac(){    
        local base_root="/home/dcc.d"
        local dc_port=48009
        local dc_name='docker_mac'
        local dc_imag=dockurr/macos
        local dc_desc="Docker(mac)"
        local domain=''
        local urlgit=''

        local lfld="$base_root/$dc_name"
        local fdat="$base_root/$dc_name/data"
        local fyml="$lfld/docker-compose.yml"
        local fcfg="$lfld/${dc_name}.conf"

        ([[ -d "$fdat" ]] || mkdir -p $fdat) 
        [[ -f "$fyml"  ]] || touch $fyml
        cd $lfld

        echo -e "\n $TIP 现在开始部署${dc_desc} ... \n"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入VNC监听端口(默认为:${dc_port}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && dc_port=$INPUT

        macver='sonoma'
        echo -e ""
        echo -e "$PRIGHT 1.sonoma(MacOS Sonoma)"
        echo -e "$PRIGHT 2.ventura(MacOS Ventura)"
        echo -e "$PRIGHT 3.monterey(MacOS Monterey)"
        echo -e "$PRIGHT 4.big-sur(MacOS Big Sur)"
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择MacOS版本(默认为: sonoma): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] && INPUT=1        
        case "${INPUT}" in
        1) macver='sonoma' ;;
        2) macver='ventura' ;;
        3) macver='monterey' ;;
        4) macver='big-sur' ;;
        *) echo -e "\n$WARN 输入错误[Y/n],设置为默认sonoma"  ;;
        esac
        
        # local lang="Chinese"
        # echo -e "\n" " 可选择的语言 "
        # echo -e "  " " 1.Chinese "
        # echo -e "  " " 2.English "
        # local CHOICE=$(echo -e "\n${BOLD}└─ 请选择Windows语言(默认为: Chinese)]: ${PLAIN}")
        # read -rp "${CHOICE}" INPUT 
        # [[ -z "$INPUT" ]] && INPUT=1 
        # case "${INPUT}" in
        # 1) lang='Chinese' ;;
        # 2) lang='English' ;;
        # *) echo -e "\n$WARN 输入错误[Y/n],设置为${lang}"  ;;
        # esac
        
        local numcpu=4
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入CPU核心数(默认为:${numcpu}): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && numcpu=$INPUT

        local memsize=8
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入内存大小(默认为:${memsize}GB): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && memsize=$INPUT

        local disksize=42
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入硬盘大小(默认为:${disksize}GB): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -n "$INPUT" ]] && disksize=$INPUT

        # local user='dd'
        # local CHOICE=$(echo -e "\n${BOLD}└─ 请输入登录账户(默认为:${user}): ${PLAIN}")
        # read -rp "${CHOICE}" INPUT
        # [[ -n "$INPUT" ]] && user=$INPUT

        # local pass='dd543212345'
        # local CHOICE=$(echo -e "\n${BOLD}└─ 请输入登录密码(默认为:${pass}): ${PLAIN}")
        # read -rp "${CHOICE}" INPUT
        # [[ -n "$INPUT" ]] && pass=$INPUT

        cat > "$fyml" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/kvm
    environment:
      VERSION: "${macver}"
      LANGUAGE: "${lang}"
      CPU_CORES: "${numcpu}"
      RAM_SIZE: "${memsize}"
      DISK_SIZE: "${disksize}"
    volumes:
      - $lfld/$dc_name/dcmac_disk:/storage
      - $lfld/$dc_name/dcmac_share:/shared
    ports:
      - ${dc_port}:8006
      - 5000:5000
      - 3389:3389/tcp
      - 3389:3389/udp
    stop_grace_period: 2m
    restart: unless-stopped
EOF

        local CHOICE=$(echo -e "\n${BOLD}└─ ${dc_name}配置文件已生成是否启动容器？[y/N]: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT="N"
        case "${INPUT}" in 
        [Yy] | [Yy][Ee][Ss]) 
            docker-compose up -d 
            ;; 
        [Nn] | [Nn][Oo]) 
            echo -e "$TIP 手动启动容器: " 
            echo -e "$TIP 配置目录: ${lfld}" 
            echo -e "$TIP 配置文件: ${fyml}" 
            echo -e "$TIP 运行命令: docker-compose up -d " 
            ;;
        *)  echo -e "\n$WARN 输入错误！" ;;
        esac

        dc_set_domain_reproxy $dc_port 

        local content=''
        content+="\nService     : ${dc_name}"
        content+="\nContainer   : ${dc_name}"
        [[ -n $WAN4 ]]    && content+="\nURL(IPV4)   : http://$WAN4:$dc_port"
        [[ -n $WAN6 ]]    && content+="\nURL(IPV6)   : http://[$WAN6]:$dc_port"
        [[ -n $domain ]]  && content+="\nDomain      : $domain  "
        [[ -n $dc_desc ]] && content+="\nDescription : $dc_desc  "
        [[ -n $dc_desc ]] && content+="\nGitHub : # ${urlgit}  "

        echo -e "\n$TIP ${dc_desc}部署信息如下：\n"
        echo -e "$content" | tee $fcfg
        
        cd -  &>/dev/null # 返回原来目录 
    }

    #================================
    while true; do
        _IS_BREAK="true"
        print_menu_docker_deploy
        local CHOICE=$(echo -e "\n${BOLD}└─ 请选择要部署的容器: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1 ) dc_deploy_watchtower  ;;
        2 ) dc_deploy_rustdesk  ;;
        3 ) dc_deploy_nginxgui  ;;
        4 ) dc_deploy_openlitespeed  ;;
        5 ) dc_deploy_deeplx  ;;
        6 ) dc_deploy_aktools  ;;
        7 ) dc_deploy_sublinkx  ;;
        8 ) dc_deploy_lucky  ;;
        9 ) dc_deploy_alist  ;;
        10) dc_deploy_iptva  ;;
        11) dc_deploy_iptvd  ;;
        12) dc_deploy_docker_win  ;;
        13) dc_deploy_docker_mac  ;;
        14) dc_deploy_wechat  ;;
        21) dc_deploy_dashdot  ;;
        22) dc_deploy_myip  ;;
        23) dc_deploy_neko  ;;
        24) dc_deploy_ittools  ;;
        25) dc_deploy_spdf  ;;
        26) dc_deploy_code_linuxserver  ;;
        27) dc_deploy_code_official  ;;
        xx) sys_reboot ;;
        # 0)  echo -e "\n$TIP 返回上级菜单 ..." && _IS_BREAK="false"  && break  ;;
        0)  docker_management_menu && _IS_BREAK="false" && break  ;; 
        *)  _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！" && _IS_BREAK="true" ;;
        esac
        case_end_tackle
    done
}

# Docker管理
MENU_DOCKER_MANAGE_ITEMS=(
    "1|安装容器|$WHITE"
    "2|卸载容器|$WHITE"
    "3|清理容器|$WHITE"
    "4|重启服务|$CYAN"
    "11|状态查看|$GREEN"
    "12|容器列表|$YELLOW" 
    "13|镜像列表|$WHITE" 
    "14|网络列表|$WHITE" 
    "………………………|$WHITE" 
    "31|站点部署|$YELLOW" 
    "32|站点管理|$WHITE" 
    "33|设置dcc|$WHITE" 
)
function docker_management_menu(){
    function print_menu_dcc_manage(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        local num_split=$MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ Docker管理 " $num_split 0 0 
        split_menu_items MENU_DOCKER_MANAGE_ITEMS[@] 0
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }
    # 设置docker-compose快捷命令
    function docker_set_1ckl(){
        local CHOICE=$(echo -e "\n${BOLD}└─ 输入要设置的快捷命令[默认为: dcc] ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        local tcmd=$INPUT
        [[ -z $INPUT ]] && tcmd="dcc"
        if [[ -x "$(command -v $tcmd)" ]] ; then
            echo -e "$WARN 快捷命令${tcmd}已存在，请更换其他命令。"
            local tpath=$(which $tcmd)
            echo -e "\n$TIP ${tcmd} -> $tpath"
            return 1
        fi
        # rm -rf `which $tcmd` 
        tpath=/usr/local/bin/docker-compose
        chmod a+x $tpath 
        ln -s $tpath /usr/bin/$tcmd
    }
    ## 显示Docker版本信息
    function docker_show_info() {
        echo -e "\n${BOLD} ┌─ Docker版本信息${PLAIN} ────────"
        if [[ ! -x "$(command -v docker)" ]] ; then
            echo -e "$WARN  ${RED}Docker环境未安装。${PLAIN}"
        else
            docker --version
        fi
        if [[ ! -x "$(command -v docker-compose)" ]] ; then
            echo -e "$WARN  ${RED}docker-compose未安装。${PLAIN}"
        else
            docker-compose --version
        fi
        echo -e "${BOLD} └─────────────────────────${PLAIN}"
        # docker images
    }
    function docker_show_containers() {
        # docker_show_info
        echo -e "\n${BOLD} ┌─ Docker容器列表${PLAIN} ────────"
        if [[ ! -x "$(command -v docker)" ]] ; then
            echo -e "$WARN  ${RED}Docker环境未安装。${PLAIN}"
        else
            docker ps -a
        fi
        echo -e "${BOLD} └─────────────────────────${PLAIN}"
    }
    function docker_show_images() {
        # docker_show_info
        echo -e "\n${BOLD} ┌─ Docker镜像列表${PLAIN} ────────"
        if [[ ! -x "$(command -v docker)" ]] ; then
            echo -e "$WARN  ${RED}Docker环境未安装。${PLAIN}"
        else
            docker images
        fi
        echo -e "${BOLD} └─────────────────────────${PLAIN}"
    }
    function docker_show_networks() {
        # docker_show_info
        echo -e "\n${BOLD} ┌─ Docker容器网络${PLAIN} ────────"
        if [[ ! -x "$(command -v docker)" ]] ; then
            echo -e "$WARN  ${RED}Docker环境未安装。${PLAIN}"
        else
            docker network ls 
        fi
        echo -e "${BOLD} └─────────────────────────${PLAIN}"
    }
    
    # Docker清理不用的镜像和网络
    function docker_clean() {
        docker_show_info 
        [[ ! -x "$(command -v docker)" ]] && echo -e "$WARN Docker环境未安装，无需卸载。" && return 1
        local CHOICE=$(echo -e "\n${BOLD}└─ 是否清理镜像和网络？[Y/n] ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT='Y'
        case "$INPUT" in
        [Yy] | [Yy][Ee][Ss]) 
            docker system prune -af --volumes 
            echo -e "$TIP Docker清理完成"
            ;; 
        [Nn] | [Nn][Oo]) echo -e "$WARN Docker清理取消 " && return 1  ;;
        *) echo -e " 错误输入..." && return 1 ;;
        esac
    }
    # Docker卸载
    function docker_uninstall() {
        docker_show_info 
        [[ ! -x "$(command -v docker)" ]] && echo -e "$WARN Docker环境未安装，无需卸载。" && return 1
        local CHOICE=$(echo -e "\n${BOLD}└─ 是否真要卸载Docker？[Y/n] ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT='Y'
        case "$INPUT" in
        [Yy] | [Yy][Ee][Ss]) 
            docker rm $(docker ps -a -q) && docker rmi $(docker images -q) && docker network prune
            app_remove docker docker-ce docker-compose > /dev/null 2>&1
            echo -e "$TIP Docker环境卸载完成"
            ;; 
        [Nn] | [Nn][Oo]) echo -e "$WARN 卸载取消 " && return 1  ;;
        *) echo -e " 错误输入..." && return 1 ;;
        esac
    }
    function docker_install_official() {
        check_sys_virt 
        if [[ "$VIRT" =~ "LXC" ]]; then
            local CHOICE=$(echo -e "\n${BOLD}└─ 检测到${RED}LXC${PLAIN}服务器，不建议安装Docker。是否继续？[Y/n] ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] &&  INPUT='Y'
            case "$INPUT" in
            [Yy] | [Yy][Ee][Ss]) ;; 
            [Nn] | [Nn][Oo]) echo -e "$WARN 安装取消 " && return 1  ;;
            *) echo -e " 错误输入..." && return 1 ;;
            esac
        fi

        echo -e "\n $WORKING 开始安装Docker ...\n"
        if [ -f "/etc/alpine-release" ]; then
            apk update
            apk add docker docker-compose
            rc-update add docker default
            service docker start
        else
            sudo curl -fsSL https://get.docker.com | sh && sudo ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin
            sudo systemctl start docker
            sudo systemctl enable docker
        fi
    }
    function docker_check_docker_compose(){
        if command -v docker &>/dev/null; then
            if ! command -v docker-compose &>/dev/null; then
                if [ -f "/usr/libexec/docker/cli-plugins/docker-compose" ]; then
                    sudo ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin
                fi
            fi
        fi
    }
    function docker_install(){
        docker_check_docker_compose
        docker_show_info
        if command -v docker &>/dev/null; then
            echo ''
            echo -e "$PRIGHT Docker已安装 ..."
            generate_separator "=" 40
            docker --version
            docker-compose --version
            generate_separator "=" 40
            echo ''
        else
            echo -e ""
            echo -e "$PRIGHT Docker安装选项"
            generate_separator "=" 40
            echo -e " 1.Official(官方)"
            echo -e " 2.LinuxMirrors(${YELLOW}推荐${PLAIN})"
            echo -e " 3.LinuxMirrors(GitHub)"
            echo -e " 4.LinuxMirrors(Gitee)"
            echo -e " 5.LinuxMirrors(jsDelivr)"
            echo -e " 0.返回"
            generate_separator "=" 40

            _IS_BREAK='true'
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择？(默认官方): ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z "$INPUT" ]] &&  INPUT=1
            case "${INPUT}" in 
            1) docker_install_official ;; 
            2) bash <(curl -sSL https://linuxmirrors.cn/docker.sh) ;; 
            3) bash <(curl -sSL https://raw.githubusercontent.com/SuperManito/LinuxMirrors/main/DockerInstallation.sh) ;; 
            4) bash <(curl -sSL https://gitee.com/SuperManito/LinuxMirrors/raw/main/DockerInstallation.sh) ;; 
            5) bash <(curl -sSL https://cdn.jsdelivr.net/gh/SuperManito/LinuxMirrors@main/DockerInstallation.sh) ;; 
            0) _IS_BREAK='false' ;; 
            *) echo -e "\n$WARN 输入错误,返回！"  ;; 
            esac 
            docker_check_docker_compose
        fi
    }    
    function docker_enable_ipv6(){
        echo -e "\n $TIP 开启容器IPv6网络"
        local CONFIG_FILE="/etc/docker/daemon.json"
        local REQUIRED_IPV6_CONFIG='{"ipv6": true, "fixed-cidr-v6": "2001:db8:1::/64"}'

        app_install jq

        # 检查配置文件是否存在，如果不存在则创建文件并写入默认设置
        if [ ! -f "$CONFIG_FILE" ]; then
            echo "$REQUIRED_IPV6_CONFIG" | jq . > "$CONFIG_FILE"
            systemctl restart docker
        else
            # 使用jq处理配置文件的更新
            local ORIGINAL_CONFIG=$(<"$CONFIG_FILE")

            # 检查当前配置是否已经有 ipv6 设置
            local CURRENT_IPV6=$(echo "$ORIGINAL_CONFIG" | jq '.ipv6 // false')

            # 更新配置，开启 IPv6
            if [[ "$CURRENT_IPV6" == "false" ]]; then
                UPDATED_CONFIG=$(echo "$ORIGINAL_CONFIG" | jq '. + {ipv6: true, "fixed-cidr-v6": "2001:db8:1::/64"}')
            else
                UPDATED_CONFIG=$(echo "$ORIGINAL_CONFIG" | jq '. + {"fixed-cidr-v6": "2001:db8:1::/64"}')
            fi

            # 对比原始配置与新配置
            if [[ "$ORIGINAL_CONFIG" == "$UPDATED_CONFIG" ]]; then
                echo -e "${TIP} 当前已开启ipv6访问"
            else
                echo "$UPDATED_CONFIG" | jq . > "$CONFIG_FILE"
                systemctl restart docker
            fi
        fi
    }
    function docker_disable_ipv6(){
        echo -e "\n $TIP 关闭容器IPv6网络"
        local CONFIG_FILE="/etc/docker/daemon.json"
        app_install jq
        # 检查配置文件是否存在
        if [ ! -f "$CONFIG_FILE" ]; then
            echo -e "${gl_hong}配置文件不存在${gl_bai}"
            return
        fi

        # 读取当前配置
        local ORIGINAL_CONFIG=$(<"$CONFIG_FILE")

        # 使用jq处理配置文件的更新
        local UPDATED_CONFIG=$(echo "$ORIGINAL_CONFIG" | jq 'del(.["fixed-cidr-v6"]) | .ipv6 = false')

        # 检查当前的 ipv6 状态
        local CURRENT_IPV6=$(echo "$ORIGINAL_CONFIG" | jq -r '.ipv6 // false')

        # 对比原始配置与新配置
        if [[ "$CURRENT_IPV6" == "false" ]]; then
            echo -e "${TIP}当前已关闭ipv6访问"
        else
            echo "$UPDATED_CONFIG" | jq . > "$CONFIG_FILE"
            sytemctl restart docker
            echo -e "${TIP}已成功关闭ipv6访问"
        fi
    }
    # 验证配置
    function dc_verify_config() {
        echo -e "\n当前配置文件内容："
        cat "$CONFIG_FILE" 2>/dev/null || echo "配置文件不存在"
        
        echo -e "\nDocker服务状态："
        systemctl status docker --no-pager -l | head -n 6
        
        echo -e "\nIPv6路由表："
        ip -6 route show | grep docker0 || echo "未发现Docker IPv6路由"
    }
    #======== 启用IPv6
    function dc_enable_ipv6() {
        echo "正在启用Docker IPv6支持..."
        local tmpfile=$(mktemp)
        
        # 使用jq合并配置
        jq \
            --argjson ipv6 true \
            --arg fixed_cidr_v6 'fd00:dead:beef::/64' \
            --argjson ip6tables true \
            --argjson experimental true \
            '. + {ipv6: $ipv6, fixed-cidr-v6: $fixed_cidr_v6, ip6tables: $ip6tables, experimental: $experimental}' \
            "$CONFIG_FILE" > "$tmpfile"
        
        mv "$tmpfile" "$CONFIG_FILE"
    }
    #========= 禁用IPv6
    function dc_disable_ipv6() {
        echo "正在禁用Docker IPv6支持..."
        local tmpfile=$(mktemp)
        local CONFIG_FILE="/etc/docker/daemon.json"
        local BACKUP_FILE="/etc/docker/daemon.json.bak"
        local IPV6_CONFIG=('ipv6' 'true' 'fixed-cidr-v6' 'fd00:dead:beef::/64' 'ip6tables' 'true' 'experimental' 'true')
        
        # 使用jq删除相关字段
        jq \
            'del(.ipv6, ."fixed-cidr-v6", .ip6tables, .experimental)' \
            "$CONFIG_FILE" > "$tmpfile"
        
        mv "$tmpfile" "$CONFIG_FILE"
    }

    function docker_add_network_v4v6(){
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入网络名称(默认:1panel-v4v6): ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "$INPUT" ]] &&  INPUT="1panel-v4v6"
        
        echo -e "\n $TIP 添加${INPUT}之前，请先确保容器网络${RED}开启了bridge网络的IPv6${PLAIN}"
        docker network create --driver=bridge \
            --subnet=172.16.10.0/24 \
            --ipv6 \
            --subnet=fd00:dead:beef::/64 \
            ${INPUT}
        echo -e "\n $TIP 添加${INPUT}网络完成.\n"
    }
    function docker_manage_ipv6(){
        generate_separator "=" 40
        echo -e " 1.开启IPv6网络"
        echo -e " 2.关闭IPv6网络"
        echo -e " 3.添加v4v6网络"
        echo -e " 0.返回"
        generate_separator "=" 40
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) dc_enable_ipv6 ;;
        2) dc_disable_ipv6 ;;
        3) docker_add_network_v4v6 ;;
        0) echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false"  && return  ;;
        *) _BREAK_INFO=" 请输入有效的选项序号！" && _IS_BREAK="true" ;;
        esac
        # case_end_tackle
    }
    function docker_service_restart(){
        if ! command -v systemctl > /dev/null 2>&1; then 
            if ! systemctl status docker > /dev/null 2>&1; then
                systemctl stop docker && systemctl start docker
            else 
                echo -e "\n$TIP 系统未安装docker服务！"
            fi
        elif ! command -v service > /dev/null 2>&1;  then
            if ! service docker status > /dev/null 2>&1; then
                service  docker stop && service  docker start
            else 
                echo -e "\n$TIP 系统未安装docker服务！"
            fi
        else
            echo -e "\n$TIP 不支持的系统服务类型！"
        fi  
    } 
    function docker_get_id(){
        local head=${1:-'ID'}
        local dc_id=''
        local CHOICE=$(echo -e "\n${BOLD}└─ 输入${head}: ${PLAIN}")
        read -rp "${CHOICE}" INPUT 
        if [[ -n $INPUT ]]; then 
            local dc_id=$INPUT 
        else 
            echo -e "\n$WARN 请输入有效的ID！"
        fi
        echo "${dc_id}"
    }
    function docker_images_rm_all(){
        local CHOICE=$(echo -e "\n${BOLD}└─ 是否删除所有镜像? [Y/n] ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
        case "${INPUT}" in
        [Yy] | [Yy][Ee][Ss])
            echo -e "\n$TIP 删除所有镜像 ..."
            docker rmi -f $(docker images -q)
            echo -e "\n$TIP 删除所有镜像成功！"
            ;;
        [Nn] | [Nn][Oo])
            echo -e "\n$TIP 取消删除所有镜像！"
            ;;
        *)  _BREAK_INFO=" 输入错误！" && _IS_BREAK="true" ;;
        esac
    }
    function docker_containers_stop_all(){
        local CHOICE=$(echo -e "\n${BOLD}└─ 是否停止所有容器? [Y/n] ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
        case "${INPUT}" in
        [Yy] | [Yy][Ee][Ss])
            echo -e "\n$TIP 停止所有容器 ..."
            docker stop $(docker ps -q)
            echo -e "\n$TIP 停止所有容器成功！"
            ;;
        [Nn] | [Nn][Oo])
            echo -e "\n$TIP 取消停止所有容器！"
            ;;
        *)  _BREAK_INFO=" 输入错误！" && _IS_BREAK="true" ;;
        esac
    }
    function docker_containers_rm_all(){
        docker_containers_stop_all
        local CHOICE=$(echo -e "\n${BOLD}└─ 是否删除所有容器? [Y/n] ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
        case "${INPUT}" in
        [Yy] | [Yy][Ee][Ss])
            echo -e "\n$TIP 删除所有容器 ..."
            docker rm $(docker ps -a -q)
            echo -e "\n$TIP 删除所有容器成功！"
            ;;
        [Nn] | [Nn][Oo])
            echo -e "\n$TIP 取消删除所有容器！"
            ;;
        *)  _BREAK_INFO=" 输入错误！" && _IS_BREAK="true" ;;
        esac
    }
    function docker_network_list(){
        local dc_name=''
        local dc_items_list=(
            "1.删除网络|${RED}"
            "2.清理网络"
            "3.删除所有"
            "4.管理IPv6|${GREEN}"
            "0.返回"
        )

        while true; do
            clear 
            docker_show_networks
            print_items_list dc_items_list[@] " ⚓ 网络操作"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1)  dc_name=$(docker_get_id '网络名') && [[ -n ${dc_name} ]] && docker network rm $dc_name ;;
            2)  docker network prune ;; # 清理网络
            3)  docker_images_rm_all ;;
            4)  docker_manage_ipv6 ;;
            # 5)  docker_disable_ipv6 ;;
            # 6)  docker_add_network_v4v6 ;;
            0)  echo -e "\n$TIP 返回 ..." && _IS_BREAK="false" && break ;;
            *)  _BREAK_INFO=" 请输入有效选项！" ;;
            esac 
            case_end_tackle 
        done 
    }
    function docker_images_list(){
        local dc_name=''
        local dc_items_list=(
            "1.删除镜像|${RED}"
            "2.获取镜像"
            "3.更新镜像"
            "4.删除所有"
            "0.返回"
        )

        while true; do
            clear 
            docker_show_images 
            print_items_list dc_items_list[@] " ⚓ 镜像操作"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1)  dc_name=$(docker_get_id '镜像名') && [[ -n ${dc_name} ]] && docker images rm $dc_name ;;
            2)  dc_name=$(docker_get_id '镜像名') && [[ -n ${dc_name} ]] && docker pull $dc_name ;;
            3)  dc_name=$(docker_get_id '镜像名') && [[ -n ${dc_name} ]] && docker pull $dc_name ;;
            4)  docker_images_rm_all ;;
            0)  echo -e "\n$TIP 返回 ..." && _IS_BREAK="false" && break ;;
            *)  _BREAK_INFO=" 请输入有效选项！" ;;
            esac 
            case_end_tackle 
        done 
    }
    function docker_containers_list(){
        local dc_id=''
        local dc_items_list=(
            "1.删除容器|${RED}"
            "2.停止容器"
            "3.重启容器"
            "4.查看容器"
            "5.停止所有"
            "6.删除所有"
            "0.返回"
        )

        while true; do
            clear 
            docker_show_containers 
            print_items_list dc_items_list[@] " ⚓ 容器操作"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1)  dc_id=$(docker_get_id "容器ID") && [[ -n ${dc_id} ]] && docker stop $dc_id && docker rm $dc_id ;;
            2)  dc_id=$(docker_get_id "容器ID") && [[ -n ${dc_id} ]] && docker stop $dc_id ;;
            3)  dc_id=$(docker_get_id "容器ID") && [[ -n ${dc_id} ]] && docker restart $dc_id ;;
            4)  dc_id=$(docker_get_id "容器ID") && [[ -n ${dc_id} ]] && docker stats $dc_id ;;
            5)  docker_containers_stop_all ;;
            6)  docker_containers_rm_all ;;
            0)  echo -e "\n$TIP 返回 ..." && _IS_BREAK="false" && break ;;
            *)  _BREAK_INFO=" 请输入有效选项！" ;;
            esac 
            case_end_tackle 
        done 
    }

    while true; do
        _IS_BREAK="true"
        print_menu_dcc_manage
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1 ) docker_install ;;
        2 ) docker_uninstall ;;
        3 ) docker_clean ;;
        4 ) docker_service_restart ;;
        11) clear && docker_show_info && docker_show_containers && docker_show_images && docker_show_networks ;;
        12) docker_containers_list ;; 
        13) docker_images_list ;; 
        14) docker_network_list ;;
        31) docker_deploy_menu && _IS_BREAK="false"  ;;
        32) caddy_management_menu && _IS_BREAK="false" ;;
        33) docker_set_1ckl && _IS_BREAK="true" ;;
        xx) sys_reboot ;;
        0)  echo -e "\n$TIP 返回主菜单 ..." && _IS_BREAK="false"  && break  ;;
        # 0)  main_menu && _IS_BREAK="false"  && break  ;;
        *)  _BREAK_INFO=" 请输入有效的选项序号！" && _IS_BREAK="true" ;;
        esac
        case_end_tackle
    done

}

function print_web_urls(){
    echo -e "\n$TIP 常用网址："
    generate_separator "=" 45
    echo -e ""
    echo -e "  1. 哪吒面板:" "https://nezha.wiki"
    echo -e "   JSON生成器:" "https://nezhainfojson.pages.dev"
    echo -e "    自定义代码:" "https://nezhadash-docs.buycoffee.top/custom-code"
    echo -e "      流量监测:" "https://wiziscool.github.io/Nezha-Traffic-Alarm-Generator"
    echo -e ""
    echo -e "  2. 云盘:" "https://ypora.zwdk.im"
    echo -e "    Zfile:" "https://zf.zwdk.im"
    generate_separator "=" 45
    _IS_BREAK="true"
    # case_end_tackle
}

# 定义主菜单数组
MENU_MAIN_ITEMS=(
    "1|基本信息|$MAGENTA"
    "2|性能测试|$WHITE"
    "3|系统更新|$WHITE"
    "4|系统清理|$GREEN"
    "………………………|$WHITE" 
    "11|系统工具|$GREEN"
    "12|服务工具|$YELLOW"
    "13|常用软件|$WHITE" 
    "14|其他脚本|$BLUE"
    "21|Caddy管理|$WHITE"
    "22|Docker管理|$YELLOW"
    "23|Python管理|$CYAN"
    "24|Web URLs|$WHITE"
)
## ======================================================
function main_menu(){
    function print_menu_main(){
        clear 
        # 调用拆分函数
        print_menu_head $MAX_SPLIT_CHAR_NUM
        split_menu_items MENU_MAIN_ITEMS[@] 0
        print_main_menu_tail $MAX_SPLIT_CHAR_NUM
    }

    while true; do
        print_menu_main
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1)  print_system_info ;;
        2)  system_test_menu ;;
        3)  sys_update ;;
        4)  sys_clean ;;

        11) system_tools_menu ;;
        12) service_tools_menu ;;
        13) commonly_tools_menu ;;
        14) other_scripts_menu ;;

        21) caddy_management_menu ;;
        22) docker_management_menu ;;
        23) python_management_menu ;;
        24) print_web_urls ;;

        xx) sys_reboot ;;
        00) script_update ;;
        0)  echo -e "\n$WARN 退出脚本！${RESET}" && _IS_BREAK="false"  && exit 0  ;;
        *)  _BREAK_INFO=" 请输入正确的数字序号！" && _IS_BREAK="true" ;;
        esac
        case_end_tackle
    done
}


function script_update(){
    cd ~ &>/dev/null
    local fname='qiq.sh'
    echo -e "\n $TIP 检测更新中，请稍等..."
    local url_update=$(get_proxy_url $URL_UPDATE)
    local url_script=$(get_proxy_url $URL_SCRIPT)
    bash <(wget --no-check-certificate -qO- $url_update)
    echo -e "\n$TIP 脚本下载 ...\n"
    curl -SL -o ${fname} $url_script && \
    chmod +x ${fname} && \
    echo -e "$TIP 脚本已更新至最新版本！\n"
    _IS_BREAK="true"
    sleep 1
    case_end_tackle && _IS_BREAK="false"
    ./${fname} && _IS_BREAK="false" && exit 1; 
    # _IS_BREAK="false" && exit 1 && ./${fname} ; 
}

#=================
# 设置qiq快捷命令 
# set_qiq_alias 1
set_qiq_alias
# 初始化全局变量
init_global_vars

echo -e " Get region: $(get_region)\n"
# 检测系统IP地址
check_ip_status

# 显示主菜单 
main_menu

