#!/bin/bash

#========================================================
#   System Required: CentOS 7+ | Debian 8+ | Ubuntu 16+ | Alpine 3+ |
#   Description: QiQ一键安装脚本
#   GitHub : https://github.com/lmzxtek/qiqtools
#   GitCode: https://gitcode.com/lmzxtek/qiqtools
#   
#   一键安装命令如下：
#   $> wget -qO qiqtools.sh https://sub.zwdk.org/qiq && chmod +x qiqtools.sh && ./qiqtools.sh 
#   $> curl -sSL -o qiqtools.sh https://sub.zwdk.org/qiq && chmod +x qiqtools.sh && ./qiqtools.sh

#   $> wget -qN https://raw.gitcode.com/lmzxtek/qiqtools/raw/main/qiqtools.sh && chmod +x qiqtools.sh && ./qiqtools.sh 
#   $> curl -sS -O https://raw.gitcode.com/lmzxtek/qiqtools/raw/main/qiqtools.sh && chmod +x qiqtools.sh && ./qiqtools.sh
#========================================================

URL_PROXY='https://proxy.zwdk.org/proxy/'
URL_REDIRECT='https://sub.zwdk.org/qiq'
# url_script='https://raw.gitcode.com/lmzxtek/qiqtools/raw/main/qiqtools.sh'
# url_update='https://raw.gitcode.com/lmzxtek/qiqtools/raw/main/update_log.sh'
URL_SCRIPT='https://raw.githubusercontent.com/lmzxtek/qiqtools/refs/heads/main/src/qiqtools.sh'
URL_UPDATE='https://raw.githubusercontent.com/lmzxtek/qiqtools/refs/heads/main/src/update_log.sh'

#==== 脚本版本号 ===========
SRC_VER=v0.7.1
#==========================
# 设置脚本的快捷命令为 `qiq`
if ! command -v qiq &>/dev/null; then
  echo -e "\n >>> qiq 快捷命令未设置 ... "
  ln -sf ~/qiqtools.sh /usr/local/bin/qiq
fi

# Language
L=E
L=C

# Sehll颜色自定义：'\e'|'\033'|\x1B(^[,<Esc>,escape)
# 3x表示字的颜色，9x为浅色；4x表示背景色，10x则为浅背景色；组合颜色用;分割: e.g: echo -e “\e[1;4mBold and Underlined”
# https://blog.csdn.net/u010632165/article/details/92811856
 black='\033[0;30m'      # 黑色
   red='\033[0;31m'      # 红色
 GREEN='\033[0;32m'      # 绿色
yellow='\033[0;33m'      # 黄色
  BLUE='\033[0;34m'      # 蓝色
  pink='\033[0;35m'      # 紫色
  CYAN='\033[0;36m'      # 天蓝
 white='\033[0;37m'      # 白色|浅灰
 default='\033[0;39m'    # 默认前景色

FCMR='\033[39m'        # 前景色：默认
FCBL='\033[30m'        # 前景色：黑色
FCRE='\033[31m'        # 前景色：红色
FCGR='\033[32m'        # 前景色：绿色
FCYE='\033[33m'        # 前景色：黄色
FCLS='\033[34m'        # 前景色：蓝色
FCZS='\033[35m'        # 前景色：紫色
FCTL='\033[36m'        # 前景色：天蓝
FCQH='\033[37m'        # 前景色：白色|浅灰

BCMR='\033[49m'        # 背景色：默认
BCBL='\033[40m'        # 背景色：黑色
BCRE='\033[41m'        # 背景色：红色
BCGR='\033[42m'        # 背景色：绿色
BCYE='\033[43m'        # 背景色：黄色
BCLS='\033[44m'        # 背景色：蓝色
BCZS='\033[45m'        # 背景色：紫色
BCTL='\033[46m'        # 背景色：天蓝
BCQH='\033[47m'        # 背景色：白色|浅灰

FCSH='\033[90m'        # 前景：深灰
FCHD='\033[91m'        # 前景：红灯
FCLG='\033[92m'        # 前景：浅绿
FCDH='\033[93m'        # 前景：淡黄
FCLB='\033[94m'        # 前景：浅蓝
FCYH='\033[95m'        # 前景：浅洋红
FCQQ='\033[96m'        # 前景：浅青色
FCBS='\033[97m'        # 前景：白色

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

# e.g: echo -e ${BCHS}${FCSH}"hello"${FCMR}${BCMR}${FTCZ}
# e.g: echo -e ${BCHS}${FCSH}"hello"${FTCZ}

  bold='\033[1m'         # 字体常用显示：1-粗体高亮；2-淡化；3-斜体；4-下划线；5-闪烁；7-反显；8-隐藏(对密码隐藏比较好)；9-划掉；21-取消加粗；其他的类似
 blink='\033[2m'         # 字体常用显示：1-粗体高亮；2-淡化；3-斜体；4-下划线；5-闪烁；7-反显；8-隐藏(对密码隐藏比较好)；9-划掉；21-取消加粗；其他的类似
 PLAIN='\033[0m'         # 重置所有

# 自定义字体彩色，read 函数
#  txtn(){ echo -e "${plain}$*"; }                        # 常规字符
 txtn(){ echo -e "${PLAIN}$*${PLAIN}"; }                # 常规字符
 txtr(){ echo -e "${red}$*${PLAIN}"; }                  # 红色字符
 txtb(){ echo -e "${BLUE}$*${PLAIN}"; }                 # 蓝色字符
 txtc(){ echo -e "${CYAN}$*${PLAIN}"; }                 # 
 txtp(){ echo -e "${pink}$*${PLAIN}"; }                 # 
 txtg(){ echo -e "${GREEN}$*${PLAIN}"; }                # 绿色字符
 txtw(){ echo -e "${white}$*${PLAIN}"; }                # 
 txty(){ echo -e "${yellow}$*${PLAIN}"; }               # 黄色字符

