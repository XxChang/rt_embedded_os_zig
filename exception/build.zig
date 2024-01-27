const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = std.Target.Cpu.Arch.thumb,
            .os_tag = .freestanding,
            .abi = .eabi,
            .cpu_model = .{ .explicit = &std.Target.arm.cpu.arm926ej_s },
        },
    });

    // const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = std.builtin.OptimizeMode.ReleaseFast });

    const exe = b.addExecutable(.{
        .name = "exception",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        // .optimize = optimize,
    });

    exe.addAssemblyFile(.{ .path = "ts.s" });
    exe.addIncludePath(.{
        .path = ".",
    });
    exe.setLinkerScript(.{ .path = "t.ld" });

    b.installArtifact(exe);

    const run_cmd = b.addSystemCommand(&[_][]const u8{ "qemu-system-arm", "-M", "versatilepb", "-m", "128M", "-kernel", "zig-out/bin/exception", "-serial", "mon:stdio" });
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the simulation");

    run_step.dependOn(&run_cmd.step);

    const debug_cmd = b.addSystemCommand(&[_][]const u8{ "qemu-system-arm", "-S", "-M", "versatilepb", "-m", "128M", "-gdb", "tcp::3333", "-kernel", "zig-out/bin/exception", "-serial", "mon:stdio" });
    debug_cmd.step.dependOn(b.getInstallStep());
    const debug_step = b.step("debug", "Debug bin with gdb");

    debug_step.dependOn(&debug_cmd.step);

    const show_symbol_cmd = b.addSystemCommand(&[_][]const u8{ "arm-none-eabi-nm", "zig-out/bin/exception" });
    show_symbol_cmd.step.dependOn(b.getInstallStep());
    const show_symbol_step = b.step("show_symbol", "Show bin file symbol");

    show_symbol_step.dependOn(&show_symbol_cmd.step);
}
