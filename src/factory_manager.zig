const std = @import("std");
const rl = @import("rl_import.zig").rl;
const ecs = @import("entt");

const player_factory = @import("entities/player_factory.zig");
const create_bounds = @import("entities/bound_blocks.zig").create_bounds;

const ModelManager = @import("model_manager.zig");

const Self = @This();

allocator: std.mem.Allocator,
// model_manager: *ModelManager,

pub fn init(allocator: std.mem.Allocator) std.mem.Allocator.Error!Self {
    return .{
        //
        .allocator = allocator,
        // .world = world,
    };
}

pub fn start(_: *Self, w: *ecs.Registry) void {
    create_bounds(w);
}

pub fn add_player(_: *Self, w: *ecs.Registry, mm: *ModelManager) void {
    player_factory.create_entity_player(w, mm);
}

pub fn teste_model_manager(self: *Self) void {
    self.model_manager.teste();
}
