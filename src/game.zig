const std = @import("std");
const rl = @import("rl_import.zig").rl;
const ecs = @import("entt");

const player_factory = @import("entities/player_factory.zig");

const check_keys = @import("rl_import.zig").anyKeyInGroupIsPressed;

const GameKeys = @import("game_keys.zig");

const SystemManager = @import("systems/system_manager.zig");
// const ResourceManager = @import("resources_manager.zig");
const ModelManager = @import("model_manager.zig");
const FactoryManager = @import("factory_manager.zig");

//Systems
const CameraSystem = @import("systems/camera_system.zig");
const MovementSystem = @import("systems/movement_system.zig");
const RenderSystem = @import("systems/render_system.zig");
const MouseInputSystem = @import("systems/mouseinput_system.zig");
const KeyboarInputSystem = @import("systems/keyboard_input.zig");

const GameMode = enum {
    Debug,
    Editor,
    Play,
};

const GameState = enum {
    Starting,
    Loading,
    Menu,
    Running,
    Paused,
};

const Self = @This();

game_state: GameState = .Starting,
game_mode: GameMode = .Debug,

allocator: std.mem.Allocator,
world: ecs.Registry,
system_manager: SystemManager,
render_system_manager: SystemManager,
// resource_manager: ResourceManager,
model_manager: ModelManager,
factory_manager: FactoryManager,

pub fn init(allocator: std.mem.Allocator) !Self {
    var world = ecs.Registry.init(allocator);

    const model_manager = try ModelManager.init(allocator);
    const factory_manager = try FactoryManager.init(allocator);

    //System Manager
    var system_manager = SystemManager.init(allocator);

    //Resource Manager
    // const resource_manager = try ResourceManager.init(allocator);

    var render_system_manager = SystemManager.init(allocator);

    //Start Normal Systems
    const move_system = try MovementSystem.create(allocator);
    try system_manager.add(move_system.system(), "MovementSystem");

    const camera_system = try CameraSystem.create(allocator);
    try system_manager.add(camera_system.system(), "CameraSystem");

    const mouseinput_system = try MouseInputSystem.create(allocator);
    try system_manager.add(mouseinput_system.system(), "MouseSystem");

    const keyboard_input = try KeyboarInputSystem.create(allocator);
    try system_manager.add(keyboard_input.system(), "KeyaboardSystem");

    //Start Render Systems
    const render_system = try RenderSystem.create(allocator);
    try render_system_manager.add(render_system.system(), "RenderSystem");

    system_manager.start(&world);

    return .{
        .allocator = allocator,
        .world = world,
        .system_manager = system_manager,
        .render_system_manager = render_system_manager,
        // .resource_manager = resource_manager,
        .model_manager = model_manager,
        .factory_manager = factory_manager,
    };
}

pub fn start(self: *Self) void {
    self.game_state = .Running;
    self.factory_manager.start(&self.world);
}

pub fn menu_keys(self: *Self) void {
    if (check_keys(GameKeys.menu_keys)) {
        if (rl.IsKeyPressed(rl.KEY_F1)) {
            if (self.game_state == .Paused) {
                self.game_state = .Running;
            }
            if (self.game_state == .Running) {
                self.game_state = .Paused;
            }
        }
    }
}

pub fn update(self: *Self, dt: f32) void {
    if (rl.IsKeyPressed(rl.KEY_N)) {
        self.factory_manager.add_player(&self.world, &self.model_manager);
    }

    if (self.game_state == .Running) {
        self.system_manager.updateAll(&self.world, dt);
    }
}

pub fn render(self: *Self, dt: f32) void {
    self.render_system_manager.updateAll(&self.world, dt);
}

pub fn deinit(self: *Self) void {
    self.model_manager.deinit();
    self.system_manager.deinit();
    self.render_system_manager.deinit();
    // self.resource_manager.deinit();
    self.world.deinit();
}
