import std::io;
import std::io::file;
import std::core::string;
import std::core::mem;

/* Raylib */
extern fn void init_window(int width, int height, char *title) @extern("InitWindow");
extern fn void set_target_fps(int fps) @extern("SetTargetFPS");
extern fn int get_random_value(int min, int max) @extern("GetRandomValue");
extern fn bool window_should_not_close() @extern("WindowShouldClose");
extern fn void begin_drawing() @extern("BeginDrawing");
extern fn void end_drawing() @extern("EndDrawing");

/* Constants */
const int WINDOW_WIDTH = 1200;
const int WINDOW_HEIGHT = 600;

const int MAP_WIDTH = 60;
const int MAP_HEIGHT = 25;
const int MAP_SIZE = MAP_HEIGHT * MAP_WIDTH;
const int MAP_TOTAL_STAGES = 2;

enum Direction {
    DIR_UP,
    DIR_DOWN,
    DIR_LEFT,
    DIR_RIGHT
}

enum GameState {
    STATE_PLAYING,
    STATE_MENU,
    STATE_OVER,
    STATE_WIN
}

enum MenuOptions {
    MENU_NEW_GAME,
    MENU_LOAD_GAME,
    MENU_SAVE_GAME,
    MENU_BACK,
    MENU_QUIT,
    MENU_IDLE
}

enum Block {
    BLOCK_EMPTY,       /* Empty space */
    BLOCK_WALL,        /* Indestructible wall */
    BLOCK_BREAKABLE,   /* Destructible block */
    BLOCK_KEY          /* Block containing a key */
}

/* Structures */
struct Menu {
    MenuOptions current_option;
}

struct Map {
    char[MAP_SIZE] grid;
    uint stage_index;
    uint total_stages;
}

fn void? Map.load(Map* map, int stage_index) {
    assert(stage_index <= map.total_stages);
    String filename = string::format(tmem, "maps/stage_%d.bin", stage_index);

    File? f = file::open(filename, "r");
    ulong bytes_read = f.read(&map.grid)!;
    assert(bytes_read == MAP_SIZE);

    f.close()!;
}

fn void Map.load_next_stage(Map* map) {
    uint next_stage = map.stage_index + 1;
    if (next_stage <= map.total_stages) {
        map.load(next_stage)!!;
        map.stage_index = next_stage;
    }
}

fn void Map.init(Map* map) {
    map.stage_index = 0;
    map.total_stages = MAP_TOTAL_STAGES;
    map.load(map.stage_index)!!;
}

struct Enemy {
    int pos_x;
    int pos_y;
    Direction dir;
}

struct Player {
    int pos_x;
    int pos_y;
    Direction dir;
    uint lives;
    uint points;
    uint max_bombs;
    uint keys_collected;
}

struct Game {
    GameState state;
    Map map;
    Player player;
    float time;
    Enemy[] enemies;
}

fn void Player.init(Player* p, int x, int y) {
    p.pos_x = x;
    p.pos_y = y;
    p.lives = 3;
    p.points = 0;
    p.max_bombs = 3;
    p.keys_collected = 0;
}

fn void Game.init(Game* game) {
    game.state = STATE_PLAYING;
    game.time = 0;

    Player player;
    player.init(0, 0);
    game.player = player;

    Map map;
    map.init();
    game.map = map;
}

fn int main() {
    Game game;
    game.init();

    init_window(WINDOW_WIDTH, WINDOW_HEIGHT, "Hello world");
    set_target_fps(60);

    while (!window_should_not_close()) {
        begin_drawing();

    }

    return 0;
}
