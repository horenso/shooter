const std = @import("std");
const raylib = @import("raylib");

pub fn build(b: *std.Build) void {
    const target = b.host;
    const optimize = b.standardOptimizeOption(.{});

    const game_lib = b.addSharedLibrary(.{
        .name = "game",
        .root_source_file = b.path("src/game/game.zig"),
        .target = target,
        .optimize = optimize,
    });

    const raylib_artifact = try raylib.addRaylib(b, b.host, optimize, .{
        .raygui = true,
        .shared = true,
        .raudio = false,
    });
    game_lib.linkLibrary(raylib_artifact);
    game_lib.linkSystemLibrary("c");

    const exe = b.addExecutable(.{
        .name = "game",
        .root_source_file = b.path("src/main/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibrary(raylib_artifact);
    exe.linkSystemLibrary("c");

    b.installArtifact(game_lib);
    b.installArtifact(exe);

    const reload_step = b.step("reload", "Reload the game");

    const pkill = b.addSystemCommand(&.{ "pkill", "-USR1", "game" });

    reload_step.dependOn(&game_lib.step);
    reload_step.dependOn(&pkill.step);
}
