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
        const UART_UFR: *volatile u8 = @ptrFromInt(self.base + UFR);
        const UART_UDR: *volatile u8 = @ptrFromInt(self.base + UDR);
        while ((UART_UFR.* & RXFE) != 0) {}
        return UART_UDR.*;
    }

    pub fn putc(self: *const UART, c: u8) void {
        const UART_UFR: *volatile u8 = @ptrFromInt(self.base + UFR);
        const UART_UDR: *volatile u8 = @ptrFromInt(self.base + UDR);
        while ((UART_UFR.* & TXFF) != 0) {}
        UART_UDR.* = c;
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
