#shellcheck disable=SC2034 #globals r shared with other files

#draw only runs when someting set DIRTY=1

QUIT=0
DIRTY=1
TICK=0.05

main_loop() {
    local rc
    while (( ! QUIT )); do
        if (( RESIZED )); then
            RESIZED=0
            term_size
            DIRTY=1
        fi
        if (( DIRTY )); then
            DIRTY=0
            draw
        fi

        poll_input "$TICK"
        rc=$?
        (( rc == 0 )) && on key
        (( rc == 2 )) && on QUIT=1
        on_tick
    done
}