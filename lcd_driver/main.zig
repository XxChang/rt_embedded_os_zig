const uart = @import("uart.zig");
const lcd = @import("vid.zig");

export fn main() callconv(.C) i32 {
    lcd.fbuf_init();
    return 0;
}