echoT(){ FLAG=$1 && shift && echo -e "\033[39m$FLAG\033[39m$@";}
echoY(){ FLAG=$1 && shift && echo -e "\033[38;5;148m$FLAG\033[39m$@";}
echoG(){ FLAG=$1 && shift && echo -e "\033[38;5;71m$FLAG\033[39m$@"; }
echoB(){ FLAG=$1 && shift && echo -e "\033[38;1;34m$FLAG\033[39m$@" ;}
echoR(){ FLAG=$1 && shift && echo -e "\033[38;5;203m$FLAG\033[39m$@"; }
echoW(){ FLAG=${1} && shift && echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"; }
echoNW(){ FLAG=${1} && shift && echo -e "\033[1m${FLAG}\033[0m${@}"; }
echoCYAN(){ FLAG=$1 && shift && echo -e "\033[1;36m$FLAG\033[0m$@"; }

txbr(){ echo -e "${red}${bold}$*${PLAIN}"; }           # 红色粗体
txbp(){ echo -e "${pink}${bold}$*${PLAIN}"; }          # 粗体
txbb(){ echo -e "${BLUE}${bold}$*${PLAIN}"; }          # 粗体
txbc(){ echo -e "${CYAN}${bold}$*${PLAIN}"; }          # 粗体
txbw(){ echo -e "${white}${bold}$*${PLAIN}"; }         # 粗体
txbn(){ echo -e "${PLAIN}${bold}$*${PLAIN}"; }         # 粗体
txbg(){ echo -e "${GREEN}${bold}$*${PLAIN}"; }         # 粗体
txby(){ echo -e "${yellow}${bold}$*${PLAIN}"; }        # 粗体

error(){ echo -e "${red}${bold}$*${PLAIN}" && exit 1; } # 红色粗体并退出
  warning(){ echo -e "${red}$*${PLAIN}"; }              # 红色
highlight(){ echo -e "${yellow}$*${PLAIN}"; }           # 黄色

note(){ echo -e "${pink}${bold}$*${PLAIN}"; }          # 品色粗体
info(){ echo -e "${GREEN}${bold}$*${PLAIN}"; }         # 绿色粗体
hint(){ echo -e "${yellow}${bold}$*${PLAIN}"; }        # 黄色粗体

# 键值对输出
txtkvn() { local key="$1" && shift && local value=$(echo "$*" | tr -d '\n') && echo -e "${PLAIN}$key${PLAIN}$value${PLAIN}"; }
txtkvr() { local key="$1" && shift && local value=$(echo "$*" | tr -d '\n') && echo -e "${PLAIN}$key${red}$value${PLAIN}";   }
txtkvb() { local key="$1" && shift && local value=$(echo "$*" | tr -d '\n') && echo -e "${PLAIN}$key${BLUE}$value${PLAIN}";  }
txtkvg() { local key="$1" && shift && local value=$(echo "$*" | tr -d '\n') && echo -e "${PLAIN}$key${GREEN}$value${PLAIN}"; }
txtkvy() { local key="$1" && shift && local value=$(echo "$*" | tr -d '\n') && echo -e "${PLAIN}$key${yellow}$value${PLAIN}";}

reading() { read -rp "$(info "$1")" "$2"; }

# 显示标号对应的文字（中文或英文）
text() { grep -q '\$' <<< "${E[$*]}" && eval echo "\$(eval echo "\${${L}[$*]}")" || eval echo "\${${L}[$*]}"; }

  qiqtools() {   main_loop && exit; }
qiq_reload() { cd ~ && qiq && exit; }

# 操作完成，等待输入...
break_end() {
      echo -e "${GREEN} 操作完成 ${red}>> ${yellow} 按任意键继续${GREEN}..."
      read -n 1 -s -r -p ""
      echo ""
}


# 自定义谷歌翻译函数
translate() {
  [ -n "$@" ] && EN="$@"
  ZH=$(wget --no-check-certificate -qO- --tries=1 --timeout=2 "https://translate.google.com/translate_a/t?client=any_client_id_works&sl=en&tl=zh&q=${EN//[[:space:]]/}" 2>/dev/null)
  [[ "$ZH" =~ ^\[\".+\"\]$ ]] && cut -d \" -f2 <<< "$ZH"
}


# 安装应用程序
install() {
  if [ $# -eq 0 ]; then
    echo "未提供软件包参数!"
    return 1
  fi

  for package in "$@"; do
    if ! command -v "$package" &>/dev/null; then
      if command -v apt &>/dev/null; then
        sudo apt update -y && sudo apt install -y "$package"
      elif command -v dnf &>/dev/null; then
        sudo dnf -y update && sudo dnf -y install "$package"
      elif command -v yum &>/dev/null; then
        yum -y update && yum -y install "$package"
      elif command -v apk &>/dev/null; then
        apk update && apk add "$package"
      else
        echo "未知的包管理器!"
        return 1
      fi
    fi
  done

  return 0
}

remove() {
    if [ $# -eq 0 ]; then
        echo "未提供软件包参数!"
        return 1
    fi

    for package in "$@"; do
        if command -v apt &>/dev/null; then
            apt purge -y "$package"
        elif command -v dnf &>/dev/null; then
            dnf remove -y "$package"
        elif command -v yum &>/dev/null; then
            yum remove -y "$package"
        elif command -v apk &>/dev/null; then
            apk del "$package"
        else
            echo "未知的包管理器!"
            return 1
        fi
    done

    return 0
}

install_dependency() { clear && install curl wget socat unzip tar; }

# export PATH=$PATH:/usr/local/bin

cur_dir=$(pwd)

# 设置纯IPv6访问GitHub出问题的处理办法
set_ipv6_github(){
  # 若没有备份则先备份DNS信息
  [ ! -f /etc/resolv.conf.bak ] || cp /etc/resolv.conf /etc/resolv.conf.bak

  read -p "是否要更改DNS为[2001:67c:2b0::4,2001:67c:2b0::6]? [Y|n]: " choice
  case "$choice" in
    [Yy])
      echo -e "nameserver 2001:67c:2b0::4\nnameserver 2001:67c:2b0::6" > /etc/resolv.conf
      ;;
       *) echo " 不修改DNS..." ;;
  esac
}

check_IPV4(){
	# echo -e "[IPv4]"
  [[ -n "$IP4_INFO" ]] && return 1; 

	local check4=`ping 1.1.1.1 -c 1 2>&1`;
	if [[ "$check4" != *"received"* ]] && [[ "$check4" != *"transmitted"* ]];then
    IP4_INFO="${red}Not Supported${PLAIN}"
	else
    txtn " >>> Check IPv4 info ..."
		# local_ipv4=$(curl -4 -s --max-time 10 api64.ipify.org)
    local res_ipv4=$(curl -4 -sS --retry 2 --max-time 1 https://www.cloudflare.com/cdn-cgi/trace)
		local local_ipv4=$( echo -e "$res_ipv4" | grep "ip="   | awk -F= '{print $2}')
		local iso2_code4=$( echo -e "$res_ipv4" | grep "loc="  | awk -F= '{print $2}')
		local warp_ipv4=$( echo -e "$res_ipv4"  | grep "warp=" | awk -F= '{print $2}')
		# local local_isp4=$(curl -s -4 --max-time 1  --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" "https://api.ip.sb/geoip/${local_ipv4}" | grep organization | cut -f4 -d '"')
		local local_isp4=''
		# local iso2_code4=$(curl -4 -sS https://www.cloudflare.com/cdn-cgi/trace | grep "loc=" | awk -F= '{print $2}')
		# local warp_code4=$(curl -4 -sS https://www.cloudflare.com/cdn-cgi/trace | grep "warp=" | awk -F= '{print $2}')

    WAN4=$local_ipv4
    COUNTRY4=$iso2_code4
    ASNORG4=$local_isp4
    [[ "$warp_ipv4" =~ ^on$ ]] && WARPSTATUS4="${red}${bold}warp${PLAIN}"
    [[ "$warp_ipv4" =~ ^off$ ]] && [[ -n "$local_isp4" ]] && isp_info=$local_isp4
    [[ -n "$WAN4" ]] && IP4_INFO="($WARPSTATUS4 $iso2_code4 -> $local_isp4)"
	fi
}

check_IPV6(){
	# echo -e "[IPv6]"
  [[ -n "$IP6_INFO" ]] && return 1;

	local check6=`ping6 240c::6666 -c 1 2>&1`;
	if [[ "$check6" != *"received"* ]] && [[ "$check4" != *"transmitted"* ]];then
    IP6_INFO="${red}Not Supported${PLAIN}"
	else
    txtn " >>> Check IPv6 info ..."
		# local_ipv6=$(curl -6 -s --max-time 20 api64.ipify.org)
    local res_ipv6=$(curl -6 -sS --retry 1 --max-time 1 https://www.cloudflare.com/cdn-cgi/trace)
		local local_ipv6=$( echo -e "$res_ipv6" | grep "ip="   | awk -F= '{print $2}')
		local iso2_code6=$( echo -e "$res_ipv6" | grep "loc="  | awk -F= '{print $2}')
		local warp_ipv6=$( echo -e "$res_ipv6"  | grep "warp=" | awk -F= '{print $2}')
		# local local_isp6=$(curl -s -6 --max-time 1 --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" "https://api.ip.sb/geoip/${local_ipv6}" | grep organization | cut -f4 -d '"')
		local local_isp6=''
    
    WAN6=$local_ipv6
    COUNTRY6=$iso2_code6
    ASNORG6=$local_isp6
    [[ "$warp_ipv6" =~ ^on$ ]] && WARPSTATUS6="${red}${bold}warp${PLAIN}"
    [[ "$warp_ipv6" =~ ^off$ ]] && [[ -n "$local_isp6" ]] && isp_info=$local_isp6
    [[ -n "$WAN6" ]] && IP6_INFO="($WARPSTATUS6 $iso2_code6 -> $local_isp6)"
	fi
}

# 获取当前服务器的IP地址
check_IP_address() {
  get_asn_org4
  get_asn_org6
}

function get_asn_org4(){
  [[ -z "$WAN4" ]] || return 0;
  txtn " >>> Check IPv4 info ..."

  # curl -sS --retry 2 --max-time 1 : 静默+错误消息，重试2次，每次最长1s
  local response=$(curl -4 -sS --retry 2 --max-time 1 https://ifconfig.co/json)

  if [[ -z "$response" ]]; then
    echo "Error: Failed to fetch IPv4 information from ifconfig.co"
    return 1
  fi

  local loc_asn4=$(echo "$response" | grep -o '"asn": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')
  local loc_asn4_org=$(echo "$response" | grep -o '"asn_org": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')

  local res_ipv4=$(curl -4 -sS --retry 2 --max-time 1 https://www.cloudflare.com/cdn-cgi/trace)
  local loc_ip4=$( echo -e "$res_ipv4" | grep "loc="  | awk -F= '{print $2}')
  local warp_ipv4=$( echo -e "$res_ipv4"  | grep "warp=" | awk -F= '{print $2}')
  local local_ipv4=$( echo -e "$res_ipv4" | grep "ip="   | awk -F= '{print $2}')
  # local local_isp4=$loc_asn4

  WAN4=$local_ipv4
  COUNTRY4=$loc_ip4
  ASNORG4=$loc_asn4
  
  [[ "$warp_ipv4" =~ ^on$ ]] && WARPSTATUS4="${red}${bold}warp${PLAIN}"
  [[ "$warp_ipv4" =~ ^off$ ]] && [[ -n "$loc_asn4" ]] && isp_info=$loc_asn4
  [[ -n "$WAN4" ]] && IP4_INFO="($WARPSTATUS4 $loc_ip4 -> $loc_asn4, $loc_asn4_org)"

}

get_asn_org6(){
  [[ -n "$WAN6" ]] && return 1;
  txtn " >>> Check IPv6 info ..."

  # curl -sS --retry 2 --max-time 1 : 静默+错误消息，重试2次，每次最长1s
  local response=$(curl -6 -sS --retry 2 --max-time 1 https://ifconfig.co/json)
  # local loc_asn=$(echo "$response" | jq -r '.asn')
  # local loc_asn_org=$(echo "$response" | jq -r '.asn_org')
  local loc_asn6=$(echo "$response" | grep -o '"asn": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')
  local loc_asn6_org=$(echo "$response" | grep -o '"asn_org": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')

  local res_ipv6=$(curl -6 -sS --retry 2 --max-time 1 https://www.cloudflare.com/cdn-cgi/trace)
  local loc_ip6=$( echo -e "$res_ipv6" | grep "loc="  | awk -F= '{print $2}')
  local warp_ipv6=$( echo -e "$res_ipv6"  | grep "warp=" | awk -F= '{print $2}')
  local local_ipv6=$( echo -e "$res_ipv6" | grep "ip="   | awk -F= '{print $2}')

  WAN6=$local_ipv6
  COUNTRY6=$loc_ip6
  ASNORG6=$loc_asn6
  [[ "$warp_ipv6" =~ ^on$ ]] && WARPSTATUS6="${red}${bold}warp${PLAIN}"
  [[ "$warp_ipv6" =~ ^off$ ]] && [[ -n "$loc_asn6" ]] && isp_info=$loc_asn6
  # [[ "$warp_ipv6" =~ ^off$ ]] && [[ -n "$local_isp4" ]] && isp_info=$local_isp4
  [[ -n "$WAN6" ]] && IP6_INFO="($WARPSTATUS6 $loc_ip6 -> $loc_asn6, $loc_asn6_org)"

}

get_asn_org42(){
  local response=$(curl -4 -s --retry 2 --max-time 1 https://api.myip.la/en?json)
  local ip=$(echo "$response" | jq -r '.ip')
  local city=$(echo "$response" | jq -r '.location.city')
  local province=$(echo "$response" | jq -r '.location.province')
  local country_code=$(echo "$response" | jq -r '.location.country_code')
  local country_name=$(echo "$response" | jq -r '..location.country_name')


}
get_asn_org62(){
  local response=$(curl -6 -s --retry 2 --max-time 1 https://api.myip.la/en?json)
  local ip=$(echo "$response" | jq -r '.ip')
  local city=$(echo "$response" | jq -r '.location.city')
  local province=$(echo "$response" | jq -r '.location.province')
  local country_code=$(echo "$response" | jq -r '.location.country_code')
  local country_name=$(echo "$response" | jq -r '..location.country_name')
}

get_IPV4_IPV6(){
  WAN4=$(curl -sS --max-time 1 4.ipw.cn)
  WAN6=$(curl -sS --max-time 1 6.ipw.cn)
  }

# 重新检测服务器IP
recheck_ip_address(){
  WAN4=""
  WAN6=""
  IP4_INFO=""
  IP6_INFO=""
  check_IP_address
}



# 检测 IPv4 IPv6 信息
check_system_ip() {
  IP4=$(wget -4 -qO- --no-check-certificate --user-agent=Mozilla --tries=2 --timeout=1 http://ip-api.com/json/) &&
  WAN4=$(expr "$IP4" : '.*query\":[ ]*\"\([^"]*\).*') &&
  COUNTRY4=$(expr "$IP4" : '.*country\":[ ]*\"\([^"]*\).*') &&
  CITY4=$(expr "$IP4" : '.*city\":[ ]*\"\([^"]*\).*') &&
  ASNORG4=$(expr "$IP4" : '.*isp\":[ ]*\"\([^"]*\).*') &&
  WAN4=$WAN4 &&
  [[ "$L" = C && -n "$COUNTRY4" ]] && COUNTRY4=$(translate "$COUNTRY4") && 
  IP4_INFO="$WARPSTATUS4 $COUNTRY4 $CITY4 $ASNORG4"

  IP6=$(wget -6 -qO- --no-check-certificate --user-agent=Mozilla --tries=2 --timeout=1 https://api.ip.sb/geoip) &&
  WAN6=$(expr "$IP6" : '.*ip\":[ ]*\"\([^"]*\).*') &&
  COUNTRY6=$(expr "$IP6" : '.*country\":[ ]*\"\([^"]*\).*') &&
  CITY6=$(expr "$IP6" : '.*city\":[ ]*\"\([^"]*\).*') &&
  ASNORG6=$(expr "$IP6" : '.*isp\":[ ]*\"\([^"]*\).*') &&
  WAN6=$WAN6 &&
  [[ "$L" = C && -n "$COUNTRY6" ]] && COUNTRY6=$(translate "$COUNTRY6")&& 
  IP6_INFO="$WARPSTATUS6 $COUNTRY6 $CITY6 $ASNORG6"
}

# Output IP details to shell
WANIP_show(){
  txtn $(txty " IPv4:") $(txtr $WAN4)"\t"$(txtn $COUNTRY4) $(txtp $WARPSTATUS4)
  txtn $(txty " IPv6:") $(txtb $WAN6)"\t"$(txtn $COUNTRY6) $(txtp $WARPSTATUS6)
}

check_root() { [[ $EUID -ne 0 ]] && echo -e "${red}错误：${PLAIN} 必须使用root用户运行此脚本！\n" && exit 1; }

check_os() {
    # check os
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -Eqi "debian"; then
        release="debian"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -Eqi "debian"; then
        release="debian"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    else
        echo -e "${red}未检测到系统版本，请联系脚本作者！${PLAIN}\n" && exit 1
    fi
}

get_arch(){
    arch=$(arch)

    if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
        arch="64"
    elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
        arch="arm64-v8a"
    elif [[ $arch == "s390x" ]]; then
        arch="s390x"
    else
        arch="64"
        echo -e "${red}检测架构失败，使用默认架构: ${arch}${PLAIN}"
    fi

    # echo "架构: ${arch}"

    # if [ "$(getconf WORD_BIT)" != '32' ] && [ "$(getconf LONG_BIT)" != '64' ] ; then
    #     echo "本软件不支持 32 位系统(x86)，请使用 64 位系统(x86_64)，如果检测有误，请联系作者"
    #     exit 2
    # fi
}

get_os_version() {
    os_version=""

    # os version
    if [[ -f /etc/os-release ]]; then
        os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
    fi
    if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
        os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
    fi

    if [[ x"${release}" == x"centos" ]]; then
        if [[ ${os_version} -le 6 ]]; then
            echo -e "${red}请使用 CentOS 7 或更高版本的系统！${PLAIN}\n" && exit 1
        fi
    elif [[ x"${release}" == x"ubuntu" ]]; then
        if [[ ${os_version} -lt 16 ]]; then
            echo -e "${red}请使用 Ubuntu 16 或更高版本的系统！${PLAIN}\n" && exit 1
        fi
    elif [[ x"${release}" == x"debian" ]]; then
        if [[ ${os_version} -lt 8 ]]; then
            echo -e "${red}请使用 Debian 8 或更高版本的系统！${PLAIN}\n" && exit 1
        fi
    fi
}

check_virt(){
  # 判断虚拟化
  if [ $(type -p systemd-detect-virt) ]; then
    VIRT=$(systemd-detect-virt)
  elif [ $(type -p hostnamectl) ]; then
    VIRT=$(hostnamectl | awk '/Virtualization/{print $NF}')
  elif [ $(type -p virt-what) ]; then
    VIRT=$(virt-what)
  fi
  VIRT=${VIRT^^} || VIRT="UNKNOWN"
}

# 获取系统信息
get_sysinfo(){
    # 函数: 获取IPv4和IPv6地址
    local is2checkip=$1
    
    clear
    txby "\n Welcome to QiQTools "
    txtp "\n >>> Start get system Info."

    txtn "\n >>> Check Hostname ..."
    hostname=$(hostname)

    txtn "\n >>> Check CPU arch ..."
    cpu_arch=$(uname -m)

    txtn " >>> Check system archtecture ..."
    if [ "$(uname -m)" == "x86_64" ]; then
      cpu_info=$(cat /proc/cpuinfo | grep 'model name' | uniq | sed -e 's/model name[[:space:]]*: //')
    else
      cpu_info=$(lscpu | grep 'BIOS Model name' | awk -F': ' '{print $2}' | sed 's/^[ \t]*//')
    fi

    txtn " >>> Check System kernel version ..."
    kernel_version=$(uname -r)

    txtn " >>> Check system virtualization ..."
    check_virt

    # 尝试使用 lsb_release 获取系统信息
    txtn " >>> Check System version ..."
    os_info=$(lsb_release -ds 2>/dev/null)

    # 如果 lsb_release 命令失败，则尝试其他方法
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
    fi

    txtn "\n >>> Check CPU usage ..."
    cpu_usage=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')
    cpu_usage_percent=$(printf "%.2f" "$cpu_usage")%

    txtn " >>> Check CPU cores ..."
    cpu_cores=$(nproc)

    txtn "\n >>> Check Memory usage ..."
    mem_info=$(free -b | awk 'NR==2{printf "%.2f/%.2f MB (%.2f%%)", $3/1024/1024, $2/1024/1024, $3*100/$2}')

    txtn " >>> Check Disk usage ..."
    disk_info=$(df -h | awk '$NF=="/"{printf "%s/%s (%s)", $3, $2, $5}')

    txtn " >>> Check Swap information ..."
    swap_used=$(free -m | awk 'NR==3{print $3}')
    swap_total=$(free -m | awk 'NR==3{print $2}')

    if [ "$swap_total" -eq 0 ]; then
        swap_percentage=0
    else
        swap_percentage=$((swap_used * 100 / swap_total))
    fi

    swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

    txtn "\n >>> Check Congestion Algorithm ..."
    congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
    queue_algorithm=$(sysctl -n net.core.default_qdisc)

    txtn " >>> Check Sever data transfer ..."
    txt_data_transfer=$(awk 'BEGIN { rx_total = 0; tx_total = 0 }
        NR > 2 { rx_total += $2; tx_total += $10 }
        END {
            rx_units = "Bytes";
            tx_units = "Bytes";
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "KB"; }
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "MB"; }
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "GB"; }

            if (tx_total > 1024) { tx_total /= 1024; tx_units = "KB"; }
            if (tx_total > 1024) { tx_total /= 1024; tx_units = "MB"; }
            if (tx_total > 1024) { tx_total /= 1024; tx_units = "GB"; }

            printf("   总接收: %.2f %s\n   总发送: %.2f %s\n", rx_total, rx_units, tx_total, tx_units);
        }' /proc/net/dev)

    txtn "\n >>> Check Current time ..."
    current_time=$(date "+%Y-%m-%d %I:%M %p")
    txtn " >>> Check System running elapsed time ..."
    runtime=$(cat /proc/uptime | awk -F. '{run_days=int($1 / 86400);run_hours=int(($1 % 86400) / 3600);run_minutes=int(($1 % 3600) / 60); if (run_days > 0) printf("%d天 ", run_days); if (run_hours > 0) printf("%d时 ", run_hours); printf("%d分\n", run_minutes)}')

    # if [[ -n "$is2checkip"]] || [[ $is2checkip -eq 1 ]]; then
    if [[ $is2checkip -ne 1 ]]; then
      txtn "\n >>> Check IP address ..."
      check_IP_address
    fi
    # country=$(curl -s ipinfo.io/country)
    # city=$(curl -s ipinfo.io/city)
    # isp_info=$(curl -s ipinfo.io/org)

    txtn ""
    txtn "\n >>> System information check Done ...\n"
    txtn ""
}

# 显示系统信息
show_system_info() {
  get_sysinfo
  clear

  txtn " "
    info "系统信息查询"
  txtkvn "↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓"
  txtkvy "    ${BLUE}虚拟化: " "${yellow}${bold}$VIRT${PLAIN}"
  txtkvn "    主机名: " "$hostname"
  txtkvn "    运营商: " "$isp_info"
  txtkvn "  系统版本: " "$os_info"
  txtkvy "  内核版本: " "$kernel_version"
  txtkvn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  txtkvn "  CPU占用: " "$cpu_usage_percent"
  txtkvn "  CPU架构: " "${yellow}$cpu_arch${PLAIN}   核心数: ${yellow}$cpu_cores${PLAIN}"
  txtkvn "  CPU型号: " "$cpu_info"
  txtkvn "——————————————————————————————————————"
  txtkvy " 物理内存: " "$mem_info"
  txtkvn " 虚拟内存: " "$swap_info"
  txtkvy " 硬盘占用: " "$disk_info"
  txtkvn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  txtkvn " 系统时间: " "$current_time"
  txtkvn " 运行时长: " "$runtime"
  txtkvn "——————————————————————————————————————"
  txtkvy " IPv4地址: " "$WAN4\t$IP4_INFO"
  txtkvy " IPv6地址: " "$WAN6\t$IP6_INFO"
  # WANIP_show
  txtkvn "——————————————————————————————————————"
  txtkvn " 拥堵算法: " "${yellow}$congestion_algorithm" "${PLAIN}$queue_algorithm"
  txtkvn "$txt_data_transfer"
  txtkvn "↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑"
  # txtn " "
}


# format_size
# Purpose: Formats raw disk and memory sizes from kibibytes (KiB) to largest unit
# Parameters:
#          1. RAW - the raw memory size (RAM/Swap) in kibibytes
# Returns:
#          Formatted memory size in KiB, MiB, GiB, or TiB
function format_size {
	RAW=$1 # mem size in KiB
	RESULT=$RAW
	local DENOM=1
	local UNIT="KiB"

	# ensure the raw value is a number, otherwise return blank
	re='^[0-9]+$'
	if ! [[ $RAW =~ $re ]] ; then
		echo "" 
		return 0
	fi

	if [ "$RAW" -ge 1073741824 ]; then
		DENOM=1073741824
		UNIT="TiB"
	elif [ "$RAW" -ge 1048576 ]; then
		DENOM=1048576
		UNIT="GiB"
	elif [ "$RAW" -ge 1024 ]; then
		DENOM=1024
		UNIT="MiB"
	fi

	# divide the raw result to get the corresponding formatted result (based on determined unit)
	RESULT=$(awk -v a="$RESULT" -v b="$DENOM" 'BEGIN { print a / b }')
	# shorten the formatted result to two decimal places (i.e. x.x)
	RESULT=$(echo $RESULT | awk -F. '{ printf "%0.1f",$1"."substr($2,1,2) }')
	# concat formatted result value with units and return result
	RESULT="$RESULT $UNIT"
	echo $RESULT
}

command -v ping >/dev/null 2>&1 && LOCAL_PING=true || unset LOCAL_PING
command -v curl >/dev/null 2>&1 && LOCAL_CURL=true || unset LOCAL_CURL
[[ ! -z $LOCAL_CURL ]] && IP_CHECK_CMD="curl -s -m 4" || IP_CHECK_CMD="wget -qO- -T 4"
IPV4_CHECK=$( (ping -4 -c 1 -W 4 ipv4.google.com >/dev/null 2>&1 && echo true) || $IP_CHECK_CMD -4 icanhazip.com 2> /dev/null)
IPV6_CHECK=$( (ping -6 -c 1 -W 4 ipv6.google.com >/dev/null 2>&1 && echo true) || $IP_CHECK_CMD -6 icanhazip.com 2> /dev/null)

gather_sysinfo(){

  # gather basic system information (inc. CPU, AES-NI/virt status, RAM + swap + disk size)

  UPTIME=$(uptime | awk -F'( |,|:)+' '{d=h=m=0; if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}')

  # check for local lscpu installs
  command -v lscpu >/dev/null 2>&1 && LOCAL_LSCPU=true || unset LOCAL_LSCPU
  if [[ $ARCH = *aarch64* || $ARCH = *arm* ]] && [[ ! -z $LOCAL_LSCPU ]]; then
    CPU_PROC=$(lscpu | grep "Model name" | sed 's/Model name: *//g')
  else
    CPU_PROC=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
  fi

  if [[ $ARCH = *aarch64* || $ARCH = *arm* ]] && [[ ! -z $LOCAL_LSCPU ]]; then
    CPU_CORES=$(lscpu | grep "^[[:blank:]]*CPU(s):" | sed 's/CPU(s): *//g')
    CPU_FREQ=$(lscpu | grep "CPU max MHz" | sed 's/CPU max MHz: *//g')
    [[ -z "$CPU_FREQ" ]] && CPU_FREQ="???"
    CPU_FREQ="${CPU_FREQ} MHz"
  else
    CPU_CORES=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
    CPU_FREQ=$(awk -F: ' /cpu MHz/ {freq=$2} END {print freq " MHz"}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
  fi

  CPU_AES=$(cat /proc/cpuinfo | grep aes)
  [[ -z "$CPU_AES" ]] && CPU_AES="\xE2\x9D\x8C Disabled" || CPU_AES="\xE2\x9C\x94 Enabled"
  CPU_VIRT=$(cat /proc/cpuinfo | grep 'vmx\|svm')
  [[ -z "$CPU_VIRT" ]] && CPU_VIRT="\xE2\x9D\x8C Disabled" || CPU_VIRT="\xE2\x9C\x94 Enabled"

  TOTAL_RAM_RAW=$(free | awk 'NR==2 {print $2}')
  TOTAL_RAM=$(format_size $TOTAL_RAM_RAW)
  TOTAL_SWAP_RAW=$(free | grep Swap | awk '{ print $2 }')
  TOTAL_SWAP=$(format_size $TOTAL_SWAP_RAW)

  # total disk size is calculated by adding all partitions of the types listed below (after the -t flags)
  TOTAL_DISK_RAW=$(df -t simfs -t ext2 -t ext3 -t ext4 -t btrfs -t xfs -t vfat -t ntfs -t swap --total 2>/dev/null | grep total | awk '{ print $2 }')
  TOTAL_DISK=$(format_size $TOTAL_DISK_RAW)
  DISTRO=$(grep 'PRETTY_NAME' /etc/os-release | cut -d '"' -f 2 )

  KERNEL=$(uname -r)
  VIRT=$(systemd-detect-virt 2>/dev/null)
  VIRT=${VIRT^^} || VIRT="UNKNOWN"

  [[ -z "$IPV4_CHECK" ]] && ONLINE="\xE2\x9D\x8C Offline | " || ONLINE="\xE2\x9C\x94 Online | "
  [[ -z "$IPV6_CHECK" ]] && ONLINE+="\xE2\x9D\x8C Offline" || ONLINE+="\xE2\x9C\x94 Online"
  # [[ -z "$IPV6_CHECK" ]] && ONLINE+="❌ Offline" || ONLINE+="✔ Online"

  echo -e 
  echo -e "${yellow}Basic System Information:${PLAIN}"
  echo -e "---------------------------------"

  echo -e "Uptime     : $UPTIME"
  echo -e "Processor  : $CPU_PROC"
  echo -e "CPU cores  : $CPU_CORES @ $CPU_FREQ"
  echo -e "AES-NI     : $CPU_AES"
  echo -e "VM-x/AMD-V : $CPU_VIRT"
  echo -e "RAM        : $TOTAL_RAM"
  echo -e "Swap       : $TOTAL_SWAP"
  echo -e "Disk       : $TOTAL_DISK"
  echo -e "Distro     : $DISTRO"
  echo -e "Kernel     : $KERNEL"
  echo -e "VM Type    : ${red}$VIRT${PLAIN}"
  echo -e "IPv4|IPv6  : $ONLINE"

  # echoT "VM Type    :" ${red}$VIRT${plain}
  # echoG "IPv4|IPv6  :" $ONLINE

}

# Function to get information from IP Address using ip-api.com free API
function ip_info() {

	# check for curl vs wget
	[[ ! -z $LOCAL_CURL ]] && DL_CMD="curl -s" || DL_CMD="wget -qO-"

	local ip6me_resp="$($DL_CMD http://ip6.me/api/)"
	local net_type="$(echo $ip6me_resp | cut -d, -f1)"
	local net_ip="$(echo $ip6me_resp | cut -d, -f2)"

	local response=$($DL_CMD http://ip-api.com/json/$net_ip)

	# if no response, skip output
	if [[ -z $response ]]; then
		return
	fi

	local country=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^country/ {print $2}' | head -1 | sed 's/^"\(.*\)"$/\1/')
	local region=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^regionName/ {print $2}' | sed 's/^"\(.*\)"$/\1/')
	local region_code=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^region/ {print $2}' | head -1 | sed 's/^"\(.*\)"$/\1/')
	local city=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^city/ {print $2}' | sed 's/^"\(.*\)"$/\1/')
	local isp=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^isp/ {print $2}' | sed 's/^"\(.*\)"$/\1/')
	local org=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^org/ {print $2}' | sed 's/^"\(.*\)"$/\1/')
	local as=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^as/ {print $2}' | sed 's/^"\(.*\)"$/\1/')
	
	echo -e ""
	echo -e "${yellow}$net_type Network Information:${PLAIN}"
	echo -e "---------------------------------"

	if [[ -n "$isp" ]]; then
		echo "ISP        : $isp"
	else
		echo "ISP        : Unknown"
	fi
	if [[ -n "$as" ]]; then
		echo "ASN        : $as"
	else
		echo "ASN        : Unknown"
	fi
	if [[ -n "$org" ]]; then
		echo "Host       : $org"
	fi
	if [[ -n "$city" && -n "$region" ]]; then
		echo "Location   : $city, $region ($region_code)"
	fi
	if [[ -n "$country" ]]; then
		echo "Country    : $country"
	fi 
	echo

	# [[ ! -z $JSON ]] && JSON_RESULT+=',"ip_info":{"protocol":"'$net_type'","isp":"'$isp'","asn":"'$as'","org":"'$org'","city":"'$city'","region":"'$region'","region_code":"'$region_code'","country":"'$country'"}'
}

# if [ ! -z $JSON ]; then
# 	UPTIME_S=$(awk '{print $1}' /proc/uptime)
# 	IPV4=$([ ! -z $IPV4_CHECK ] && echo "true" || echo "false")
# 	IPV6=$([ ! -z $IPV6_CHECK ] && echo "true" || echo "false")
# 	AES=$([[ "$CPU_AES" = *Enabled* ]] && echo "true" || echo "false")
# 	CPU_VIRT_BOOL=$([[ "$CPU_VIRT" = *Enabled* ]] && echo "true" || echo "false")
# 	JSON_RESULT='{"version":"'$YABS_VERSION'","time":"'$TIME_START'","os":{"arch":"'$ARCH'","distro":"'$DISTRO'","kernel":"'$KERNEL'",'
# 	JSON_RESULT+='"uptime":'$UPTIME_S',"vm":"'$VIRT'"},"net":{"ipv4":'$IPV4',"ipv6":'$IPV6'},"cpu":{"model":"'$CPU_PROC'","cores":'$CPU_CORES','
# 	JSON_RESULT+='"freq":"'$CPU_FREQ'","aes":'$AES',"virt":'$CPU_VIRT_BOOL'},"mem":{"ram":'$TOTAL_RAM_RAW',"ram_units":"KiB","swap":'$TOTAL_SWAP_RAW',"swap_units":"KiB","disk":'$TOTAL_DISK_RAW',"disk_units":"KB"}'
# fi


# 更新系统
sys_update_and_upgrade() {
    
    # Update system on Debian-based systems
    if [ -f "/etc/debian_version" ]; then
        apt update -y && DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
    fi

    # Update system on Red Hat-based systems
    if [ -f "/etc/redhat-release" ]; then
        yum -y update
    fi

    # Update system on Alpine Linux
    if [ -f "/etc/alpine-release" ]; then
        apk update && apk upgrade
    fi
}


# 更新系统
sys_update() {
    
    # Update system on Debian-based systems
    if [ -f "/etc/debian_version" ]; then
        apt update -y
    fi

    # Update system on Red Hat-based systems
    if [ -f "/etc/redhat-release" ]; then
        yum -y update
    fi

    # Update system on Alpine Linux
    if [ -f "/etc/alpine-release" ]; then
        apk update 
    fi
}

clean_debian() {
    apt autoremove --purge -y
    apt clean -y
    apt autoclean -y
    apt remove --purge $(dpkg -l | awk '/^rc/ {print $2}') -y
    journalctl --rotate
    journalctl --vacuum-time=1s
    journalctl --vacuum-size=50M
    apt remove --purge $(dpkg -l | awk '/^ii linux-(image|headers)-[^ ]+/{print $2}' | grep -v $(uname -r | sed 's/-.*//') | xargs) -y
}

clean_redhat() {
    yum autoremove -y
    yum clean all
    journalctl --rotate
    journalctl --vacuum-time=1s
    journalctl --vacuum-size=50M
    yum remove $(rpm -q kernel | grep -v $(uname -r)) -y
}

clean_alpine() {
    apk del --purge $(apk info --installed | awk '{print $1}' | grep -v $(apk info --available | awk '{print $1}'))
    apk autoremove
    apk cache clean
    rm -rf /var/log/*
    rm -rf /var/cache/apk/*

}

# 清理系统
clean_sys() {
    # Main script
    if [ -f "/etc/debian_version" ]; then
        # Debian-based systems
        clean_debian
    elif [ -f "/etc/redhat-release" ]; then
        # Red Hat-based systems
        clean_redhat
    elif [ -f "/etc/alpine-release" ]; then
        # Alpine Linux
        clean_alpine
    fi
}

# 设置docker-compose快捷命令
docker_set_1ckl(){

  tcmd="dcc"
  reading "\n 请输入要设置的快捷键[dcc]: " ccmd

  [[ -n $ccmd ]] && tcmd=$ccmd
  chmod a+x /usr/local/bin/docker-compose 
  rm -rf `which $tcmd` 
  ln -s /usr/local/bin/docker-compose /usr/bin/$tcmd
}

install_add_docker() {
  
  if [[ "$VIRT" =~ "LXC" ]]; then
    echo -e "\n >>> 检测到${red}LXC${PLAIN}服务器，不建议安装Docker。\n"
    read -p " 安装docker环境吗？(输入Y[y]继续): " choice
    case "$choice" in
      [Yy]) clear ;;
      # [Nn]) return 1 ;;
         *) echo -e " 安装取消..." && return 1 ;;
    esac
  fi

  echo -e "\n >>> 开始安装Docker ...\n"
  if [ -f "/etc/alpine-release" ]; then
    apk update
    apk add docker docker-compose
    rc-update add docker default
    service docker start
  else
    curl -fsSL https://get.docker.com | sh && ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin
    systemctl start docker
    systemctl enable docker
  fi
}

# Docker安装
docker_install() {
  if ! command -v docker &>/dev/null; then
      echo -e "\n >>> Docker未安装 ..."
      
    read -p "使用LinuxMirror安装吗,否则使用官方脚本安装？(Y|y): " choice
    case "$choice" in
      [Yy])
        bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
        ;;
        *) 
        install_add_docker
        docker_set_1ckl
        ;;
      # [Nn]) 
      #   echo "无效的选择，请输入 Y 或 N。" ;;
    esac

  else
    echo -e "\n >>> Docker已安装 ..."
    docker --version
    docker-compose --version
    echo -e ""
  fi
}

# Docker卸载
docker_uninstall() {
  clear
  read -p "确定卸载docker环境吗？(Y/N): " choice
  case "$choice" in
    [Yy])
      docker rm $(docker ps -a -q) && docker rmi $(docker images -q) && docker network prune
      remove docker docker-ce docker-compose > /dev/null 2>&1
      ;;
    [Nn]) ;;
       *) echo "无效的选择，请输入 Y 或 N。" ;;
  esac
}

# Docker清理不用的镜像和网络
docker_clean() {
  # clear
  read -p "确定清理无用的容器镜像和容器网络吗？[Y|N]: " choice
  case "$choice" in
    [Yy]) docker system prune -af --volumes ;;
    [Nn]) echo "操作取消..." ;;
        *) echo "无效的选择，请输入 Y 或 N" ;;
  esac
}


# Docker列表：版本，镜像，网络和卷
docker_info_list() {
  clear
  echo -e "\n ☞☞☞ Dcoker版本"
  txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  docker --version
  docker-compose --version
  
  echo -e "\n ☞☞☞ Dcoker镜像列表"
  txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  docker image ls
  
  echo -e "\n ☞☞☞ Dcoker容器列表"
  txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  docker ps -a

  echo -e "\n ☞☞☞ Dcoker卷列表"
  txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  docker volume ls
  
  echo -e "\n ☞☞☞ Dcoker网络列表"
  txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  docker network ls

  echo ""
}



# 安装常用工具
common_apps_menu() {
  
txtn " "
txtn $(txby "▼ 常用工具")$(txtp " ❃❃❃ ")
txtn "—————————————————————————————————————"
# WANIP_show
# txtn "====================================="
txtn $(txtn " 1.curl(下载工具)")$(txtc " ")"      "$(txtn "11.htop(系统监控)")$(txtg " ")
txtn $(txtn " 2.wget(下载工具)")$(txtg " ")"      "$(txtr "12.btop(现代化监控)")$(txtb " ❀")
txtn $(txtn " 3.sudo(超级管理权限)")$(txtg " ")"  "$(txtn "13.iftop(网络流量监控)")$(txtg " ")
txtn $(txty " 4.gdu(磁盘占用查看)")$(txtg " ")"   "$(txtn "14.tar(GZ压缩解压)")$(txtg " ")
txtn $(txtn " 5.fzf(文件管理)")$(txtg " ")"       "$(txtn "15.unzip(ZIP压缩解压)")$(txtg " ")
txtn $(txtn " 6.ranger(全局搜索)")$(txtg " ")"    "$(txtn "16.ffmpeg(视频编码直播推流)")$(txtg " ")
txtn $(txtn " 7.tmux(多路后台运行)")$(txtg " ")"  "$(txtn "17.socat(通信连接(申请域名证书必备))")$(txtg " ")
txtn $(txty " 8.SuperVisor")$(txtb " ★")"         "$(txtn "18.pure-ftp")$(txtb " ")
txtn $(txty " 9.Fail2Ban")$(txtg " ★")"           "$(txtn "19.ClamAV(病毒扫描)")$(txtg " ")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "31.全部安装")$(txtg " ★")"           "$(txtn "41.安装指定工具")$(txtg " ")
txtn $(txtn "32.全部卸载")$(txtg " ")"            "$(txtn "42.卸载指定工具")$(txtg " ")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "61.贪吃蛇")$(txtg "£")"              "$(txtn "71.sl(跑火车屏保)")$(txtg "→")
txtn $(txtn "62.俄罗斯方块")$(txtg "▣")"          "$(txtn "72.cmatrix(黑客帝国屏保)")$(txtg "┇┊")
txtn $(txtn "63.太空入侵者")$(txtg "➹")"          "$(txtn "73.最新天气")$(txty "☀")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtc "88.Sky-Box工具箱")$(txtr "")"        "$(txty "99.KejiLion脚本")$(txtc "")$(txty "")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"          "$(txty "")$(txtc "")$(txty "")
txtn " "

}

common_apps_run() {
  while true; do 
    clear && common_apps_menu
    reading "请输入你的选择: " sub_choice

    case $sub_choice in
      1) clear && install curl   && clear && echo "工具已安装，使用方法如下：" && curl   --help ;;
      2) clear && install wget   && clear && echo "工具已安装，使用方法如下：" && wget   --help ;;
      3) clear && install sudo   && clear && echo "工具已安装，使用方法如下：" && sudo   --help ;;
      4) clear && install gdu    && cd / && clear && gdu    && cd ~ ;;
      5) clear && install fzf    && cd / && clear && fzf    && cd ~ ;;
      6) clear && install ranger && cd / && clear && ranger && cd ~ ;;
      7) clear && install tmux   && clear && echo "工具已安装，使用方法如下：" && tmux   --help ;;
      8) clear && install supervisor ;;
      9)clear 
        install fail2ban
        sudo apt-get install rsyslog -y
        sudo systemctl start fail2ban
        sudo systemctl enable fail2ban
        sudo systemctl status fail2ban
        ;;

     11) clear && install htop   && clear && htop  ;;
     12) clear && install btop    ;;
     13) clear && install iftop  && clear && iftop ;;
     14) clear && install tar    && clear && echo "工具已安装，使用方法如下：" && tar    --help ;;
     15) clear && install unzip  && clear && echo "工具已安装，使用方法如下：" && unzip  ;;
     16) clear && install ffmpeg && clear && echo "工具已安装，使用方法如下：" && ffmpeg --help ;;
     17) clear && install socat  && clear && echo "工具已安装，使用方法如下：" && socat  --h    ;;
     18) clear && install pure-ftpd  ;;
     19) clear 
         install clamav clamav-daemon 
         sudo systemctl start clamav-daemon
         sudo systemctl start clamav-freshclam.service
         sudo systemctl enable clamav-daemon
         sudo systemctl enable clamav-freshclam.service
         sudo systemctl status clamav-daemon
         sudo systemctl status clamav-freshclam.service
         ;;
     
     31) clear && install sudo curl wget btop gdu supervisor
        install fail2ban
        sudo apt-get install rsyslog -y
        sudo systemctl start fail2ban
        sudo systemctl enable fail2ban
        sudo systemctl status fail2ban
      ;;

     32) clear && remove btop gdu ;;
 
     41) clear && reading "请输入安装的工具名(wget curl): " installname && install $installname ;;
     42) clear && reading "请输入卸载的工具名(htop ufw): "  removename  && remove  $removename  ;;

     61) clear && install nsnake    && clear && /usr/games/nsnake ;;
     62) clear && install bastet    && clear && /usr/games/bastet ;;
     63) clear && install ninvaders && clear && /usr/games/ninvaders ;;

     71) clear && install sl        && clear && /usr/games/sl ;;
     72) clear && install cmatrix   && clear && cmatrix ;;
     73) clear && curl wttr.in ;; 

     88) clear && 
        country=$(curl -s --connect-timeout 1 --max-time 3 ipinfo.io/country)
        if [ "$country" = "CN" ]; then
          wget -O box.sh https://proxy.063643.xyz/proxy/https://raw.githubusercontent.com/BlueSkyXN/SKY-BOX/main/box.sh && chmod +x box.sh && clear && ./box.sh
        else
          wget -O box.sh https://raw.githubusercontent.com/BlueSkyXN/SKY-BOX/main/box.sh && chmod +x box.sh && clear && ./box.sh
        fi
      ;;

     99) clear 
        country=$(curl -s --connect-timeout 1 --max-time 3 ipinfo.io/country)
        if [ "$country" = "CN" ]; then
          curl -sS -O https://kejilion.pro/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh
        else
          bash <(curl -sL kejilion.sh)
          # curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh
        fi
        ;;
     
      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
  done
}


# 安装最新版本的python
install_python() {
  # 系统检测
  OS=$(cat /etc/os-release | grep -o -E "Debian|Ubuntu|CentOS" | head -n 1)

  if [[ $OS == "Debian" || $OS == "Ubuntu" || $OS == "CentOS" ]]; then
      echo -e "检测到你的系统是 ${YELLOW}${OS}${NC}"
  else
      echo -e "${RED}很抱歉，你的系统不受支持！${NC}"
      exit 1
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
          exit 1
      fi
  else
      echo -e "${RED}检测到没有安装Python3。${NC}"
      read -p "是否确认安装最新版Python3？默认安装 [Y/n]: " CONFIRM
      if [[ $CONFIRM != "n" ]]; then
          echo -e "${GREEN}开始安装最新版Python3...${NC}"
      else
          echo -e "${YELLOW}已取消安装Python3${NC}"
          exit 1
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

iptables_open() {
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -F

    ip6tables -P INPUT ACCEPT
    ip6tables -P FORWARD ACCEPT
    ip6tables -P OUTPUT ACCEPT
    ip6tables -F

}

# 修改系统SSH连接端口
change_ssh_port() {
  #!/bin/bash

  # 去掉 #Port 的注释
  sed -i 's/#Port/Port/' /etc/ssh/sshd_config

  # 读取当前的 SSH 端口号
  current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

  # 打印当前的 SSH 端口号
  echo "当前的 SSH 端口号是: $current_port"

  echo "------------------------"

  # 提示用户输入新的 SSH 端口号
  read -p "请输入新的 SSH 端口号: " new_port

  # 备份 SSH 配置文件
  cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

  # 替换 SSH 配置文件中的端口号
  sed -i "s/Port [0-9]\+/Port $new_port/g" /etc/ssh/sshd_config

  # 重启 SSH 服务
  service sshd restart

  echo "SSH 端口已修改为: $new_port"

  clear
  iptables_open
  remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1

}

changedns_menu() {
txtn " "
txtn $(txby "▼ 修改DNS")$(txtp " 卐卐卐 ")
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn " 文件路径: /etc/resolv.conf "
cat /etc/resolv.conf
txtn "====================================="
txtn $(txtp " 1.优化DNS")$(txtb "❀")"        "$(txtn "")$(txtb "")
txtn $(txtn " 2.纯IPv6")$(txtb "◎")"         "$(txtn "")$(txtb "")
txtn $(txty " 3.OpenDNS")$(txtr "◎")"        "$(txty "")$(txtp "")
txtn $(txtn " 4.Google DNS")$(txtb "◎")"     "$(txtn "")$(txtb "")
txtn $(txtn " 5.AliYun DNS")$(txtb "◎")"     "$(txtn "")$(txtb "")
txtn $(txtn " 6.Cloudflare DNS")$(txtb "◎")" "$(txtn "")$(txtb "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "66.备份")$(txtn "❉")"           "$(txtn "72.恢复最初DNS")$(txtg "☪")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"           "$(txtp "")$(txtc "")$(txty "")
txtn " "
}

# 修改系统的DNS
change_dns() {
    echo "当前DNS地址: /etc/resolv.conf"
    echo "------------------------"
    cat /etc/resolv.conf
    echo "------------------------"
    echo ""
    # 询问用户是否要优化DNS设置
    read -p "是否要设置为Cloudflare和Google的DNS地址？(y/n): " choice

    if [ "$choice" == "y" ]; then
        # 若未备份，则先备份
        if [ ! -f /etc/resolv.conf.bak ] ; then 
          echo ""
          echo " >>> 备份: /etc/resolv.conf => /etc/resolv.conf.bak"
          cp /etc/resolv.conf /etc/resolv.conf.bak
        fi
        # 定义DNS地址
        cloudflare_ipv4="1.1.1.1"
            google_ipv4="8.8.8.8"
        cloudflare_ipv6="2606:4700:4700::1111"
            google_ipv6="2001:4860:4860::8888"

        # 检查机器是否有IPv6地址
        ipv6_available=0
        if [[ $(ip -6 addr | grep -c "inet6") -gt 0 ]]; then
            ipv6_available=1
        fi

        # 设置DNS地址为Cloudflare和Google（IPv4和IPv6）
        echo "\n设置DNS为Cloudflare和Google"

        # 设置IPv4地址
        echo "nameserver $cloudflare_ipv4" > /etc/resolv.conf
        echo "nameserver $google_ipv4" >> /etc/resolv.conf

        # 如果有IPv6地址，则设置IPv6地址
        if [[ $ipv6_available -eq 1 ]]; then
            echo "nameserver $cloudflare_ipv6" >> /etc/resolv.conf
            echo "nameserver $google_ipv6" >> /etc/resolv.conf
        fi

        echo "DNS地址已更新"
        echo "------------------------"
        cat /etc/resolv.conf
        echo "------------------------"
    else
        echo "DNS设置未更改"
    fi

}


# 重装系统
dd_xitong_1() {
  reading "请输入你重装后的密码: " vpspasswd
  install wget
  bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh') $xitong -v 64 -p $vpspasswd -port 22
}

dd_xitong_2() {
  install wget
  wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
}

dd_xitong_bin456789() {
  country=$(curl -s --max-time 3 ipinfo.io/country)
  if [ "$country" = "CN" ]; then
      curl -O https://mirror.ghproxy.com/https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
  else
      curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
  fi
}

dd_system_menu() {
  
txtn " "
txtn $(txby "▼ 可选系统菜单")$(txtp " ❃❃❃ ")
txtn "—————————————————————————————————————"
# WANIP_show
txtn $(txby "> 系统虚拟化: ")$(txtp "${red}$VIRT${PLAIN}\n")
txtn "\t${pink} Linux   : ${BLUE}root${red}@${yellow}LeitboGi0ro${PLAIN}"
txtn "\t${pink} Windows : ${BLUE}Administrator${red}@${yellow}Teddysun.com"
txtn "\t${pink} @bin456789 : ${BLUE}root|Administrator${red}@${yellow}123@@@"
txtn "\t${pink}           ${white}(Windows need mininumn 15G Storage)${PLAIN}\n"
txtn "====================================="
txtn $(txtp " 1.Debian 12")$(txtb " ")"        "$(txtn "11.Ubuntu 24.04")$(txtb "☋")
txtn $(txtn " 2.Debian 11")$(txtb " ")"        "$(txtn "12.Ubuntu 22.04")$(txtb "☋")
txtn $(txty " 3.Debian 10")$(txtr " ")"        "$(txty "13.Ubuntu 20.04")$(txtp "☋")
txtn $(txtn " 4.AlmaLinux 9")$(txtb " ")"      "$(txtn "14.RockyLinux 9")$(txtb "❀")
txtn $(txtn " 5.AlmaLinux 8")$(txtb " ")"      "$(txtn "15.RockyLinux 8")$(txtb "❀")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "31.Alpine 3.20")$(txtb " ")"      "$(txtn "41.CentOS 9")$(txtb " ")
txtn $(txtn "32.Alpine 3.19")$(txtb " ")"      "$(txtn "42.CentOS 8")$(txtb " ")
txtn $(txtn "33.Alpine 3.18")$(txtb " ")"      "$(txtn "43.Kali Rolling")$(txtb " ")
txtn $(txtn "34.Arch Linux")$(txtb " ")"       "$(txtn "44.Fedora")$(txtb "❀")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "51.Windows 2025")$(txtb " ")"     "$(txtn "61.Windows 11(EN)")$(txtc " ")
txtn $(txtn "52.Windows 2022")$(txtb " ")"     "$(txtn "62.Windows 11(CN)")$(txtc " ")
txtn $(txtn "53.Windows 2019")$(txtb " ")"     "$(txtn "63.Windows 10(EN)")$(txtg " ")
txtn $(txtn "54.Windows 2016")$(txtb " ")"     "$(txtn "64.Windows 10(CN)")$(txtg " ")
txtn $(txtn "55.Windows 7")$(txtb " ")"        "$(txtn "")$(txtg "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "71.41合一脚本")$(txtn "❉")"       "$(txtn "72.脚本使用说明")$(txtg "♡")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"        "$(txtp "")$(txtc "")$(txty "")
txtn " "
}

dd_usage(){
txtn " "
txtn $(txby "▼ DD脚本使用说明")$(txtp " ❃❃❃ ")
txtn "—————————————————————————————————————"
txtn "       Linux : ${BLUE}root${red}@${yellow}LeitboGi0ro${PLAIN}"
txtn "     Windows : ${BLUE}Administrator${red}@${yellow}Teddysun.com"
txtn "  @bin456789 : ${BLUE}root|Administrator${red}@${yellow}123@@@"
txtn "   ${white}(Windows need mininumn 15G Storage)${PLAIN}"
txtn '   (当administrator无法登录时, 可尝试.\\administrator)\n'
txtn "  bash InstallNET.sh -windows 10 -lang 'en'"
txtn "  bash InstallNET.sh -windows 11 -lang 'cn'\n"
txtn "  reinstall.sh alma 8|9"
txtn "  reinstall.sh rocky 8|9"
txtn "  reinstall.sh debian 9|10|11|12"
txtn "  reinstall.sh ubuntu 24.04 [--minimal]"
txtn "  reinstall.sh alpine 3.17|3.18|3.19|3.20\n"
txtn "      reinstall.bat windows --image-name='windows server 2022 serverdatacenter' --lang=zh-cn "
txtn "  bash reinstall.sh windows --image-name 'Windows 10 Enterprise LTSC 2021'--lang en-us "
txtn "  bash reinstall.sh windows --image-name 'windows 11 pro' --lang zh-cn \n"
txtn "  bash reinstall.sh windows --image-name 'windows 11 business 23h2'"
txtn "                            --iso 'https://drive.massgrave.dev/zh-cn_windows_11_business_editions_version_23h2_updated_aug_2024_x64_dvd_6ca91c94.iso' \n"
txtn "  bash reinstall.sh windows --image-name 'Windows 10 business 22h2'"
txtn "                            --iso 'https://drive.massgrave.dev/zh-cn_windows_10_business_editions_version_22h2_updated_aug_2024_x86_dvd_8d7e500f.iso'\n"
txtn "  bash reinstall.sh dd --img https://example.com/xx.xz"
txtn "  bash reinstall.sh alpine --hold=1"
txtn "  bash reinstall.sh netboot.xyz\n"
txtn "  注意: Windows 10 LTSC 2021 zh-cn 的wsappx进程会长期占用CPU, 需要更新系统补丁。\n"
}
txtn "—————————————————————————————————————"

dd_system_run() {
  # https://github.com/leitbogioro/Tools 
  # https://github.com/MoeClub/Note
  # https://github.com/0oVicero0/Debian-ReInstall
  # https://github.com/mowwom/OvzReinstall
  # https://github.com/bin456789/reinstall

  clear
  txty "\n请备份数据，将为你重装系统，预计花费15分钟。\n"
  txtn "\t虚拟化类型: ${red}$VIRT${PLAIN} \n"
  txtn "\t${pink} =>> Password For KVM <<="
  txtn "\t${pink} Linux   : ${BLUE}root${red}@${yellow}LeitboGi0ro${PLAIN}"
  txtn "\t${pink} Windows : ${BLUE}Administrator${red}@${yellow}Teddysun.com"
  txtn "\t${pink}           ${white}(Windows need mininumn 15G Storage)${PLAIN}\n"
  read -p "确定继续吗？[Y|n]: " choice
  
  case "$choice" in
    [Yy]) clear ;;
    [Nn]) echo "已取消" && return 1 ;;
       *) echo "无效的选择，请输入 Y 或 N，返回..." && return 1 ;;
  esac

  if [[ "$VIRT" != *"KVM"* ]]; then
    # 如果系统虚拟化不是KVM，则使用OsMutation进行DD系统
    wget -qO OsMutation.sh https://raw.githubusercontent.com/LloydAsp/OsMutation/main/OsMutation.sh && chmod u+x OsMutation.sh && ./OsMutation.sh
    return 1
  fi 

  # 机器基于KVM，则使用LeitboGi0ro的有脚本进行DD
  while true; do
    clear && dd_system_menu
    reading "请选择要重装的系统: " sys_choice

    dd_xitong_2 
    dd_xitong_bin456789

    case "$sys_choice" in
       1) 
        # bash InstallNET.sh -debian
        bash InstallNET.sh -debian 12
        reboot 
        exit ;;
        # xitong="-d 12" 
        # dd_xitong_1 
        # exit 
        # reboot 
        # ;;
       2) 
        bash InstallNET.sh -debian 11
        reboot 
        exit ;;
        # xitong="-d 11" 
        # dd_xitong_1 
        # reboot 
        # exit ;;
       3) 
        bash InstallNET.sh -debian 10
        reboot 
        exit ;;
        # xitong="-d 10" 
        # dd_xitong_1 
        # reboot 
        # exit ;;
       4) 
        bash reinstall.sh alma 9
        reboot 
        exit ;;
       5) 
        bash reinstall.sh alma 8
        reboot 
        exit ;;
        
      11) 
        # dd_xitong_2 
        bash InstallNET.sh -ubuntu 24.04
        reboot 
        exit ;;
        
      12) 
        # dd_xitong_2 
        # bash InstallNET.sh -ubuntu 
        bash InstallNET.sh -ubuntu 22.04
        reboot 
        exit ;;
      13) 
        bash InstallNET.sh -ubuntu 20.04
        # bash InstallNET.sh -ubuntu 18.04
        # bash InstallNET.sh -ubuntu 16.04
        reboot 
        exit ;;
        # xitong="-u 20.04" 
        # dd_xitong_1 
        # reboot 
        # exit ;;
      14) 
        bash reinstall.sh rocky 9
        reboot 
        exit ;;
      15) 
        bash reinstall.sh rocky 8
        reboot 
        exit ;;
        
      #============================== 
     41) 
        bash InstallNET.sh -centos 9
        reboot 
        exit ;;
     42) 
        bash InstallNET.sh -centos 8
        reboot 
        exit ;;
      43) 
        bash InstallNET.sh -kali   
        # bash InstallNET.sh -kali rolling   
        # bash InstallNET.sh -kali dev   
        # bash InstallNET.sh -kali experimental   
        reboot 
        exit ;;
      44) 
        bash reinstall.sh fedora
        reboot 
        exit ;;
        
      #============================== 
      31) 
        bash InstallNET.sh -alpine 3.20
        reboot 
        exit ;;
      32) 
        bash InstallNET.sh -alpine 3.19
        reboot 
        exit ;;
      33) 
        bash InstallNET.sh -alpine 3.18
        reboot 
        exit ;;
      34) 
        bash reinstall.sh arch
        # bash InstallNET.sh -alpine
        # bash InstallNET.sh -alpine edge
        # bash InstallNET.sh -alpine 3.19
        # bash InstallNET.sh -alpine 3.18
        reboot 
        exit ;;
      #============================== 
      
      #============================== 
      51) 
        bash reinstall.sh windows --image-name='windows server 2025 serverdatacenter' --lang=zh-cn
        # reboot 
        # exit ;;
        break_end
        ;;
      52) 
        # bash InstallNET.sh -windows 2022
        bash reinstall.sh windows --image-name='windows server 2022 serverdatacenter' --lang=zh-cn
        # reboot 
        # exit ;;
        break_end
        ;;
      53) 
        bash InstallNET.sh -windows 2019
        reboot 
        exit ;;
      54) 
        bash InstallNET.sh -windows 2016
        reboot 
        exit ;;
      55) 
        URL="https://massgrave.dev/windows_7_links"
        web_content=$(wget -q -O - "$URL")
        iso_link=$(echo "$web_content" | grep -oP '(?<=href=")[^"]*cn[^"]*windows_7[^"]*professional[^"]*x64[^"]*\.iso')

        bash reinstall.sh windows --iso="$iso_link" --image-name='Windows 7 PROFESSIONAL'
        reboot 
        exit ;;

      61) 
        bash InstallNET.sh -windows 11 -lang "en"
        # bash InstallNET.sh -windows 11 -lang "cn"
        # bash InstallNET.sh -windows 11 -lang "jp" -port "22[1~65535]" -pwd "PssWord" -hostname "win11"
        # Note: Windows 10 and 11 23H2 for English preferred to use base images of tiny10 and tiny11 which were developed and optimized by ntdev .
        reboot 
        exit ;;
      62) 
        bash InstallNET.sh -windows 11 -lang "cn"
        reboot 
        exit ;;
      63) 
        bash InstallNET.sh -windows 10 -lang "en"
        reboot 
        exit ;;
      64) 
        bash InstallNET.sh -windows 10 -lang "cn"
        reboot 
        exit ;;

      71) 
        apt update -y #&& apt dist-upgrade -y
        wget --no-check-certificate -O NewReinstall.sh https://raw.githubusercontent.com/fcurrk/reinstall/master/NewReinstall.sh && chmod a+x NewReinstall.sh && bash NewReinstall.sh
        ;;

      72) clear
        # dd_xitong_2 
        # dd_xitong_bin456789
        dd_usage
        break_end
        ;;
      #============================== 
      0) system_tools_run && exit ;;
      *) echo "无效的选择，请重新输入。" && break_end ;;
    esac    
  done
}

banroot_with_new_user() {
  install sudo

  # 提示用户输入新用户名
  reading "请输入新用户名: " new_username

  # 创建新用户并设置密码
  sudo useradd -m -s /bin/bash "$new_username"
  sudo passwd "$new_username"

  # 赋予新用户sudo权限
  echo "$new_username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

  # 禁用ROOT用户登录
  sudo passwd -l root

  echo "操作已完成。"
  
}

alter_ipv4_ipv6() {
  ipv6_disabled=$(sysctl -n net.ipv6.conf.all.disable_ipv6)

  echo ""
  if [ "$ipv6_disabled" -eq 1 ]; then
      echo "当前网络优先级设置: IPv4 优先"
  else
      echo "当前网络优先级设置: IPv6 优先"
  fi
  echo "------------------------"

  echo ""
  echo "切换的网络优先级"
  echo "------------------------"
  echo "1. IPv4 优先          2. IPv6 优先"
  echo "------------------------"
  read -p "选择优先的网络: " choice

  case $choice in
      1)
          sysctl -w net.ipv6.conf.all.disable_ipv6=1 > /dev/null 2>&1
          echo "已切换为 IPv4 优先" ;;
      2)
          sysctl -w net.ipv6.conf.all.disable_ipv6=0 > /dev/null 2>&1
          echo "已切换为 IPv6 优先" ;;
      *) echo "无效的选择" ;;
  esac
}

# 设置系统虚拟内存
set_swap() {

  # 当机器为虚拟化为非KVM化，则不进行设置

  if [[ "$VIRT" != *"KVM"* ]]; then 
    WARPSTATUS6="${red}${bold}warp${PLAIN}"
    txtn "\nThe server type is: $(txbr $VIRT)"
    txtn "(Only KVM server can set swap)\n"
    return 1
  fi

  if [ "$EUID" -ne 0 ]; then
    echo "请以 root 权限运行此脚本。"
    exit 1
  fi

  clear
  # 获取当前交换空间信息
   swap_used=$(free -m | awk 'NR==3{print $3}')
  swap_total=$(free -m | awk 'NR==3{print $2}')

  if [ "$swap_total" -eq 0 ]; then
    swap_percentage=0
  else
    swap_percentage=$((swap_used * 100 / swap_total))
  fi

  swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

  echo "\n当前虚拟内存: $swap_info\n"

  read -p "是否调整大小?[Y|N]: " choice

  case "$choice" in
    [Yy])
      # 输入新的虚拟内存大小
      read -p "请输入虚拟内存大小MB: " new_swap

      # 获取当前系统中所有的 swap 分区
      swap_partitions=$(grep -E '^/dev/' /proc/swaps | awk '{print $1}')

      # 遍历并删除所有的 swap 分区
      for partition in $swap_partitions; do
        swapoff "$partition"
        wipefs -a "$partition"  # 清除文件系统标识符
        mkswap -f "$partition"
        echo "已删除并重新创建 swap 分区: $partition"
      done

      # 确保 /swapfile 不再被使用
      swapoff /swapfile

      # 删除旧的 /swapfile
      rm -f /swapfile

      # 创建新的 swap 分区
      dd if=/dev/zero of=/swapfile bs=1M count=$new_swap
      chmod 600 /swapfile
      mkswap /swapfile
      swapon /swapfile

      if [ -f /etc/alpine-release ]; then
          echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
          echo "nohup swapon /swapfile" >> /etc/local.d/swap.start
          chmod +x /etc/local.d/swap.start
          rc-update add local
      else
          echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
      fi

      echo "虚拟内存大小已调整为${new_swap}MB"
      ;;
    [Nn])
      echo "已取消"
      ;;
    *)
      echo "无效的选择，请输入 Y 或 N。"
      ;;
  esac
  
}

# 修改系统名
change_sys_name(){
  current_hostname=$(hostname)

  # 询问用户是否要更改主机名
  echo "当前主机名: $current_hostname"
  read -p "是否要更改主机名？(y/n): " answer

  if [ "$answer" == "y" ]; then
      # 获取新的主机名
      read -p "请输入新的主机名: " new_hostname
      if [ -n "$new_hostname" ]; then
          if [ -f /etc/alpine-release ]; then
              # Alpine
              echo "$new_hostname" > /etc/hostname
              hostname "$new_hostname"
          else
              # 其他系统，如 Debian, Ubuntu, CentOS 等
              hostnamectl set-hostname "$new_hostname"
              sed -i "s/$current_hostname/$new_hostname/g" /etc/hostname
              systemctl restart systemd-hostnamed
          fi
          echo "主机名已更改为: $new_hostname"
      else
          echo "无效的主机名。未更改主机名。"
          exit 1
      fi
  else
      echo "未更改主机名。"
  fi
}

# 修改系统安装源
alter_sourcelist(){
  # 获取系统信息
  source /etc/os-release

  # 定义 Ubuntu 更新源
  ustc_ubuntu_source="http://mirrors.ustc.edu.cn/ubuntu"
  thu_ubuntu_source="http://mirrors.tuna.tsinghua.edu.cn/ubuntu"
  tencent_ubuntu_source="http://mirrors.cloud.tencent.com/ubuntu"
  aliyun_ubuntu_source="http://mirrors.aliyun.com/ubuntu"
  official_ubuntu_source="http://archive.ubuntu.com/ubuntu"
  initial_ubuntu_source=""

  # 定义 Debian 更新源
  ustc_debian_source="http://mirrors.ustc.edu.cn/debian"
  thu_debian_source="http://mirrors.tuna.tsinghua.edu.cn/debian"
  tencent_debian_source="http://mirrors.cloud.tencent.com/debian"
  aliyun_debian_source="http://mirrors.aliyun.com/debian"
  official_debian_source="http://deb.debian.org/debian"
  initial_debian_source=""

  # 定义 CentOS 更新源
  ustc_centos_source="http://mirrors.ustc.edu.cn/centos"
  thu_centos_source="http://mirrors.tuna.tsinghua.edu.cn/centos"
  tencent_centos_source="http://mirrors.cloud.tencent.com/centos"
  aliyun_centos_source="http://mirrors.aliyun.com/centos"
  official_centos_source="http://mirror.centos.org/centos"
  initial_centos_source=""

  # 获取当前更新源并设置初始源
  case "$ID" in
      ubuntu) initial_ubuntu_source=$(grep -E '^deb ' /etc/apt/sources.list | head -n 1 | awk '{print $2}') ;;
      debian) initial_debian_source=$(grep -E '^deb ' /etc/apt/sources.list | head -n 1 | awk '{print $2}') ;;
      centos) initial_centos_source=$(awk -F= '/^baseurl=/ {print $2}' /etc/yum.repos.d/CentOS-Base.repo | head -n 1 | tr -d ' ') ;;
           *) echo "未知系统，无法执行切换源脚本" && exit 1 ;;
  esac

  # 备份当前源
  backup_sources() {
      case "$ID" in
          ubuntu) cp /etc/apt/sources.list /etc/apt/sources.list.bak ;;
          debian) cp /etc/apt/sources.list /etc/apt/sources.list.bak ;;
          centos)
              if [ ! -f /etc/yum.repos.d/CentOS-Base.repo.bak ]; then
                  cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
              else
                  echo "备份已存在，无需重复备份"
              fi
              ;;
          *) echo "未知系统，无法执行备份操作" && exit 1 ;;
      esac
      echo "已备份当前更新源为 /etc/apt/sources.list.bak 或 /etc/yum.repos.d/CentOS-Base.repo.bak"
  }

  # 还原初始更新源
  restore_initial_source() {
      case "$ID" in
          ubuntu) cp /etc/apt/sources.list.bak /etc/apt/sources.list ;;
          debian) cp /etc/apt/sources.list.bak /etc/apt/sources.list ;;
          centos) cp /etc/yum.repos.d/CentOS-Base.repo.bak /etc/yum.repos.d/CentOS-Base.repo ;;
               *) echo "未知系统，无法执行还原操作" && exit 1 ;;
      esac
      echo "已还原初始更新源"
  }

  # 函数：切换更新源
  switch_source() {
      case "$ID" in
          ubuntu) sed -i 's|'"$initial_ubuntu_source"'|'"$1"'|g' /etc/apt/sources.list ;;
          debian) sed -i 's|'"$initial_debian_source"'|'"$1"'|g' /etc/apt/sources.list ;;
          centos) sed -i "s|^baseurl=.*$|baseurl=$1|g" /etc/yum.repos.d/CentOS-Base.repo ;;
               *) echo "未知系统，无法执行切换操作" && exit 1 ;;
      esac
  }

  alter_source() {
    local oldsrc=$1
    local newsrc=$2
    sed -i 's|'"deb.debian.org/debian"'|'"$newsrc/debian"'|g' /etc/apt/sources.list
    # sed -i 's|'"archive.ubuntu.com/ubuntu"'|'"$newsrc/ubuntu"'|g' /etc/apt/sources.list
    # sed -i 's|'"mirror.centos.org/centos"'|'"$newsrc/centos"'|g' /etc/apt/sources.list
    case "$ID" in
        ubuntu) sed -i 's|'"$oldsrc/ubuntu"'|'"$newsrc/ubuntu"'|g' /etc/apt/sources.list ;;
        debian) sed -i 's|'"$oldsrc/debian"'|'"$newsrc/debian"'|g' /etc/apt/sources.list ;;
        centos) sed -i "s|^baseurl=.*$|baseurl/centos=$newsrc/centos|g" /etc/yum.repos.d/CentOS-Base.repo ;;
              *) echo "未知系统，无法执行切换操作" && exit 1 ;;
    esac
  }

  # 主菜单
  while true; do
      clear
      case "$ID" in
          ubuntu) echo -e "Ubuntu 更新源切换脚本\n------------------------" ;;
          debian) echo -e "Debian 更新源切换脚本\n------------------------" ;;
          centos) echo -e "CentOS 更新源切换脚本\n------------------------" ;;
               *) echo "未知系统，无法执行脚本" && exit 1 ;;
      esac

      echo "1. 切换到官方源"
      echo "2. 切换到阿里源"
      echo "3. 切换到腾讯源"
      echo "4. 切换到清华源"
      echo "5. 切换到中科院源"
      echo "------------------------"
      echo "8. 备份当前更新源"
      echo "9. 还原初始更新源"
      echo "------------------------"
      echo "11.LinuxMirror(CN)"
      echo "12.LinuxMirror(Edu)"
      echo "13.LinuxMirror(All)"
      echo "------------------------"
      echo "0. 返回上一级"
      echo "------------------------"
      read -p "请选择操作: " choice

      case $choice in
          1)
              backup_sources
              case "$ID" in
                  ubuntu) switch_source $official_ubuntu_source ;;
                  debian) switch_source $official_debian_source ;;
                  centos) switch_source $official_centos_source ;;
                       *) echo "未知系统，无法执行切换操作" && exit 1 ;;
              esac
              echo "已切换到官方源"
              ;;
          2)
              backup_sources
              case "$ID" in
                  ubuntu) switch_source $aliyun_ubuntu_source ;;
                  debian) switch_source $aliyun_debian_source ;;
                  centos) switch_source $aliyun_centos_source ;;
                       *) echo "未知系统，无法执行切换操作" && exit 1 ;;
              esac
              echo "已切换到阿里云源"
              ;;
          3)
              backup_sources
              case "$ID" in
                  ubuntu) switch_source $tencent_ubuntu_source ;;
                  debian) switch_source $tencent_debian_source ;;
                  centos) switch_source $tencent_centos_source ;;
                       *) echo "未知系统，无法执行切换操作" && exit 1 ;;
              esac
              echo "已切换到腾讯源"
              ;;
          4)
              backup_sources
              case "$ID" in
                  ubuntu) switch_source $thu_ubuntu_source ;;
                  debian) switch_source $thu_debian_source ;;
                  centos) switch_source $thu_centos_source ;;
                       *) echo "未知系统，无法执行切换操作" && exit 1 ;;
              esac
              echo "已切换到清华源"
              ;;
          5)
              backup_sources
              case "$ID" in
                  ubuntu) switch_source $ustc_ubuntu_source ;;
                  debian) switch_source $ustc_debian_source ;;
                  centos) switch_source $ustc_centos_source ;;
                       *) echo "未知系统，无法执行切换操作" && exit 1 ;;
              esac
              echo "已切换到中科院源"
              ;;
          8)
              backup_sources
              case "$ID" in
                  ubuntu) switch_source $initial_ubuntu_source ;;
                  debian) switch_source $initial_debian_source ;;
                  centos) switch_source $initial_centos_source ;;
                       *) echo "未知系统，无法执行切换操作" && exit 1 ;;
              esac
              echo "已切换到初始更新源"
              ;;

          9) restore_initial_source ;;

          # https://linuxmirrors.cn/
         11) clear &&  bash <(curl -sSL https://gitee.com/SuperManito/LinuxMirrors/raw/main/ChangeMirrors.sh) ;;
         12) clear &&  bash <(curl -sSL https://linuxmirrors.cn/main.sh) --edu ;;
         13) clear &&  bash <(curl -sSL https://linuxmirrors.cn/main.sh) --abroard ;;

          0) break ;;
          *) echo "无效的选择，请重新输入" ;;
      esac
      break_end
  done
}

timezone_menu(){
echo -e "
▶ 时区切换
${PLAIN}-->> 亚洲 <<-----------------------------
${GREEN} 1.${PLAIN} 中国上海时间              ${GREEN} 2.${PLAIN} 中国香港时间
${GREEN} 3.${PLAIN} 日本东京时间              ${GREEN} 4.${PLAIN} 韩国首尔时间
${GREEN} 5.${PLAIN} 新加坡时间                ${GREEN} 6.${PLAIN} 中国香港时间
${GREEN} 7.${PLAIN} 阿联酋迪拜时间            ${GREEN} 8.${PLAIN} 澳大利亚悉尼时间

${PLAIN}-->> 欧洲 <<-----------------------------
${GREEN}11.${PLAIN} 英国伦敦时间              ${GREEN}12.${PLAIN} 法国巴黎时间
${GREEN}13.${PLAIN} 德国柏林时间              ${GREEN}14.${PLAIN} 俄罗斯莫斯科时间
${GREEN}15.${PLAIN} 荷兰尤特赖赫特时间        ${GREEN}16.${PLAIN} 西班牙马德里时间

${PLAIN}-->> 美洲 <<-----------------------------
${GREEN}21.${PLAIN} 美国西部时间              ${GREEN}22.${PLAIN} 美国东部时间
${GREEN}23.${PLAIN} 加拿大时间               ${GREEN}24.${PLAIN} 墨西哥时间
${GREEN}25.${PLAIN} 巴西时间                 ${GREEN}26.${PLAIN} 阿根廷时间
${PLAIN}-------------------------------
${GREEN} 0.${PLAIN} 返回上级菜单
${PLAIN}-------------------------------
"
}

# 修改系统时区
alter_timezone(){
  while true; do
    clear
    echo "系统时间信息"

    # 获取当前系统时区
    current_timezone=$(timedatectl show --property=Timezone --value)

    # 获取当前系统时间
    current_time=$(date +"%Y-%m-%d %H:%M:%S")

    # 显示时区和时间
    echo "当前系统时区：$current_timezone"
    echo "当前系统时间：$current_time"

    timezone_menu
    read -p "请输入你的选择: " sub_choice

    case $sub_choice in
         1) timedatectl set-timezone Asia/Shanghai ;;
         2) timedatectl set-timezone Asia/Hong_Kong ;;
         3) timedatectl set-timezone Asia/Tokyo ;;
         4) timedatectl set-timezone Asia/Seoul ;;
         5) timedatectl set-timezone Asia/Singapore ;;
         6) timedatectl set-timezone Asia/Kolkata ;;
         7) timedatectl set-timezone Asia/Dubai ;;
         8) timedatectl set-timezone Australia/Sydney ;;
        11) timedatectl set-timezone Europe/London ;;
        12) timedatectl set-timezone Europe/Paris ;;
        13) timedatectl set-timezone Europe/Berlin ;;
        14) timedatectl set-timezone Europe/Moscow ;;
        15) timedatectl set-timezone Europe/Amsterdam ;;
        16) timedatectl set-timezone Europe/Madrid ;;
        21) timedatectl set-timezone America/Los_Angeles ;;
        22) timedatectl set-timezone America/New_York ;;
        23) timedatectl set-timezone America/Vancouver ;;
        24) timedatectl set-timezone America/Mexico_City ;;
        25) timedatectl set-timezone America/Sao_Paulo ;;
        26) timedatectl set-timezone America/Argentina/Buenos_Aires ;;
        0) break ;; # 跳出循环，退出菜单
        *) break ;; # 跳出循环，退出菜单
    esac
  done
}

# 管理BBRv3
bbrv3_install(){
  if dpkg -l | grep -q 'linux-xanmod'; then
    while true; do
          clear
          kernel_version=$(uname -r)
          echo "您已安装xanmod的BBRv3内核"
          echo "当前内核版本: $kernel_version"

          echo ""
          echo "内核管理"
          echo "------------------------"
          echo "1. 更新BBRv3内核              2. 卸载BBRv3内核"
          echo "------------------------"
          echo "0. 返回上一级选单"
          echo "------------------------"
          read -p "请输入你的选择: " sub_choice

          case $sub_choice in
              1)
                apt purge -y 'linux-*xanmod1*'
                update-grub

                # wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
                wget -qO - https://raw.githubusercontent.com/kejilion/sh/main/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

                # 步骤3：添加存储库
                echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

                # version=$(wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')
                version=$(wget -q https://raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

                apt update -y
                apt install -y linux-xanmod-x64v$version

                echo "XanMod内核已更新。重启后生效"
                rm -f /etc/apt/sources.list.d/xanmod-release.list
                rm -f check_x86-64_psabi.sh*

                reboot

                  ;;
              2)
                apt purge -y 'linux-*xanmod1*'
                update-grub
                echo "XanMod内核已卸载。重启后生效"
                reboot
                  ;;
              0)
                  break  # 跳出循环，退出菜单
                  ;;

              *)
                  break  # 跳出循环，退出菜单
                  ;;

          esac
    done

  else

    clear
    echo "请备份数据，将为你升级Linux内核开启BBR3"
    echo "官网介绍: https://xanmod.org/"
    echo "------------------------------------------------"
    echo "支持Debian|Ubuntu|Alipine, 仅支持x86_64架构"
    echo "VPS是512M内存的，请提前添加1G虚拟内存，防止因内存不足失联！"
    echo "------------------------------------------------"
    read -p "确定继续吗？(Y/N): " choice

    case "$choice" in
      [Yy])
        if [ -r /etc/os-release ]; then
            . /etc/os-release
            if [ "$ID" == "debian" ] || [ "$ID" == "ubuntu" ]; then
                echo "当前为Debian或Ubuntu系统"
                bbrv3_debian_ub
                reboot
                break
            elif [ "$ID" == "alpine" ] || [ "$ID" == "ubuntu" ]; then
                echo "当前为Alpine系统"
                bbrv3_conf
                reboot
                break
            fi
        else
            echo "无法确定操作系统类型"
            break
        fi

        ;;

      [Nn]) echo "已取消" ;;
      *) echo "无效的选择，请输入 Y 或 N。" ;;
    esac
  fi

}

# 为Debian或Ubuntu系统开启BBRv3
bbrv3_debian_ub(){
  # 检查系统架构
  arch=$(dpkg --print-architecture)
  if [ "$arch" != "amd64" ]; then
    echo "当前环境不支持，仅支持x86_64架构"
    break
  fi

  install wget gnupg

  # wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
  wget -qO - https://raw.githubusercontent.com/kejilion/sh/main/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

  # 步骤3：添加存储库
  echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

  # version=$(wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')
  version=$(wget -q https://raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

  apt update -y
  apt install -y linux-xanmod-x64v$version

  # 步骤5：启用BBR3
  bbrv3_conf

  echo "XanMod内核安装并BBR3启用成功。重启后生效"
  rm -f /etc/apt/sources.list.d/xanmod-release.list
  rm -f check_x86-64_psabi.sh*
}

# 给Alpine系统添加BBRv3
bbrv3_conf(){
  cat > /etc/sysctl.conf << EOF
net.core.default_qdisc=fq_pie
net.ipv4.tcp_congestion_control=bbr
EOF

  sysctl -p
}

# 防火墙管理
firewall_manage(){
  if dpkg -l | grep -q iptables-persistent; then
    while true; do
          clear
          echo "防火墙已安装"
          echo "------------------------"
          iptables -L INPUT

          echo ""
          echo "防火墙管理"
          echo "------------------------"
          echo "1. 开放指定端口              2. 关闭指定端口"
          echo "3. 开放所有端口              4. 关闭所有端口"
          echo "------------------------"
          echo "5. IP白名单                  6. IP黑名单"
          echo "7. 清除指定IP"
          echo "------------------------"
          echo "9. 卸载防火墙"
          echo "------------------------"
          echo "0. 返回上一级选单"
          echo "------------------------"
          read -p "请输入你的选择: " sub_choice

          case $sub_choice in
              1)
              read -p "请输入开放的端口号: " o_port
              sed -i "/COMMIT/i -A INPUT -p tcp --dport $o_port -j ACCEPT" /etc/iptables/rules.v4
              sed -i "/COMMIT/i -A INPUT -p udp --dport $o_port -j ACCEPT" /etc/iptables/rules.v4
              iptables-restore < /etc/iptables/rules.v4

                  ;;
              2)
              read -p "请输入关闭的端口号: " c_port
              sed -i "/--dport $c_port/d" /etc/iptables/rules.v4
              iptables-restore < /etc/iptables/rules.v4
                ;;

              3)
              current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

              cat > /etc/iptables/rules.v4 << EOF
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A FORWARD -i lo -j ACCEPT
-A INPUT -p tcp --dport $current_port -j ACCEPT
COMMIT
EOF
              iptables-restore < /etc/iptables/rules.v4

                  ;;
              4)
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

                  ;;

              5)
              read -p "请输入放行的IP: " o_ip
              sed -i "/COMMIT/i -A INPUT -s $o_ip -j ACCEPT" /etc/iptables/rules.v4
              iptables-restore < /etc/iptables/rules.v4

                  ;;

              6)
              read -p "请输入封锁的IP: " c_ip
              sed -i "/COMMIT/i -A INPUT -s $c_ip -j DROP" /etc/iptables/rules.v4
              iptables-restore < /etc/iptables/rules.v4
                  ;;

              7)
              read -p "请输入清除的IP: " d_ip
              sed -i "/-A INPUT -s $d_ip/d" /etc/iptables/rules.v4
              iptables-restore < /etc/iptables/rules.v4
                  ;;

              9)
              remove iptables-persistent
              rm /etc/iptables/rules.v4
              break
              # echo "防火墙已卸载，重启生效"
              # reboot
                  ;;

              0) break ;; # 跳出循环，退出菜单
              *) break ;; # 跳出循环，退出菜单
          esac
    done
else

  clear
  echo "将为你安装防火墙，该防火墙仅支持Debian/Ubuntu"
  echo "------------------------------------------------"
  read -p "确定继续吗？(Y/N): " choice

  case "$choice" in
    [Yy])
    if [ -r /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "debian" ] && [ "$ID" != "ubuntu" ]; then
            echo "当前环境不支持，仅支持Debian和Ubuntu系统"
            break
        fi
    else
        echo "无法确定操作系统类型"
        break
    fi

  clear
  iptables_open
  remove iptables-persistent ufw
  rm /etc/iptables/rules.v4

  apt update -y && apt install -y iptables-persistent

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
  systemctl enable netfilter-persistent
  echo "防火墙安装完成"


      ;;
    [Nn]) echo "已取消" ;;
    *) echo "无效的选择，请输入 Y 或 N。" ;;
  esac
fi

}

# 用户管理
user_manage(){
  while true; do
    # clear && install sudo && clear 
    clear
    # 显示所有用户、用户权限、用户组和是否在sudoers中
    echo "用户列表"
    echo "----------------------------------------------------------------------------"
    printf "%-24s %-34s %-20s %-10s\n" "用户名" "用户权限" "用户组" "sudo权限"
    while IFS=: read -r username _ userid groupid _ _ homedir shell; do
        groups=$(groups "$username" | cut -d : -f 2)
        sudo_status=$(sudo -n -lU "$username" 2>/dev/null | grep -q '(ALL : ALL)' && echo "Yes" || echo "No")
        printf "%-20s %-30s %-20s %-10s\n" "$username" "$homedir" "$groups" "$sudo_status"
    done < /etc/passwd


      echo ""
      echo "账户操作"
      echo "------------------------"
      echo "1. 创建普通账户             2. 创建高级账户"
      echo "------------------------"
      echo "3. 赋予最高权限             4. 取消最高权限"
      echo "------------------------"
      echo "5. 删除账号"
      echo "------------------------"
      echo "0. 返回上一级菜单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1)
            # 提示用户输入新用户名
            read -p "请输入新用户名: " new_username

            # 创建新用户并设置密码
            sudo useradd -m -s /bin/bash "$new_username"
            sudo passwd "$new_username"

            echo "操作已完成。"
              ;;

          2)
            # 提示用户输入新用户名
            read -p "请输入新用户名: " new_username

            # 创建新用户并设置密码
            sudo useradd -m -s /bin/bash "$new_username"
            sudo passwd "$new_username"

            # 赋予新用户sudo权限
            echo "$new_username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

            echo "操作已完成。"

              ;;
          3)
            read -p "请输入用户名: " username
            # 赋予新用户sudo权限
            echo "$username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
              ;;
          4)
            read -p "请输入用户名: " username
            # 从sudoers文件中移除用户的sudo权限
            sudo sed -i "/^$username\sALL=(ALL:ALL)\sALL/d" /etc/sudoers

              ;;
          5)
            read -p "请输入要删除的用户名: " username
            # 删除用户及其主目录
            sudo userdel -r "$username"
              ;;

          0) break ;; # 跳出循环，退出菜单
          *) break ;; # 跳出循环，退出菜单
      esac
  done
}

# 用户名和密码管理
pss_generate(){
  echo "随机用户名"
  echo "------------------------"
  for i in {1..5}; do
      username="user$(< /dev/urandom tr -dc _a-z0-9 | head -c6)"
      echo "随机用户名 $i: $username"
  done

  echo ""
  echo "随机姓名"
  echo "------------------------"
  first_names=("John" "Jane" "Michael" "Emily" "David" "Sophia" "William" "Olivia" "James" "Emma" "Ava" "Liam" "Mia" "Noah" "Isabella")
  last_names=("Smith" "Johnson" "Brown" "Davis" "Wilson" "Miller" "Jones" "Garcia" "Martinez" "Williams" "Lee" "Gonzalez" "Rodriguez" "Hernandez")

  # 生成5个随机用户姓名
  for i in {1..5}; do
      first_name_index=$((RANDOM % ${#first_names[@]}))
      last_name_index=$((RANDOM % ${#last_names[@]}))
      user_name="${first_names[$first_name_index]} ${last_names[$last_name_index]}"
      echo "随机用户姓名 $i: $user_name"
  done

  echo ""
  echo "随机UUID"
  echo "------------------------"
  for i in {1..5}; do
      uuid=$(cat /proc/sys/kernel/random/uuid)
      echo "随机UUID $i: $uuid"
  done

  echo ""
  echo "16位随机密码"
  echo "------------------------"
  for i in {1..5}; do
      password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)
      echo "随机密码 $i: $password"
  done

  echo ""
  echo "32位随机密码"
  echo "------------------------"
  for i in {1..5}; do
      password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)
      echo "随机密码 $i: $password"
  done
  echo ""

}

# 定时任务管理
cron_manage(){
  while true; do
      clear
      echo "定时任务列表"
      crontab -l
      echo ""
      echo "操作"
      echo "------------------------"
      echo "1. 添加定时任务              2. 删除定时任务"
      echo "------------------------"
      echo "0. 返回上一级菜单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1)
              read -p "请输入新任务的执行命令: " newquest
              echo "------------------------"
              echo "1. 每周任务                 2. 每天任务"
              read -p "请输入你的选择: " dingshi

              case $dingshi in
                  1)
                      read -p "选择周几执行任务？ (0-6，0代表星期日): " weekday
                      (crontab -l ; echo "0 0 * * $weekday $newquest") | crontab - > /dev/null 2>&1
                      ;;
                  2)
                      read -p "选择每天几点执行任务？（小时，0-23）: " hour
                      (crontab -l ; echo "0 $hour * * * $newquest") | crontab - > /dev/null 2>&1
                      ;;
                  *)
                      break  # 跳出
                      ;;
              esac
              ;;
          2)
              read -p "请输入需要删除任务的关键字: " kquest
              crontab -l | grep -v "$kquest" | crontab -
              ;;
          0) break ;; # 跳出循环，退出菜单
          *) break ;; # 跳出循环，退出菜单
      esac
  done
}

# 系统常用工具
system_tools_menu() {
  
txtn " "
txtn $(txbr "▼ 系统工具")$(txbg " ❁❁❁ ")
txtn "—————————————————————————————————————"
# WANIP_show
txtn "     主机名: "$(txtp "$hostname")
txtn "   系统版本: "$(txtp "$os_info")
txtn "====================================="
txtn $(txtn " 1.修改ROOT密码")$(txtg " ")"           "$(txby "11.修改虚拟内存")$(txty " ☆")
txtn $(txtn " 2.开启ROOT密码登录")$(txtg " ")"       "$(txtn "12.修改主机名")$(txtn " ")
txtn $(txtn " 3.开放所有端口")$(txtg " ")"           "$(txtn "13.切换系统更新源")$(txtn " ")
txtn $(txtn " 4.修改SSH端口")$(txtg " ")"            "$(txtb "14.系统时区调整")$(txty " ")
txtn $(txtc " 5.优化DNS")$(txtg " ")"                "$(txtp "15.开启BBR3加速")$(txtn " ")
txtn $(txty " 6.一键DD系统")$(txty " ☣")"            "$(txtn "16.防火墙管理器")$(txtn " ")
txtn $(txtn " 7.禁用ROOT账户")$(txtg " ")"           "$(txtn "17.用户管理")$(txtn " ")
txtn $(txtp " 8.切换优先ipv4/ipv6")$(txtg " ")"      "$(txtn "18.用户/密码生成器")$(txtn " ")
txtn $(txtn " 9.查看端口占用状态")$(txtg " ")"       "$(txtn "19.定时任务管理")$(txtn " ")
txtn $(txty "10.开启SSH转发")$(txtg " ☆")"          "$(txtn "")$(txtn " ")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "66.性能测试")$(txty " ▷")"              "$(txtn "77.系统信息")$(txtn " ☼")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr " ✖")"            "$(txtr "99")$(txtb ".重启服务器")$(txtc " ☢")
txtn " "

}

system_tools_run() {
  while true; do 
    clear && system_tools_menu
    reading "请输入你的选择: " sub_choice

    case $sub_choice in
      # 1) clear && reading "请输入你的快捷按键: " kuaijiejian && echo "alias $kuaijiejian='~/kejilion.sh'" >> ~/.bashrc && source ~/.bashrc && echo "快捷键已设置" ;;
      1) clear && echo "设置你的ROOT密码" && passwd ;;
      2) 
        clear && echo "设置你的ROOT密码" && passwd

        sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
        sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
        service sshd restart
        echo "ROOT登录设置完毕！"

        reading "需要重启服务器吗？(Y/N): " choice
        case "$choice" in
          [Yy]) reboot ;;
          [Nn]) echo "已取消" ;;
             *) echo "无效的选择，请输入 Y 或 N。" ;;
        esac
        ;;
      # 4) clear && install_python ;;
      3) clear && iptables_open && remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1 && echo "端口已全部开放" ;;
      4) clear && change_ssh_port ;;
      5) clear && change_dns ;;
      6) clear && dd_system_run ;;
      
      7) clear && banroot_with_new_user ;;
      8) clear && alter_ipv4_ipv6 ;;
      9) clear && ss -tulnape ;;
     10) clear 
         sed -i 's/^#\?AllowTcpForwarding.*/AllowTcpForwarding yes/g' /etc/ssh/sshd_config;
         sed -i 's/^#\?GatewayPorts.*/GatewayPorts yes/g' /etc/ssh/sshd_config;
         service sshd restart
         # systemctl restart sshd 
        ;;

     11) clear && set_swap ;;
     12) clear && change_sys_name  ;;
     13) clear && alter_sourcelist ;;
     14) clear && alter_timezone ;;
     15) clear && bbrv3_install ;;
     16) clear && firewall_manage ;;
     17) clear && user_manage ;;
     18) clear && pss_generate ;;
     19) clear && cron_manage ;;

     66) clear && server_test_run ;;
     77) clear && show_system_info ;;
     99) clear && echo -e "\n正在重启服务器，即将断开SSH连接..." && reboot ;;
      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
  done
}


function fetch(){
    download_url="$1"
    if [ -n "$(command -v wget)" ] ; then
        wget -qO- $download_url
    elif [ -n "$(command -v curl)" ] ; then
        curl -sLo- $download_url
    else
        install wget
        wget -qO- $download_url
    fi
}

# 性能测试工具
server_test_menu() {  
txtn " "
txtn $(txbr "▼ 性能测试")$(txbg " ☯☯☯ ")
txtn "—————————————————————————————————————"
txtn "   主机名  : "$(txtp "$hostname")
txtn "   系统版本: "$(txtp "$os_info")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
WANIP_show 
txtn "====================================="
txtn $(txty " 1.GB5测试")$(txtg " ☯")"               "$(txtn "11.ChatGPT解锁状态检测")$(txtn " ")
txtn $(txtn " 2.NodeBench性能测试")$(txtp " ")"      "$(txtn "12.Region流媒体解锁测试")$(txtn " ")
txtn $(txtn " 3.bench性能测试")$(txtg " ")"          "$(txty "13.yeahwu流媒体解锁测试")$(txty " ✔")
txtn $(txtb " 4.融合怪测评(spiritysdx)")$(txtg " ")" "$(txty "")$(txty " ")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "21.三网测速(Superspeed)")$(txtp " ")"   "$(txtn "24.单线程测速")$(txtn " ")
txtn $(txty "22.三网回程(bestrace)")$(txtp " ")"     "$(txtb "25.带宽性能(yabs)")$(txtn " ")
txtn $(txtn "23.回程线路(mtr_trace)")$(txtg " ")"    "$(txtn "")$(txtn "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "00.服务器基本信息")$(txtg " ✔")"        "$(txty "")$(txty " ")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"             "$(txtr "99")$(txtb ".重启服务器")$(txtc "☢")
txtn " "
}

server_test_run() {
  while true; do 
    clear && server_test_menu
    reading "请输入你的选择: " sub_choice

    case $sub_choice in
      # 1) clear && reading "请输入你的快捷按键: " kuaijiejian && echo "alias $kuaijiejian='~/kejilion.sh'" >> ~/.bashrc && source ~/.bashrc && echo "快捷键已设置" ;;

      1) clear && bash <(curl -sL bash.icu/gb5) ;;
      2) clear && install curl && curl -Lso- bench.sh | bash ;;
      3) clear && fetch bench.sh | bash ;;
      4) clear && install curl && curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh ;;
     
     11) clear && install curl && bash <(curl -Ls https://cdn.jsdelivr.net/gh/missuo/OpenAI-Checker/openai.sh) ;;
     12) clear && install curl && bash <(curl -L -s check.unlock.media) ;;
     13) clear && install wget && wget -qO- https://github.com/yeahwu/check/raw/main/check.sh | bash ;;

     21) clear && install curl && bash <(curl -Lso- https://git.io/superspeed_uxh) ;;
     22) clear && install wget && wget -qO- git.io/besttrace | bash ;;
     23) clear && install curl && curl https://raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh | bash ;;
     24) clear && bash <(fetch https://bench.im/hyperspeed) ;;
     25) clear && install curl && curl -sL yabs.sh | bash -s -- -i -5 ;;

     99) clear && echo -e "\n正在重启服务器，即将断开SSH连接..." && reboot ;;
     00) clear && gather_sysinfo && ip_info ;;
      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
    clear
  done
}

