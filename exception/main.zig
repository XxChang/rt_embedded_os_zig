const lcd = @import("vid.zig");
const init = @import("init.zig");
const exception = @import("exception.zig");
const define = @import("define.zig");
const uart = @import("uart.zig");
const timer = @import("timer.zig");

export fn IRQ_handler() void {
    const vicstatus = define.VIC_STATUS.*;
    if ((vicstatus & 0x0010) != 0) {
        if (timer.timer1.tvalue() == 0) {
            timer.timer1.handler();
        }

        if (timer.timer2.tvalue() == 0) {
            timer.timer2.handler();
        }
    }

    if ((vicstatus & 0x0020) != 0) {
        if (timer.timer3.tvalue() == 0) {
            timer.timer3.handler();
        }

        if (timer.timer4.tvalue() == 0) {
            timer.timer4.handler();
        }
    }
}

export fn main() void {
    _ = init;
    _ = exception;

    lcd.color = lcd.Color.YELLOW;
    lcd.fbuf_init();
    lcd.kprintf("main starts\n");
    define.VIC_INTENABLE.* = 0;
    const flag: u32 = 1;
    define.VIC_INTENABLE.* |= (flag << 4);
    define.VIC_INTENABLE.* |= (flag << 5);
    timer.timer1.init();
    timer.timer2.init();
    timer.timer3.init();
    timer.timer4.init();

    timer.timer1.start();
    timer.timer2.start();
    timer.timer3.start();
    timer.timer4.start();

    lcd.kprintf("Enter while(1) loop, handle timer interrupts\n");
}
