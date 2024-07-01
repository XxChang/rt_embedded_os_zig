.text
.code 32
.global reset_handler, vectors_start, vectors_end

reset_handler:
    ldr sp, =svc_stack_top   // 设置SVC模式的栈 
    bl copy_vectors          // 拷贝向量表到地址0
    mrs r0, cpsr
    bic r1, r0, #0x1f
    orr r1, r1, #0x12
    msr cpsr, r1             // 设置SVC模式
    ldr sp, =irq_stack_top   // set IRQ mode stack
    bic r0, r0, #0x80
    msr cpsr, r0         // go back to SVC mode with IRQ enabled
    ; mrc p15, 0, r0, c1, c0, 0
    ; bic r0, r0, #0x20000000
    ; mcr p15, 0, r0, c1, c0, 0
    bl main
    b .
lock:
    mrs r0, cpsr
    orr r0, r0, #0x80
    msr cpsr, r0
    mov pc, lr
unlock:
    mrs r0, cpsr
    bic r0, r0, #0x80
    msr cpsr, r0
    mov pc, lr

irq_handler:
    sub lr, lr, #4
    stmfd sp!, {r0-r12, lr}
    bl IRQ_handler
    ldmfd sp!, {r0-r12, pc}^

undef_handler:
    sub lr, lr, #4
    stmfd sp!, {r0-r12, lr}
    bl UND_handler
    ldmfd sp!, {r0-r12, pc}^

swi_handler:
    sub lr, lr, #4
    stmfd sp!, {r0-r12, lr}
    bl SWI_handler
    ldmfd sp!, {r0-r12, pc}^

prefetch_abort_handler:
    sub lr, lr, #4
    stmfd sp!, {r0-r12, lr}
    bl PREFETCH_ABORT_handler
    ldmfd sp!, {r0-r12, pc}^

data_abort_handler:
    sub lr, lr, #8
    stmfd sp!, {r0-r12, lr}
    bl DATA_ABORT_handler
    ldmfd sp!, {r0-r12, pc}^

fiq_handler:
    sub lr, lr, #4
    stmfd sp!, {r0-r12, lr}
    bl FIQ_handler
    ldmfd sp!, {r0-r12, pc}^

vectors_start:
    ldr pc, reset_handler_addr
    ldr pc, undef_handler_addr 
    ldr pc, swi_handler_addr
    ldr pc, prefetch_abort_handler_addr
    ldr pc, data_abort_handler_addr
    b .
    ldr pc, irq_handler_addr 
    ldr pc, fiq_handler_addr
    reset_handler_addr:             .word reset_handler
    undef_handler_addr:             .word undef_handler
    swi_handler_addr:               .word swi_handler
    prefetch_abort_handler_addr:    .word prefetch_abort_handler
    data_abort_handler_addr:        .word data_abort_handler
    irq_handler_addr:               .word irq_handler
    fiq_handler_addr:               .word fiq_handler
vectors_end:
    