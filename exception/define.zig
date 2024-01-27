const VIC_BASE: u32 = 0x10140000;
pub const VIC_STATUS: *volatile u32 = @ptrFromInt(VIC_BASE + 0x000);
pub const VIC_INTENABLE: *volatile u32 = @ptrFromInt(VIC_BASE + 0x010);
