const cffi = @cImport({
    @cInclude("font0");
});
pub var fb: [*]volatile i32 = @ptrFromInt(0x200000);

const tab = [_]u8{ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
pub const Color = enum(u4) { BLUE, GREEN, RED, WHITE, CYAN, YELLOW };
pub var color: Color = undefined;
var row: usize = 0;
var col: usize = 0;
var scroll_row: usize = undefined;
const cursor: u8 = 127;

pub fn fbuf_init() void {
    @as(*volatile u32, @ptrFromInt(0x1000001c)).* = 0x2c77;
    @as(*volatile u32, @ptrFromInt(0x10120000)).* = 0x3f1f3f9c;
    @as(*volatile u32, @ptrFromInt(0x10120004)).* = 0x090b61df;
    @as(*volatile u32, @ptrFromInt(0x10120008)).* = 0x067f1800;

    @as(*volatile u32, @ptrFromInt(0x10120010)).* = 0x200000;
    @as(*volatile u32, @ptrFromInt(0x10120018)).* = 0x82b;
}

pub fn clrpix(x: usize, y: usize) void {
    var pix: usize = y * 640 + x;
    fb[pix] = 0x00000000;
}

pub fn setpix(x: usize, y: usize) void {
    var pix = y * 640 + x;
    switch (color) {
        Color.RED => {
            fb[pix] = 0x000000FF;
        },
        Color.BLUE => {
            fb[pix] = 0x00FF0000;
        },
        Color.GREEN => {
            fb[pix] = 0x0000FF00;
        },
        Color.WHITE => {
            fb[pix] = 0x00FFFFFF;
        },
        Color.YELLOW => {
            fb[pix] = 0x0000FFFF;
        },
        Color.CYAN => {
            fb[pix] = 0x00FFFF00;
        },
    }
}

fn dchar(c: u8, x: usize, y: usize) void {
    const index = @as(usize, c) * 16;
    for (0..16) |r| {
        const byte = cffi.fonts0[index + r];
        for (0..8) |bit| {
            const flag: u8 = 1;
            if ((byte & (flag << @as(u3, @intCast(bit)))) != 0) {
                setpix(x + bit, y + r);
            }
        }
    }
}

pub fn undchar(c: u8, x: usize, y: usize) void {
    const index = @as(usize, c) * 16;
    const caddress = cffi.fonts0[index..];
    for (0..16) |row_index| {
        const byte = caddress[row_index];
        for (0..8) |bit| {
            const flag: u8 = 1;
            if ((byte & (flag << @as(u3, @intCast(bit)))) != 0) {
                clrpix(x + bit, y + row_index);
            }
        }
    }
}

pub fn scroll() void {
    for (64 * 640..640 * 480) |i| {
        fb[i] = fb[i + 640 * 16];
    }
}

pub fn kpchar(c: u8, ro: usize, co: usize) void {
    const x = co * 8;
    const y = ro * 16;
    dchar(c, x, y);
}

pub fn unkpchar(c: u8, ro: usize, co: usize) void {
    const x = co * 8;
    const y = ro * 16;
    undchar(c, x, y);
}

fn erasechar() void {
    const x = col * 8;
    const y = row * 16;
    for (0..16) |r| {
        for (0..8) |bit| {
            clrpix(x + bit, y + r);
        }
    }
}

fn clrcursor() void {
    unkpchar(cursor, row, col);
}

fn putcursor(c: u8) void {
    kpchar(c, row, col);
}

fn kputc(c: u8) void {
    clrcursor();
    if (c == '\r') {
        col = 0;
        putcursor(cursor);
        return;
    }
    if (c == '\n') {
        row = row + 1;
        if (row >= 25) {
            row = 24;
            scroll();
        }
        putcursor(cursor);
        return;
    }
    if (c == '\x08') {
        if (col > 0) {
            col = col - 1;
            erasechar();
            putcursor(cursor);
        }
        return;
    }
    kpchar(c, row, col);
    col = col + 1;
    if (col >= 80) {
        col = 0;
        row = row + 1;
        if (row >= 25) {
            row = 24;
            scroll();
        }
    }
    putcursor(cursor);
}

pub fn kprintf(x: []const u8) void {
    for (x) |c| {
        kputc(c);
        if (c == '\n') {
            kputc('\r');
        }
    }
}
