# shellcheck disable=SC2034 # globals are shared with the other files

# This is the windows manager, windows live in parallel arrays indexed by id
#ORDER lists ids that still open
# body ROW COL HEIGHT WIDTH

W_X=() W_Y=() W_H=() W_W=() W_TITLE=() W_BODY=()
ORDER=()
HIT=-1
DRAG=-1
DRAG_DX=0

#win_new TITLE X Y WIDTH HEIGHT BODY_FUNCTION
win_new() {
    local id=${#W_X[@]} 
    W_TITLE[id]=$1 W_X[id]=$2 W_Y[id]=$3 W_W[id]=$4 W_H[id]=$5 W_BODY[id]=$6
    ORDER+=("$id")
}

win_close() {
    local o rest=()
    for o in "${ORDER[@]}"; do
        [[ $o == "$1" ]] || rest+=("$o")
    done
    ORDER=("${rest[@]}")
}

win_raise() {
    win_close "$1"
    ORDER+=("$1")
}

#bring window at back to front
win_cycle() {
    (( ${#ORDER[@]} > 1 )) && win_raise "${ORDER[0]}"
    return 0
}

#win_at X Y :sets HIT to the top window under that point
win_at() {
    local i id
    HIT=-1
    for (( i = ${#ORDER[@]} - 1; i >= 0; i-- )); do
        id=${ORDER[i]}
        if (( $1 >= W_X[id] && $1 < W_X[id] + W_W[id] && $2 >= W_Y[id] && $2 < W_Y[id] + W_H[id] )); then
            HIT=$id
            return 
        fi
    done
}

win_clamp() {
    local id=$1 x=${W_X[$1]} y=${W_Y[$1]}
    (( x > COLS - W_W[id] + 1 )) && x=$(( COLS - W_W[id] + 1 ))
    (( y > ROWS - W_H[id] )) && y=$(( ROWS - W_H[id] ))
    (( x < 1 )) && x=1
    (( y < 1 )) && y=1
    W_X[id]=$x W_Y[id]=$y
}

wm_clamp_all() {
    local id
    for id in "${ORDER[@]}"; do
        win_clamp "$id"
    done
}

#win_draw ID FOCUSED(0|1)

win_draw() {
    local id=$1 x=${W_X[$1]} y=${W_Y[$1]} w=${W_W[$1]} h=${W_H[$1]} 
    local border=2 title=2
    (( $2 )) && border=36 title="1;36"

    fill "$y" "$x" "$h" "$w"
    box "$y" "$x" "$h" "$w" "$border"
    put "$y" $(( x + 2 )) " ${W_TITLE[id]} " "$title"
    put "$y" $(( x + w - 4 )) "[x]" "$border"

    CLIP_ROW=$(( y + h - 2)) CLIP_COL=$(( x + w - 3 ))
    "${W_BODY[id]}" $(( y + 1 )) $(( x + 2 )) $(( h - 2 )) $(( w - 4 ))
    clip_reset
}

win_draw_all() {
    local i last=$(( ${#ORDER[@]} - 1 ))
    for (( i = 0; i <= last; i++ )); do
        win_draw "${ORDER[i]}" $(( i == last ))
    done
}

wm_mouse() {
    local id
    case $IN_ACT in
        press)
            [[ $IN_BTN == left ]] || return 0
            win_at "$IN_X" "$IN_Y"
            (( HIT >= 0 )) || return 0
            id=$HIT
            win_raise "$id"
            if (( IN_Y == W_Y[id] )); then
                if (( IN_X >= W_X[id] + W_W[id] - 4 && IN_X <= W_X[id] + W_W[id] - 2)); then
                    win_close "$id"
                else
                    DRAG=$id DRAG_DX=$(( IN_X - W_X[id] ))
                fi
            fi
            DIRTY=1
            ;;
        drag)
            (( DRAG >= 0 )) || return 0
            W_X[DRAG]=$(( IN_X - DRAG_DX ))
            W_Y[DRAG]=$IN_Y
            win_clamp "$DRAG"
            DIRTY=1
            ;;
        release)
            DRAG=-1
            ;;
    esac
}

