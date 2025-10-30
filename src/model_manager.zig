const std = @import("std");
const rl = @import("rl_import.zig").rl;

const models_file = @import("models_list.zig");
const ModelStruct = models_file.ModelStruct;
const models_list = models_file.model_list;

const Self = @This();

allocator: std.mem.Allocator,
models: std.StringHashMap(ModelStruct),

pub fn init(allocator: std.mem.Allocator) std.mem.Allocator.Error!Self {
    var models = std.StringHashMap(ModelStruct).init(allocator);

    for (models_list) |model_struct| {
        var copy_model = model_struct;
        const model = rl.LoadModel(model_struct.path);
        const texture = rl.LoadTexture(model_struct.texture_path);
        model.materials[0].maps[rl.MATERIAL_MAP_DIFFUSE].texture = texture;

        copy_model.model = model;
        try models.put(copy_model.name, copy_model);
    }

    return .{
        //
        .allocator = allocator,
        .models = models,
    };
}

pub fn addModel(self: *Self) void {
    _ = self;
}

pub fn getModel(self: *Self, key: []const u8) ?ModelStruct {
    return self.models.get(key);
}

pub fn deinit(self: *Self) void {
    std.debug.print("[ModelManager]:Deinit\n", .{});

    var models_iter = self.models.iterator();
    while (models_iter.next()) |item| {
        rl.UnloadModel(item.value_ptr.model);
    }
    self.models.clearAndFree();
    self.models.deinit();
}

pub fn teste(_: *Self) void {
    std.debug.print("Testando algo\n", .{});
}