install_baota_cn() {
  if [ -f "/etc/init.d/bt" ] && [ -d "/www/server/panel" ]; then
      clear
      echo "宝塔面板已安装，应用操作"
      echo ""
      echo "------------------------"
      echo "1. 管理宝塔面板           2. 卸载宝塔面板"
      echo "------------------------"
      echo "0. 返回上一级选单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1) clear && bt ;;
          2) clear && curl -o bt-uninstall.sh http://download.bt.cn/install/bt-uninstall.sh > /dev/null 2>&1 && chmod +x bt-uninstall.sh && ./bt-uninstall.sh ;;
          0) break  ;;
          *) break  ;;
      esac
  else
      clear
      echo "安装提示"
      echo "如果您已经安装了其他面板工具或者LDNMP建站环境，建议先卸载，再安装宝塔面板！"
      echo "会根据系统自动安装，支持Debian，Ubuntu，Centos"
      echo "官网介绍: https://www.bt.cn/new/index.html"
      echo ""

      # 获取当前系统类型
      get_system_type() {
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

      system_type=$(get_system_type)

      if [ "$system_type" == "unknown" ]; then
          echo "不支持的操作系统类型"
      else
          read -p "确定安装宝塔吗？(Y/N): " choice
          case "$choice" in
              [Yy])
                  iptables_open
                  install wget
                  if [ "$system_type" == "centos" ]; then
                      yum install -y wget && wget -O install.sh https://download.bt.cn/install/install_6.0.sh && sh install.sh ed8484bec
                  elif [ "$system_type" == "ubuntu" ]; then
                      wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh ed8484bec
                  elif [ "$system_type" == "debian" ]; then
                      wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh ed8484bec
                  fi
                  ;;
              [Nn]) ;;
                 *) ;;
          esac
      fi
  fi

}

