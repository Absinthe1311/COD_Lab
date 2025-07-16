// #pragma GCC push_options
// #pragma GCC optimize("O0")
// void start(){
//   asm("li\tsp,1024\n\t"
//       "call main");
// }

// __attribute__ ((noinline)) void wait(int instr_num){
//   while(instr_num--);
// }

// void main()
// {
//   int x = 0x39c5bb00;
//   (*((int*)0xe0000000)) = x;
//   while(1){
//     wait(1000000);
//     x = x ^ 0x39c5bb00 ^ 0x66ccff00;
//     (*((int*)0xe0000000)) = x;
//   }
// }
// #pragma GCC pop_options

#pragma GCC push_options
#pragma GCC optimize("O0")
void start() {
    asm("li\tsp,1024\n\t"
        "call main");
}

__attribute__((noinline)) void wait(int instr_num) {
    while (instr_num--);
}

void main()
{
    unsigned short SW = (*((short*)0xf0000000));
    //unsigned short SW_15 = SW >> 15;
    unsigned short SW_14 = SW >> 14;
    int Ln_2 = 2;
    int Ln_1 = 1;
    int Ln = 0;

    int Rn_1 = 1;
    int Rn_2 = 1;
    int Rn = 0;

    int displayNumber;
    while (1)
    {
        while (SW_14 == 1)
        {
            Ln = Ln_2 + Ln_1;
            Ln_2 = Ln_1;
            Ln_1 = Ln;
            (*((int*)0xe0000000)) = Ln;
            wait(10000000);
        }
        while (SW_14 == 2)
        {
            Rn = Rn_2 + Rn_1;
            Rn_1 = Rn_2;
            Rn_2 = Rn;
            (*((int*)0xe0000000)) = Rn;
            wait(10000000);
        }
        while (SW_14 == 3)
        {
            displayNumber = 0xF9FFFFFF;
            (*((int*)0xe0000000)) = displayNumber;
            wait(1000000);
            displayNumber = 0xFFA4FFFF;
            (*((int*)0xe0000000)) = displayNumber;
            wait(10000000);
            displayNumber = 0xFFFFB0FF;
            (*((int*)0xe0000000)) = displayNumber;
            wait(10000000);
            displayNumber = 0xFFFFFF99;
            (*((int*)0xe0000000)) = displayNumber;
            wait(10000000);
        }
    }
}
#pragma GCC pop_options
//0 3 4 7 11 18 29
//2 3 5 8 13 21 34