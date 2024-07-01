const VIC_BASE: u32 = 0x10140000;
pub const VIC_STATUS: *volatile u32 = @ptrFromInt(VIC_BASE + 0x000);
pub const VIC_INTENABLE: *volatile u32 = @ptrFromInt(VIC_BASE + 0x010);

const SIC_BASE_ADDR: usize = 0x10003000;
pub const SIC_STATUS: *volatile u32 = @ptrFromInt(SIC_BASE_ADDR + 0x000);
pub const SIC_INTENABLE: *volatile u32 = @ptrFromInt(SIC_BASE_ADDR + 0x008);

const N_SCAN: usize = 