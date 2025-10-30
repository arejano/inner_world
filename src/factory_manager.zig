const std = @import("std");
const rl = @import("rl_import.zig").rl;
const ecs = @import("entt");

const player_factory = @import("entities/player_factory.zig");

const ModelManager = @import("model_manager.zig");

const Self = @This();

allocator: std.mem.Allocator,
model_manager: *ModelManager,

pub fn init(allocator: std.mem.Allocator, model_manager: *ModelManager) std.mem.Allocator.Error!Self {
    return .{
        //
        .allocator = allocator,
        .model_manager = model_manager,
        // .world = world,
    };
}

pub fn add_player(_: *Self, world: *ecs.Registry) void {
    player_factory.create_entity_player(world);
}

pub fn teste_model_manager(self: *Self) void {
    self.model_manager.teste();
}
