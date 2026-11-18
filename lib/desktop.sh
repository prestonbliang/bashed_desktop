# shellcheck disable=SC2034  # globals are shared with the other files#PLACEHOLDER DESKTOP
TAGLINE="desktop environment in pure unfiltered unadulterated unalloyed undiluted unmingled unmixed unpolluted spotless immaculate sterile uncontaminated virtuous untainted uncorrupted unblemished unspotted unsullied undefiled uninfected bash"
STATUS="BOMBOCLAT! move ur mouse, click, or press"
CLOCK=""

content_welcome() {
    put "$1" "$2" "Drag a title bar to move a window." "1"
    put $(( $1 + 1 )) "$2" "Click one to bring it forward." "1"
    put $(( $1 + 2 )) "$2" "[x] closes. tab cycles. q quits." "1" 
    wrap $(( $1 + 4 )) "$2" "$4" "$TAGLINE" 2
}

content_events() {
    put "$1" "$2" "last input:"
    put $(( $1 + 1 )) "$2" "$STATUS" 36
}

content_clock() {
    put "$1" "$2" "$CLOCK" 1
}

desktop_start(){
    win_new "Welcome" 3 2 46 14 content_welcome
    win_new "Events" 30 9 46 6 content_events
    win_new "Clock" 6 17 22 5 content_clock
    wm_clamp_all
}

on_key() {
    log "key=$IN_KEY act=$IN_ACT btn=$IN_BTN at $IN_X,$IN_Y"
    case $IN_KEY in
        q) QUIT=1; return ;;
        tab) win_cycle; STATUS="key tab" ;;
        mouse) STATUS="mouse $IN_ACT $IN_BTN at $IN_X,$IN_Y"; wm_mouse ;;
        *) STATUS="key $IN_KEY" ;;

    esac
    DIRTY=1
}

on_resize() {
    wm_clamp_all;
}

on_tick() {
    local now
    printf -v now '%(%H:%M:%S)T' -1
    [[ $now == "$CLOCK" ]] && return
    CLOCK=$now
    DIRTY=1
}

draw() {
    clear_screen
    win_draw_all
    fill "$ROWS" 1 1 "$COLS" " " 7
    put "$ROWS" 2 "bashed_desktop $BD_VERSION    ${COLS}x${ROWS}    drag titles    tab cycles    q quits" 7
    flush
}