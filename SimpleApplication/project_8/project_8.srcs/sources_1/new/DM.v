`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 22:38:42
// Design Name: 
// Module Name: DM
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


module DM(
    input [31:0] mem_aluout,
    input [31:0] data_in,
    input [31:0] mem_RD2,
    input mem_mem_w,
    input [2:0] mem_dm_ctrl,

    output [31:0] mem_data_in,
    output [31:0] Addr_out,
    output [31:0] Data_out,
    output mem_w,
    output [2:0] dm_ctrl
    );
    
    assign mem_data_in = data_in;
    assign Addr_out = mem_aluout;
    assign Data_out = mem_RD2;
    assign mem_w = mem_mem_w;
    assign dm_ctrl = mem_dm_ctrl;
endmodule
