const lcd = @import("vid.zig");
const init = @import("init.zig");
const exception = @import("exception.zig");
const define = @import("define.zig");
const uart = @import("uart.zig");
const timer = @import("timer.zig");
const kbd = @import("kbd.zig");

export fn IRQ_handler() void {
    const vicstatus = define.VIC_STATUS.*;
    const sicstatus = define.SIC_STATUS.*;

    if ((vicstatus & (1 << 4)) != 0) {
        timer.timer1.handler();
    }

    if ((vicstatus & (1 << 31)) != 0) {
        if ((sicstatus & (1 << 3)) != 0) {
            kbd.kbd.kbd_handler();
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
    define.VIC_INTENABLE.* |= (flag << 31);

    define.SIC_INTENABLE.* = 0;
    define.SIC_INTENABLE.* |= (flag << 3);

    timer.timer1.init();
    timer.timer1.start();

    lcd.kprintf("Enter while(1) loop, handle timer interrupts\n");
    kbd.kbd.init();
}