install_baota_aa(){
  if [ -f "/etc/init.d/bt" ] && [ -d "/www/server/panel" ]; then
      clear
      echo "aaPanel已安装，应用操作"
      echo ""
      echo "------------------------"
      echo "1. 管理aaPanel           2. 卸载aaPanel"
      echo "------------------------"
      echo "0. 返回上一级选单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1) clear && bt ;;
          2) clear && curl -o bt-uninstall.sh http://download.bt.cn/install/bt-uninstall.sh > /dev/null 2>&1 && chmod +x bt-uninstall.sh && ./bt-uninstall.sh ;;
          0) break ;;
          *) break ;;
      esac
  else
      clear
      echo "安装提示"
      echo "如果您已经安装了其他面板工具或者LDNMP建站环境，建议先卸载，再安装aaPanel！"
      echo "会根据系统自动安装，支持Debian，Ubuntu，Centos"
      echo "官网介绍: https://www.aapanel.com/new/index.html"
      echo ""

      # 获取当前系统类型
      get_system_type() {
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

      system_type=$(get_system_type)

      if [ "$system_type" == "unknown" ]; then
          echo "不支持的操作系统类型"
      else
          read -p "确定安装aaPanel吗？(Y/N): " choice
          case "$choice" in
              [Yy])
                  iptables_open
                  install wget
                  if [ "$system_type" == "centos" ]; then
                      yum install -y wget && wget -O install.sh http://www.aapanel.com/script/install_6.0_en.sh && bash install.sh aapanel
                  elif [ "$system_type" == "ubuntu" ]; then
                      wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh aapanel
                  elif [ "$system_type" == "debian" ]; then
                      wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh aapanel
                  fi
                  ;;
              [Nn]) ;;
                 *) ;;
          esac
      fi
  fi

}

install_1panel() {
  if command -v 1pctl &> /dev/null; then
      clear
      echo "1Panel已安装，应用操作"
      echo ""
      echo "------------------------"
      echo "1. 查看1Panel信息           2. 卸载1Panel"
      echo "------------------------"
      echo "0. 返回上一级选单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1) clear && 1pctl user-info && 1pctl update password ;;
          2) clear && 1pctl uninstall ;;
          0) break ;;
          *) break ;;
      esac
  else
      clear
      echo "安装提示"
      echo "如果您已经安装了其他面板工具或者LDNMP建站环境，建议先卸载，再安装1Panel！"
      echo "会根据系统自动安装，支持Debian，Ubuntu，Centos"
      echo "官网介绍: https://1panel.cn/"
      echo ""
      # 获取当前系统类型
      get_system_type() {
        if [ -f /etc/os-release ]; then
          . /etc/os-release
          if [ "$ID" == "centos" ]; then
            echo "centos"
          elif [ "$ID" == "ubuntu" ]; then
            echo "ubuntu"
          elif [ "$ID" == "debian" ]; then
            echo "debian"
          else
            echo "others"
          fi
        else
          echo "unknown"
        fi
      }

      system_type=$(get_system_type)

      if [ "$system_type" == "unknown" ]; then
        echo "不支持的操作系统类型"
      else
        read -p "确定安装1Panel吗？(Y/N): " choice
        case "$choice" in
          [Yy])
            # iptables_open
            # docker_install
            if [ "$system_type" == "centos" ]; then
              curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
            elif [ "$system_type" == "ubuntu" ]; then
              curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
            elif [ "$system_type" == "debian" ]; then
              curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
            elif [ "$system_type" == "others" ]; then
              bash <(curl -sSL https://linuxmirrors.cn/docker.sh) && curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
            fi
            ;;
          [Nn]) ;;
             *) ;;
        esac
      fi
  fi
}

app_manage_menu(){
local appname=$1
txtn " "
txtn $(txby "▼ 应用管理")$(txtp " ♨♨♨ ")
txtn "—————————————————————————————————————"
# WANIP_show
txtn " >>> $appname已安装"
txtn "====================================="
txtn $(txtn " 1.安装")$(txtg "✔")"         "$(txtn "")$(txtn "")
txtn $(txtn " 2.卸载")$(txtg "✔")"         "$(txtn "")$(txtn "")
txtn $(txtn " 3.重新安装")$(txtg "✔")"      "$(txtc "")$(txtn "")
txtn $(txtn " 4.查看状态")$(txtg "✔")"      "$(txtc "")$(txtn "")
txtn $(txtn " 5.帮助说明")$(txtg "✔")"      "$(txtc "")$(txtn "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"    "$(txtp "")$(txtc "")$(txty "")
txtn " "
}

app_manage_run() {
  local appname=$1

  if command -v 1pctl &> /dev/null; then
      clear && app_manage_menu      
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1) clear ;;
          2) clear ;;
          0) break ;;
          *) break ;;
      esac
  else
    txtn " >>> $appname尚未安装，请先安装..."

  fi
}

# 安装ubuntu桌面显示端
install_ub_desktop() {
  source /etc/os-release

  sudo apt update 

  case "$ID" in
      ubuntu) sudo apt -y install ubuntu-desktop ;;
      debian) 
        # sudo apt -y install task-gnome-desktop 
        sudo apt install x-window-system-core gnome-core
        sudo apt -y install xrdp
        ;;
      # debian) sudo apt -y install task-xfce-desktop ;;
      # debian) sudo apt -y install task-kde-desktop ;;
      # centos) ;;
           *) echo " >>> 未知系统，无法执行切换源脚桌面安装" && return 1 ;;
  esac

  txtn " >>> 注意：建议添加普通用户用于登录GUI桌面。"

  reading " >>> 是否添加新用户? [Y|n]: " choice
  case "$choice" in
    [Yy]) 
      # 提示用户输入新用户名
      read -p "请输入新用户名: " new_username

      # 创建新用户并设置密码
      sudo useradd -m -s /bin/bash "$new_username"
      sudo passwd "$new_username"

      echo " >>> 已添加新用户: $new_username\n"

      # 赋予新用户sudo权限
      reading " >>> 是否赋予新用户sudo权限? [Y|n]: " choice
      case "$choice" in
        [Yy]) echo "$new_username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers ;;
          *) echo " >>> 不赋予新用户sudo权限." ;;
      esac
     ;;

    # [Nn]) echo " >>> " ;;
        *) echo " >>> 不添加新用户..." ;;
  esac

  reading " >>> 是否添加新用户安装RDP服务? [Y|n]: " choice
  case "$choice" in
    [Yy]) 
      # sudo apt -y install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils
      # sudo apt install x-window-system-core gnome-core

      sudo apt -y install xrdp
      sudo systemctl status xrdp
      sudo adduser xrdp ssl-cert
     ;;

    # [Nn]) echo " >>> 不添安装RDP服务..." ;;
        *) echo " >>> 不添安装RDP服务。" ;;
  esac

  sudo reboot
}


# 在Ubuntu22.04上安装可道云
# https://docs.kodcloud.com/setup/ubuntu/
install_kodbox(){
  # 安装信赖
  sudo apt update && sudo apt -y upgrade && \
  sudo apt install -y nginx mysql-server redis-server && \
  sudo apt install -y php php-fpm php-mysql php-gd php-redis php-mbstring php-curl php-xml php-zip php-json && \
  sudo systemctl disable apache2.service && \
  sudo systemctl enable nginx php8.1-fpm mysql redis-server

  sudo apt -y install imagemagick ffmpeg && \
  sudo sed -i '/PDF/s/none/read \| write/g' /etc/ImageMagick-6/policy.xml

  # touch /etc/nginx/sites-enabled/default
  cat > /etc/nginx/sites-enabled/default << EOF
listen 80;              ##访问端口
root /var/www/html;     #改成自己的站点目录
server_name _;          #访问域名 '_'代表任何域名都能访问

location ~ [^/]\.php(/|$) {
   try_files $uri =404;
   fastcgi_pass unix:/run/php/php8.1-fpm.sock;
   fastcgi_index index.php;
   set $path_info $fastcgi_path_info;
   set $real_script_name $fastcgi_script_name;  
   if ($fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
      set $real_script_name $1;
      set $path_info $2;
   }
   fastcgi_param SCRIPT_FILENAME $document_root$real_script_name;
   fastcgi_param SCRIPT_NAME $real_script_name;
   fastcgi_param PATH_INFO $path_info;
   include fastcgi_params;
}
EOF

  PHP_INI=/etc/php/8.1/fpm/php.ini
  PHP_FPM=/etc/php/8.1/fpm/pool.d/www.conf
  sed -i \
    -e "s/max_execution_time = 30/max_execution_time = 3600/g" \
    -e "s/max_input_time = 60/max_input_time = 3600/g" \
    -e "s/memory_limit = 128M/memory_limit = 512M/g" \
    -e "s/post_max_size = 8M/post_max_size = 512M/g" \
    -e "s/upload_max_filesize = 2M/upload_max_filesize = 512M/g" \
    ${PHP_INI}
  sed -i \
    -e "s/pm.max_children = 5/pm.max_children = 100/g" \
    -e "s/pm.start_servers = 2/pm.start_servers = 10/g" \
    -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 10/g" \
    -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 50/g" \
    -e "s/;pm.max_requests = 500/pm.max_requests = 500/g" \
    -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
    ${PHP_FPM}
  sudo systemctl restart php8.1-fpm

  sudo mysql
  # mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'xxxx';
  # mysql> quit

  # sudo mysql_secure_installation

  # mysql> CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
  # mysql> CREATE DATABASE IF NOT EXISTS kodbox CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
  # mysql> GRANT ALL PRIVILEGES ON kodbox.* TO 'username'@'localhost';
  # mysql> FLUSH PRIVILEGES;
  # mysql> quit

  # 安装KodBox
  sudo apt install -y unzip
  cd /var/www/html/
  sudo curl -L "https://api.kodcloud.com/?app/version&download=server.link" -o kodbox.zip
  sudo unzip kodbox.zip && sudo rm kodbox.zip
  sudo chown -R www-data:www-data /var/www/html
  sudo chmod -R 755 /var/www/html
  sudo systemctl restart nginx

  # 设置防火墙
  sudo ufw allow ssh
  sudo ufw allow http
  sudo ufw enable
}

# 安装苹果CMS网站
# https://github.com/magicblack/maccms_down
# https://github.com/magicblack/maccms10
# https://kejilion.blogspot.com/2023/06/3-cms.html
# https://www.youtube.com/watch?v=94u3wvJWKuA
# https://www.tweek.top/archives/1706060591396
# https://www.youtube.com/watch?v=AVorImTHH8Q
install_maccms(){
  
      # add_yuming
      # install_ssltls
      add_db

  wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/maccms.com.conf
  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

  cd /home/web/html
  mkdir $yuming
  cd $yuming

  wget https://github.com/magicblack/maccms_down/raw/master/maccms10.zip && unzip maccms10.zip && rm maccms10.zip
  cd /home/web/html/$yuming/template/ && wget https://github.com/kejilion/Website_source_code/raw/main/DYXS2.zip && unzip DYXS2.zip && rm /home/web/html/$yuming/template/DYXS2.zip
  cp /home/web/html/$yuming/template/DYXS2/asset/admin/Dyxs2.php /home/web/html/$yuming/application/admin/controller
  cp /home/web/html/$yuming/template/DYXS2/asset/admin/dycms.html /home/web/html/$yuming/application/admin/view/system
  mv /home/web/html/$yuming/admin.php /home/web/html/$yuming/vip.php && wget -O /home/web/html/$yuming/application/extra/maccms.php https://raw.githubusercontent.com/kejilion/Website_source_code/main/maccms.php

  clear
  echo "您的苹果CMS搭建好了！"
  echo "https://$yuming"
  echo "------------------------"
  echo "安装信息如下: "
  echo "数据库地址: mysql"
  echo "数据库端口: 3306"
  echo "数据库名: $dbname"
  echo "用户名: $dbuse"
  echo "密码: $dbusepasswd"
  echo "数据库前缀: mac_"
  echo "------------------------"
  echo "安装成功后登录后台地址"
  echo "https://$yuming/vip.php"
  # nginx_status
}

# 使用Docker安装苹果CMS内容管理系统
docker_deploy_maccms_tweek(){

  local BFLD="/home/dcc.d"

  local dc_port=7878
  local dc_name=macms10
  local dc_imag=gs0245/maccms10
  local dc_desc="苹果CMS10内容管理系统"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$BFLD/$dc_name/docker-compose.yml"
  local FCONF="$BFLD/$dc_name/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 Memos ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  cat > $LFLD/docker-compose.yml << EOF
services:
  maccms10:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
        - $LPTH:/data
        - $LPTH/template:/opt/maccms10/template
    ports:
        - '$dc_port:7878'
      #network_mode: host (optional)
    restart: always
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
  
  # 下载影视主题到/root/npm/mnt/docker/maccms/template
  echoR " >>> " " 部署苹果CMS10成功，先下载MXONE主题到模板目录..."
  cd $LPTH/template && \
  wget  -q https://github.com/dockkkk/mxone/releases/download/mxone/mxone.zip && \
  unzip -q mxone.zip && rm ./mxone.zip

  echoR " >>> " " 主题下载成功，以下为苹果CMS10配置信息"
  echo -e   "======================================================="
  echo -e   " IPv4链接: http://$WAN4:$dc_port/admin123.php  "
  echo -e   " IPv6链接: http://[$WAN6]:$dc_port/admin123.php"
  echo -e   " 默认账户: admin@admin123"
  echo -e   "=======================================================" 
  echo -e   " 解析接口: https://svip.ffzyplay.com/?url=              "
  echo -e   " 后台主题: mxoneX主题,/admin123.php/admin/mxone/mxoneset"
  echo -e   " 参考教程: https://www.tweek.top/archives/1706060591396 "
  echo -e   "=======================================================" 
  echo -e   " 非凡采集站: http://ffzy5.tv/                           "
  echo -e   " 快看采集站: https://kuaikanzy.net/                     "
  echo -e   " 暴风采集站: https://publish.bfzy.tv/                   "
  echo -e   " 乐视采集站: https://www.leshizy1.com/                  "
  echo -e   "=======================================================" 
  echo -e   ""

  echo -e   " IPv4链接: https://$WAN4:$dc_port/admin123.php" >> $FCONF
  echo -e   " IPv6链接: https://[$WAN6]:$dc_port/admin123.php" >> $FCONF
  echo -e   " 默认账户: admin@admin123                               " >> $FCONF
  echo -e   "                                                       " >> $FCONF
  echo -e   " 解析接口: https://svip.ffzyplay.com/?url=              " >> $FCONF
  echo -e   " 后台主题: mxoneX主题,/admin123.php/admin/mxone/mxoneset" >> $FCONF
  echo -e   " 参考教程: https://www.tweek.top/archives/1706060591396 " >> $FCONF
  echo -e   "                                                       " >> $FCONF
  echo -e   " 非凡采集站: http://ffzy5.tv/                           " >> $FCONF
  echo -e   " 快看采集站: https://kuaikanzy.net/                     " >> $FCONF
  echo -e   " 暴风采集站: https://publish.bfzy.tv/                   " >> $FCONF
  echo -e   " 乐视采集站: https://www.leshizy1.com/                  " >> $FCONF
  
}

