        .global reset_start
start:
        ldr sp, =stack_top
        bl main
        b .