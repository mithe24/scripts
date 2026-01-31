#!/bin/sh
# Battery status display script for systems with /sys/class/power_supply

SYS_BASE="/sys/class/power_supply"

# Read battery energy values
# Returns: "energy_now energy_full" or exits with error
read_battery() {
    bat="$1"
    base="$SYS_BASE/$bat"
    
    [ -r "$base/energy_now" ] || return 1
    [ -r "$base/energy_full" ] || return 1
    
    energy_now=$(cat "$base/energy_now" 2>/dev/null) || return 1
    energy_full=$(cat "$base/energy_full" 2>/dev/null) || return 1
    
    # Validate numeric values
    case "$energy_now" in
        ''|*[!0-9]*) return 1 ;;
    esac
    case "$energy_full" in
        ''|*[!0-9]*) return 1 ;;
    esac
    
    echo "$energy_now $energy_full"
}

# Determine battery state symbol based on status of all batteries
battery_state_symbol() {
    charging=0
    discharging=0
    full=0
    not_charging=0
    bat_found=0
    
    for bat in BAT0 BAT1; do
        status_path="$SYS_BASE/$bat/status"
        [ -r "$status_path" ] || continue
        
        bat_found=1
        status=$(cat "$status_path" 2>/dev/null | tr -d '\n')
        case "$status" in
            Charging)
                charging=1
                ;;
            Discharging)
                discharging=1
                ;;
            Full)
                full=1
                ;;
            "Not charging")
                not_charging=1
                ;;
        esac
    done
    
    # No batteries found
    [ "$bat_found" -eq 0 ] && echo " " && return 1
    
    # Priority: charging > discharging > not_charging
    # If any battery is charging, show charging
    [ "$charging" -eq 1 ] && echo "⁺" && return 0
    # If any battery is discharging, show discharging
    [ "$discharging" -eq 1 ] && echo "⁻" && return 0
    # If any battery is not charging (plugged but not charging)
    [ "$not_charging" -eq 1 ] && echo "˜" && return 0
    
    # Unknown status
    echo " "
    return 1
}

battery_bar() {
    percent="$1"
    
    [ "$percent" -lt 0 ] && percent=0
    [ "$percent" -gt 100 ] && percent=100
    
    filled=$((percent / 10))
    empty=$((10 - filled))
    
    bar=""
    i=0
    while [ "$i" -lt "$filled" ]; do
        bar="${bar}█"
        i=$((i + 1))
    done
    
    i=0
    while [ "$i" -lt "$empty" ]; do
        bar="${bar}░"
        i=$((i + 1))
    done
    
    echo "$bar"
}

battery_summary() {
    total_now=0
    total_full=0
    bat_count=0
    
    for bat in BAT0 BAT1; do
        vals=$(read_battery "$bat") || continue
        set -- $vals
        total_now=$((total_now + $1))
        total_full=$((total_full + $2))
        bat_count=$((bat_count + 1))
    done
    
    if [ "$bat_count" -eq 0 ] || [ "$total_full" -eq 0 ]; then
        echo "No battery"
        return 1
    fi
    
    percent=$(( (total_now * 100 + total_full / 2) / total_full ))
    
    bar=$(battery_bar "$percent")
    symbol=$(battery_state_symbol)
    
    echo "▕${bar}▏${percent}${symbol}"
}

battery_summary
