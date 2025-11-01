const std = @import("std");
const rl_3d_learn = @import("rl_3d_learn");

const rl = @import("rl_import.zig").rl;

const Game = @import("game.zig");

pub fn main() !void {
    rl.InitWindow(800, 600, "Inner World");

    defer rl.CloseWindow();

    const monitor_target = 1;
    const monitor = rl.GetMonitorCount();
    const monitor_height = rl.GetMonitorHeight(monitor_target);
    const monitor_width = rl.GetMonitorWidth(monitor_target);

    std.debug.print("[DEBUG] Monitor count: {d}\n", .{monitor});
    std.debug.print("[DEBUG] Monitor: Width: {d}  Height: {d}\n", .{ monitor_width, monitor_height });

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        _ = gpa.detectLeaks();
        _ = gpa.deinit();
    }

    const allocator = gpa.allocator();

    var game = try Game.init(allocator);

    defer {
        game.deinit();
    }

    rl.SetWindowMonitor(monitor_target);
    rl.SetWindowPosition(2560, 0);
    rl.SetTargetFPS(60);
    rl.SetWindowSize(monitor_width, monitor_height);
    rl.ToggleBorderlessWindowed();
    // rl.DisableCursor();

    game.start();

    while (!rl.WindowShouldClose()) {
        const dt = rl.GetFrameTime();

        game.update(dt);
        game.render(dt);
    }
}
