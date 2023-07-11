const lcd = @import("vid.zig");

export fn main() callconv(.C) i32 {
    lcd.fbuf_init();
    while (true) {}
    return 0;
}
