const std = @import("std");
const jstring_build = @import("jstring");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const jstring_dep = b.dependency("jstring", .{});
    const zcmd_dep = b.dependency("zcmd", .{});

    const exe = b.addExecutable(.{
        .name = "translate_c_extract",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.addModule("jstring", jstring_dep.module("jstring"));
    jstring_build.linkPCRE(exe, jstring_dep);
    exe.addModule("zcmd", zcmd_dep.module("zcmd"));

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_exe.addArgs(args);
    }

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}
