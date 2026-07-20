# 1. Îi dăm voie utilizatorului să scrie în fișierul de sleep fără parolă
echo "ssuvj ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/power/state" | sudo tee /etc/sudoers.d/allow-suspend-ssuvj > /dev/null

# 2. Rescriem scriptul computer.sh simplificat
cat << 'EOF' > computer.sh
#!/bin/bash

DRIVER=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver 2>/dev/null)

clear
echo "============================================="
echo "   Configurare Profil Energie - Debian 13"
echo "============================================="
echo "Driver procesor: $DRIVER"
echo "---------------------------------------------"
echo "Alegeți o opțiune:"
echo "1) Economie maximă (Îngheață la MINIM)"
echo "2) Implicit / Adaptiv (Din fabrică)"
echo "3) Pune laptopul în mod Sleep (Suspend)"
echo "4) Ieșire"
echo "---------------------------------------------"
read -p "Introduceți numărul opțiunii [1-4]: " optiune

case $optiune in
  1)
    echo "Se aplică: ECONOMIE MAXIMĂ..."
    echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    if [ -f /sys/devices/system/cpu/intel_pstate/max_perf_pct ]; then
        echo "8" | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct > /dev/null
        echo "8" | sudo tee /sys/devices/system/cpu/intel_pstate/min_perf_pct > /dev/null
        echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null
    fi
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference ]; then
        echo "power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference > /dev/null
    fi
    echo "Modul economie a fost aplicat."
    ;;
    
  2)
    echo "Se aplică: PROFIL IMPLICIT (FABRICĂ)..."
    echo "powersave" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
    if [ -f /sys/devices/system/cpu/intel_pstate/max_perf_pct ]; then
        echo "100" | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct > /dev/null
        echo "8" | sudo tee /sys/devices/system/cpu/intel_pstate/min_perf_pct > /dev/null
        echo "0" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null
    fi
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference ]; then
        echo "balance_performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference > /dev/null
    fi
    echo "Sistemul a revenit la setările inteligente din fabrică."
    ;;
    
  3)
    echo "Se inițiază modul Sleep direct prin Kernel..."
    echo "mem" | sudo tee /sys/power/state > /dev/null
    ;;
    
  4)
    exit 0
    ;;
  *)
    echo "Opțiune invalidă!"
    exit 1
    ;;
esac

echo "---------------------------------------------"
echo "Frecvența actuală a nucleelor:"
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq | awk '{print $1/1000000 " GHz"}'
echo "============================================="
EOF
chmod +x computer.sh
