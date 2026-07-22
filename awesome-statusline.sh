#!/bin/bash
# ============================================================================
# Awesome Statusline - FULL Mode (Custom: terminal colors, 2-stage gradient)
# ============================================================================
# Line 1: 🤖 Model | 🎨 Style | ✅ Git (↑ahead ↓behind) | 🐍 Env
# Line 2: 📂 full path 🌿(branch) | 💰 cost | ⏰ duration
# Line 3: 🧠 Context bar 40 blocks - Green→Red (2-stage)
# Line 4: 🚀 5H Limit bar 40 blocks - Green→Red (2-stage)
# Line 5: 🌟 7D Limit bar 40 blocks - Green→Red (2-stage)
# ============================================================================

input=$(cat)

# Parse JSON input
MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // "."')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
CURRENT_USAGE=$(echo "$input" | jq -r '.context_window.current_usage // null')
OUTPUT_STYLE=$(echo "$input" | jq -r '.output_style.name // ""')
TOTAL_COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
TOTAL_DURATION=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

FIVE_HOUR_PCT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
FIVE_HOUR_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
SEVEN_DAY_PCT=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
SEVEN_DAY_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# ============================================================================
# Terminal Colors (no Catppuccin — uses basic ANSI)
# ============================================================================
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
C_CYAN="\033[96m"
C_GREEN="\033[92m"
C_YELLOW="\033[93m"
C_RED="\033[91m"
C_BLUE="\033[94m"
C_MAGENTA="\033[95m"
C_WHITE="\033[97m"
C_GRAY="\033[90m"

# ============================================================================
# 2-stage gradient: Green → Red
# ============================================================================
get_gradient_color() {
    local pct=$1
    local r g b

    if [[ $pct -le 50 ]]; then
        # Green (#00c800) → Yellow (#c8c800)
        local t=$((pct * 100 / 50))
        r=$((0 + 200 * t / 100))
        g=200
        b=0
    else
        # Yellow (#c8c800) → Red (#c80000)
        local t=$(((pct - 50) * 100 / 50))
        r=200
        g=$((200 - 200 * t / 100))
        b=0
    fi
    echo "$r;$g;$b"
}

generate_bar() {
    local pct=$1
    local width=$2
    local bar=""
    local filled=$(( (pct * width + 50) / 100 ))
    [[ $filled -gt $width ]] && filled=$width

    local end_color
    end_color=$(get_gradient_color "$pct")

    for ((i=0; i<filled; i++)); do
        local block_pct=$((i * 100 / width))
        local color
        color=$(get_gradient_color "$block_pct")
        bar+="\033[38;2;${color}m█"
    done

    for ((i=0; i<width-filled; i++)); do
        bar+="\033[38;2;${end_color}m░"
    done

    echo -e "$bar$RESET"
}

# ============================================================================
# Line 1: Model | Style | Git Status (↑ahead ↓behind) | Env
# ============================================================================

MODEL_DISPLAY="[ai] ${BOLD}${C_CYAN}${MODEL}${RESET}"

STYLE_DISPLAY=""
[[ -n "$OUTPUT_STYLE" ]] && STYLE_DISPLAY="[~] ${C_YELLOW}${OUTPUT_STYLE}${RESET}"

GIT_STATUS_DISPLAY=""
cd "$CURRENT_DIR" 2>/dev/null
if git rev-parse --git-dir > /dev/null 2>&1; then
    STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
    UNSTAGED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
    UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

    AHEAD_BEHIND=""
    if git rev-parse --abbrev-ref '@{upstream}' &>/dev/null; then
        COUNTS=$(git rev-list --left-right --count HEAD...'@{upstream}' 2>/dev/null)
        if [[ -n "$COUNTS" ]]; then
            AHEAD=$(echo "$COUNTS" | awk '{print $1}')
            BEHIND=$(echo "$COUNTS" | awk '{print $2}')
            [[ "$AHEAD" -gt 0 ]] && AHEAD_BEHIND="${AHEAD_BEHIND}${C_CYAN}↑${AHEAD}${RESET}"
            [[ "$BEHIND" -gt 0 ]] && AHEAD_BEHIND="${AHEAD_BEHIND}${C_MAGENTA}↓${BEHIND}${RESET}"
        fi
    fi

    if [[ "$STAGED" -eq 0 && "$UNSTAGED" -eq 0 && "$UNTRACKED" -eq 0 ]]; then
        GIT_STATUS_DISPLAY="${C_GREEN}[ok] git clean${RESET}"
        [[ -n "$AHEAD_BEHIND" ]] && GIT_STATUS_DISPLAY="${GIT_STATUS_DISPLAY} ${AHEAD_BEHIND}"
    else
        STATUS=""
        [[ "$STAGED" -gt 0 ]] && STATUS="${STATUS}+${STAGED}"
        [[ "$UNSTAGED" -gt 0 ]] && STATUS="${STATUS}!${UNSTAGED}"
        [[ "$UNTRACKED" -gt 0 ]] && STATUS="${STATUS}?${UNTRACKED}"
        GIT_STATUS_DISPLAY="${C_YELLOW}[!] dirty ${STATUS}${RESET}"
        [[ -n "$AHEAD_BEHIND" ]] && GIT_STATUS_DISPLAY="${GIT_STATUS_DISPLAY} ${AHEAD_BEHIND}"
    fi
