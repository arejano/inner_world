const std = @import("std");
const rl_3d_learn = @import("rl_3d_learn");

const rl = @import("rl_import.zig").rl;
const ecs = @import("entt");

const player_factory = @import("entities/player_factory.zig");

const ct = @import("components/component_types.zig");

// const RenderSystem = @import("systems/render_system.zig");

var camera = @import("camera3d.zig").init();
// var world: ecs.Registry = undefined;

const Game = @import("game.zig");

pub fn main() !void {
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

    rl.InitWindow(800, 600, "Raylib_Learn");

    defer rl.CloseWindow();

    rl.SetWindowMonitor(1);
    rl.SetTargetFPS(60);
    // rl.DisableCursor();

    while (!rl.WindowShouldClose()) {
        const dt = rl.GetFrameTime();
        game.update(dt);

        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.RAYWHITE);
        rl.BeginMode3D(camera.camera);

        game.render(dt);

        rl.DrawGrid(40, 1.0);

        rl.EndMode3D();
    }
}