docker_deploy_ubuntu2004novnc(){

  local BFLD="/home/dcc.d"

  local dc_port=6080
  local dc_name=ubuntu_novnc
  local dc_image=fredblgr/ubuntu-novnc:20.04
  # local dc_image=fredblgr/ubuntu-novnc:22.04
  local dc_desc="一个网页版Ubuntu远程桌面，挺好用的！\n官网介绍: https://hub.docker.com/r/fredblgr/ubuntu-novnc"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$BFLD/$dc_name/docker-compose.yml"
  local FCONF="$BFLD/$dc_name/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 Portainer ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  rootpasswd=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)  
  read -p "请输入登录密码(默认为: ${rootpasswd}): " pstmp
  [[ -z "$pstmp" ]] || rootpasswd=$pstmp

  resolution='1280x720'
  read -p "请输入横向分辨率(默认1280,分辨率为: ${resolution}): " wstmp
  read -p "请输入纵向分辨率(默认720, 分辨率为: ${resolution}): " hstmp
  [[ -z "$wstmp" ]] || resolution='$wstmpx720'
  [[ -z "$hstmp" ]] || resolution='1280x$hstmp'
  [[ -z "$hstmp" && -z "$wstmp" ]] || resolution='$wstmpx$hstmp'

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    environment:
      - HTTP_PASSWORD=$rootpasswd
      - RESOLUTION=$resolution
    volumes:
        - $LPTH:/workspace:rw
    ports:
        - '$dc_port:80'
    restart: always
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   " Account    : root@$rootpasswd" >> $FCONF
  echo -e   " Resolution : $resolution" >> $FCONF
  echo -e   " Account    : root@$rootpasswd"
  echo -e   " Resolution : $resolution"
  echo -e   ""

}

docker_deploy_portainer(){
  
  local BFLD="/home/dcc.d"

  local dc_port=9050
  local dc_name=portainer
  local dc_imag=portainer/portainer
  local dc_desc="Portainer是一个轻量级的docker容器管理面板\n官网介绍: https://www.portainer.io"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$BFLD/$dc_name/docker-compose.yml"
  local FCONF="$BFLD/$dc_name/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 Portainer ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
        - $LPTH:/data
        - /var/run/docker.sock:/var/run/docker.sock
    ports:
        - '$dc_port:9000'
    restart: always
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

}

docker_deploy_memos(){
  
  local BFLD="/home/dcc.d"

  local dc_port=5230
  local dc_name=memos
  local dc_imag=ghcr.io/usememos/memos:latest
  local dc_desc="Memos"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$BFLD/$dc_name/docker-compose.yml"
  local FCONF="$BFLD/$dc_name/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 Memos ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
        - $LPTH:/var/opt/memos
    ports:
        - '$dc_port:5230'
    restart: always
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
  
  echo -e   " Default Account: admin@admin" >> $FCONF
  echo -e   " Default Account: admin@admin"
  echo -e   ""

}

docker_deploy_qbittorrent(){
  
  local BFLD="/home/dcc.d"

  local dc_port=8383
  local dc_name=qbittorrent
  local dc_imag=lscr.io/linuxserver/qbittorrent:latest
  local dc_desc="QBittorent"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"
  local FYML="$BFLD/$dc_name/docker-compose.yml"
  local FCONF="$BFLD/$dc_name/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 QBittorent ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - WEBUI_PORT=$dc_port
    volumes:
        - $LPTH:/downloads
        - $LFLD/config:/config
    ports:
        - '$dc_port:$dc_port'
        - '6881:6881'
        - '6881:6881/udp'
    restart: unless-stopped
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
  echo -e   " Default Account: admin@*****\n Password can be get from logs of the docker." >> $FCONF
  echo -e   " Default Account: admin@*****\n Password can be get from logs of the docker."
  echo -e   ""
  
}

docker_deploy_rocketchat(){
  
  echoR "Docker-compose.yml is not test. Todo..." &&  return 1 

  local BFLD="/home/dcc.d"

  local dc_port=3897
  local dc_name=rocketchat
  local dc_image=lscr.io/linuxserver/qbittorrent:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  [[ -d $LFLD/config ]] || mkdir -p $LFLD/config
  # cd $LFLD && touch docker-compose.yml
  cd $LFLD 
  curl -L https://raw.githubusercontent.com/RocketChat/Docker.Official.Image/master/compose.yml -O

  docker-compose up -d

      clear 
      if docker inspect rocketchat &>/dev/null; then
              clear
              echo "rocket.chat已安装，访问地址: "
              check_IP_address
              echo "http:$WAN4:3897"
              echo ""

              echo "应用操作"
              echo "------------------------"
              echo "1. 更新应用             2. 卸载应用"
              echo "------------------------"
              echo "0. 返回上一级选单"
              echo "------------------------"
              read -p "请输入你的选择: " sub_choice

              case $sub_choice in
                  1)
                      clear
                      docker rm -f rocketchat
                      docker rmi -f rocket.chat:6.3

                      docker run --name rocketchat --restart=always -p 3897:3000 --link db --env ROOT_URL=http://localhost --env MONGO_OPLOG_URL=mongodb://db:27017/rs5 -d rocket.chat

                      clear
                      check_IP_address
                      echo "rocket.chat已经安装完成"
                      echo "------------------------"
                      echo "多等一会，您可以使用以下地址访问rocket.chat:"
                      echo "http:$WAN4:3897"
                      echo ""
                      ;;
                  2)
                      clear
                      docker rm -f rocketchat
                      docker rmi -f rocket.chat
                      docker rmi -f rocket.chat:6.3
                      docker rm -f db
                      docker rmi -f mongo:latest
                      # docker rmi -f mongo:6
                      rm -rf /home/docker/mongo
                      echo "应用已卸载"
                      ;;
                  0)
                      break  # 跳出循环，退出菜单
                      ;;
                  *)
                      break  # 跳出循环，退出菜单
                      ;;
              esac
      else
          clear
          echo "安装提示"
          echo "rocket.chat国外知名开源多人聊天系统"
          echo "官网介绍: https://www.rocket.chat"
          echo ""

          # 提示用户确认安装
          read -p "确定安装rocket.chat吗？(Y/N): " choice
          case "$choice" in
              [Yy])
              clear
              docker_install
              docker run --name db -d --restart=always \
                  -v /home/docker/mongo/dump:/dump \
                  mongo:latest --replSet rs5 --oplogSize 256
              sleep 1
              docker exec -it db mongosh --eval "printjson(rs.initiate())"
              sleep 5
              docker run --name rocketchat --restart=always -p 3897:3000 --link db --env ROOT_URL=http://localhost --env MONGO_OPLOG_URL=mongodb://db:27017/rs5 -d rocket.chat:6.3

              clear

              check_IP_address
              echo "rocket.chat已经安装完成"
              echo "------------------------"
              echo "多等一会，您可以使用以下地址访问rocket.chat:"
              echo "http:$WAN4:3897"
              echo ""

                  ;;
              [Nn])
                  ;;
              *)
                  ;;
          esac
      fi
}

docker_deploy_searxng(){
  
  local BFLD="/home/dcc.d"

  local dc_port=8700
  local dc_name=searxng
  local dc_image=alandoyle/searxng:latest
  local dc_desc="SearXNG"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/config"
  local FYML="$BFLD/$dc_name/docker-compose.yml"
  local FCONF="$BFLD/$dc_name/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 SearXNG ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    volumes:
        - $LPTH:/etc/searxng
        - $LFLD/templates:/usr/local/searxng/searx/templates/simple
        - $LFLD/theme:/usr/local/searxng/searx/static/themes/simple
    ports:
        - '$dc_port:8080/tcp'
    restart: unless-stopped
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
 
}

docker_deploy_spdf(){
  
  local BFLD="/home/dcc.d"

  local dc_port=8020
  local dc_name=spdf
  local dc_imag=frooodle/s-pdf:latest
  local dc_desc="S-Pdf"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/trainingData"
  local FYML="$BFLD/$dc_name/docker-compose.yml"
  local FCONF="$BFLD/$dc_name/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 S-Pdf ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
        - $LPTH:/usr/share/tesseract-ocr/5/tessdata
        - $LFLD/extraConfigs:/configs
        - $LFLD/logs:/logs
    ports:
        - '$dc_port:8080'
    restart: always
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

}

docker_deploy_ittools(){
  
  local BFLD="/home/dcc.d"

  local dc_port=3380
  local dc_name=ittools
  local dc_imag=corentinth/it-tools:latest
  local dc_desc="IT-Tools常用工具箱"
  # local dc_imag=ghcr.io/corentinth/it-tools:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echo -e "\n >>> 现在开始部署IT-Tools ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    ports:
        - '$dc_port:80'
    restart: always
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

}

docker_deploy_nextterminal(){
  
  local BFLD="/home/dcc.d"

  local dc_port=8081
  local dc_name=nextterminal
  local dc_imag=dushixiang/next-terminal-pro:latest
  local dc_desc="Next Terminal"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 Next Terminal ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  # cd $LFLD && touch docker-compose.yml
  # curl -sSL https://f.typesafe.cn/next-terminal/docker-compose.yml > docker-compose.yml

  cat > "$FYML" << EOF
services:
  guacd:
    image: dushixiang/guacd:latest
    restart: always      
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    environment:
      DB: sqlite
      GUACD_HOSTNAME: guacd
      GUACD_PORT: 4822
    ports:
      - "$dc_port:8088"
    volumes:
      - /etc/localtime:/etc/localtime
      - ${LPTH}:/usr/local/next-terminal/data
    restart: always
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
  echo -e   " Default Account: admin@admin" >> $FCONF
  echo -e   " Default Account: admin@admin"
  echo -e   ""

}

docker_deploy_dashdot(){
  
  local BFLD="/home/dcc.d"

  local dc_port=4009
  local dc_name=dashdot
  local dc_imag=mauricenino/dashdot:latest
  local dc_desc="Dash."

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 Dash dot ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    privileged: true
    ports:
      - '$dc_port:3001'
    volumes:
      - /:/mnt/host:ro
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
  # echo -e   " Default Account: admin@admin" >> $FCONF
  # echo -e   " Default Account: admin@admin"
  echo -e   ""
}

docker_deploy_watchtower(){
  
  local BFLD="/home/dcc.d"

  local dc_port=0
  local dc_name=watchtower
  local dc_imag=containrrr/watchtower
  local dc_desc="Watch Tower"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  # echoR "\n >>>" " 现在开始部署 Dash dot ... \n"  
  # read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  # [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
  # echo -e   " Default Account: admin@admin" >> $FCONF
  # echo -e   " Default Account: admin@admin"
  echo -e   ""
}

docker_deploy_deeplx(){
  
  local BFLD="/home/dcc.d"

  local dc_port=1188
  local dc_name=deeplx
  local dc_imag=ghcr.io/owo-network/deeplx:latest
  local dc_desc="DeepLX(Free API)"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 DeepLX ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    restart: always
    ports:
      - "$dc_port:1188"
    # environment:
      # - TOKEN=helloworld
      # - AUTHKEY=xxxxxxx:fx
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
  # echo -e   " Default Account: admin@admin" >> $FCONF
  # echo -e   " Default Account: admin@admin"
  echo -e   ""
}

# https://neko.m1k1o.net/#/getting-started/quick-start
docker_deploy_neko(){
  
  local BFLD="/home/dcc.d"

  local dc_port=7702
  local dc_name=neko
  local dc_imag=m1k1o/neko:firefox
  local dc_desc="Neko-Firefox"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  pssuser=neko
  pssadmin=admin

  echoR "\n >>>" " 现在开始部署 Neko ... \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  read -p "请输入登录密码(默认:${pssuer}): " ptmp
  [[ -z "$ptmp" ]] || pssuer=$ptmp

  read -p "请输入管理密码(默认:${pssadmin}): " ptmp
  [[ -z "$ptmp" ]] || pssadmin=$ptmp

  # wget https://raw.githubusercontent.com/m1k1o/neko/master/docker-compose.yaml
  # sudo docker-compose up -d

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: ${dc_imag}
    restart: "unless-stopped"
    shm_size: "2gb"
    ports:
      - "$dc_port:8080"
      - "52000-52100:52000-52100/udp"
    environment:
      NEKO_SCREEN: 1920x1080@30
      NEKO_PASSWORD: $pssuser
      NEKO_PASSWORD_ADMIN: $pssadmin
      NEKO_EPR: 52000-52100
      NEKO_ICELITE: 1
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   " Password: $pssuser|$pssadmin" >> $FCONF
  echo -e   " Password: $pssuser|$pssadmin"
  echo -e   ""
}

# https://github.com/m1k1o/neko-rooms/blob/master/docker-compose.yml
docker_deploy_neko_rooms(){
  
  local BFLD="/home/dcc.d"

  local dc_port=7703
  local dc_name=nekorooms
  local dc_imag=m1k1o/neko-rooms:latest
  local dc_desc="Neko-Rooms"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  url_ext=http://127.0.0.1
  url_loc=127.0.0.1

  echoR "\n >>>" " 现在开始部署 Neko-Room ... \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  read -p "请输入客户连接IP(默认:${url_loc}): " ptmp
  [[ -z "$ptmp" ]] || url_loc=$ptmp

  read -p "请输入外部链接(默认:${url_ext}): " ptmp
  [[ -z "$ptmp" ]] || url_ext=$ptmp

  # wget -O neko-rooms.sh https://raw.githubusercontent.com/m1k1o/neko-rooms/master/traefik/install
  # sudo bash neko-rooms.sh

  cat > "$FYML" << EOF
networks:
  default:
    attachable: true
    name: "neko-rooms-net"

services:
  ${dc_name}:
    container_name: ${dc_name}
    image: ${dc_imag}
    restart: "unless-stopped"
    environment:
      - "TZ=Asia/Shanghai"
      - "NEKO_ROOMS_MUX=true"
      - "NEKO_ROOMS_EPR=59000-59049"
      - "NEKO_ROOMS_NAT1TO1=$url_loc" # IP address of your server that is reachable from client
      - "NEKO_ROOMS_INSTANCE_URL=$url_ext:$dc_port/" # external URL
      - "NEKO_ROOMS_INSTANCE_NETWORK=neko-rooms-net"
      - "NEKO_ROOMS_TRAEFIK_ENABLED=false"
      - "NEKO_ROOMS_PATH_PREFIX=/room/"
    ports:
      - "$dc_port:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   " Web URL: $url_ext:$dc_port" >> $FCONF
  echo -e   " Web URL: $url_ext:$dc_port"
  echo -e   ""
}

# https://github.com/cedar2025/Xboard
docker_deploy_xboard(){
  
  local BFLD="/home/dcc.d"

  local dc_port=7001
  local dc_name=xboard
  local dc_imag=containrrr/watchtower
  local dc_desc="XBoard"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  # echoR "\n >>>" " 现在开始部署 Dash dot ... \n"  
  # read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  # [[ -z "$ptmp" ]] || dc_port=$ptmp

  git clone -b  docker-compose --depth 1 https://github.com/cedar2025/Xboard
  cd Xboard
  docker compose run -it --rm xboard php artisan xboard:install

#   cat > "$FYML" << EOF
# version: '3'

# services:
#   ${dc_name}:
#     container_name: ${dc_name}
#     image: $dc_imag
#     restart: unless-stopped
#     volumes:
#       - /var/run/docker.sock:/var/run/docker.sock
# EOF

  docker-compose up -d
  # docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
  [[ -z "$WAN4" ]] || echo -e   " URL: http://$WAN4:$dc_port" >> $FCONF
  [[ -z "$WAN4" ]] || echo -e   " URL: http://$WAN4:$dc_port"
  [[ -z "$WAN6" ]] || echo -e   " URL: http://[$WAN6]:$dc_port" >> $FCONF
  [[ -z "$WAN6" ]] || echo -e   " URL: http://[$WAN6]:$dc_port"
  echo -e   ""
}


# https://lotusnetwork.github.io/docs/lotusboard_setup.html
docker_deploy_lotusboard(){
  
  local BFLD="/home/dcc.d"

  local dc_port=7001
  local dc_name=lotusboard
  local dc_imag=ghcr.io/lotusnetwork/sakuraneko
  local dc_desc="LotusBoard"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 Dash dot ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  git clone https://github.com/lotusnetwork/lotusboard-docker.git . && \
  git submodule update --init && \
  git submodule update --remote

  cat > "$FYML" << EOF
services:
  www:
    image: ${dc_name}
    # build: https://github.com/lotusnetwork/sakuraneko.git <- if you're ARM user please replace image line with this
    volumes:
      - './lotusboard:/www'
      - './wwwlogs:/wwwlogs'
      - './caddy.conf:/run/caddy/caddy.conf'
      - './supervisord.conf:/run/supervisor/supervisord.conf'
      - './crontabs.conf:/etc/crontabs/root'
      - './.caddy:/root/.caddy'
    ports:
      - '$dc_port:80' <--- Modify if you want to reverse proxy, Eg (443tls -> caddy -> 8080), format is host:container
    restart: always
    links:
      - mysql
  mysql:
    image: mysql:5.7.29
    # image: arm64v8/mysql:latest  <- if you're ARM user please replace image line with this
    volumes:
      - './mysql:/var/lib/mysql'
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 'DataBase_password'
      MYSQL_DATABASE: DB_Name
EOF

  docker-compose up -d
  docker compose exec www bash
  bash init.sh
  docker-compose restart

  # docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
  [[ -z "$WAN4" ]] || echo -e   " URL: http://$WAN4:$dc_port" >> $FCONF
  [[ -z "$WAN4" ]] || echo -e   " URL: http://$WAN4:$dc_port"
  [[ -z "$WAN6" ]] || echo -e   " URL: http://[$WAN6]:$dc_port" >> $FCONF
  [[ -z "$WAN6" ]] || echo -e   " URL: http://[$WAN6]:$dc_port"
  echo -e   ""
}

# https://github.com/wg-easy/wg-easy
docker_deploy_wireguardpanel(){
  
  local BFLD="/home/dcc.d"

  local dc_port=51821
  local dc_name=wireguardpanel
  local dc_imag=ghcr.io/wg-easy/wg-easy
  local dc_desc="WireGuard-Web-UI"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/.wg-easy"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD

  echoR "\n >>>" " 现在开始部署 Dash dot ... \n"  
  read -p "请输入Web-UI监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  dc_udp=51820
  read -p "请输入UDP监听端口(默认为:${dc_udp}): " pudp
  [[ -z "$pudp" ]] || dc_udp=$pudp

  dc_ip="${WAN4}"
  [[ -z "$dc_ip" ]] || dc_ip=${WAN6}
  read -p "请输入服务器IP(默认为:dc_ip): " piploc
  [[ -z "$piploc" ]] || dc_ip=$piploc

  dc_pass="foobar123"
  read -p "请输入管理密码(默认为: $dc_pass): " ppass
  [[ -z "$ppass" ]] || dc_pass=$ppass

  cat > "$FYML" << EOF
volumes:
  etc_wireguard:

services:
  wg-easy:
    environment:
      # Change Language:
      # (Supports: en, ua, ru, tr, no, pl, fr, de, ca, es, ko, vi, nl, is, pt, chs, cht, it, th, hi)
      - LANG=chs
      # ⚠️ Required:
      # Change this to your host's public address
      - WG_HOST=$dc_ip

      # Optional:
      - PASSWORD=$dc_pass
      - WG_PORT=$dc_udp
      # - WG_DEFAULT_ADDRESS=10.8.0.x
      # - WG_DEFAULT_DNS=1.1.1.1
      # - WG_MTU=1420
      # - WG_ALLOWED_IPS=192.168.15.0/24, 10.0.1.0/24
      # - WG_PERSISTENT_KEEPALIVE=25
      # - WG_PRE_UP=echo "Pre Up" > /etc/wireguard/pre-up.txt
      # - WG_POST_UP=echo "Post Up" > /etc/wireguard/post-up.txt
      # - WG_PRE_DOWN=echo "Pre Down" > /etc/wireguard/pre-down.txt
      # - WG_POST_DOWN=echo "Post Down" > /etc/wireguard/post-down.txt
      # - UI_TRAFFIC_STATS=true 

    image: $dc_imag
    container_name: ${dc_name}
    volumes:
      - etc_wireguard:/etc/wireguard
    ports:
      - "$dc_udp:51820/udp"
      - "$dc_port:51821/tcp"
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc
  echo -e   " Default password: $dc_pass" >> $FCONF
  echo -e   " Default password: $dc_pass"
  echo -e   " UDP port        : $dc_udp" >> $FCONF
  echo -e   " UDP port        : $dc_udp"
  echo -e   ""
}

docker_deploy_yacd(){

  local BFLD="/home/dcc.d"

  local dc_port=1234
  local dc_name=yacd
  # local dc_image=haishanh/yacd
  local dc_image=ghcr.io/haishanh/yacd:master
  local dc_desc="YACD--Yet Another Clash Board"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -d $LFLD/config ]] || mkdir -p $LFLD/config
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署YACD ... \n"

  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  echoR "\nConfiguration: " "$FYML"
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    volumes:
        - $LFLD/config:/config
    ports:
        - $dc_port:80
    restart: unless-stopped
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  # docker run -p 1234:80 -d --name yacd --rm ghcr.io/haishanh/yacd:master 
}

docker_deploy_clashdashboard(){

  local BFLD="/home/dcc.d"

  local dc_port=7893
  local dc_name=clash_web
  local dc_imag=haishanh/yacd
  # local dc_imag=ghcr.io/haishanh/yacd
  local dc_desc="Clash Dash Board (webui)"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -d $LFLD/config ]] || mkdir -p $LFLD/config

  echoR "\n >>>" " 现在开始部署 Clash Dash Board ... \n"  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  clash:
    container_name: clash
    image: dreamacro/clash
    volumes:
        - $LFLD/.config:/root/.config/clash
    ports:
        - 8790:7890
        - 8791:7891
        - 8792:9090 
    restart: always

  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    depends_on:
      # 依赖于clash服务，在clash启动后，web才启动
      - clash
    volumes:
        - $LFLD/config:/config
    ports:
        - '$dc_port:90'
    restart: always
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

}

docker_deploy_npm(){

  local BFLD="/home/dcc.d"

  local dc_port=81
  local dc_name=npm
  local dc_imag=jc21/nginx-proxy-manager:latest
  local dc_desc="Nginx Proxy Manager"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -d "$LFLD/letsencrypt" ]] || mkdir -p "$LFLD/letsencrypt"
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 Nginx Proxy Manager ... \n"
  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
        - $LPTH:/data
        - $LFLD/letsencrypt:/etc/letsencrypt
    ports:
        - '$dc_port:81'
        - '80:80'
        - '443:443'
    restart: always
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

}

# 使用Docker compose部署MyIP
docker_deploy_myip(){

  local BFLD="/home/dcc.d"

  local dc_port=18966
  local dc_name=myip
  local dc_imag=ghcr.io/jason5ng32/myip:latest
  local dc_desc="MyIP-IP Checking"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 MyIP ... \n"
  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  myip:
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    ports:
      - $dc_port:18966
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e " >>> MyIP 部署成功!!! "
  echo -e ""

}

# 使用Docker compose部署ChatGPT-Next-Web
docker_deploy_chatgptnextweb(){

  local BFLD="/home/dcc.d"

  local dc_port=3303
  local dc_name=chatgptnextweb
  local dc_imag=yidadaa/chatgpt-next-web
  local dc_desc="ChatGPT-Next-Web"
  # local dcc_code="543212345,7654321234567"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署ChatGPT-Next-Web ... \n"
  
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  read -p "请输入API_KEY       : " OPENAI_API_KEY
  read -p "请输入GEMINI_API_KEY: " GOOGLE_API_KEY
  read -p "请输入登录密码       : " PASS

  CUSTOM_MODELS="-all,+gemini-pro"

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    # profiles: [ "no-proxy" ]
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    ports:
      - $dc_port:3000
    environment:
      - OPENAI_API_KEY=$OPENAI_API_KEY
      - GOOGLE_API_KEY=$GOOGLE_API_KEY
      - CODE=$PASS
      - BASE_URL=$BASE_URL
      - OPENAI_ORG_ID=$OPENAI_ORG_ID
      - HIDE_USER_API_KEY=$HIDE_USER_API_KEY
      - DISABLE_GPT4=$DISABLE_GPT4
      - ENABLE_BALANCE_QUERY=$ENABLE_BALANCE_QUERY
      - DISABLE_FAST_LINK=$DISABLE_FAST_LINK
      - OPENAI_SB=$OPENAI_SB
      - CUSTOM_MODELS=$CUSTOM_MODELS
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   " Password   : $PASS" >> $FCONF
  echo -e   " Password   : $PASS"
  echo -e   ""

}

docker_deploy_gptacademic(){

  local BFLD="/home/dcc.d"

  local dc_port=50923
  local dc_name=gpt_academic
  local dc_imag=ghcr.io/binary-husky/gpt_academic_nolocal:master
  local dc_desc="gpt_academic学术工具"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署GPT-Academic ... \n"

  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  read -p "请输入API_KEY       : " API_KEY
  read -p "请输入GEMINI_API_KEY: " GEMINI_API_KEY
  read -p "请输入登录账户       : " USER
  read -p "请输入登录密码       : " PASS
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    environment:
      - API_KEY=$API_KEY
      - GEMINI_API_KEY=$GEMINI_API_KEY
      - DEFAULT_WORKER_NUM=30
      - AUTHENTICATION=[("$USER", "$PASS")]  
      - AVAIL_LLM_MODELS=["gpt-3.5-turbo", "gpt-4","gemini-pro"]   
      - LLM_MODEL=gemini-pro
      - AUTO_CLEAR_TXT=False
      - ADD_WAIFU=True
      - WEB_PORT=$dc_port
    ports:
        - '$dc_port:$dc_port'  # 50923必须与WEB_PORT相互对应
    volumes:
        - $LFLD/config:/config
        - $LPTH:/downloads
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e "\n Config path: $LFLD/config"
  echo -e "\n User       : $USER"
  echo -e   " Password   : $PASS"
  echo -e ""

  echo -e "\n Config path: $LFLD/config" >> $FCONF
  echo -e "\n User       : $USER" >> $FCONF
  echo -e   " Password   : $PASS" >> $FCONF
}

# https://github.com/babaohuang/GeminiProChat
docker_deploy_geminiprochat(){

  local BFLD="/home/dcc.d"

  local dc_port=3033
  local dc_name=geminiprochat
  local dc_imag=babaohuang/geminiprochat:latest
  local dc_desc="GeminiProChat"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 Gemini Pro Chat ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  read -p "请输入GEMINI_API_KEY: " GEMINI_API_KEY
  read -p "请输入登录密码       : " SITE_PASSWORD
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    environment:
      - GEMINI_API_KEY=$GEMINI_API_KEY
      - SITE_PASSWORD=$SITE_PASSWORD
    ports:
        - '$dc_port:3000'
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   "Site password: $SITE_PASSWORD"
  echo -e   "Site password: $SITE_PASSWORD" >> $FCONF
  echo -e ""
}

# https://github.com/Amery2010/TalkWithGemini
docker_deploy_talkwithgemini(){
  local BFLD="/home/dcc.d"

  local dc_port=35481
  local dc_name=talkwithgemini
  local dc_imag=xiangfa/talk-with-gemini
  local dc_desc="Talk With Gemini"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 Talk with Gemini ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  read -p "请输入GEMINI_API_KEY: " GEMINI_API_KEY
  read -p "请输入登录密码       : " SITE_PASSWORD
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    environment:
      - GEMINI_API_KEY=$GEMINI_API_KEY
      - ACCESS_PASSWORD=$SITE_PASSWORD
    ports:
        - '$dc_port:3000'
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   "Site password: $SITE_PASSWORD"
  echo -e   "Site password: $SITE_PASSWORD" >> $FCONF
  echo -e ""
}

# https://github.com/gooaclok819/sublinkX
docker_deploy_sublinkx(){
  local BFLD="/home/dcc.d"

  local dc_port=40088
  local dc_name=sublinkx
  local dc_imag=jaaksi/sublinkx
  local dc_desc="SubLinkX"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/db"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  mkdir -p "$BFLD/$dc_name/template"
  mkdir -p "$BFLD/$dc_name/logs"
  mkdir -p "$BFLD/$dc_name/db"

  echoR "\n >>>" " 现在开始部署 SublinkX ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
        - $LFLD/db:/app/db
        - $LFLD/template:/app/template
        - $LFLD/logs:/app/logs
    ports:
        - '$dc_port:8000'
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e ""
}

# https://lucky666.cn/
# https://github.com/gdy666/lucky
docker_deploy_lucky(){
  local BFLD="/home/dcc.d"

  local dc_port=16601
  local dc_name=lucky
  local dc_imag=gdy666/lucky
  local dc_desc="Lucky"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/goodluck"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  # mkdir -p "$BFLD/$dc_name/template"
  # mkdir -p "$BFLD/$dc_name/logs"
  # mkdir -p "$BFLD/$dc_name/db"

  echoR "\n >>>" " 现在开始部署 Lucky ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
        - $LPTH:/goodluck
    network_mode: host
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e ""
}

# https://pdf2zh.com/
# https://github.com/Byaidu/PDFMathTranslate
docker_deploy_pdf2zh(){
  local BFLD="/home/dcc.d"

  local dc_port=37860
  local dc_name=pdf2zh
  local dc_imag=byaidu/pdf2zh
  local dc_desc="pdf2zh, PDFMathTranslate"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " Start to deploy: pdf2zh ... \n"
  read -p " Input port to listen(Default:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    ports:
        - '$dc_port:7860'
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e ""
}

