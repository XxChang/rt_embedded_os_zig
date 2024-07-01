const lcd = @import("vid.zig");

const KCNTL: usize = 0x0;
const KSTAT: usize = 0x4;
const KDATA: usize = 0x8;
const KCLK: usize = 0xC;
const KISTA: usize = 0x10;

extern fn lock() callconv(.Nake) void;
extern fn unlock() callconv(.Nake) void;

pub const Kbd = struct {
    base: [*]volatile u8,
    buf: [128]u8,
    head: usize,
    tail: usize,
    data: i32,
    room: i32,

    pub fn init(self: *Kbd) void {
        self.base[KCNTL] = 0x14;
        self.base[KCLK] = 8;
    }

    pub fn kbd_handler(self: *Kbd) void {
        var scode: u8 = undefined;
        var c: u8 = undefined;
        lcd.color = lcd.Color.RED;
        scode = self.base[KDATA];
        if (scode & 0x80 == 1) {
            return;
        }
        self.buf[self.head] = c;
        self.head += 1;
        self.head %= 128;
        self.data += 1;
        self.room -= 1;
    }

    pub fn kgetc(self: *Kbd) u8 {
        var c: u8 = undefined;
        unlock();
        while (self.data <= 0) {}
        lock();
        c = self.buf[self.tail];
        self.tail += 1;
        self.tail %= 128;
        self.data -= 1;
        self.room += 1;
        unlock();
        return c;
    }

    pub fn kegets(self: *Kbd, s: [*]u8) i32 {
        var c: u8 = undefined;
        var i: i32 = 0;
        while (true) {
            c = self.kgetc();
            if (c == '\r') {
                break;
            }
            s[i] = c;
            i += 1;
        }
        s[i] = 0;
        return i;
    }
};

pub var kbd = Kbd{
    .base = @ptrFromInt(0x10006000),
    .buf = [_]u8{0} ** 128,
    .head = 0,
    .tail = 0,
    .data = 0,
    .room = 128,
};
