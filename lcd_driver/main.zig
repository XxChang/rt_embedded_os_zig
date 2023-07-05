const uart = @import("uart.zig");
const lcd = @import("vid.zig");
const std = @import("std");

extern const _binary_image_bmp_start: u8;
const WIDTH: usize = 640;

fn show_bmp(p: *u8, start_row: usize, start_col: usize) void {
    var pp: [*]u8 = undefined;

    var p_i: usize = @ptrToInt(p);

    // 指针类型转换需要对齐，指针地址未对齐的话会导致不合法行为
    var q: [*]u8 = @intToPtr([*]u8, p_i + 14);
    q = q + 4;
    const w: i32 = @as(i32, q[0]) | (@as(i32, q[1]) << 8) | (@as(i32, q[2]) << 16) | (@as(i32, q[3]) << 24);
    const h: i32 = @as(i32, q[4]) | (@as(i32, q[5]) << 8) | (@as(i32, q[6]) << 16) | (@as(i32, q[7]) << 24);
    p_i += 54;
    const rsize: i32 = @divTrunc((3 * w + 3), 4) * 4;
    p_i += @intCast(usize, (h - 1) * rsize);

    for (start_row..(start_row + @intCast(usize, h))) |i| {
        pp = @intToPtr([*]u8, p_i);

        for (start_col..(start_col + @intCast(usize, w))) |j| {
            const b = pp[0];
            const g = pp[1];
            const r = pp[2];
            const pixel = (@as(i32, b) << 16) | (@as(i32, g) << 8) | @as(i32, r);
            @ptrCast([*]volatile i32, lcd.fb)[i * WIDTH + j] = pixel;
            pp += 3;
        }
        p_i -= @intCast(usize, rsize);
    }
    var content: [125]u8 = undefined;
    const message = std.fmt.bufPrint(&content, "\nBMP image height={} width={}\n", .{
        h,
        w,
    }) catch unreachable;

    uart.uart1.prints(message);
}

export fn main() callconv(.C) i32 {
    lcd.fbuf_init();
    while (true) {
        var p = &_binary_image_bmp_start;

        show_bmp(p, 0, 0);
        uart.uart1.prints("enter a key from this UART : ");
        _ = uart.uart1.getc();
    }
    return 0;
}