docker_deploy_dockerwin_amd64(){
  local BFLD="/home/dcc.d"

  local dc_port=18006
  local dc_name=dockerwin
  local dc_imag=dockurr/windows
  local dc_desc="Docker windows"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/disk"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  mkdir -p "$BFLD/$dc_name/dockerwinshare"
  # mkdir -p "$BFLD/$dc_name/logs"
  # mkdir -p "$BFLD/$dc_name/db"

  echoR "\n >>>" " 现在开始部署 Docker-win ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  local winver="win11"
  echoR "\n" " 可选择的系统列表 "
  echoR "  " " win11  \t Windows 11 Pro "
  echoR "  " " win11e \t Windows 11 Enterprise "
  echoR "  " " win10  \t Windows 10 Pro "
  echoR "  " " win10e \t Windows 10 Enterprise "
  echoR "  " " ltsc10 \t Windows 10 LTSC "
  echoR "  " " win8   \t Windows 8.1 Pro "
  echoR "  " " win8e  \t Windows 8.1 Enterprise "
  echoR "  " " win7   \t Windows 7 Enterprise "
  echoR "  " " winxp  \t Windows xp Professional "
  echoR "  " " 2025   \t Windows Server 2025 "
  echoR "  " " 2022   \t Windows Server 2022 "
  echoR "  " " 2019   \t Windows Server 2019 "
  echoR "  " " 2016   \t Windows Server 2016 "
  echoR "  " " 2012   \t Windows Server 2012 "
  echoR "  " " core11 \t Tiny 11 Core "
  echoR "  " " tiny11 \t Tiny 11  "
  echoR "  " " tiny10 \t Tiny 10  "
  read -p "请输入要安装的系统版本: win11(default)" ptmp
  [[ -z "$ptmp" ]] || winver=$ptmp
  
  local lang="English"
  echoR "\n" " 可选择的语言 "
  echoR "  " " Chinese  \t 中文 "
  echoR "  " " English  \t 英文 "
  read -p "请输入系统语言: English(default)" ptmp
  [[ -z "$ptmp" ]] || lang=$ptmp

  local cpucores="4"
  read -p "请输入CPU核心数: 4(default)" ptmp
  [[ -z "$ptmp" ]] || cpucores=$ptmp

  local ramsize="8G"
  read -p "请输入内存大小: 8G(default)" ptmp
  [[ -z "$ptmp" ]] || ramsize=$ptmp

  local disksize="64G"
  read -p "请输入磁盘大小: 64G(default)" ptmp
  [[ -z "$ptmp" ]] || disksize=$ptmp

  local username="docker"
  read -p "请输入账户名称: docker(default)" ptmp
  [[ -z "$ptmp" ]] || username=$ptmp

  local userpswd="docker54321"
  read -p "请输入账户密码: docker54321(default)" ptmp
  [[ -z "$ptmp" ]] || userpswd=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    environment:
      VERSION: "${winver}"
      LANGUAGE: "${lang}"
      CPU_CORES: "${cpucores}"
      RAM_SIZE: "${ramsize}"
      DISK_SIZE: "${disksize}"
      USERNAME: "${username}"
      PASSWORD: "${userpswd}"
    devices:
      - /dev/kvm
    volumes:
      - $BFLD/$dc_name/disk:/storage
      - $BFLD/$dc_name/dockerwinshare:/shared
    cap_add:
      - NET_ADMIN
    ports:
      - 8006:8006
      - 3389:3389/tcp
      - 3389:3389/udp
    stop_grace_period: 2m
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e ""
}

docker_deploy_dockerwin_arm64(){
  local BFLD="/home/dcc.d"

  local dc_port=28006
  local dc_name=dockerwinarm
  local dc_imag=dockurr/windows-arm
  local dc_desc="Docker windows(ARM)"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/disk"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  mkdir -p "$BFLD/$dc_name/dockerwinshare"
  # mkdir -p "$BFLD/$dc_name/logs"
  # mkdir -p "$BFLD/$dc_name/db"

  echoR "\n >>>" " 现在开始部署 Docker-win(ARM) ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  local winver="win11"
  echoR "\n" " 可选择的系统列表 "
  echoR "  " " win11  \t Windows 11 Pro "
  echoR "  " " win11e \t Windows 11 Enterprise "
  echoR "  " " win10  \t Windows 10 Pro "
  echoR "  " " win10e \t Windows 10 Enterprise "
  echoR "  " " ltsc10 \t Windows 10 LTSC "
  read -p "请输入要安装的系统版本: win11(default)" ptmp
  [[ -z "$ptmp" ]] || winver=$ptmp
  
  local lang="English"
  echoR "\n" " 可选择的语言 "
  echoR "  " " Chinese  \t 中文 "
  echoR "  " " English  \t 英文 "
  read -p "请输入系统语言: English(default)" ptmp
  [[ -z "$ptmp" ]] || lang=$ptmp

  local cpucores="4"
  read -p "请输入CPU核心数: 4(default)" ptmp
  [[ -z "$ptmp" ]] || cpucores=$ptmp

  local ramsize="8G"
  read -p "请输入内存大小: 8G(default)" ptmp
  [[ -z "$ptmp" ]] || ramsize=$ptmp

  local disksize="64G"
  read -p "请输入磁盘大小: 64G(default)" ptmp
  [[ -z "$ptmp" ]] || disksize=$ptmp

  local username="docker"
  read -p "请输入账户名称: docker(default)" ptmp
  [[ -z "$ptmp" ]] || username=$ptmp

  local userpswd="docker54321"
  read -p "请输入账户密码: docker54321(default)" ptmp
  [[ -z "$ptmp" ]] || userpswd=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    environment:
      VERSION: "${winver}"
      LANGUAGE: "${lang}"
      CPU_CORES: "${cpucores}"
      RAM_SIZE: "${ramsize}"
      DISK_SIZE: "${disksize}"
      USERNAME: "${username}"
      PASSWORD: "${userpswd}"
    devices:
      - /dev/kvm
    volumes:
      - $BFLD/$dc_name/disk:/storage
      - $BFLD/$dc_name/dockerwinshare:/shared
    cap_add:
      - NET_ADMIN
    ports:
      - 8006:8006
      - 3389:3389/tcp
      - 3389:3389/udp
    stop_grace_period: 2m
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e ""
}

docker_deploy_dockermac(){
  local BFLD="/home/dcc.d"

  local dc_port=38006
  local dc_name=dockermac
  local dc_imag=dockurr/macos
  local dc_desc="Docker MacOS"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/disk"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  mkdir -p "$BFLD/$dc_name/dockerwinshare"
  # mkdir -p "$BFLD/$dc_name/logs"
  # mkdir -p "$BFLD/$dc_name/db"

  echoR "\n >>>" " 现在开始部署 Docker-MacOS ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  local winver="win11"
  echoR "\n" " 可选择的系统列表 "
  echoR "  " " sonoma   \t macOS Sonoma "
  echoR "  " " ventura  \t macOS Ventura "
  echoR "  " " monterey \t macOS Monterey "
  echoR "  " " big-sur  \t macOS Big Sur "
  read -p "请输入要安装的系统版本: sonoma(default)" ptmp
  [[ -z "$ptmp" ]] || winver=$ptmp
  
  # local lang="English"
  # echoR "\n" " 可选择的语言 "
  # echoR "\n" " Chinese  \t 中文 "
  # echoR "\n" " English  \t 英文 "
  # read -p "请输入系统语言: English(default)" ptmp
  # [[ -z "$ptmp" ]] || lang=$ptmp

  local cpucores="4"
  read -p "请输入CPU核心数: 4(default)" ptmp
  [[ -z "$ptmp" ]] || cpucores=$ptmp

  local ramsize="8G"
  read -p "请输入内存大小: 8G(default)" ptmp
  [[ -z "$ptmp" ]] || ramsize=$ptmp

  local disksize="64G"
  read -p "请输入磁盘大小: 64G(default)" ptmp
  [[ -z "$ptmp" ]] || disksize=$ptmp

  # local username="docker"
  # read -p "请输入账户名称: docker(default)" ptmp
  # [[ -z "$ptmp" ]] || username=$ptmp

  # local userpswd="docker54321"
  # read -p "请输入账户密码: docker54321(default)" ptmp
  # [[ -z "$ptmp" ]] || userpswd=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    environment:
      VERSION: "${winver}"
      CPU_CORES: "${cpucores}"
      RAM_SIZE: "${ramsize}"
      DISK_SIZE: "${disksize}"
    devices:
      - /dev/kvm
    volumes:
      - $BFLD/$dc_name/disk:/storage
      - $BFLD/$dc_name/dockerwinshare:/shared
    cap_add:
      - NET_ADMIN
    ports:
      - 8006:8006
      - 5900:5900/tcp
      - 5900:5900/udp
    stop_grace_period: 2m
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e ""
}

docker_deploy_dockerwechat(){

  local BFLD="/home/dcc.d"

  local dc_port=5800
  local dc_vnc=5900
  local dc_name=wechat
  local dc_imag=ricwang/docker-wechat:latest
  local dc_desc="WeChat"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 WeChat ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  read -p "请输入VNC端口(默认为:${dc_vnc}): " ptmp
  [[ -z "$ptmp" ]] || dc_vnc=$ptmp
  
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    volumes:
      - ./.xwechat:/root/.xwechat
      - ./xwechat_files:/root/xwechat_files
      - ./downloads:/root/downloads
      - /dev/snd:/dev/snd
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
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   "URL: http://$WAN4:$dc_port" >> $FCONF
  echo -e   "URL: http://$WAN4:$dc_port"
  echo -e   "VNC: http://$WAN4:$dc_vnc" >> $FCONF
  echo -e   "VNC: http://$WAN4:$dc_vnc"
  echo -e ""
}

docker_deploy_iptv_allinone(){

  local BFLD="/home/dcc.d"

  local dc_port=35455
  local dc_name=iptva
  local dc_imag=youshandefeiyang/allinone
  local dc_desc="IP-TV(allinone)"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 IP-tv(allinone) ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp  
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    privileged: true
    ports:
        - '$dc_port:35455'
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   "URL: http://$WAN4:$dc_port" >> $FCONF
  echo -e   "URL: http://$WAN4:$dc_port"
  echo -e ""
}


docker_deploy_iptv_doube(){

  local BFLD="/home/dcc.d"

  local dc_port=35027
  local dc_name=iptvb
  local dc_imag=doubebly/doube-itv:latest
  local dc_desc="IP-TV(doubebly)"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 IP-tv(doubebly) ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp  
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    restart: unless-stopped
    privileged: true
    ports:
        - '$dc_port:5000'
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   "URL: http://$WAN4:$dc_port" >> $FCONF
  echo -e   "URL: http://$WAN4:$dc_port"
  echo -e ""
}

docker_deploy_aktools(){

  local BFLD="/home/dcc.d"

  local dc_port=4083
  local dc_name=aktools
  local dc_imag=registry.cn-shanghai.aliyuncs.com/akfamily/aktools:1.8.95
  local dc_desc="AKTools"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 AKTools ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  # curl -sS -O https://github.com/akfamily/aktools/blob/main/Dockerfile
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    environment:
      - SITE_PASSWORD=$SITE_PASSWORD
    ports:
        - '$dc_port:8080'
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   "Request example: http://$WAN4:$dc_port/api/public/stock_zh_a_hist" >> $FCONF
  echo -e   "Request example: http://$WAN4:$dc_port/api/public/stock_zh_a_hist"
  echo -e ""
}

# https://akshare.akfamily.xyz/akdocker/akdocker.html#docker
# https://github.com/lmzxtek/akshare 
docker_deploy_akjupyterlab(){

  local BFLD="/home/dcc.d"

  local dc_port=7788
  local dc_name=akjupyterlab
  local dc_imag=registry.cn-shanghai.aliyuncs.com/akfamily/aktools:jupyter
  local dc_desc="AKJupyter-Lab"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 AKJupyter-Lab ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  # docker run -it -p 8888:8888 \
  #         --name akdocker \
  #         -v /home:/home registry.cn-shanghai.aliyuncs.com/akfamily/aktools:jupyter jupyter-lab \
  #         --allow-root \
  #         --no-browser \
  #         --ip=0.0.0.0
  
  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
        - /home:/home
    ports:
        - '$dc_port:8888'
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   "Web URL: http://$WAN4:$dc_port/lab?token=*******" >> $FCONF
  echo -e   "Web URL: http://$WAN4:$dc_port/lab?token=*******"
  echo -e ""
}

# https://www.cnblogs.com/jruing/p/15943834.html
docker_deploy_jupyterlab(){

  local BFLD="/home/dcc.d"

  local dc_port=7668
  local dc_name=jupyterlab
  local dc_imag=captainji/jupyterlab
  # local dc_imag=captainji/jupyterlab:3.0.5
  local dc_desc="Jupyter-Lab"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/notebooks"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 Jupyter-Lab ... \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  # docker run -d --name jupyterlab3 -p 8888:8888 -v (pwd):/opt/notebooks captainji/jupyterlab:3.0.5

  # docker run -d \
  #           -p 8888:8888 \
  #           -e JUPYTER_ENABLE_LAB=yes \
  #           -v /data/docker/jupyter:/usr/local/src/jupyterlab_workspace \
  #           -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime \
  #           -v /etc/timezone:/etc/timezone \
  #           --restart=always \
  #           --name JupyterLab captainji/jupyterlab
  # docker logs Jupyterlab

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
        - /home:/home
        - $LPTH:/opt/notebooks
    ports:
        - '$dc_port:8888'
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e   "Web URL: http://$WAN4:$dc_port/lab?token=*******" >> $FCONF
  echo -e   "Web URL: http://$WAN4:$dc_port/lab?token=*******"
  echo -e ""
}

docker_deploy_kasmworkspaces(){

  local BFLD="/home/dcc.d"

  local dc_port=8443
  local dc_name=kasmworkspaces
  local dc_imag=captainji/jupyterlab
  local dc_desc="KasmWorkspaces"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/notebooks"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 Kasm Workspaces ... \n"
  echoR "\n >>>" " 注: 部署KASM，推荐的最低配置为 2CPU+2GRAM+20GHDD \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cd /tmp
  curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.15.0.06fdc8.tar.gz
  tar -xf kasm_release_1.15.0.06fdc8.tar.gz

  # sudo bash kasm_release/install.sh
  # sudo bash kasm_release/install.sh -L 8443
  sudo bash kasm_release/install.sh --accept-eula -L $dc_port
  # sudo bash kasm_release/install.sh --accept-eula --slim-images --swap-size 8192 -L $dc_port

  # docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echoR "\n >>> " "部署 Kasm Workspaces 完成 \n"
  echo -e   "Web URL: http://$WAN4:$dc_port" >> $FCONF
  echo -e   "Web URL: http://$WAN4:$dc_port"
  echo -e ""
}

docker_deploy_puter(){

  local BFLD="/home/dcc.d"

  local dc_port=44100
  local dc_name=puter
  local dc_imag=captainji/jupyterlab
  local dc_desc="Puter"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/config"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 Puter ... \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  mkdir -p config data
  # sudo chown -R 1000:1000 puter
  # wget https://raw.githubusercontent.com/HeyPuter/puter/main/docker-compose.yml
  # docker compose up

  cat > "$FYML" << EOF
services:
   ${dc_name}:
    container_name:  ${dc_name}
    image: ghcr.io/heyputer/puter:latest
    pull_policy: always
    # build: ./
    restart: unless-stopped
    ports:
      - '$dc_port:4100'
    environment:
      # TZ: Europe/Paris
      # CONFIG_PATH: /etc/puter
      PUID: 1000
      PGID: 1000
    volumes:
      - ./config:/etc/puter
      - ./data:/var/puter
    healthcheck:
      test: wget --no-verbose --tries=1 --spider http://puter.localhost:4100/test || exit 1
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 30s
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echoR "\n >>> " "部署 Puter 完成 \n"
  echo -e   "Web URL: http://$WAN4:$dc_port" >> $FCONF
  echo -e   "Web URL: http://$WAN4:$dc_port"
  echo -e ""
}

docker_deploy_torbrowser(){

  local BFLD="/home/dcc.d"

  local dc_port=35800
  local dc_name=torbrowser
  local dc_imag=domistyle/tor-browser
  local dc_desc="Tor-Browser"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 Tor Browser ... \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    ports:
        - '$dc_port:5800'
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echoR "\n >>> " "部署 Tor Browser 完成 \n"
  # echo -e   "Web URL: http://$WAN4:$dc_port" >> $FCONF
  # echo -e   "Web URL: http://$WAN4:$dc_port"
  echo -e ""
}

docker_deploy_browserless(){

  local BFLD="/home/dcc.d"

  local dc_port=33003
  local dc_name=browserless
  local dc_imag=ghcr.io/browserless/chromium
  local dc_desc="Browserless"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 browserless(Chromium) ... \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    ports:
        - '$dc_port:3000'
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echoR "\n >>> " "部署 browserless(Chromium) 完成 \n"
  # echo -e   "Web URL: http://$WAN4:$dc_port" >> $FCONF
  # echo -e   "Web URL: http://$WAN4:$dc_port"
  echo -e ""
}

docker_deploy_linuxserverfirefox(){

  local BFLD="/home/dcc.d"

  local dc_port=33004
  local dc_name=linuxserverfirefox
  local dc_imag=ghcr.io/linuxserver/firefox:latest
  local dc_desc="LinuxServerFirefox"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 LinuxServer(Firefox) ... \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  # docker run -d \
  #           --name=firefox \
  #           --security-opt seccomp=unconfined \
  #           -e PUID=1000 \
  #           -e PGID=1000 \
  #           -e TZ=Etc/UTC \
  #           -p 3000:3000 \
  #           -p 3001:3001 \
  #           -v /firefox:/config \
  #           --shm-size="7gb" \
  #           --restart unless-stopped \
  #           ghcr.io/linuxserver/firefox:latest

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
      - $LPTH:/config
    ports:
    #  - '$dc_port:3000'
      - '$dc_port:3001'
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    security_opt:
      - seccomp=unconfined
    shm_size: "7gb"
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echoR "\n >>> " "部署 LinuxServer(Firefox) 完成 \n"
  # echo -e   "Web URL: http://$WAN4:$dc_port" >> $FCONF
  # echo -e   "Web URL: http://$WAN4:$dc_port"
  echo -e ""
}


docker_deploy_linuxserverchromium(){

  local BFLD="/home/dcc.d"

  local dc_port=33005
  local dc_name=linuxserverchromium
  local dc_imag=ghcr.io/linuxserver/chromium:latest
  # local dc_imag=ghcr.io/linuxserver/mullvad-browser:latest
  # local dc_imag=ghcr.io/linuxserver/opera:latest
  local dc_desc="LinuxServerChromium"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 LinuxServer(Chromium) ... \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  # docker run -d \
  #             --name=chromium \
  #             --security-opt seccomp=unconfined \
  #             -e PUID=1000 \
  #             -e PGID=1000 \
  #             -e TZ=Etc/UTC \
  #             -p 3000:3000 \
  #             -p 3001:3001 \
  #             -v /chromium:/config \
  #             --shm-size="7gb" \
  #             --restart unless-stopped \
  #             ghcr.io/linuxserver/chromium:latest

  cat > "$FYML" << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    volumes:
      - $LPTH:/config
    ports:
    #  - '$dc_port:3000'
      - '$dc_port:3001'
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    security_opt:
      - seccomp=unconfined
    shm_size: "7gb"
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echoR "\n >>> " "部署 LinuxServer(Chromium) 完成 \n"
  # echo -e   "Web URL: http://$WAN4:$dc_port" >> $FCONF
  # echo -e   "Web URL: http://$WAN4:$dc_port"
  echo -e ""
}

docker_deploy_linuxserverrdesktop(){

  local BFLD="/home/dcc.d"

  local dc_port=3389
  local dc_name=rdesktop
  local dc_imag=lscr.io/linuxserver/rdesktop:latest
  # local dc_imag=ghcr.io/linuxserver/mullvad-browser:latest
  # local dc_imag=ghcr.io/linuxserver/opera:latest
  local dc_desc="LinuxServerRDesktop"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 LinuxServer(Chromium) ... \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  $dc_name:
    image: $dc_imag
    container_name: $dc_name
    security_opt:
      - seccomp:unconfined #optional
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock #optional
      - ./data:/config #optional
    ports:
      - $dc_port:3389
    # devices:
    #   - /dev/dri:/dev/dri #optional
    shm_size: "1gb" #optional
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echoR "\n >>> " "部署 LinuxServer(rdesktop) 完成 \n"
  # echo -e   "Web URL: http://$WAN4:$dc_port" >> $FCONF
  # echo -e   "Web URL: http://$WAN4:$dc_port"
  echo -e ""
}

# https://blog.csdn.net/BBQ__ZXB/article/details/138978608
docker_deploy_photopea(){

  local BFLD="/home/dcc.d"

  local dc_port=2887
  local dc_name=photopea
  local dc_imag=registry.cn-guangzhou.aliyuncs.com/os_cmty/os_cmty:Photopea
  # local dc_imag=kovaszab/photopea:latest
  # local dc_imag=dennysubke/photopea:latest # https://gitflic.ru/project/photopea-v2/photopea-v-2.git
  
  local dc_desc="Photepea Online Editor"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署 Photopea Online Editor... \n"
  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  cat > "$FYML" << EOF
services:
  $dc_name:
    image: $dc_imag
    container_name: $dc_name
    ports:
      - $dc_port:2887
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echoR "\n >>> " "部署 Photepea Online Editor 完成 \n"
  # echo -e   "Web URL: http://$WAN4:$dc_port" >> $FCONF
  # echo -e   "Web URL: http://$WAN4:$dc_port"
  echo -e ""
}


docker_deploy_chunhuchat(){

  local BFLD="/home/dcc.d"

  local dc_port=7847
  local dc_name=changhuchat
  local dc_image=ghcr.io/gaizhenbiao/chuanhuchatgpt:latest
  local dc_desc="ChunHu川虎学术"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/history"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/history"
  local FYML="$LFLD/docker-compose.yml"
  local FCONF="$LFLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echoR "\n >>>" " 现在开始部署GPT-Academic ... \n"

  read -p "请输入监听端口(默认:${dc_port}): " ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp

  # read -p "请输入API_KEY       : " API_KEY
  # read -p "请输入GEMINI_API_KEY: " GEMINI_API_KEY
  # read -p "请输入登录账户       : " USER
  # read -p "请输入登录密码       : " PASS

  cd "$LFLD" && install git && git clone https://github.com/GaiZhenbiao/ChuanhuChatGPT.git .
  cp config_example.json config.json
  # curl -os "${LFLD}/config.json" https://raw.githubusercontent.com/GaiZhenbiao/ChuanhuChatGPT/main/config_example.json

  cat > $LFLD/docker-compose.yml << EOF
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    build:
      context: . 
      dockerfile: Dockerfile

    environment:
      - PUID=0
    volumes:
        - $LFLD/config.json:/app/config.json
        - $LPTH:/app/history
    ports:
        - '$dc_port:7860'
    restart: unless-stopped
EOF

  # docker-compose up -d  
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e "\n Config path: $LFLD/config.json"
  echo -e "\n Config path: $LFLD/config.json" >> $FCONF
  # echo -e "\n User       : $USER" >> $FCONF
  # echo -e   " Password   : $PASS" >> $FCONF
  echo -e ""
}

# 部署Docker，使用yml配置文件
docker_deploy_start(){
  local BFLD=$1
  local NAME=$2
  local PORT=$3
  local DESC=$4

  local CONF="${BFLD}/${NAME}/${NAME}.conf"

  # 先检测一下Docker安装状态
  echoR "\n >>>" " Check Docker status ... "
  docker_install

  echoR "\n >>>" " Start to build and run Docker ($NAME) ... "
  cd ${BFLD}/${NAME}
  docker-compose up -d

  # 是否绑定域名？
  echoR "\n >>>" " Start set domain ... "
  txtb "—————————————————————————————————————"
  WANIP_show
  txtb "—————————————————————————————————————"
  read -p "  请输入要绑定域名(输入为空则不绑定域名): " DOMAIN
  if [[ -n "$DOMAIN" ]]; then
    echo -e "(注意: 此时域名解析应不开CDN, 绑定成功之后，能正常访问时再开启。)\n"
    echo -e " >>> 输入的域名为: " DOMAIN

    # caddy_install
    caddy_reproxy $DOMAIN "127.0.0.1" $PORT
    caddy_reload

  else 
    echo -e "\n >>> 不绑定域名 ... " 
  fi
  
  # 保存配置信息和访问链接
  echoR "\n >>>" " Start save config file ... "
  # echoR "\n >>>" " 保存配置文件: ${CONF}"
  cat > "${CONF}" << EOF
Service     : ${NAME}
Container   : ${NAME}
URL(IPV4)   : http://$WAN4:$PORT
URL(IPV6)   : http://[$WAN6]:$PORT
Domain      : $DOMAIN
Description : $DESC
EOF

  # 显示配置文件信息
  # echoR "\n容器 >> ${NAME} << " "配置信息和访问链接："
  echoR "\n >>>" " 容器${NAME}配置信息:"
  echoB " >>>" " 路径 > ${CONF}"
  txtb "↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓"
  # cat $LFLD/${NAME}.conf
  echoT "Service   : " "${NAME}"
  echoT "Container : " "${NAME}"
  [[ -n "$WAN4"      ]] && echoR "URL(IPV4) : " "http://$WAN4:$PORT   "
  [[ -n "$WAN6"      ]] && echoR "URL(IPV6) : " "http://[$WAN6]:$PORT "
  [[ -n "$DOMAIN"    ]] && echoY "Domain    : " "https://${DOMAIN}            "
  txtb "↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↓↓↓↓↓↓"

  echoR "\n >>>" " Great! Deploy ${NAME} Done."
  echoT ""
}

# 站点工具菜单
website_deploy_menu() {

txtn " "
txtn $(txby "▼ 容器部署")$(txtp " ♨♨♨ ")
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txtn " 1.AuroraPanel")$(txtg " ")"          "$(txtn "11.MacCMS")$(txtn " ")
txtn $(txtn " 2.Ubuntu20-noVNC")$(txtg " ")"       "$(txtn "12.Memos")$(txtn " ")
txtn $(txtn " 3.IT-Tools")$(txtg " ")"             "$(txtc "13.YACD")$(txtn " ")
txtn $(txtc " 4.SearXNG")$(txtg " ")"              "$(txtn "14.ClashDashBoard")$(txtn " ")
txtn $(txtn " 5.StirlingPDF")$(txtg " ")"          "$(txtb "15.RocketChat")$(txtr " ✘")
txtn $(txty " 6.MyIP(IPChecking)")$(txtg " ")"     "$(txtn "16.GPT_Academic")$(txtn " ")
txtn $(txtn " 7.QBittorrent")$(txtg " ")"          "$(txtn "17.GeminiProChat")$(txtn " ")
txtn $(txtn " 8.Portainer")$(txtg " ")"            "$(txtn "18.ChunhuChat")$(txtn " ")
txtn $(txtn " 9.Next-Terminal")$(txtg " ")"        "$(txtn "19.ChatGPT-Next-Web")$(txtn " ")
txtn $(txtn "10.NginxProxyManager")$(txtg " ")"    "$(txtc "20.Aktools")$(txtn " ")
txtn "--------------------------------------"
txtn $(txtn "21.Dash.")$(txtg " ")"                "$(txtn "31.AKJupyter-Lab")$(txtn " ")
txtn $(txtn "22.WatchTower")$(txtg " ")"           "$(txty "32.Jupyter-Lab")$(txtn " ★")
txtn $(txtn "23.DeepLX")$(txtg " ☆")"              "$(txtn "33.Photopea")$(txtn " ")
txtn $(txtn "24.Puter")$(txtn " ")"                "$(txtn "34.Lucky")$(txtn " ")
txtn $(txtc "25.SubLinkX")$(txtg " ")"             "$(txtn "35.pdf2zh")$(txtp " ")
txtn $(txtb "26.TalkWithGemini")$(txtg " ")"       "$(txtn "36.")$(txtp " ")
txtn $(txtb "27.IP-tv(allinone)")$(txtg " ")"      "$(txtn "37.")$(txtp " ")
txtn $(txtb "28.IP-tv(doubebly)")$(txtg " ")"      "$(txtn "38.")$(txtp " ")
txtn "====================================="
txtn $(txty "61.Docker-win")$(txtg " ")"           "$(txtn "71.linuxserver(firefox)")$(txtp " ")
txtn $(txtn "62.Docker-win(ARM)")$(txtg " ")"      "$(txtn "72.linuxserver(chromium)")$(txtp " ")
txtn $(txtn "63.Docker-mac")$(txtg " ")"           "$(txtn "73.linuxserver(rdesktop)")$(txtp " ")
txtn $(txtn "64.Docker-wechat")$(txtg " ")"        "$(txtn "74.TorBrowser")$(txtp " ")
txtn $(txtn "65.Neko")$(txtg " ")"                 "$(txtn "75.OnlineBrowser")$(txtp " ")
txtn $(txtn "66.Neko-Rooms")$(txtg " ")"           "$(txtn "76.KasmWorkspaces")$(txtp " ")
# txtn $(txtn "")$(txtg " ")"           "$(txtn "")$(txtp " ")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "====================================="
txtn $(txtp "96.重启Caddy")$(txty "☣")"            "$(txtp "97.")$(txtc "站点管理")$(txty "❦")
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"           "$(txtp "98.")$(txtc "容器管理")$(txty "☪")
txtn " "
}

