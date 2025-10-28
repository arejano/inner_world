const rl = @import("../rl_import.zig").rl;

pub const Transform = struct {
    position: rl.Vector3,
    rotation: rl.Vector3,
    scale: rl.Vector3,
    block_width: f32 = 2,
    block_height: f32 = 4,
};

pub const Renderable = struct {
    color: rl.Color,
    mesh: rl.Mesh = undefined,
};

pub const Velocity = rl.Vector3;

pub const Player = struct {
    name: []const u8 = "player_sem_nome",
    death: bool = false,
    life: f32 = 1000.0,
};
