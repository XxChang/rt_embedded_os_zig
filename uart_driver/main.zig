const uart = @import("uart.zig");

const v = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

export fn main() callconv(.C) i32 {
    var string = [_]u8{0} ** 30;
    string[0] = 'h';
    uart.uart1.prints("Enter lines from serial terminal 0\n\r");
    while (true) {
        uart.uart1.gets(&string);
        uart.uart1.prints("   ");
        uart.uart1.prints(string[0..]);
        uart.uart1.prints("\n\r");
        const end = "end";

        if (arrayEquals(string[0..3], end[0..3])) {
            break;
        }
    }

    uart.uart1.prints("Compute sum of array: \r\n");

    var sum: i32 = 0;
    for (v) |i| {
        sum += i;
    }
    uart.uart1.prints("sum = ");
    uart.uart1.putc(@intCast(u8, @divTrunc(sum, 10) + '0'));
    uart.uart1.putc(@intCast(u8, @mod(sum, 10) + '0'));
    uart.uart1.prints("\r\nEND OF RUN\n\r");

    return 0;
}

fn arrayEquals(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    var i: usize = 0;
    while (i < a.len) : (i += 1) {
        if (a[i] != b[i]) return false;
    }
    return true;
}
