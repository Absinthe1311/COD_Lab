`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:34:45
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input [15:0] sw_i,
    input [4:0] btn_i,
    input clk,
    input rstn,
    output [7:0] disp_an_o,
    output [7:0] disp_seg_o,
    output [15:0] led_o
    );
    /************ variables declaration ************/
    //for U10_Enter
    wire [4:0] BTN_out;   //check
    wire [15:0] SW_out;   //check

    //for U8_clk_div
    wire rst_i = ~rstn;  //check
    wire Clk_CPU;        //check
    wire [31:0]clkdiv;   //check

    //for U7_SPIO
    wire IO_clk_i = ~Clk_CPU; //check
    wire [15:0] LED_out;    //check
    wire [1:0] counter_set;  //check
    wire [15:0] led;  //check

    //for U3_dm_controller
    wire [31:0] Data_read;  //check
    wire [31:0] Data_write_to_dm;  //check
    wire [3:0] wea_mem;  //check

    //for U2_ROMD
    wire [31:0] spo; //check

    //for U9_Counter_x
    wire counter0_OUT; //check
    wire counter1_OUT; //check
    wire counter2_OUT; //check

    //for U4_RAM_B
    wire clka0_i = ~clk;  //check
    wire [31:0]douta;  //check

    //for U1_SCPU
    wire [31:0]Addr_out;  //check
    wire CPU_MIO;  //check
    wire [31:0]Data_out; //check
    wire [31:0]PC_out; //check
    wire [2:0] dm_ctrl; //check
    wire mem_w; //check

    //for U4_MIO_BUS
    wire [31:0]Cpu_data4bus;  //check
    wire GPIOe0000000_we;   //check
    wire GPIOf0000000_we;   //check
    wire [31:0]Peripheral_in; //check
    wire counter_we;   //check
    wire [9:0] ram_addr;  //check
    wire [31:0] ram_data_in;  //check
    wire [31:0] counter_out = 32'h00000000;  //check
    wire data_ram_we;   //check

    //for U5_Multi_8CH32
    wire [31:0] Disp_num;  //check
    wire [7:0] LE_out;  //check
    wire [7:0] point_out;  //check

    //for U6_SSeg7
    wire [7:0] seg_an;  //check
    wire [7:0] seg_sout;    //check

    /******************************************************************************************************/

    Enter U10_Enter(
        .BTN(btn_i),
        .SW(sw_i),
        .clk(clk),
        .BTN_out(BTN_out),
        .SW_out(SW_out)
    ); //checked again

    clk_div U8_clk_div(
        .SW2(sw_i[2]),
        .clk(clk),
        .rst(rst_i),
        .Clk_CPU(Clk_CPU),
        .clkdiv(clkdiv)
    ); //checked again

    SPIO U7_SPIO(
        .EN(GPIOf0000000_we),
        .P_Data(Peripheral_in),
        .clk(IO_clk_i),
        .rst(rst_i),
        .LED_out(LED_out),
        .counter_set(counter_set),
        .led(led)
    ); //checked again

    dm_controller U3_dm_controller(
        .Addr_in(Addr_out),
        .Data_read_from_dm(Cpu_data4bus),
        .Data_write(ram_data_in),
        .dm_ctrl(dm_ctrl),
        .mem_w(mem_w),
        .Data_read(Data_read),
        .Data_write_to_dm(Data_write_to_dm),
        .wea_mem(wea_mem)
    ); //checked again

    //这是原来取指令的地方
    ROM_D U2_ROMD(
        .a(PC_out[11:2]),
        .spo(spo)
    );  //checked 

    // //现在我使用自己设计的IM来测试我的CPU模块
    // IM U2_IM(
    //     .pc(PC_out),
    //     .instruction(spo)
    // ); //checked again

    Counter_x U9_Counter_x(
        .clk(IO_clk_i),
        .clk0(clkdiv[6]),
        .clk1(clkdiv[9]),
        .clk2(clkdiv[11]),
        .counter_ch(counter_set),
        .counter_val(Peripheral_in),
        .counter_we(counter_we),
        .rst(rst_i),
        .counter0_OUT(counter0_OUT),
        .counter1_OUT(counter1_OUT),
        .counter2_OUT(counter2_OUT)
    ); //checked again

    RAM_B U4_RAM_B(
        .addra(ram_addr),
        .clka(clka0_i),
        .dina(Data_write_to_dm),
        .wea(wea_mem),
        
        .douta(douta)
    ); //checked again
    
    // //使用这个DM来测试我的lw,sw之类的指令，直接将SCPU的数据连上去而不过总线
    // DM_Test U4_DM(
    //     .clk(clka0_i),
    //     .DMWr(mem_w),
    //     .addr(Addr_out),
    //     .din(Data_out),
    //     .DMType(dm_ctrl),
    //     .dout(Data_read)
    // );

    SCPU U1_SCPU(
        .Data_in(Data_read), 
        .INT(counter0_OUT),
        .MIO_ready(CPU_MIO),
        .clk(Clk_CPU),      //测试，尝试直接使用未分频CPU
        .inst_in(spo),
        .reset(rst_i),
        .Addr_out(Addr_out),
        .CPU_MIO(CPU_MIO),
        .Data_out(Data_out),
        .PC_out(PC_out),
        .dm_ctrl(dm_ctrl), //就是DMType
        .mem_w(mem_w)
    ); //checked again

    MIO_BUS U4_MIO_BUS(
        .BTN(BTN_out),
        .Cpu_data2bus(Data_out),
        .SW(SW_out),
        .addr_bus(Addr_out),
        .clk(clk),
        .counter_out(counter_out),
        .counter0_out(counter0_OUT),
        .counter1_out(counter1_OUT),
        .counter2_out(counter2_OUT),
        .led_out(LED_out),
        //.PC(PC_out), //这里 ，现在尝试打开
        .mem_w(mem_w),
        .ram_data_out(douta),
        .rst(rst_i),
        .Cpu_data4bus(Cpu_data4bus),
        .GPIOe0000000_we(GPIOe0000000_we),
        .GPIOf0000000_we(GPIOf0000000_we),
        .Peripheral_in(Peripheral_in),
        .counter_we(counter_we),
        .ram_addr(ram_addr),
        .ram_data_in(ram_data_in)
    ); //problem

    Multi_8CH32 U5_Multi_8CH32(
        .EN(GPIOe0000000_we),
        .LES(64'hFFFFFFFFFFFFFFFF),
        .Switch(SW_out[7:5]),
        .clk(IO_clk_i),
        .rst(rst_i),
        .data0(Peripheral_in),
        .data1({1'b0,1'b0,PC_out[31:2]}),
        .data2(spo),
        .data3(counter_out),
        .data4(Addr_out),
        .data5(Data_out),
        .data6(Cpu_data4bus),
        .data7(PC_out),
        .point_in({clkdiv[31:0],clkdiv[31:0]}),
        .Disp_num(Disp_num),
        .LE_out(LE_out),
        .point_out(point_out)
    ); //checking

    SSeg7 U6_SSeg7(
        .Hexs(Disp_num),
        .LES(LE_out),
        .SW0(SW_out[0]),
        .clk(clk),
        .flash(clkdiv[10]),
        .point(point_out),
        .rst(rst_i),
        .seg_an(seg_an),
        .seg_sout(seg_sout)
    ); //checked again
    
    assign disp_an_o = seg_an; //check
    assign disp_seg_o = seg_sout; //check
    assign led_o = led; //check

endmodule

