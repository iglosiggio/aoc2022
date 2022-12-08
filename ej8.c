#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

static const char* color_table[2][10] = {
    /* Visible */ {
        "\033[38;2;10;0;0m",
        "\033[38;2;33;0;0m",
        "\033[38;2;83;0;0m",
        "\033[38;2;200;28;10m",
        "\033[38;2;228;84;31m",
        "\033[38;2;254;137;49m",
        "\033[38;2;251;190;34m",
        "\033[38;2;248;242;76m",
        "\033[38;2;248;243;125m",
        "\033[38;2;249;247;212m"
    },
    /* Not visible */ {
        "\033[38;2;20;20;20m",
        "\033[38;2;40;40;40m",
        "\033[38;2;60;60;60m",
        "\033[38;2;80;80;80m",
        "\033[38;2;100;100;100m",
        "\033[38;2;120;120;120m",
        "\033[38;2;140;140;140m",
        "\033[38;2;160;160;160m",
        "\033[38;2;180;180;180m",
        "\033[38;2;200;200;200m",
    }
};

static size_t count_trees(size_t sidelen, char map[sidelen][sidelen], size_t x, size_t y, size_t dx, size_t dy) {
    size_t result = 0;
    char starting_tree = map[y][x];
    x += dx;
    y += dy;
    while (0 <= x && x < sidelen && 0 <= y && y < sidelen) {
        result++;
        if (starting_tree <= map[y][x]) break;
        x += dx;
        y += dy;
    }
    return result;
}

static void calculate_visibility(size_t sidelen, char map[sidelen][sidelen], bool visible[sidelen][sidelen], size_t x, size_t y, size_t dx, size_t dy, char tallest_seen) {
    while (0 <= x && x < sidelen && 0 <= y && y < sidelen) {
        if (tallest_seen < map[y][x]) {
            tallest_seen = map[y][x];
            visible[y][x] = true;
        }
        x += dx;
        y += dy;
    }
}

static void calculate_visibility_from_tree(size_t sidelen, char map[sidelen][sidelen], bool visible[sidelen][sidelen], size_t x, size_t y, size_t dx, size_t dy) {
    char starting_tree = map[y][x];
    x += dx;
    y += dy;
    while (0 <= x && x < sidelen && 0 <= y && y < sidelen) {
        visible[y][x] = true;
        if (starting_tree <= map[y][x]) break;
        x += dx;
        y += dy;
    }
}


static void print_map(size_t sidelen, char map[sidelen][sidelen], bool visible[sidelen][sidelen]) {
    for (size_t i = 0; i < sidelen; i++) {
        for (size_t j = 0; j < sidelen; j++)
            if (visible[i][j])
                printf("%s%c", color_table[0][map[i][j] - '0'], map[i][j]);
            else
                printf("%s%c", color_table[1][map[i][j] - '0'], map[i][j]);
        putc('\n', stdout);
    }
    printf("\033[0m");
}

int main() {
    ssize_t sidelen;
    size_t curline_bufsiz = 0;
    char* curline = NULL;

    /* Read first line */
    sidelen = getline(&curline, &curline_bufsiz, stdin);
    if (sidelen < 0) perror("Failed to read input");
    assert(0 <= sidelen);
    /* Sidelen includes \n, lets remove it */
    sidelen--;

    char map[sidelen][sidelen];
    memcpy(map[0], curline, sidelen);

    for (size_t i = 1; i < sidelen; i++) {
        ssize_t linelen = getline(&curline, &curline_bufsiz, stdin);
        if (linelen < 0) perror("Failed to read input");
        assert(linelen == sidelen + 1 /* The \n */);
        memcpy(map[i], curline, sidelen);
    }

    bool visible[sidelen][sidelen];
    memset(visible, false, sizeof(visible));

    for (size_t i = 0; i < sidelen; i++) {
        calculate_visibility(sidelen, map, visible,           0,           i,  1,  0, '0' - 1);
        calculate_visibility(sidelen, map, visible, sidelen - 1,           i, -1,  0, '0' - 1);
        calculate_visibility(sidelen, map, visible, i,           sidelen - 1,  0, -1, '0' - 1);
        calculate_visibility(sidelen, map, visible, i,                     0,  0,  1, '0' - 1);
    }

    size_t total_visible = 0;
    for (size_t i = 0; i < sidelen; i++)
        for (size_t j = 0; j < sidelen; j++)
            if (visible[i][j])
                total_visible++;

    print_map(sidelen, map, visible);
    printf("There are %ld visible trees\n", total_visible);

    size_t best_x = 0;
    size_t best_y = 0;
    size_t best_score = 0;
    for (size_t x = 0; x < sidelen; x++)
        for (size_t y = 0; y < sidelen; y++) {
            size_t right = count_trees(sidelen, map, x, y,  1,  0);
            size_t left  = count_trees(sidelen, map, x, y, -1,  0);
            size_t down  = count_trees(sidelen, map, x, y,  0,  1);
            size_t up    = count_trees(sidelen, map, x, y,  0, -1);
            size_t score = right * left * up * down;
            if (best_score < score) {
                best_score = score;
                best_x = x;
                best_y = y;
            }
        }
    bool treehouse_visible[sidelen][sidelen];
    memset(treehouse_visible, false, sizeof(treehouse_visible));
    treehouse_visible[best_y][best_x] = true;
    calculate_visibility_from_tree(sidelen, map, treehouse_visible, best_x, best_y,  1,  0);
    calculate_visibility_from_tree(sidelen, map, treehouse_visible, best_x, best_y, -1,  0);
    calculate_visibility_from_tree(sidelen, map, treehouse_visible, best_x, best_y,  0, -1);
    calculate_visibility_from_tree(sidelen, map, treehouse_visible, best_x, best_y,  0,  1);

    print_map(sidelen, map, treehouse_visible);
    printf("The best treehouse can be built at (%ld,%ld) for a total scenic score of %ld\n", best_x, best_y, best_score);

    return 0;
}