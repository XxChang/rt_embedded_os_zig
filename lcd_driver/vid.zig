pub var fb: *volatile i32 = @ptrFromInt(0x200000);

pub fn fbuf_init() void {
    @as(*volatile u32, @ptrFromInt(0x1000001c)).* = 0x2c77;
    @as(*volatile u32, @ptrFromInt(0x10120000)).* = 0x3f1f3f9c;
    @as(*volatile u32, @ptrFromInt(0x10120004)).* = 0x090b61df;
    @as(*volatile u32, @ptrFromInt(0x10120008)).* = 0x067f1800;

    @as(*volatile u32, @ptrFromInt(0x10120010)).* = 0x200000;
    @as(*volatile u32, @ptrFromInt(0x10120018)).* = 0x82b;
}
