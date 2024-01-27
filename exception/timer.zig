const lcd = @import("vid.zig");

const TLOAD: usize = 0x0;
const TVALUE: usize = 0x1;
const TCNTL: usize = 0x2;
const TINTCLR: usize = 0x3;
const TRIS: usize = 0x4;
const TMIS: usize = 0x5;
const TBGLOAD: usize = 0x6;
const TIMER1: usize = 0x101E2000;
const TIMER2: usize = 0x101E2020;
const TIMER3: usize = 0x101E3000;
const TIMER4: usize = 0x101E3020;

pub const Timer = struct {
    base: [*]volatile u32,
    color: lcd.Color,
    tick: i32,
    hh: i32,
    mm: i32,
    ss: i32,
    clock: [16]u8,

    pub fn init(self: *Timer) void {
        lcd.kprintf("timer_init()\n");
        self.base[TLOAD] = 0x0;
        self.base[TVALUE] = 0x0;
        self.base[TRIS] = 0x0;
        self.base[TMIS] = 0x0;
        self.base[TCNTL] = 0x62;
        self.base[TBGLOAD] = @divTrunc(0xF0000, 60);
        self.tick = 0;
        self.hh = 0;
        self.mm = 0;
        self.ss = 0;
        @memcpy(self.clock[0..8], "00:00:00");
    }

    pub fn tvalue(self: *const Timer) u32 {
        return self.base[TVALUE];
    }

    pub fn start(self: *Timer) void {
        self.base[TCNTL] |= 0x80;
    }

    pub fn stop(self: *Timer) void {
        self.base[TCNTL] &= 0x7F;
    }

    pub fn clear_interrupt(self: *Timer) void {
        self.base[TINTCLR] = 0xFFFFFFFF;
    }

    pub fn handler(self: *Timer) void {
        self.tick += 1;
        // self.ss = @divTrunc(self.tick, 120);
        // self.ss = self.tick;
        // self.ss = @mod(self.ss, 60);
        // if (self.ss == 0) {
        //     self.mm += 1;
        //     if (@mod(self.mm, 60) == 0) {
        //         self.mm = 0;
        //         self.hh += 1;
        //     }
        // }

        if (self.tick == 60) {
            self.tick = 0;
            self.ss += 1;
            if (self.ss == 60) {
                self.ss = 0;
                self.mm += 1;
                if (self.mm == 60) {
                    self.mm = 0;
                    self.hh += 1;
                }
            }
            for (0..8) |i| {
                lcd.unkpchar(self.clock[i], @as(u8, @intFromEnum(self.color)), 70 + i);
            }

            self.clock[7] = @as(u8, @intCast(@mod(self.ss, 10))) + '0';
            self.clock[6] = @as(u8, @intCast(@divTrunc(self.ss, 10))) + '0';
            self.clock[4] = @as(u8, @intCast(@mod(self.mm, 10))) + '0';
            self.clock[3] = @as(u8, @intCast(@divTrunc(self.mm, 10))) + '0';
            self.clock[1] = @as(u8, @intCast(@mod(self.hh, 10))) + '0';
            self.clock[0] = @as(u8, @intCast(@divTrunc(self.hh, 10))) + '0';

            lcd.color = self.color;
            for (0..8) |i| {
                lcd.kpchar(self.clock[i], @as(u8, @intFromEnum(self.color)), 70 + i);
            }
        }

        self.clear_interrupt();
    }
};

pub var timer1 = Timer{
    .base = @ptrFromInt(TIMER1),
    .color = @enumFromInt(0),
    .tick = undefined,
    .hh = undefined,
    .mm = undefined,
    .ss = undefined,
    .clock = undefined,
};

pub var timer2 = Timer{
    .base = @ptrFromInt(TIMER2),
    .color = @enumFromInt(1),
    .tick = undefined,
    .hh = undefined,
    .mm = undefined,
    .ss = undefined,
    .clock = undefined,
};

pub var timer3 = Timer{
    .base = @ptrFromInt(TIMER3),
    .color = @enumFromInt(2),
    .tick = undefined,
    .hh = undefined,
    .mm = undefined,
    .ss = undefined,
    .clock = undefined,
};

pub var timer4 = Timer{
    .base = @ptrFromInt(TIMER4),
    .color = @enumFromInt(3),
    .tick = undefined,
    .hh = undefined,
    .mm = undefined,
    .ss = undefined,
    .clock = undefined,
};
