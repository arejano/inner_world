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

pub const Velocity = struct { x: f32, y: f32, z: f32 };
pub const Direction = struct { x: f32, y: f32, z: f32 };
pub const Gravity = struct { x: f32, y: f32, z: f32 };

pub const Player = struct {
    name: []const u8 = "player_sem_nome",
    death: bool = false,
    life: f32 = 1000.0,
};

pub const CameraTarget = struct {};
pub const Camera = struct {};
pub const CameraComponent = struct {
    camera: rl.Camera3D,
    distance: f32,
    height: f32,
    yaw: f32,
    pitch: f32,
    min_pitch: f32,
    max_pitch: f32,
    mouse_sensitive: f32 = 0.003,
    soulder_offset: f32 = 0.6,
    mode: c_int = rl.CAMERA_FREE,
    zoom_speed: f32 = 0.8,
    max_zoom: f32 = 40,
    min_zoom: f32 = 1,
};

pub const Invisible = struct {};
pub const Hidden = struct {};
pub const KeyboardController = struct {};
pub const MouseController = struct {};

pub const ActionState = struct {
    locomotion: Locomotion,
    combat: Combat,
    interaction: Interaction,
};

pub const Locomotion = enum {
    idle,
    walk,
    run,
    sprint,
    jump,
    fall,
    land, //solo??? arrastando??
    crouch, //agachar
    climb,
    swim,
    dash,
    roll,
    slide, //deslizar
    glide, //planar
};

pub const Combat = enum {
    none,
    attack_light,
    attack_heavy,
    block,
    parry,
    stagger,
    death,
    evade,
    cast,
};

pub const Interaction = enum {
    none,
    interact,
    pickup,
    talk,
    open_door,
};
