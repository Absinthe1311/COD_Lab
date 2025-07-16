#pragma GCC push_options
#pragma GCC optimize("O0")

typedef unsigned short uint16_t;
typedef unsigned char uint8_t;
typedef unsigned int uint32_t;

void start()
{
  asm("li\tsp,1024\n\t" // 设置栈指针
      "call main");     // 跳转到main
}

__attribute__((noinline)) void wait(uint32_t cycles)
{
  while (cycles--)
    ;
}

// 画一个色块（tile），不使用乘法和除法 
// 这个绘制色块的函数应该没问题了
void draw_tile(int x, int y, uint16_t color) {
    volatile uint32_t *vram = (volatile uint32_t *)0xC0000000;
    int block_start_x = x << 5; // x * 32
    int block_start_y = y << 5; // y * 32
    int dy, dx;
    for (dy = 0; dy < 32; dy++) {
        int pixel_y = block_start_y + dy;
        int row_addr = pixel_y << 9; // pixel_y * 512
        for (dx = 0; dx < 32; dx++) {
            int pixel_x = block_start_x + dx;
            int addr = row_addr + pixel_x;
            vram[addr] = color & 0xFFF;
        }
    }
}

// 画整个迷宫  应该画出人，墙，路
void draw_maze(uint8_t maze[16][16]) {
    int x, y;
    for (y = 0; y < 16; y++) {
        for (x = 0; x < 16; x++) {
            uint8_t maze_val = maze[y][x];
            // draw_tile(x, y, maze_val ? 0x000 : 0xFFF); // 黑色墙/白色路
            if(maze_val==0)
            {
                draw_tile(x,y,0xFFF); //白色的路
            }
            else if(maze_val == 1)
            {
                draw_tile(x,y,0x000); //黑色的墙
            }
            else if(maze_val ==2)
            {
                draw_tile(x,y,0xF00); //红色的角色
            }
        }
    }
}

void update_player(uint8_t maze[16][16]) {
    // 查找玩家当前位置
    int player_x = -1, player_y = -1;
    for (int y = 0; y < 16; y++) {
        for (int x = 0; x < 16; x++) {
            if (maze[y][x] == 2) {
                player_x = x;
                player_y = y;
                break;
            }
        }
        if (player_x != -1) break;
    }
    // if (player_x == -1 || player_y == -1) return; // 没有找到玩家

    // 通过开关来控制角色的移动
    volatile uint32_t *SW = (volatile unsigned int*)0xf0000000;
    unsigned short SW_12 = (*SW >>12) & 0x1;
    unsigned short SW_13 = (*SW>>13) & 0x1;
    unsigned short SW_14 = (*SW>>14) & 0x1;
    unsigned short SW_15 = (*SW>>15) & 0x1;

    int new_x = player_x;
    int new_y = player_y;

    if(SW_12)
    {
        new_y--; //上
    }
    if(SW_13)
    {
        new_y++; // 下
    }
    if(SW_14)
    {
       new_x--; //左
    }
    if(SW_15)
    {
        new_x++; //右
    }

    // 检查边界和是否为路径
    if (new_x >= 0 && new_x < 16 && new_y >= 0 && new_y < 16 && maze[new_y][new_x] == 0) {
        maze[player_y][player_x] = 0; // 恢复原位置为路径
        draw_tile(player_x, player_y,0xfff); //将路径恢复成白色
        wait(500000);

        maze[new_y][new_x] = 2;       // 新位置为人物
        draw_tile(player_x,player_y,0xf00); //将人物这块染红
        wait(500000);
    }
}



// 填纯色测试 用来测试开关 测试完毕，可以正常读取开关
// 使用开关的12 13 14 15 （我要看一下我的开关是否拨了）
void draw_test_pattern_single_switch() {
  // 硬件寄存器定义 volatile保证从内存中读取数据
    volatile uint32_t *vram = (volatile unsigned int *)0xC0000000;
    volatile uint32_t *SW = (volatile unsigned int*)0xf0000000;
    unsigned short SW_12 = (*SW >>12) & 0x1;
    unsigned short SW_13 = (*SW>>13) & 0x1;
    unsigned short SW_14 = (*SW>>14) & 0x1;
    unsigned short SW_15 = (*SW>>15) & 0x1;

    uint32_t color = 0xfff; //默认是白色
    if(SW_12)
    {
        color = 0xf00; //如果拨12，得到红色
    }
    if(SW_13)
    {
        color = 0x0f0; //如果拨13， 得到绿色
    }
    if(SW_14)
    {
        color = 0x00f; //如果拨14，得到蓝色
    }
    if(SW_15)
    {
        color = 0xFF0; //如果拨15，得到黄色
    }

    unsigned int addr = 0;
    
    for (int y = 0; y < 307200; y++) {
      vram[y] = color&0xFFF;
    }
}


void main() {
    // 迷宫的初始值部分
    uint8_t maze[16][16];
    for(int i = 0; i<16;i++)
    {
        for(int j = 0; j<16;j++)
            maze[i][j] = 1;
    }
    //角色的初始位置
    maze[1][2] = 2;
    //角色的周围设置为都可以移动
    maze[0][2] = 0;
    maze[0][1] = 0;
    maze[1][1] = 0;
    maze[2][1] = 0;
    maze[2][2] = 0;
    maze[2][3] = 0;
    maze[1][3] = 0;
    maze[0][3] = 0;

    maze[2][4] = 0;
    maze[2][4] = 0;
    maze[3][4] = 0;
    maze[3][5] = 0;
    maze[3][6] = 0;
    maze[3][7] = 0;
    maze[4][7] = 0;
    maze[5][7] = 0;
    maze[6][7] = 0;
    maze[7][7] = 0;
    maze[8][7] = 0;
    maze[8][8] = 0;
    maze[8][9] = 0;
    maze[8][10] = 0;
    maze[9][10] = 0;
    maze[9][11] = 0;
    maze[10][11] = 0;
    maze[10][12] = 0;
    maze[11][12] = 0;
    maze[12][12] = 0;
    maze[13][12] = 0;
    maze[14][12] = 0;
    maze[14][13] = 0;
    maze[14][14] = 0;

    // 新的测试 先将地图绘制出来
    draw_maze(maze);
    wait(5000000); 
    while(1) //主循环
    {
        update_player(maze); //将迷宫传入进去
        wait(5000000); 
    }
}

#pragma GCC pop_options
