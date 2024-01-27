extern const vectors_start: u32;
extern const vectors_end: u32;
export fn copy_vectors() void {
    const vectors_src = &vectors_start;
    const vectors_dst: [*]allowzero u32 = @ptrFromInt(0);
    const size = @as(usize, @intCast(@intFromPtr(&vectors_end) - @intFromPtr(&vectors_start)));
    const length = @as(usize, size / @sizeOf(u32));
    const vectors: [*]u32 = @ptrCast(vectors_src);
    @memcpy(vectors_dst, vectors[0..length]);
}
