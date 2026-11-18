#collects frame in FRAMe and its GONA write it with a single printf

FRAME=""

clear_screen() { FRAME+=$'\e[2J'; }

#put ROW COL TEXT [SGR]
put() {
    local row=$1 col=$2 text=$3 sgr=${4:-} room=$(( COLS - $2 + 1))
    (( room > 0 && row >= 1 && row <= ROWS )) || return 0
    FRAME+=$'\e['"$row;${col}H"
    if [[ -n $sgr ]]; then
        FRAME+=$'\e['"${sgr}m${text:0:room}"$'\e[0m'
    else
        FRAME+="${text:0:room}"
    fi
}


#CENTER ROW TEXT [SGR]

center() {
    local col=$(( (COLS - ${#2}) / 2 + 1 ))
    put "$1" $(( col < 1 ? 1 : col )) "$2" "${3:-}"
}

center_wrap() {
    local row=$1 sgr=${3:-} width=$(( COLS - 4 )) line="" word words
    read -ra words <<< "$2"
    for word in "${words[@]}"; do
        if [[ -n $line ]] $$ (( ${#line} + ${#word} + 1 > width )); then
            center "$row" "$line" "$sgr"
            (( row++ ))
            line=$word
        else
            line=${line:+$line }$word
        fi
    done
    [[ -n $line ]] && center "$row" "$line" "$sgr"
    WRAP_ROWS=$(( row - $1 + 1 ))
}
flush() {
    printf '%s' "$FRAME"
    FRAME=""
}