else
    GIT_STATUS_DISPLAY="${C_GRAY}no git${RESET}"
fi

ENV_DISPLAY=""
if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    ENV_DISPLAY="[env] ${C_MAGENTA}${CONDA_DEFAULT_ENV}${RESET}"
elif [[ -n "$VIRTUAL_ENV" ]]; then
    ENV_DISPLAY="[env] ${C_MAGENTA}$(basename "$VIRTUAL_ENV")${RESET}"
else
    ENV_DISPLAY="${C_GRAY}no env${RESET}"
fi

LINE1="${MODEL_DISPLAY}"
[[ -n "$STYLE_DISPLAY" ]] && LINE1="${LINE1} | ${STYLE_DISPLAY}"
LINE1="${LINE1} | ${GIT_STATUS_DISPLAY} | ${ENV_DISPLAY}"

# ============================================================================
# Line 2: Directory + Branch | Cost | Duration
# ============================================================================

DIR_DISPLAY="[dir] ${C_WHITE}${CURRENT_DIR}${RESET}"

BRANCH_DISPLAY=""
cd "$CURRENT_DIR" 2>/dev/null
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    [[ -n "$BRANCH" ]] && BRANCH_DISPLAY=" ${C_GREEN}@(${BRANCH})${RESET}"
fi

COST_DISPLAY=""
if [[ "$TOTAL_COST" != "0" && -n "$TOTAL_COST" ]]; then
    COST_FMT=$(printf "%.2f" "$TOTAL_COST")
    COST_DISPLAY="[\$] ${C_WHITE}${COST_FMT}\$${RESET}"
else
    COST_DISPLAY="[\$] ${C_GRAY}0.00\$${RESET}"
fi

DURATION_DISPLAY=""
if [[ "$TOTAL_DURATION" != "0" && -n "$TOTAL_DURATION" ]]; then
    DURATION_SEC=$((TOTAL_DURATION / 1000))
    if [[ $DURATION_SEC -ge 3600 ]]; then
        DURATION_FMT="$((DURATION_SEC / 3600))h$((DURATION_SEC % 3600 / 60))m"
    else
        DURATION_FMT="$((DURATION_SEC / 60))m"
    fi
    DURATION_DISPLAY="[t] ${C_WHITE}${DURATION_FMT}${RESET}"
else
    DURATION_DISPLAY="[t] ${C_GRAY}0m${RESET}"
fi

LINE2="${DIR_DISPLAY}${BRANCH_DISPLAY} | ${COST_DISPLAY} | ${DURATION_DISPLAY}"

# ============================================================================
# Line 3: Context bar (40 blocks)
# ============================================================================

CONTEXT_PERCENT=0
CURRENT_TOKENS=0
if [[ "$CURRENT_USAGE" != "null" && -n "$CURRENT_USAGE" ]]; then
    INPUT_TOKENS=$(echo "$CURRENT_USAGE" | jq -r '.input_tokens // 0')
    CACHE_CREATE=$(echo "$CURRENT_USAGE" | jq -r '.cache_creation_input_tokens // 0')
    CACHE_READ=$(echo "$CURRENT_USAGE" | jq -r '.cache_read_input_tokens // 0')
    CURRENT_TOKENS=$((INPUT_TOKENS + CACHE_CREATE + CACHE_READ))
    [[ "$CONTEXT_SIZE" -gt 0 ]] && CONTEXT_PERCENT=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))
