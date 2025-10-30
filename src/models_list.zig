const std = @import("std");
const rl = @import("rl_import.zig").rl;

pub const ModelStruct = struct {
    name: [:0]const u8,
    path: [:0]const u8,
    texture_path: [:0]const u8,
    model: rl.Model = undefined,
};

const t: ModelStruct = .{
    .name = "player",
    .path = "resources/rubber_duck/RubberDuck_LOD0.obj",
    .texture_path = "resources/teste.png",
};

pub const model_list: [1]ModelStruct = .{
    t,
};
