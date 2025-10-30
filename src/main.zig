const std = @import("std");
const rl_3d_learn = @import("rl_3d_learn");

const rl = @import("rl_import.zig").rl;

const Game = @import("game.zig");

pub fn main() !void {
    rl.InitWindow(800, 600, "Inner World");

    defer rl.CloseWindow();

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

    rl.SetWindowMonitor(1);
    rl.SetTargetFPS(60);
    // rl.DisableCursor();

    while (!rl.WindowShouldClose()) {
        const dt = rl.GetFrameTime();
        game.update(dt);

        game.render(dt);
    }
}
