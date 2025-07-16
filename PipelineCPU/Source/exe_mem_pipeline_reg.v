`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/16 20:19:29
// Design Name: 
// Module Name: exe_mem_pipeline_reg
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


module exe_mem_pipeline_reg(
    input clk,resetn,flush,
    input i_exe_RegWrite,
    input i_exe_mem_w,
    input [2:0] i_exe_dm_ctrl,
    input [1:0] i_exe_WDSel,
    input [31:0]i_exe_aluout,
    input [4:0]i_exe_rd,
    input [31:0] i_exe_RD2,
    input [31:0] i_exe_pc_plus4,
    input [31:0] i_exe_pcImm,
    input i_exe_Zero,
    input [2:0] i_exe_NPCOp,

    output reg o_mem_RegWrite,
    output reg o_mem_mem_w,
    output reg [2:0]o_mem_dm_ctrl,
    output reg [1:0]o_mem_WDSel,
    output reg [31:0]o_mem_aluout,
    output reg [4:0]o_mem_rd,
    output reg [31:0] o_mem_RD2,
    output reg [31:0] o_mem_pc_plus4,
    output reg [31:0] o_mem_pcImm,
    output reg o_mem_Zero,
    output reg [2:0] o_mem_NPCOp
    );

    always@(posedge clk or posedge resetn)
    begin
        if(resetn   || flush)
        begin
            o_mem_RegWrite <= 0;
            o_mem_mem_w <= 0;
            o_mem_dm_ctrl <= 0;
            o_mem_WDSel <= 0;
            o_mem_aluout <= 0;
            o_mem_rd <= 0;
            o_mem_RD2 <= 0;
            o_mem_pc_plus4 <= 0;
            o_mem_pcImm <= 0;
            o_mem_Zero <= 0;
            o_mem_NPCOp <= 0;
        end
        else begin
            o_mem_RegWrite <= i_exe_RegWrite;
            o_mem_mem_w <= i_exe_mem_w;
            o_mem_dm_ctrl <= i_exe_dm_ctrl;
            o_mem_WDSel <= i_exe_WDSel;
            o_mem_aluout <= i_exe_aluout;
            o_mem_rd <= i_exe_rd;     
            o_mem_RD2 <= i_exe_RD2;
            o_mem_pc_plus4 <= i_exe_pc_plus4;
            o_mem_pcImm <= i_exe_pcImm;
            o_mem_Zero <= i_exe_Zero;
            o_mem_NPCOp <= i_exe_NPCOp;
        end      
    end
endmodule