fi

TOKENS_K=$((CURRENT_TOKENS / 1000))
CONTEXT_K=$((CONTEXT_SIZE / 1000))

CTX_BAR=$(generate_bar "$CONTEXT_PERCENT" 40)
CTX_END_COLOR=$(get_gradient_color "$CONTEXT_PERCENT")
LINE3="[ctx] ${C_CYAN}Context${RESET}  ${CTX_BAR} ${BOLD}\033[38;2;${CTX_END_COLOR}m${CONTEXT_PERCENT}% used${RESET} (${TOKENS_K}k/${CONTEXT_K}k)"

# ============================================================================
# Lines 4-5: Usage 5H and 7D
# ============================================================================

format_time_remaining() {
    local reset_epoch="$1"
    [[ -z "$reset_epoch" || "$reset_epoch" == "null" ]] && return
    local now_epoch=$(date +%s)
    local remaining=$((reset_epoch - now_epoch))
    [[ $remaining -lt 0 ]] && remaining=0
    local hours=$((remaining / 3600))
    local minutes=$(((remaining % 3600) / 60))
    echo "in ${hours}h${minutes}m"
}

_date_fmt() {
    local epoch="$1" fmt="$2"
    if date -j -f "%s" "$epoch" "+$fmt" 2>/dev/null; then return; fi
    date -d "@$epoch" "+$fmt" 2>/dev/null
}

format_reset_datetime() {
    local reset_epoch="$1"
    [[ -z "$reset_epoch" || "$reset_epoch" == "null" ]] && return
    local hour=$(_date_fmt "$reset_epoch" "%H")
    local hour_12=$((hour % 12))
    [[ $hour_12 -eq 0 ]] && hour_12=12
    local ampm="am"
    [[ $hour -ge 12 ]] && ampm="pm"
    local month_day=$(_date_fmt "$reset_epoch" "%b %d")
    echo "${month_day} at ${hour_12}${ampm}"
}

if [[ -n "$FIVE_HOUR_PCT" ]]; then
    FIVE_HOUR=$(printf "%.0f" "$FIVE_HOUR_PCT")
    SEVEN_DAY=$(printf "%.0f" "${SEVEN_DAY_PCT:-0}")

    FIVE_RESET_FMT=$(format_time_remaining "$FIVE_HOUR_RESET")
    SEVEN_RESET_FMT=$(format_reset_datetime "$SEVEN_DAY_RESET")

    FIVE_BAR=$(generate_bar "$FIVE_HOUR" 40)
    SEVEN_BAR=$(generate_bar "$SEVEN_DAY" 40)

    FIVE_END_COLOR=$(get_gradient_color "$FIVE_HOUR")
    SEVEN_END_COLOR=$(get_gradient_color "$SEVEN_DAY")

    LINE4="[5h] ${C_BLUE}5H Limit${RESET} ${FIVE_BAR} ${BOLD}\033[38;2;${FIVE_END_COLOR}m${FIVE_HOUR}%${RESET} (Resets ${FIVE_RESET_FMT})"
    LINE5="[7d] ${C_YELLOW}7D Limit${RESET} ${SEVEN_BAR} ${BOLD}\033[38;2;${SEVEN_END_COLOR}m${SEVEN_DAY}%${RESET} (Resets ${SEVEN_RESET_FMT})"
else
    FIVE_BAR=$(generate_bar 0 40)
    SEVEN_BAR=$(generate_bar 0 40)
    FIVE_END_COLOR=$(get_gradient_color 0)
    SEVEN_END_COLOR=$(get_gradient_color 0)
    LINE4="[5h] ${C_BLUE}5H Limit${RESET} ${FIVE_BAR} ${BOLD}\033[38;2;${FIVE_END_COLOR}m0%${RESET} ${C_GRAY}(loading..)${RESET}"
    LINE5="[7d] ${C_YELLOW}7D Limit${RESET} ${SEVEN_BAR} ${BOLD}\033[38;2;${SEVEN_END_COLOR}m0%${RESET} ${C_GRAY}(loading..)${RESET}"
fi

# ============================================================================
# Output
# ============================================================================
echo -e "$LINE1"
echo -e "$LINE2"
echo -e "$LINE3"
echo -e "$LINE4"
echo -e "$LINE5"
