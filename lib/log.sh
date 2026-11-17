#stdout is screen, so SIR debug output goes to file instead
#isnt intellisense great?  I can see the future!
BD_LOG=${BD_LOG:-}

log() {
    [[ -n $BD_LOG ]] || return 0
    printf '%(%T)T %s\n' -1 "$*" >> "$BD_LOG"
}

