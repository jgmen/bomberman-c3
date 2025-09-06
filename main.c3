import std::io;
import std::io::file;
import std::core::string;
import std::core::mem;

/* Colors */
const Color GRAY     = (Color){130, 130, 130, 255};
const Color YELLOW   = (Color){253, 249,   0, 255};
const Color GOLD     = (Color){255, 203,   0, 255};
const Color BROWN    = (Color){127, 106,  79, 255};
const Color WHITE    = (Color){255, 255, 255, 255};
const Color BLACK    = (Color){  0,   0,   0, 255};
const Color BLANK    = (Color){  0,   0,   0,   0};
const Color SKYBLUE  = (Color){102, 191, 255, 255};

/* Raylib */
struct Rect {
    float x;
    float y;
    float width;
    float height;
}

struct Color {
    char r;
    char g;
    char b;
    char a;
}

extern fn void init_window(int width, int height, char *title) @extern("InitWindow");
extern fn void set_target_fps(int fps) @extern("SetTargetFPS");
extern fn int get_random_value(int min, int max) @extern("GetRandomValue");
extern fn bool window_should_close() @extern("WindowShouldClose");
extern fn void begin_drawing() @extern("BeginDrawing");
extern fn void end_drawing() @extern("EndDrawing");
extern fn void clear_background(Color color) @extern("ClearBackground");
extern fn void draw_rect(Rect rect, Color color) @extern("DrawRectangleRec");

/* Constants */
const int WINDOW_WIDTH = 1200;
const int WINDOW_HEIGHT = 600;

const int MAP_WIDTH = 60;
const int MAP_HEIGHT = 25;
const int MAP_SIZE = MAP_HEIGHT * MAP_WIDTH;
const int MAP_TOTAL_STAGES = 2;

const int BLOCK_SIZE = 20;

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
    uint pos_x;
    uint pos_y;
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

/* Draw functions */
fn void Map.draw(Map* map) {
    for (int y = 0; y < MAP_HEIGHT; y++) {
        for (int x = 0; x < MAP_WIDTH; x++) {
            int index = y * MAP_WIDTH + x;
            char block = map.grid[index];

            Rect rect = {
                .x      = (float) x * BLOCK_SIZE,
                .y      = (float) y * BLOCK_SIZE,
                .width  = (float) BLOCK_SIZE,
                .height = (float) BLOCK_SIZE
            };

            Color color;
            switch (block) {
                case (char) Block.BLOCK_WALL.ordinal     : color = GRAY; break;
                case (char) Block.BLOCK_BREAKABLE.ordinal: color = YELLOW; break;
                case (char) Block.BLOCK_KEY.ordinal      : color = GOLD; break;
                case (char) Block.BLOCK_EMPTY.ordinal    : color = BLANK; break;
            }

            draw_rect(rect, color);
        }
    }
}


fn void Game.draw(Game* game) {
    game.map.draw();
}

fn int main() {
    init_window(WINDOW_WIDTH, WINDOW_HEIGHT, "Bomberman");
    set_target_fps(60);

    Game game;
    game.init();

    while (!window_should_close()) {
        begin_drawing();
        clear_background(SKYBLUE);
        game.draw();
        end_drawing();
    }

    return 0;
}
