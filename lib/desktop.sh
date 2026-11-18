#shellcheck disable=SC2034 #globals r shared with other files
#PLACEHOLDER DESKTOP
TAGLINE="desktop enviroment in pure unfiltered unadulterated unalloyed undiluted unmingled unmixed unpolluted spotless immaculate sterile uncontaminated virtuous untainted uncorrupted unblemished unspotted unsullied undefiled uninfected bash"
STATUS="BOMBOCLAT! move ur mouse, click, or press"

on_key() {
    log "key=$IN_KEY act=$IN_ACT btn=$IN_BTN at $IN_X,$IN_Y"
    case $IN_KEY in
        q) QUIT=1; return ;;
        mouse) STATUS="mouse $IN_ACT $IN_BTN at $IN_X,$IN_Y" ;;
        *) STATUS="key $IN_KEY" ;;
    esac
    DIRTY=1
}

on_tick() { :; }

draw() {
    local mid=$(( ROWS / 2 ))
    clear_screen
    center $(( mid - 1 )) "BASHED DESKTOP" "1;36"
    center "$mid" "$TAGLINE"
    center $(( mid + 2 )) "$STATUS" 
    put "$ROWS" 1 "bashed_desktop $BD_VERSION  ${COLS}x${ROWS}  q to quit" 2
    flush
}