const lcd = @import("vid.zig");
const uart = @import("uart.zig");
const std = @import("std");

export fn main() callconv(.C) i32 {
    var line = [_]u8{0} ** 64;
    lcd.fbuf_init();
    while (true) {
        lcd.color = lcd.Color.GREEN;
        lcd.kprintf("enter a line from UART port: ");
        uart.uart1.prints("enter line from UART : ");
        uart.uart1.gets(&line);
        uart.uart1.prints(" line=");
        uart.uart1.prints(&line);
        uart.uart1.prints("\n");
        lcd.color = lcd.Color.RED;
        lcd.kprintf("line=");
        lcd.kprintf(&line);
        lcd.kprintf("\n");
    }
    return 0;
}