# 面板工具
docker_deploy_run(){
  while true; do
    clear && website_deploy_menu
    read -p "请输入你的选择: " sub_choice

    case $sub_choice in
      1) clear && install curl && bash <(curl -fsSL https://raw.githubusercontent.com/Aurora-Admin-Panel/deploy/main/install.sh)  ;;
      2) clear && docker_deploy_ubuntu2004novnc ;;
      3) clear && docker_deploy_ittools ;;
      4) clear && docker_deploy_searxng ;;
      5) clear && docker_deploy_spdf ;;
      6) clear && docker_deploy_myip ;;
      7) clear && docker_deploy_qbittorrent ;;
      8) clear && docker_deploy_portainer ;;
      9) clear && docker_deploy_nextterminal ;;
     10) clear && docker_deploy_npm ;;
     
     11) clear && docker_deploy_maccms_tweek ;;
     12) clear && docker_deploy_memos ;;
     13) clear && docker_deploy_yacd ;;
     14) clear && docker_deploy_clashdashboard;;
     15) clear && docker_deploy_rocketchat ;;
     16) clear && docker_deploy_gptacademic ;;
     17) clear && docker_deploy_geminiprochat ;;
     18) clear && docker_deploy_chunhuchat ;;
     19) clear && docker_deploy_chatgptnextweb ;;
     20) clear && docker_deploy_aktools ;;

     21) clear && docker_deploy_dashdot ;;
     22) clear && docker_deploy_watchtower ;;
     23) clear && docker_deploy_deeplx ;;
     24) clear && docker_deploy_puter ;;
     25) clear && docker_deploy_sublinkx ;;
     26) clear && docker_deploy_talkwithgemini ;;
     27) clear && docker_deploy_iptv_allinone ;;
     28) clear && docker_deploy_iptv_doube ;;

     31) clear && docker_deploy_akjupyterlab ;;
     32) clear && docker_deploy_jupyterlab ;;
    #  35) clear && docker_deploy_browserless ;;
     33) clear && docker_deploy_photopea ;;
     34) clear && docker_deploy_lucky ;;
     35) clear && docker_deploy_pdf2zh ;;
    
     61) clear && docker_deploy_dockerwin_amd64 ;;
     62) clear && docker_deploy_dockerwin_arm64 ;;
     63) clear && docker_deploy_dockermac ;;
     64) clear && docker_deploy_dockerwechat ;;
     65) clear && docker_deploy_neko ;;
     66) clear && docker_deploy_neko_rooms ;;

     71) clear && docker_deploy_linuxserverfirefox ;;
     72) clear && docker_deploy_linuxserverchromium ;;
     73) clear && docker_deploy_linuxserverrdesktop ;;
     74) clear && docker_deploy_torbrowser ;;
     75) clear && install curl && curl -sLkO hammou.ch/online-browser && bash online-browser ;;
      # https://github.com/hhammouch/online-browser
     76) clear && docker_deploy_kasmworkspaces ;;

     96) clear && caddy_reload ;;
     97) clear && WebSites_manager_run ;;
     98) clear && docker_manage_run ;;

      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
  done

}

other_tools_menu() {
txtn " "
txtn $(txbr "▼ 管理工具")$(txbg " ののの ")
txtn "-------------------------------------"
WANIP_show
txtn "====================================="
# txtn "—————————————————————————————————————"
# txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty " 1.1Panel")$(txty " ☂")"         "$(txtn "11.AList")$(txtg " ")
txtn $(txtn " 2.aaPanel")$(txtg " ")"         "$(txtn "12.MacCMS")$(txtb " ✘")
txtn $(txtn " 3.宝塔面板")$(txtg " ")"        "$(txtc "13.WebOS")$(txtr " ")
txtn $(txtr " 4.NeZha(v0)")$(txtg " ")"        "$(txty "14.Code-Server")$(txtg " ")
txtn $(txtn " 5.OpenLiteSpeed")$(txtg " ")"   "$(txtn "15.ChatGPT-Next-Web")$(txtr " ✘")
txtn $(txtn " 6.Puter")$(txtg " ")"           "$(txtn "16.爱影CMS")$(txtn " ♡")
txtn $(txtn " 7.Lucky")$(txtg " ")"           "$(txtn "17.DataEase")$(txtn " ")
txtn $(txtn " 8.JumpServer")$(txtg " ")"      "$(txtn "18.Akile Monitor")$(txtn " ✲")
txtn $(txtr " 9.NeZha(v1)")$(txtg " ")"      "$(txtn "")$(txtn " ")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "31.Docker")$(txtg " ☆")"         "$(txtn "51.Gnome-Desktop")$(txtg " ")
txtn $(txtn "32.Python")$(txtg " ")"          "$(txtn "52.RustDesk Server")$(txtg " ")
txtn $(txtn "33.pip")$(txtg " ")"             "$(txtn "53.DeepLX Server")$(txtg " ")
txtn $(txtn "34.miniConda")$(txtr " ")"       "$(txtn "54.Chrome")$(txtg " ")
txtn $(txty "35.Conda-forge")$(txtr " ★")"    "$(txtc "55.Jupyter-lab")$(txtg " ")
txtn $(txtn "36.TA-Lib")$(txtg " ")"          "$(txtn "56.SubLinkX")$(txtn " ")
txtn $(txtn "37.Julia")$(txtg " ")"           "$(txtn "57.")$(txtn " ")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "41.Add 1panel-v4v6")$(txtg " ")" "$(txtn "")$(txtb " ")
txtn $(txtn "42.set AliYun(pip)")$(txtg " ")" "$(txtn "")$(txtb " ")
txtn $(txtn "43.Docker(一点科技)")$(txtg " ")" "$(txtn "")$(txtb " ")
txtn $(txtn "44.Nginx(一点科技)")$(txtg " ")" "$(txtn "")$(txtb " ")
txtn $(txtn "45.Serv00(一点科技)")$(txtg " ")" "$(txtn "")$(txtb " ")
txtn $(txtn "46.pip(gunicorn)")$(txtg " ")" "$(txtn "")$(txtb " ")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")
txtn " "
}

other_tools_run() {
  while true; do
    clear && other_tools_menu
    reading "请选择代码: " choice

    case $choice in
      1) clear && install_1panel  ;;
      2) clear && install_baota_aa ;;
      3) clear && install_baota_cn ;;
      4) clear && install curl && curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh  -o nezha.sh && chmod +x nezha.sh && ./nezha.sh  ;;
      5) clear && install wget && wget https://raw.githubusercontent.com/litespeedtech/ols1clk/master/ols1clk.sh && bash ols1clk.sh  ;;
      
      6) clear 
        git clone https://github.com/HeyPuter/puter
        cd puter
        install npm
        npm install
        npm start

        [[ -n "$WAN4" ]] && txtn " >>> URL: http://$WAN4:4000 "
        [[ -n "$WAN6" ]] && txtn " >>> URL: http://[$WAN6]:4000 "
        ;;
      7) clear && install curl 
        # curl -o /tmp/install.sh  https://fastly.jsdelivr.net/gh/gdy666/lucky-files@main/golucky.sh  && sh /tmp/install.sh https://fastly.jsdelivr.net/gh/gdy666/lucky-files@main 2.11.2  
        curl -o /tmp/install.sh   https://6.666666.host:66/files/golucky.sh  && sh /tmp/install.sh https://6.666666.host:66/files 2.11.2
         txtn ""
         txtn " >>> 部署Lucky转发服务完成"
         txtn " >>> 访问地址: http://localhost:16601"
         txtn " >>> 注意: 若安装失败, 可考虑选择第2项:/usr/share目录下"
         txtn ""
        ;;

      8) clear && install curl       
        country=$(curl -s --max-time 3 ipinfo.io/country)
        if [ "$country" = "CN" ]; then
          curl -sSL https://resource.fit2cloud.com/jumpserver/jumpserver/releases/latest/download/quick_start.sh | bash
        else
          curl -sSL https://github.com/jumpserver/jumpserver/releases/latest/download/quick_start.sh | bash
        fi

         txtn ""
         txtn " >>> 安装JumpServer堡垒机完成"
         txtn " >>> 访问地址: http://localhost:16601"
         txtn " >>> 账号密码: admin@ChangeMe"
         txtn ""
        ;;
      9) clear && curl -L https://raw.githubusercontent.com/nezhahq/scripts/refs/heads/main/install.sh -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh ;;

     11) clear && install curl && curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s install  ;;
     12) clear && install_maccms ;;
    #  13) clear && install_kodbox  ;;
     13) clear && if [ -f /usr/bin/curl ];then curl -sSO https://support.tenfell.cn/install.sh;else wget -O install.sh https://support.tenfell.cn/install.sh;fi;bash install.sh  ;;
     14) clear && install curl && curl -fsSL https://code-server.dev/install.sh | sh  ;;
     15) clear && install curl && bash <(curl -s https://raw.githubusercontent.com/Yidadaa/ChatGPT-Next-Web/main/scripts/setup.sh) ;;
     
     16) clear && install wget 
         sudo rm -f iycms.sh; sudo wget --no-check-certificate -c -O iycms.sh https://www.iycms.com/api/static/down/linux/ubuntu/install_x86_64.sh;sudo chmod +x iycms.sh; sudo ./iycms.sh 
         txtn ""
         txtn " >>> 部署iyCMS内容管理系统完成."
         txtn " >>> (完成部署需要安装MySQL或PostgreSQL数据库)"
         txtn " 安装完成后，可以使用以下命令查看和操作程序"
         txtn " systemctl status iycms       查看iycms服务运行状态"
         txtn " systemctl start iycms        启动iycms服务       "
         txtn " systemctl stop iycms         停止iycms服务       "
         txtn " systemctl restart iycms      重启iycms服务       "

         txtn ""
        #  txtn " >>> 访问URL: http://{WAN4}:21007" 
        [[ -n "$WAN4" ]] && txtn " >>> URL: http://$WAN4:21007 "
        [[ -n "$WAN6" ]] && txtn " >>> URL: http://[$WAN6]:21007 "
         ;;

      17) clear && curl -sSL https://dataease.oss-cn-hangzhou.aliyuncs.com/quick_start_v2.sh | bash ;;
      18) clear && wget -O ak-setup.sh "https://raw.githubusercontent.com/akile-network/akile_monitor/refs/heads/main/ak-setup.sh" && chmod +x ak-setup.sh && sudo ./ak-setup.sh ;;
      
      31) clear && docker_install ;;
      32) clear && install_python ;;
      33) clear && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py ;;
      34) 
        clear 
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-$(uname)-$(uname -m).sh && bash Miniconda3-latest-$(uname)-$(uname -m).sh 
        # if [[ $(uname -m | grep 'arm') != "" ]]; then 
        #   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh && bash Miniconda3-latest-Linux-aarch64.sh
        # else
        #   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh 
        # fi 
        ;;

      35) clear 
          if command -v curl &>/dev/null; then
            curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && bash Miniforge3-$(uname)-$(uname -m).sh
          else
            wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && bash Miniforge3-$(uname)-$(uname -m).sh 
          fi
          ;;
      36) clear && curl -O https://netcologne.dl.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz && tar -xzf ta-lib-0.4.0-src.tar.gz && cd ta-lib/ && ./configure --prefix=/usr && make && make install && cd .. ;;
      37) clear && curl -fsSL https://install.julialang.org | sh ;;

      41) 
          # clear 
          echo -e "\n >>> 添加1panel-v4v6之前，请先确保1Panel面板中开启了bridge网络的IPv6."
          docker network create --driver=bridge \
              --subnet=172.16.10.0/24 \
              --gateway=172.16.10.1 \
              --ip-range=172.16.10.0/16 \
              --subnet=2408:400e::/48 \
              --gateway=2408:400e::1 \
              --ip-range=2408:400e::/64 \
            1panel-v4v6
          echo -e "\n >>> 添加1panel-v4v6完成.\n"

          ;;

      42) 
          echo ' >>> 开始设置python源...'
          pip config set global.index-url  http://mirrors.aliyun.com/pypi/simple 
          pip config set global.trusted-host mirrors.aliyun.com
          pip config set global.disable-pip-version-check true
          pip config set global.timeout 30
          echo ' >>> 设置python源完成。'
          echo ''
           ;;
      43) clear && wget -O 1keji_nznginx.sh "https://pan.1keji.net/f/YJTA/1keji_nznginx.sh" && chmod +x 1keji_nznginx.sh && ./1keji_nznginx.sh ;;
      44) clear && wget -O 1keji_docker.sh "https://pan.1keji.net/f/rRi2/1keji_docker.sh" && chmod +x 1keji_docker.sh && ./1keji_docker.sh ;;
      45) clear && wget -O 1kejiV01.sh "https://pan.1keji.net/f/ERGcp/1kejiV01.sh" && chmod +x 1kejiV01.sh && ./1kejiV01.sh ;;
      46) clear && pip install gunicorn greenlet eventlet gevent ;;

      51) clear && install_ub_desktop ;;
      52) clear && install wget && wget https://raw.githubusercontent.com/dinger1986/rustdeskinstall/master/install.sh && chmod +x install.sh && ./install.sh ;;
      53) clear && install curl && bash <(curl -Ls https://qwq.mx/deeplx) ;;
      # 52) clear && install curl && bash <(curl -Ls https://raw.githubusercontent.com/OwO-Network/DeepLX/main/install.sh) ;;

      54) 
        clear 
        sudo apt-get install -f && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i google-chrome-stable_current_amd64.deb
        ;;
      55)  clear && pip install jupyter_server ;;
      56)  clear && curl -s https://raw.githubusercontent.com/gooaclok819/sublinkX/main/install.sh | sudo bash ;;
        
      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end
  done 
}

warp_tools_menu() {

txtn " "
txtn $(txbr "▼ 节点管理")$(txbb " ✈✈✈ ")
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txty " 1.Warp(@fscarmen)")$(txtr " ★")"              "$(txtn "11.XRay(@233boy)")$(txtg " ")
txtn $(txtn " 2.Warp(@hamid-gh98)")$(txtg " ")"             "$(txtn "12.V2Ray(@233boy)")$(txtg " ")
txtn $(txtn " 3.Warp(@Misaka-blog)")$(txtg " ")"            "$(txtn "13.V2Ray-Agent(@mack-a)")$(txtg " ")
txtn $(txtr " 4.Warp(@p3terx)")$(txtb " ")"                 "$(txtn "14.Hysteria2(@Misaka)")$(txtg " ")
txtn $(txtn " 5.Warp-go(@fscarmen)")$(txtg " ")"            "$(txtn "15.TUIC5(@Misaka)")$(txtg " ")
txtn $(txtn " 6.SingBox-Argox(@fscarmen)")$(txtg " ")"      "$(txtn "16.mianyang()")$(txtg " ")
txtn $(txby " 7.SingBox(@fscarmen)")$(txty " ♡")"           "$(txtn "17.ArgoX")$(txtb " ")
txtn $(txbb " 8.SingBox(@ygkkk)")$(txtb " ○")"              "$(txtr "18.Check-IP")$(txtb " ☭")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "51.XRayR(@XrayR-project)")$(txtg " ")"         "$(txtn "61.V2bX(Vless&Trojan to V2board)")$(txtg "")
txtn $(txtn "52.XRayR(@wyx2685)")$(txtg " ")"               "$(txtn "62.Bodhi(Hysteria2 to V2board)")$(txtg "")
txtn $(txtc "53.XRayR(Alpine)")$(txtg " ")"                 "$(txtn "63.XRayR-Docker(@XrayR-project)")$(txtg " ")
txtn $(txtc "54.XRayR(AirGo)")$(txtg " ")"                  "$(txtn "")$(txtg "")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr " ✖")
txtn " "
}

warp_tools_run() {
  while true; do
    clear && warp_tools_menu
    reading "请选择代码: " choice
    
    case $choice in
      1) 
        clear && install wget && wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh [option] [lisence/url/token] 
        recheck_ip_address
        ;;
      2) 
        clear 
        country=$(curl -s --max-time 3 ipinfo.io/country)
        if [ "$country" = "CN" ]; then
          bash <(curl -sSL https://mirror.ghproxy.com/https://raw.githubusercontent.com/hamid-gh98/x-ui-scripts/main/install_warp_proxy.sh) 
        else
          bash <(curl -sSL https://raw.githubusercontent.com/hamid-gh98/x-ui-scripts/main/install_warp_proxy.sh) 
        fi
        recheck_ip_address
        ;;
      3) 
        clear && wget -N https://gitlab.com/Misaka-blog/warp-script/-/raw/main/warp.sh && bash warp.sh 
        recheck_ip_address
        ;;
      4) clear && bash <(curl -fsSL git.io/warp.sh) menu  ;;
      5) clear 
        country=$(curl -s --max-time 3 ipinfo.io/country)
        if [ "$country" = "CN" ]; then
          wget -N https://mirror.ghproxy.com/https://raw.githubusercontent.com/fscarmen/warp/main/warp-go.sh && bash warp-go.sh 
        else
          wget -N https://raw.githubusercontent.com/fscarmen/warp/main/warp-go.sh && bash warp-go.sh 
        fi
        recheck_ip_address
          ;;
      6) clear && bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/sba/main/sba.sh) ;;
      7) clear 
        country=$(curl -s --max-time 3 ipinfo.io/country)
        if [ "$country" = "CN" ]; then
          bash <(wget -qO-  https://mirror.ghproxy.com/https://raw.githubusercontent.com/fscarmen/sing-box/main/sing-box.sh)
        else
          bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/sing-box/main/sing-box.sh)
        fi
        ;;

      8) clear && bash <(curl -Ls https://gitlab.com/rwkgyg/sing-box-yg/raw/main/sb.sh) ;;

     11) clear && bash <(wget -qO- -o- https://github.com/233boy/Xray/raw/main/install.sh) ;;
     12) clear && bash <(wget -qO- -o- https://git.io/v2ray.sh) ;;
     13) clear && wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh ;;
     14) clear && wget -N --no-check-certificate https://raw.githubusercontent.com/Misaka-blog/hysteria-install/main/hy2/hysteria.sh && bash hysteria.sh ;;
     15) clear && wget -N --no-check-certificate https://gitlab.com/Misaka-blog/tuic-script/-/raw/main/tuic.sh && bash tuic.sh ;;
     16) clear && bash <(curl -fsSL https://github.com/vveg26/sing-box-reality-hysteria2/raw/main/beta.sh) ;;
     17) clear && bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/argox/main/argox.sh)  ;;
     18) check_IP_address ;;

     51) clear && wget -N https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh && bash install.sh && cd /etc/XrayR ;;
     52) clear && wget -N https://raw.githubusercontent.com/wyx2685/XrayR-release/master/install.sh && bash install.sh ;;
     53) clear && apk add wget sudo curl && wget -N https://github.com/Cd1s/alpineXrayR/releases/download/one-click/install-xrayr.sh && chmod +x install-xrayr.sh && bash install-xrayr.sh ;;
     54) clear && bash <(curl -Ls https://raw.githubusercontent.com/ppoonk/XrayR-for-AirGo/main/scripts/manage.sh) ;;

     61) clear && wget -N https://raw.githubusercontent.com/wyx2685/V2bX-script/master/install.sh && bash install.sh ;;
     62) clear && cd ~ && git clone https://github.com/lotusnetwork/bodhi-docker.git && cd bodhi-docker ;;
     63) clear && cd ~ && git clone https://github.com/XrayR-project/XrayR-release xrayr && cd xrayr ;;
    #  64) clear && docker run -p 1234:80 -d --name yacd --rm ghcr.io/haishanh/yacd:master ;;
    #  65) clear && echo -e "\n Todo: ... \n" ;;

      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    # recheck_ip_address
    break_end
  done 

}

IP_check_select_menu() {
txtn " "
txtn $(txbr "▼ IP检测与优选")$(txbb " ㊥㊥㊥ ")
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txtn " 1.Show IP(ip.sb)")$(txtg " ")"      "$(txtn "11.Set GitHUB(IPv6)")$(txtg " ")
txtn $(txtn " 2.Show IPv4(local)")$(txtb " ☆")"   "$(txtb "12.Cloudflare Select IP")$(txtg " ")
txtn $(txtn " 3.Show IPv6(local)")$(txtb " ☆")"   "$(txtn "13.Cloudflare Select CDN")$(txtg " ")
txtn $(txtp " 4.Cloudflare(IPv4)")$(txtg " ")"    "$(txtr "14.Check DNS")$(txtg " ")
txtn $(txtp " 5.Cloudflare(IPv6)")$(txtg " ")"    "$(txty "15.检测出站IP")$(txtg " ☭")
txtn "—————————————————————————————————————"
txtn $(txtp "21.安装网络管理工具(ip,ping...)")$(txtg " ")"    "$(txty "")$(txtg " ")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")
txtn " "
}

IP_check_select_run() {
  while true; do
    clear && IP_check_select_menu
    reading "请选择代码: " choice
    
    case $choice in
      1) echo -e "\nIP: $(curl -s ip.sb)\n"  ;;
      2) echo -e "\n$(ip addr | grep "inet ")\n"  ;;
      3) echo -e "\n$(ip addr | grep "inet6")\n"  ;;
      4) clear && curl -s4m5 https://www.cloudflare.com/cdn-cgi/trace ;;
      5) clear && curl -s6m5 https://www.cloudflare.com/cdn-cgi/trace ;;

     11) set_ipv6_github ;;
     12) clear && cd ~ && mkdir -p cfip && cd cfip && curl -sSL https://gitlab.com/rwkgyg/CFwarp/raw/main/point/cfip.sh -o cfip.sh && chmod +x cfip.sh && bash cfip.sh ;;
     13) clear && cd ~ && mkdir -p cfip && cd cfip && curl -sSL https://gitlab.com/rwkgyg/CFwarp/raw/main/point/CFcdnym.sh -o CFcdnym.sh && chmod +x CFcdnym.sh && bash CFcdnym.sh ;;
     14) clear && install nslookup && nslookup google.com ;;
     15) check_IP_address ;;
     21) clear
        # 对于Docker里面的环境，有可能需要进行这个操作 
         sys_update && install net-tools iputils-ping iproute2

         echo ""
         echo "IP 管理工具已安装，使用方法如下："
         echo "   1. 查看端口    : ss -tuln"
         echo "   2. 查看绑定端口: lsof -i :port"
         echo "   3. 查看系统IP  : ip addr show"
         echo "   4. 查看系统IPv4: ip addr show | grep 'inet '"
         echo "   5. 查看系统IPv6: ip addr show | grep inet6  "
         echo "   6. Ping: ping -4 www.google.com  "
         echo "   7. Ping: ping -6 ipv6.google.com "
         ;;

      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    # recheck_ip_address   
    break_end 
  done 

}

board_panels_menu() {
txtn " "
txtn $(txbr "▼ 节点面板")$(txbg " ⊕⊕⊕ ")
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txtn " 1.3X-UI(@mhsanaei)")$(txtg " ")"       "$(txtn "11.Hiddify")$(txtg " ")
txtn $(txtb " 2.X-UI(@alireza0)")$(txtg " ")"        "$(txty "12.V2RayA")$(txtg " ")
txtn $(txtn " 3.X-UI(@FranzKafkaYu)")$(txtg " ")"    "$(txtn "13.Daed")$(txtg " ")
txtn $(txtn " 4.X-UI(@rwkgyg)")$(txtg " ")"          "$(txtn "14.Daed-Docker")$(txtg " ")
txtn $(txtc " 5.X-UI(alpine)")$(txtg " ")"           "$(txtn "15.S-UI(@alireza0)")$(txtg " ")
txtn $(txtn " 6.H-UI(only HY2)")$(txtg " ")"         "$(txtn "")$(txtg "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "21.XBoard")$(txtb "✘")"                 "$(txtn "41.LotusBoard")$(txtb " ")
txtn $(txtn "22.V2Board")$(txtb "✘")"                "$(txtn "42.SSPanel")$(txtb "✘")
txtn $(txtn "23.V2Board(wyx2685)")$(txtb "✘")"       "$(txtn "43.Proxypanel")$(txtb "✘")
txtn $(txtn "24.AirGo")$(txtg " ")"                  "$(txtn "44.WireGuard-WebUI")$(txtb " ")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")
txtn " "
}

board_panels_run() {
  while true; do
    clear && board_panels_menu
    reading "请选择面板代码: " choice
    
    case $choice in
      1) clear && bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh) ;;
      2) clear && bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh) ;;
      3) clear && bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh) ;;
      4) clear && bash <(curl -Ls https://gitlab.com/rwkgyg/x-ui-yg/raw/main/install.sh)  ;;
      5) clear && apk add curl && apk add bash && bash <(curl -Ls https://raw.githubusercontent.com/Lynn-Becky/Alpine-x-ui/main/alpine-xui.sh)  ;;
      6) clear && bash <(curl -fsSL https://raw.githubusercontent.com/jonssonyan/h-ui/main/install.sh)  ;;

     11) clear && bash -c "$(curl -Lfo- https://raw.githubusercontent.com/hiddify/hiddify-config/main/common/download_install.sh)" ;;
     12) clear && echo -e "\n Todo: ... \n" ;;
     13) clear && sh -c "$(curl -sL https://github.com/daeuniverse/dae-installer/raw/main/installer.sh)" @ update-geoip update-geosite ;;
     14) clear && docker run -d --privileged --network=host --pid=host --restart=unless-stopped  -v /sys:/sys  -v /etc/daed:/etc/daed --name=daed ghcr.io/daeuniverse/daed:latest ;;
     15) clear && bash <(curl -Ls https://raw.githubusercontent.com/alireza0/s-ui/master/install.sh)  ;;

     21) clear && docker_deploy_xboard ;;
     24) clear && bash <(curl -Ls https://raw.githubusercontent.com/ppoonk/AirGo/main/server/scripts/install.sh)  ;;

     41) clear && docker_deploy_lotusboard ;;
     44) clear && docker_deploy_wireguardpanel ;;

      0) clear && qiqtools ;;
      # 0) clear && return 1 && exit;;
      *) echo "无效的输入!" ;;
    esac  
    break_end
  done 

}

# 更新容器镜像
docker_container_update(){

  local dc_name=$1
  local dc_imag=$2
  local dc_port=$3
  local dc_user=$4
  local dc_pass=$5
  
  clear
  txtn " "
  txtn " >>> 删除容器$dc_name ..."
  docker rm -f "$dc_name"
  txtn " >>> 删除镜像$dc_imag ..."
  docker rmi -f "$dc_imag"

  txtn " >>> 重新构建容器$dc_name ..."
  $docker_rum

  clear
  txtn " "
  txtn " $dc_name 更新完成"
  txtn "↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓"

  if [ -n "$dc_port"]; then
    echo -e " 使用以下地址访问:"
    echo -e "http://$WAN4:$dc_port"
    echo -e "http://$[WAN6]:$dc_port"
  fi

  [[ -n "$dc_user" ]] && echo -e "     User: $dc_user"
  [[ -n "$dc_pass" ]] && echo -e " Password: $dc_pass"
  txtn "↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑"
  txtn " "
}

docker_app() {
  if docker inspect "$docker_name" &>/dev/null; then
      clear
      echo "$docker_name 已安装，访问地址: "
      # check_IP_address
      echo "http://$WAN4:$docker_port"
      echo "http://[$WAN6]:$docker_port"
      echo ""
      echo "应用操作"
      echo "------------------------"
      echo "1. 更新应用             2. 卸载应用"
      echo "------------------------"
      echo "0. 返回上一级选单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1)
              clear
              docker rm -f "$docker_name"
              docker rmi -f "$docker_img"

              $docker_rum

              clear
              echo "$docker_name 已经安装完成"
              echo "------------------------"
              # 获取外部 IP 地址
              # check_IP_address
              echo "您可以使用以下地址访问:"
              echo "http://$WAN4:$docker_port"
              $docker_use
              $docker_passwd
              ;;
          2)
              clear
              docker rm -f "$docker_name"
              docker rmi -f "$docker_img"
              rm -rf "/home/docker/$docker_name"
              echo "应用已卸载"
              ;;
          0) ;; # 跳出循环，退出菜单
          *) ;; # 跳出循环，退出菜单
      esac
  else
      clear
      echo "安装提示"
      echo "$docker_describe"
      echo "$docker_url"
      echo ""

      # 提示用户确认安装
      read -p "确定安装吗？(Y/N): " choice
      case "$choice" in
          [Yy])
              clear
              # 安装 Docker（请确保有 docker_install 函数）
              docker_install
              $docker_rum

              clear
              echo "$docker_name 已经安装完成"
              echo "------------------------"
              # 获取外部 IP 地址
              # check_IP_address
              echo "您可以使用以下地址访问:"
              echo "http://$WAN4:$docker_port"
              echo "http://[$WAN6]:$docker_port"
              echo "------------------------"
              $docker_use
              $docker_passwd

              ;;
          [Nn]) ;; # 用户选择不安装
            *) ;; # 无效输入
      esac
  fi
}

docker_container_list_menu(){
txtn " "
txtn $(txbr "▼ Docker容器")$(txbg " ☪☪☪ ")
txtn "—————————————————————————————————————"
if ! command -v docker &>/dev/null; then
    echo -e " >>> Docker${red}未安装${PLAIN} ..."
else
  # echo -e "\n >>> Docker已安装 ..."
  docker ps -a
fi
txtn "====================================="
txtn $(txtn " 1.创建新的容器")$(txtg "✔")"       "$(txtn "11.启动所有容器")$(txtn "✔")
txtn $(txtn " 2.启动指定容器")$(txtg "✔")"       "$(txtn "12.暂停所有容器")$(txtn "✔")
txtn $(txtn " 3.重启指定容器")$(txtc "✔")"       "$(txtn "14.删除所有容器")$(txtn "✔")
txtn $(txtc " 4.停止指定容器")$(txtg "✔")"       "$(txtn "13.重启所有容器")$(txtn "✔")
txtn $(txty " 5.删除指定容器")$(txtr "✔")"       "$(txtp "15.进入指定容器")$(txtn "✔")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "21.查看容器网络")$(txtp "✔")"       "$(txtr "31.清理容器")$(txtc "〄")
txtn $(txtp "22.查看容器日志")$(txty "✔")"       "$(txtn "32.容器状态")$(txtp "☪")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")"       "$(txtr "")$(txtb "")$(txtc "")
txtn " "  
}

