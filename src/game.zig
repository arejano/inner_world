const std = @import("std");
const rl = @import("rl_import.zig").rl;
const ecs = @import("entt");

const player_factory = @import("entities/player_factory.zig");

const GameCamera = @import("camera3d.zig");
const SystemManager = @import("systems/system_manager.zig");
// const ResourceManager = @import("resources_manager.zig");

//Systems
const CameraSystem = @import("systems/camera_system.zig");
const MovementSystem = @import("systems/movement_system.zig");
const RenderSystem = @import("systems/render_system.zig");
const MouseInputSystem = @import("systems/mouseinput_system.zig");
const KeyboarInputSystem = @import("systems/keyboard_input.zig");

const Self = @This();

allocator: std.mem.Allocator,
camera: GameCamera,
world: ecs.Registry,
system_manager: SystemManager,
render_system_manager: SystemManager,
// resource_manager: ResourceManager,

pub fn init(allocator: std.mem.Allocator) !Self {
    const camera = GameCamera.init();
    var world = ecs.Registry.init(allocator);
    //System Manager
    var system_manager = SystemManager.init(allocator);

    //Resource Manager
    // const resource_manager = try ResourceManager.init(allocator);

    var render_system_manager = SystemManager.init(allocator);

    //Crate Entities
    player_factory.create_entity_player(&world);

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
        .camera = camera,
        .world = world,
        .system_manager = system_manager,
        .render_system_manager = render_system_manager,
        // .resource_manager = resource_manager,
    };
}

pub fn update(self: *Self, dt: f32) void {
    // std.debug.print("Game:Update\n", .{});
    self.system_manager.updateAll(&self.world, dt);
}

pub fn render(self: *Self, dt: f32) void {
    std.debug.print("Game:Render\n", .{});
    self.render_system_manager.updateAll(&self.world, dt);
}

pub fn deinit(self: *Self) void {
    self.system_manager.deinit();
    self.render_system_manager.deinit();
    // self.resource_manager.deinit();
    self.world.deinit();
}
