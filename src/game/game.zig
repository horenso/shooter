const std = @import("std");
const rl = @import("raylib.zig");

const player_w = 10;
const player_h = 10;

pub const Game = struct {
    x: f32 = 10,
    y: f32 = 10,
};

export fn gameStructSize() usize {
    return @sizeOf(Game);
}

export fn gameInit() *Game {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const game = allocator.create(Game) catch @panic("out of memory");

    rl.SetConfigFlags(rl.FLAG_WINDOW_RESIZABLE);
    rl.InitWindow(800, 800, "hello world!");
    rl.SetTargetFPS(60);

    return game;
}

export fn gameDeinit(game: *Game) void {
    _ = game;

    rl.CloseWindow();
}

export fn gameTick(game: *Game) void {
    if (rl.IsKeyDown(rl.KEY_RIGHT)) game.x += 2.0;
    if (rl.IsKeyDown(rl.KEY_LEFT)) game.x -= 2.0;
    if (rl.IsKeyDown(rl.KEY_UP)) game.y -= 2.0;
    if (rl.IsKeyDown(rl.KEY_DOWN)) game.y += 2.0;

    rl.BeginDrawing();
    defer rl.EndDrawing();

    rl.ClearBackground(rl.BLACK);
    rl.DrawFPS(10, 10);

    rl.DrawText(
        "Hello world!",
        100,
        100,
        20,
        rl.YELLOW,
    );
    rl.DrawRectangle(
        @intFromFloat(game.x),
        @intFromFloat(game.y),
        player_w,
        player_h,
        rl.RED,
    );
}

export fn gameShouldClose(game: *Game) bool {
    _ = game;
    return rl.WindowShouldClose();
}
