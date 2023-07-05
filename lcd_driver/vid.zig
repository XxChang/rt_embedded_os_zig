pub var fb: *volatile i32 = @intToPtr(*volatile i32, 0x200000);

pub fn fbuf_init() void {
    @intToPtr(*volatile u32, 0x1000001c).* = 0x2c77;
    @intToPtr(*volatile u32, 0x10120000).* = 0x3f1f3f9c;
    @intToPtr(*volatile u32, 0x10120004).* = 0x090b61df;
    @intToPtr(*volatile u32, 0x10120008).* = 0x067f1800;

    @intToPtr(*volatile u32, 0x10120010).* = 0x200000;
    @intToPtr(*volatile u32, 0x10120018).* = 0x82b;
}