docker_container_list_run() {
  while true; do
    clear && docker_container_list_menu
    reading "请选择: " choice

    case $choice in
      1) 
        read -p "请输入创建命令: " docker_cmd
        $docker_cmd
        ;;

      2) 
        read -p "请输入要启动的容器名: " dockername
        docker start $dockername
        ;;
      3) 
        read -p "请输入要重启的容器名: " dockername
        docker restart $dockername
        ;;
      4) 
        read -p "请输入要停止的容器名: " dockername
        docker stop $dockername
        ;;
      5) 
        read -p "请输入要删除的容器名: " dockername
        docker stop $dockername
        docker rm $dockername
        ;;

     11) clear && docker start $(docker ps -a -q) ;;
     12) clear && docker stop $(docker ps -a -q) ;;
     13) clear && docker restart $(docker ps -a -q) ;;
     14) 
      read -p "确定删除所有容器吗？(Y/N): " choice
      case "$choice" in
        [Yy]) docker rm -f $(docker ps -a -q) ;;
        [Nn]) ;;
          *) echo "无效的选择，请输入 Y 或 N。" ;;
      esac
      ;;

     15) read -p "请输入容器名: " dockername && docker exec -it $dockername /bin/bash ;;

     22) read -p "请输入容器名: " dockername && docker logs $dockername ;;
     21) 
      echo ""
      container_ids=$(docker ps -q)

      echo "------------------------------------------------------------"
      printf "%-25s %-25s %-25s\n" "容器名称" "网络名称" "IP地址"

      for container_id in $container_ids; do
          container_info=$(docker inspect --format '{{ .Name }}{{ range $network, $config := .NetworkSettings.Networks }} {{ $network }} {{ $config.IPAddress }}{{ end }}' "$container_id")

          container_name=$(echo "$container_info" | awk '{print $1}')
          network_info=$(echo "$container_info" | cut -d' ' -f2-)

          while IFS= read -r line; do
              network_name=$(echo "$line" | awk '{print $1}')
              ip_address=$(echo "$line" | awk '{print $2}')

              printf "%-20s %-20s %-15s\n" "$container_name" "$network_name" "$ip_address"
          done <<< "$network_info"
      done
      ;;
     
     31) docker_clean ;;
     32) clear && docker_info_list ;;

      0) clear && docker_manage_run ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}

docker_images_list_menu(){
txtn " "
txtn $(txbr "▼ Docker镜像列表")$(txbg " ☪☪☪ ")
txtn "—————————————————————————————————————"
if ! command -v docker &>/dev/null; then
    echo -e " >>> Docker${red}未安装${PLAIN} ..."
else
  # echo -e "\n >>> Docker已安装 ..."
  # docker ps -a
  docker image ls
fi
txtn "====================================="
txtn $(txtn " 1.获取指定镜像")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 2.更新指定镜像")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 3.删除指定镜像")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 4.删除所有镜像")$(txtg "✔")"       "$(txtn "")$(txtn "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")"           "$(txtr "")$(txtb "")$(txtc "")
txtn " "  
}

docker_images_list_run() {
  while true; do
    clear && docker_images_list_menu
    reading "请选择: " choice

    case $choice in
      1) read -p "请输入要获取的镜像名: " dockername && docker pull $dockername ;;
      2) read -p "请输入要更新的镜像名: " dockername && docker pull $dockername ;;
      3) read -p "请输入要删除的镜像名: " dockername && docker rmi -f $dockername ;;
      4) 
        read -p "确定删除所有镜像吗？(Y/N): " choice
        case "$choice" in
          [Yy]) docker rmi -f $(docker images -q) ;;
          [Nn]) ;;
             *)  echo "无效的选择，请输入 Y 或 N。" ;;
        esac
        ;;
     
      0) clear && docker_manage_run ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}

docker_network_list_menu(){
txtn " "
txtn $(txbr "▼ Docker网络列表")$(txbg " ☪☪☪ ")
txtn "—————————————————————————————————————"
if ! command -v docker &>/dev/null; then
    echo -e " >>> Docker${red}未安装${PLAIN} ..."
else
  # echo -e "\n >>> Docker已安装 ..."
  # docker ps -a
  # docker image ls
  docker network ls
fi
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
container_ids=$(docker ps -q)
printf "%-25s %-25s %-25s\n" "容器名称" "网络名称" "IP地址"

for container_id in $container_ids; do
    container_info=$(docker inspect --format '{{ .Name }}{{ range $network, $config := .NetworkSettings.Networks }} {{ $network }} {{ $config.IPAddress }}{{ end }}' "$container_id")

    container_name=$(echo "$container_info" | awk '{print $1}')
    network_info=$(echo "$container_info" | cut -d' ' -f2-)

    while IFS= read -r line; do
        network_name=$(echo "$line" | awk '{print $1}')
        ip_address=$(echo "$line" | awk '{print $2}')

        printf "%-20s %-20s %-15s\n" "$container_name" "$network_name" "$ip_address"
    done <<< "$network_info"
done

txtn " "
txtn "====================================="
txtn $(txtn " 1.创建网络")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 2.加入网络")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 3.退出网络")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 4.删除网络")$(txtg "✔")"       "$(txtn "")$(txtn "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")"           "$(txtr "")$(txtb "")$(txtc "")
txtn " "  
}

docker_network_list_run() {
  while true; do
    clear && docker_network_list_menu
    reading "请选择: " choice

    case $choice in
      1) read -p "设置新网络名: " dockernetwork && docker network create $dockernetwork ;;
      2) 
        read -p "加入网络名: " dockernetwork 
        read -p "那些容器加入该网络: " dockername 
        docker network connect $dockernetwork $dockername 
        ;;
      3) 
        read -p "退出网络名: " dockernetwork
        read -p "那些容器退出该网络: " dockername
        docker network disconnect $dockernetwork $dockername
        echo ""
        ;;
      4) 
        read -p "请输入要删除的网络名: " dockernetwork
        docker network rm $dockernetwork
        ;;
     
      0) clear && docker_manage_run ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}

docker_volume_list_menu(){
txtn " "
txtn $(txbr "▼ Docker卷列表")$(txbg " ☪☪☪ ")
txtn "—————————————————————————————————————"
if ! command -v docker &>/dev/null; then
    echo -e " >>> Docker${red}未安装${PLAIN} ..."
else
  # echo -e "\n >>> Docker已安装 ..."
  # docker ps -a
  # docker image ls
  # docker network ls
  docker volume ls
fi
txtn "====================================="
txtn $(txtn " 1.创建新卷")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 2.删除卷")$(txtg "✔")"       "$(txtn "")$(txtn "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")"           "$(txtr "")$(txtb "")$(txtc "")
txtn " "  
}

docker_volume_list_run() {
  while true; do
    clear && docker_volume_list_menu
    reading "请选择: " choice

    case $choice in
      1) 
        read -p "设置新卷名: " dockerjuan
        docker volume create $dockerjuan
        ;;
      
      2) 
        read -p "输入删除卷名: " dockerjuan
        docker volume rm $dockerjuan
        ;;
     
      0) clear && docker_manage_run ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}

docker_volume_list_menu(){
  local dc_name=$1
txtn " "
txtn $(txbc " Docker > ")$(txby "${dc_name}")
txtn "—————————————————————————————————————"
echoY " Service     : " "$dc_name" 
echoY " Container   : " "$dc_name" 
echoY " Port        : " "$dc_port" 
echoY " Image       : " "$dc_imag" 
echoY " Volume      : " "$dc_volu" 
echoY " Description : " "$dc_desc" 
txtn "====================================="
txtn $(txtn " 1.安装应用")$(txtg "❀")"       "$(txtn "")$(txtn "")
txtn $(txtn " 2.更新应用")$(txtg "☣")"       "$(txtn "")$(txtn "")
txtn $(txtn " 3.卸载应用")$(txtg "✁")"       "$(txtn "")$(txtn "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")"           "$(txtr "")$(txtb "")$(txtc "")
txtn " "  
}

# 指定容器管理
docker_container_manage(){
  local dc_name=$1
  local dc_port=$2
  local dc_desc=$3
}

docker_menu() {
txtn " "
txtn $(txbr "▼ 容器管理")$(txbg " ☪☪☪ ")
txtn "—————————————————————————————————————"
WANIP_show
if ! command -v docker &>/dev/null; then
  txtn "====================================="
    echo -e " >>> Docker${yellow}未安装${PLAIN} ..."
elif ! command -v docker-compose &>/dev/null; then
  txtn "====================================="
  echo -e " >>> docker-compose${yellow}未安装${PLAIN} ..."
fi
txtn "====================================="
txtn $(txtn " 1.Docker环境安装")$(txtg " ")"       "$(txty "11.Docker状态")$(txtn " ☆")
txtn $(txtn " 2.Docker环境卸载")$(txtg " ")"       "$(txtn "12.Docker清理")$(txtn " ")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "21.Docker容器管理")$(txtp " ")"       "$(txtn "31.Docker网络管理")$(txtn " ")
txtn $(txtn "22.Docker镜像管理")$(txtp " ★")"      "$(txtn "32.Docker卷管理")$(txtn " ")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "66.设置快捷键[dcc]")$(txtg " ")"      "$(txtp "88.站点部署")$(txty " ▷")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"           "$(txtr "")$(txtb "")$(txtc "")
txtn " "
}

docker_manage_run() {
  while true; do
    clear && docker_menu
    reading "请选择: " choice

    case $choice in
      1) clear && docker_install ;;
      2) docker_uninstall ;;

     11) clear && docker_info_list ;;
     12) docker_clean ;;

     21) clear && docker_container_list_run ;;
     22) clear && docker_images_list_run ;;

     31) clear && docker_network_list_run ;;
     32) clear && docker_volume_list_run ;;

     66) docker_set_1ckl "dcc" ;;
     88) clear && docker_deploy_run ;;
      # 9) clear && chmod a+x /usr/local/bin/docker-compose && rm -rf `which dcc` && ln -s /usr/local/bin/docker-compose /usr/bin/dcc ;;
      
      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}


check_port() {
    # 定义要检测的端口
    PORT=443

    # 检查端口占用情况
    result=$(ss -tulpn | grep ":$PORT")

    # 判断结果并输出相应信息
    if [ -n "$result" ]; then
        is_nginx_container=$(docker ps --format '{{.Names}}' | grep 'nginx')

        # 判断是否是Nginx容器占用端口
        if [ -n "$is_nginx_container" ]; then
            echo ""
        else
            clear
            echo -e "\e[1;31m端口 $PORT 已被占用，无法安装环境，卸载以下程序后重试！\e[0m"
            echo "$result"
            break_end
            clear && clear && qiqtools
        fi
    else
        echo ""
    fi
}

add_yuming() {
  # check_IP_address
  unset yuming
  echo -e "先将域名解析到本机IP: ${red}$WAN4  ${BLUE}$WAN6${PLAIN}"
  read -p "请输入你解析的域名: " yuming
  echo "$yuming"
}

# 反代域名
reverse_proxy() {
      # check_IP_address
      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy.conf
      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
      sed -i "s/0.0.0.0/$WAN4/g" /home/web/conf.d/$yuming.conf
      sed -i "s/0000/$duankou/g" /home/web/conf.d/$yuming.conf
      docker restart nginx
}

# 安装PHP8.3
install_php83(){
  apt insstall sudo && sudo apt update && sudo apt upgrade -y && sudo apt install -y ca-certificates apt-transport-https software-properties-common lsb-release && sudo add-apt-repository ppa:ondrej/php -y && sudo apt update && sudo apt install -y php8.3 php8.3-fpm php8.3-cli && sudo systemctl enable php8.3-fpm --now

  # 安装PHP8.3-extentions
  # sudo apt install -y php8.3-{cli,fpm,curl,mysql,gd,opcache,zip,intl,common,bcmath,imagick,xmlrpc,readline,memcached,redis,mbstring,apcu,xml,dom,memcache}

  # php --version
  # php -m
}

# 安装PHP7.4
install_php74(){
  sudo apt update && sudo -y apt install software-properties-common && sudo add-apt-repository ppa:ondrej/php && sudo apt -y install php7.4 php7.4-cli php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-zip php7.4-xsl php7.4-mbstring php7.4-xml php7.4-xmlrpc php7.4-opcache

  # sudo apt-get autoremove php*
  # sudo add-apt-repository ppa:apt-fast/stable && sudo -y apt install apt-fast && sudo add-apt-repository ppa:ondrej/php && sudo apt-get update && sudo apt-fast -y install php7.4 && sudo -y apt-fast install php7.4-dev && sudo -y apt-fast install php-pear && sudo -y apt-fast install php7.4-fpm php7.4-mysql php7.4-curl php7.4-json php7.4-mbstring php7.4-xml php7.4-intl

  # php --version
  # php -m
}

install_mariadb(){
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

install_postgresql(){
  
  postgresql_usage
  read -p "确认要安装PostgreSQL？[Y|y] " sub_choice

  case $sub_choice in
    [Yy])
      install postgresql-client && apt update && install postgresql && postgresql_usage
      ;;
    [Nn]) ;;
        *) ;;
  esac
  

}

install_redis(){
  curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

  apt update
  apt install redis
  systemctl start redis-server
  systemctl enable redis-server

}

nginx_docker(){
  docker rm -f nginx >/dev/null 2>&1
  docker rmi nginx nginx:alpine >/dev/null 2>&1
  docker run -d --name nginx --restart always -p 80:80 -p 443:443 -p 443:443/udp -v /home/web/nginx.conf:/etc/nginx/nginx.conf -v /home/web/conf.d:/etc/nginx/conf.d -v /home/web/certs:/etc/nginx/certs -v /home/web/html:/var/www/html -v /home/web/log/nginx:/var/log/nginx nginx:alpine
}

nginx_install(){
  # apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
  # curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
  # echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
  # echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx

  # apt update
  # apt install nginx
  
  # systemctl start nginx
  # systemctl enable nginx
  
  apt install sudo && \
  sudo apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring && \
  curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
  echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list && \
  echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx && \
  sudo apt update && sudo apt install -y nginx && systemctl start nginx && systemctl enable nginx
}

nginx_remove(){
  sudo apt update
  sudo apt remove nginx nginx-common

  # 手动删除Nginx
  # sudo service nginx stop
  # sudo rm /etc/nginx/nginx.conf
  # sudo rm -rf /etc/nginx/conf.d
  # sudo rm -rf /var/log/nginx
  # sudo rm /run/nginx.pid
  # sudo rm -rf /var/www/html
  # sudo rm /usr/sbin/nginx
  # sudo find / -name nginx -print -exec rm -rf {} \;

}

openresty_install(){ echo -e "OpenResty installation is not implemented...";}

caddy_install(){
  # 准备目录和主页文件
  # mkdir -p /home/web/{caddy,html}
  [[ -d "/home/web/caddy" ]] || mkdir -p "/home/web/caddy"
  [[ -d "/home/web/html" ]] || mkdir -p "/home/web/html"
  [[ -d "/home/web/log" ]] || mkdir -p "/home/web/log"

  cd "/home/web/caddy"
  # touch /home/web/caddy/Caddyfile
  # touch /home/web/html/index.html
  [[ -f "/home/web/html/index.html"    ]] || wget -qO /home/web/html/index.html https://raw.gitcode.com/lmzxtek/qiqtools/raw/main/src/caddy/index.html
  [[ -f "/home/web/caddy/default.conf" ]] || wget -qO /home/web/caddy/default.conf https://raw.gitcode.com/lmzxtek/qiqtools/raw/main/src/caddy/default.conf

  if ! command -v caddy &>/dev/null; then
    echo -e "\n >>> Caddy未安装 ... "
    read -p " 安装Caddy环境吗? (输入Y[y]继续): " choice
    case "$choice" in
      [Yy]) 
            clear 
            sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl && \
            curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg && \
            curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list && \
            sudo apt update && sudo apt install -y caddy
            ;;
      # [Nn]) return 1 ;;
         *) echo -e " 不安装Caddy..." && return 1 ;;
    esac
  else
    echo -e "\n >>> Caddy已安装 ..."
    echo -e " >>> Config: /etc/caddy/Caddyfile"
    caddy --version
    echo -e ""
  fi
}

caddy_uninstall(){ echo -e "\nUninstall Caddy is not implemented...\n";}

# 反代
caddy_reproxy(){
  local domain=$1
  local reproxip=$2
  local report=$3
  cat > /home/web/caddy/$domain.conf << EOF
$domain {
    reverse_proxy $reproxip:$report
    encode gzip
}
EOF
}

# 重定向
caddy_redirect(){
  local domain=$1
  local redirurl=$2
  cat > /home/web/caddy/$domain.conf << EOF
$domain {
    redir $redirurl{uri}
}
EOF
}


# 静态网站
caddy_staticweb(){
  local domain=$1
  local rootpath=$2
  cat > /home/web/caddy/$domain.conf << EOF
$domain {
    root * $rootpath
    encode gzip
    file_server
}
EOF
}

# 更新域名信息
caddy_newcaddyfile(){
  if [ -z "$(find /home/web/caddy -name "*.conf")" ]; then
    echo " >>> No .conf files found in /home/web/caddy"
  else
    echo " >>> Put all *.conf files into: /etc/caddy/Caddyfile"
    mv /etc/caddy/Caddyfile /etc/caddy/Caddyfile.bak
    find /home/web/caddy -name "*.conf" -exec cat {} + > /etc/caddy/Caddyfile
    # cd /etc/caddy/Caddyfile
  fi
}

caddy_stop()  { caddy_install; cd /etc/caddy; caddy stop;  cd - ; }
caddy_start() { caddy_install; cd /etc/caddy; caddy start; cd - ; }
caddy_status(){ caddy_install; cd /etc/caddy; sudo systemctl status caddy; cd - ; }
caddy_reload(){ caddy_install; cd /etc/caddy; caddy_newcaddyfile; caddy reload; cd - ; }

# 站点列表（不包含default.conf)
caddy_web_list(){
  # ls -t /home/web/caddy | grep -v "default.conf" | sed 's/\.[^.]*$//'
  dm_list=$(ls -t /home/web/caddy | grep -v "default.conf" | sed 's/\.[^.]*$//')
  # clear
  echo -e "\n >> ${red}站点列表\n${PLAIN}-------------------------------\n"
  for dm_file in $dm_list; do
      printf "%-30s\n" "$dm_file"
  done
  echo -e "\n${PLAIN}-------------------------------\n"
}

# 修改域名
caddy_change_domain(){
  read -p "请输入旧域名: " dm_old
  read -p "请输入新域名: " dm_new

  mv /home/web/caddy/$dm_old.conf /home/web/caddy/$dm_new.conf
  sed -i "s/$dm_old/$dm_new/g" /home/web/caddy/$dm_new.conf

  caddy_reload
}

# 给现有域名添加新的域名
caddy_add_domain(){
  read -p "请输入旧域名: " dm_old
  read -p "请输入新域名: " dm_new

  cp /home/web/caddy/$dm_old.conf /home/web/caddy/$dm_new.conf
  sed -i "s/$dm_old/$dm_new/g" /home/web/caddy/$dm_new.conf

  caddy_reload  
}

# 删除现有域名
caddy_delete_domain(){
  read -p "请输入要删除的域名: " dm_old
  rm /home/web/caddy/$dm_old.conf
  
  caddy_reload
}

# 清理站点缓存
caddy_clean_cache(){ echo "Caddy会自动清除过期的缓存条目，无需额外操作。"; }

caddy_version(){
  caddy_version=$(caddy -v)
  caddy_version=$(echo "$caddy_version" | grep -oP "v/\K[0-9]+\.[0-9]+\.[0-9]+")
  echo -n "Caddy : v$caddy_version"
}

# 站点管理菜单
caddy_web_menu(){

clear

txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txbr "▼ 站点目录")$(txbg " ✉✉✉ ")
txtb "-------------------------------------"
txtn $(txtn " 数据：")$(txtb " /home/web/html ")
txtn $(txtn " 配置：")$(txtb " /home/web/caddy")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn " "
txtn $(txbr "▼ 站点管理")$(txbg " 〠 ")
txtn "====================================="
txtn $(txtn " 1.查看站点列表")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn $(txtn " 2.查看分析报告")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn $(txtr " 3.更换站点域名")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn $(txtn " 4.添加站点域名")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn $(txtb " 5.删除指定站点")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn $(txtn " 6.清理站点缓存")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")
txtn " "
}

# Web站点管理器
caddy_web_manager(){
  while true; do
      # caddy_web_list
      caddy_web_menu
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1) clear && caddy_web_list ;;
          2) clear && install goaccess && goaccess --log-format=COMBINED /home/web/log/caddy/access.log ;;
          3) clear && caddy_web_list && caddy_change_domain ;;
          4) clear && caddy_web_list && caddy_add_domain ;;
          5) clear && caddy_web_list && caddy_delete_domain ;;
          6) caddy_clean_cache ;;

          # 0) break ;; # 跳出循环，退出菜单
          0) WebSites_manager_run ;; # 跳出循环，退出菜单
          *) echo "无效的输入!" ;; # 跳出循环，退出菜单
      esac
      break_end
  done
}

# 网站管理菜单
WebSites_manager_menu() {

txtn " "
txtn $(txbr "▼ 站点管理")$(txtp " ❦❦❦ ")
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txtn " 1.安装LDNMP环境")$(txtn "✘")"      "$(txtn "11.更新LDNMP环境")$(txtn "✘")
txtn $(txtn " 2.卸载LDNMP环境")$(txtn "✘")"      "$(txtn "12.优化LDNMP环境")$(txtn "✘")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "11.查看状态")$(txtg " ☆")"          "$(txtn "21.安装PHP8.3")$(txtg " ")
txtn $(txtn "12.安装Caddy")$(txtg " ")"          "$(txtn "22.安装PHP8.2")$(txtn " ✘")
txtn $(txtn "13.安装Nginx")$(txtg " ")"          "$(txtn "23.安装PHP8.1")$(txtn " ✘")
txtn $(txtn "14.安装OpenLiteSpeed")$(txtg " ")"  "$(txtn "24.安装PHP7.4")$(txtb " ")
txtn $(txtn "15.卸载Nginx")$(txtr " ")"          "$(txtr "")$(txtb "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "31.站点列表")$(txtg " ")"           "$(txty "41.重启服务")$(txtp " ☢")
txtn $(txtn "32.站点管理")$(txtg " ☆")"          "$(txtn "42.停止服务")$(txtg " ")
txtn $(txtn "33.添加重定向")$(txtg " ")"         "$(txtn "43.更新服务")$(txtg " ")
txtn $(txty "34.添加反向代理")$(txtg " ★")"      "$(txtn "44.删除服务")$(txtg " ✘")
txtn $(txtn "35.添加静态站点")$(txtg " ")"       "$(txty "45.检测IP") $(txtb " ☭")
txtn "====================================="
txtn $(txtn "61.安装Redis")$(txtg " ")"          "$(txtn "63.安装MariaDB")$(txtb " ")
txtn $(txtn "62.安装MySQL")$(txtn "✘")"          "$(txtn "64.安装PostgreSQL")$(txtb " ")
# txtn $(txtn "")$(txtb "✘")"        "$(txtn "")$(txtb "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "77.站点防御程序")$(txtb "✘")"       "$(txtp "88.站点部署")$(txty "✔")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")
txtn " "
}

WebSites_manager_run(){

  if [ -d /etc/caddy ]; then
    cd /etc/caddy
  fi

  # check_IP_address

  while true; do
    clear && WebSites_manager_menu
    reading "请选择: " choice

    case $choice in
     11) caddy_status ;;
     12) clear && caddy_install ;;
     13) 
        #  安装Nginx

        # nginx_docker
        nginx_install
        # install nginx

        clear
        # nginx_version=$(docker exec nginx nginx -v 2>&1)
        nginx_version=$(nginx -v)
        nginx_version=$(echo "$nginx_version" | grep -oP "nginx/\K[0-9]+\.[0-9]+\.[0-9]+")
        echo "nginx已安装完成"
        echo "当前版本: v$nginx_version"
        # echo "当前版本: $(nginx -v)"
        echo ""
        ;;

    #  14) clear && openresty_install ;;
     14) 
      clear
      wget https://raw.githubusercontent.com/litespeedtech/ols1clk/master/ols1clk.sh && bash ols1clk.sh
      # bash <( curl -k https://raw.githubusercontent.com/litespeedtech/ols1clk/master/ols1clk.sh )
      echo ""
      echo -e " >>> 安装OpenLiteSpeed成功..."
      echo -e " >>> 设置用户名和密码：/usr/local/lsws/admin/misc/admpass.sh"
      ;;

     15) clear && nginx_remove ;;

     21) clear && install_php83 ;;
     22) clear && install_php74 ;;

     31) caddy_web_list ;;
     32) caddy_web_manager ;;
     33)
        # check_IP_address
        add_yuming
        read -p "请输入跳转域名: " reverseproxy

        caddy_redirect $yuming $reverseproxy
        
        # caddy_newcaddyfile
        caddy_reload
        
        echo -e "\n您的重定向网站做好了！"
        echo "https://$yuming"
        echo ""
        ;;

     34)
        add_yuming
        reverseproxy="127.0.0.1"
        read -p "请输入你的反代IP(默认:$reverseproxy): " reverseproxy
        # [[ -z "$reverseproxy" ]] || reverseproxy="127.0.0.1"
        if [[ -z "$reverseproxy" ]]; then 
          reverseproxy="127.0.0.1"
        fi

        read -p "请输入反代端口: " port 
        echo -e "\n请确认以下输入信息"
        echo -e "  域名为：$yuming"
        echo -e " IP+端口: $reverseproxy:$port"

        read -p "确认以上信息无误吗？(N|n) " choice 
        case "$choice" in
            [Nn])
              continue 
                ;;
            *)
                ;;
        esac

        caddy_reproxy $yuming $reverseproxy $port
        
        # caddy_newcaddyfile
        caddy_reload
        
        echo -e "\n您的反向代理网站做好了！"
        echo "https://$yuming"
        echo ""
        ;;

     35)
        add_yuming
        read -p "请输入web概目录: " rootpath 

        caddy_staticweb $yuming $rootpath

        # caddy_newcaddyfile
        caddy_reload
        
        echo -e "\n您的静态网站搭建好了！"
        echo "https://$yuming"
        echo ""
        ;;

     41) caddy_reload ;;
     42) caddy_start ;;
     43) caddy_stop ;;
     44) caddy_uninstall ;;
     45) check_IP_address ;;

     61) clear && install_redis ;;
     62) clear && mysql_install ;;
     63) clear && install_mariadb ;;
     64) clear && install_postgresql ;;

    #  61) clear && install redis-server ;;
    #  62) clear && install mysql-server ;;
    #  63) clear && install mariadb-server ;;

    #  77) clear &&  ;;
     88) clear && docker_deploy_run ;;

      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}

# 脚本更新
function script_update(){
  cd ~
  bash <(wget --no-check-certificate -qO- $URL_UPDATE)

  # echo -e "脚本链接:\n" " >>> ${cyan}https://gitlab.com/lmzxtek/qiqtools/-/raw/main/qiqtools.sh${plain}"
  curl -sS -O $URL_SCRIPT && \
  chmod +x qiqtools.sh && \
  echo -e "\n脚本已更新至最新版本！\n按任意键重新加载脚本...\n"
  break_end #&& exit && qiq
  qiq_reload
}


# show_header_qiq(){
# echo -e "
#  ${GREEN}  ░███     ${CYAN}░████  ${GREEN}  ░███   ${PLAIN}
#  ${GREEN} ░██ ░██   ${CYAN} ░██   ${GREEN} ░██ ░██ ${PLAIN}
#  ${GREEN}░██   ░██  ${CYAN} ░██   ${GREEN}░██   ░██${PLAIN}
#  ${GREEN} ░██ ░██   ${CYAN} ░██   ${GREEN} ░██ ░██ ${PLAIN}
#  ${GREEN}   ░██ ██  ${CYAN}░████  ${GREEN}   ░██ ██${PLAIN}

# ${BLUE}─┬─╭─╮╭─╮┬ ╭─╮${PLAIN}  
# ${BLUE} │ │ ││ ││ ╰─╮${PLAIN}  
# ${BLUE} │ ╰─╯╰─╯╰─╰─╯${PLAIN}   ${CYAN}♧♧${PLAIN} QiQTools ${BLUE}$SRC_VER${PLAIN}"

# }

show_header_qiq(){
echo -e "
  ${CYAN}♧♧♧${PLAIN}  QiQ Tools ${BLUE}$SRC_VER${PLAIN}  ${CYAN}♧♧♧${PLAIN}"
}

# 显示主菜单
function main_menu() {
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txty " 1.系统信息")$(txty " ")"       "$(txtn "11.容器管理")$(txtp " ")
txtn $(txtn " 2.系统更新")$(txtb " ")"       "$(txty "12.容器部署")$(txtc " ")
txtn $(txtn " 3.系统清理")$(txtb " ")"       "$(txtr "13.站点管理")$(txtb " ★")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "21.系统工具")$(txtp " ")"       "$(txtn "31.性能测试")$(txtb " ")
txtn $(txtn "22.管理工具")$(txtn " ")"       "$(txtp "32.节点搭建")$(txty " ✈")
txtn $(txty "23.常用工具")$(txtb " ☆")"      "$(txtc "33.节点面板")$(txty " ")
txtn $(txtn "24.IP检测优选")$(txtb " ")"     "$(txty "34.测出站IP")$(txtb " ☭")
txtn "====================================="
txtn $(txtb "00.脚本更新")$(txtb " ☋")"      "$(txty "99")$(txtc ".重启系统 ☢")
txtn "—————————————————————————————————————"
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
# txtn $(txtn " 0.退出脚本")$(txtr "✖")"       "$(txtb "♧♧ ")$(txtc "QiQTools") $(txtb "$script_version")
txtn $(txtn " 0.退出脚本")$(txtr " ✖")"      "$(txtp "✟✟ ")$(txtc "快捷命令")$(txtb ">") $(txty "qiq") $(txtb "<")
txtn " "
}


# Main Loops for the scripts
main_loop(){
while true; do
  clear && cd ~ && show_header_qiq && main_menu 
  reading "请输入你的选择: " choice

  case $choice in
     1) clear && show_system_info ;;
     2) clear && sys_update_and_upgrade ;;
     3) clear && clean_sys ;;

    11) clear && docker_manage_run ;;
    12) clear && docker_deploy_run ;;
    13) clear && WebSites_manager_run ;;

    21) clear && system_tools_run ;;
    22) clear && common_apps_run  ;;
    23) clear && other_tools_run  ;;
    24) clear && IP_check_select_run  ;;

    31) clear && server_test_run  ;;
    32) clear && warp_tools_run   ;;
    33) clear && board_panels_run  ;;
    34) recheck_ip_address  ;;
    # 34) check_IP_address  ;;

    00) script_update ;;
    99) echo "正在重启服务器，即将断开SSH连接" && reboot  ;;
     0) exit ;;
     *) echo "无效的输入!" ;;
  esac  
  break_end
done
}

check_IP_address
# get_IPV4_IPV6

clear
get_sysinfo 1
main_loop