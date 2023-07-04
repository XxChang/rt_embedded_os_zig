const TXFE: u8 = 0x80;
const RXFF: u8 = 0x40;
const TXFF: u8 = 0x20;
const RXFE: u8 = 0x10;
const BUSY: u8 = 0x08;

const UDR = 0x00;
const UFR = 0x18;

const UART = struct {
    base: usize,

    pub fn getc(self: *const UART) u8 {
        while ((@intToPtr(*volatile u8, self.base + UFR).* & RXFE) != 0) {}
        return @intToPtr(*volatile u8, self.base + UDR).*;
    }

    pub fn putc(self: *const UART, c: u8) void {
        while ((@intToPtr(*volatile u8, self.base + UFR).* & TXFF) != 0) {}
        @intToPtr(*volatile u8, self.base + UDR).* = c;
    }

    pub fn gets(self: *const UART, s: [*]u8) void {
        var ptr = s;
        ptr[0] = self.getc();
        while (ptr[0] != '\r') : (ptr[0] = self.getc()) {
            self.putc(ptr[0]);
            ptr += 1;
        }
        ptr[0] = 0;
    }

    pub fn prints(self: *const UART, s: []const u8) void {
        for (s) |character| {
            self.putc(character);
        }
    }
};

pub const uart1: UART = .{
    .base = 0x101F1000,
};
