pub const rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("rcamera.h");
    @cInclude("raymath.h");
});

pub fn anyKeyInGroupIsPressed(keys: []c_int) bool {
    for (keys) |k| {
        if (rl.IsKeyPressed(k)) {
            return true;
        }
    }

    return false;
}
