`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/16 18:51:56
// Design Name: 
// Module Name: id_exe_pipeline_reg
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


module id_exe_pipeline_reg(
    input wire clk,resetn,pause,flush,
    input wire i_id_RegWrite,
    input wire i_id_mem_w,
    input wire [4:0] i_id_ALUOp,
    input wire i_id_ALUSrc,
    input wire [2:0] i_id_dm_ctrl,
    input wire [1:0] i_id_WDSel,
    input wire [2:0] i_id_NPCOp,
    input wire [31:0] i_id_pc,
    input wire [31:0] i_id_RD1,
    input wire [31:0] i_id_RD2,
    input wire [31:0] i_id_immout,
    input wire [4:0] i_id_rd,
    input wire [4:0] i_id_rs1,
    input wire [4:0] i_id_rs2,
    input wire i_id_ltype,
    output reg  o_exe_RegWrite,
    output reg  o_exe_mem_w,
    output reg [4:0] o_exe_ALUOp,
    output reg o_exe_ALUSrc,
    output reg [2:0] o_exe_dm_ctrl,
    output reg [1:0] o_exe_WDSel,
    output reg [2:0] o_exe_NPCOp,
    output reg [31:0] o_exe_pc,
    output reg [31:0] o_exe_RD1,
    output reg [31:0] o_exe_RD2,
    output reg [31:0] o_exe_immout,
    output reg [4:0] o_exe_rd,
    output reg [4:0] o_exe_rs1,
    output reg [4:0] o_exe_rs2,
    output reg o_exe_ltype
    );
    always@(posedge clk or posedge resetn) begin
        // if(pause) begin
        //     //do nothing
        // end
        // if(flush || pause||resetn) begin
        //     o_exe_RegWrite <= 0;
        //     o_exe_mem_w <= 0;
        //     o_exe_ALUOp <= 0;
        //     o_exe_ALUSrc <= 0;
        //     o_exe_dm_ctrl <= 0;
        //     o_exe_WDSel <= 0;
        //     o_exe_NPCOp <= 0;
        //     o_exe_pc <= 0;
        //     o_exe_RD1 <= 0;
        //     o_exe_RD2 <= 0;
        //     o_exe_immout <= 0;
        //     o_exe_rd <= 0;
        //     o_exe_rs1 <= 0;
        //     o_exe_rs2 <= 0;
        //     o_exe_ltype <= 0;
        // end
        if(flush || resetn) begin
            o_exe_RegWrite <= 0;
            o_exe_mem_w <= 0;
            o_exe_ALUOp <= 0;
            o_exe_ALUSrc <= 0;
            o_exe_dm_ctrl <= 0;
            o_exe_WDSel <= 0;
            o_exe_NPCOp <= 0;
            o_exe_pc <= 0;
            o_exe_RD1 <= 0;
            o_exe_RD2 <= 0;
            o_exe_immout <= 0;
            o_exe_rd <= 0;
            o_exe_rs1 <= 0;
            o_exe_rs2 <= 0;
            o_exe_ltype <= 0;
        end
        else if(pause) begin
            o_exe_RegWrite <= 0;
            o_exe_mem_w <= 0;
            o_exe_ALUOp <= 0;
            o_exe_ALUSrc <= 0;
            o_exe_dm_ctrl <= 0;
            o_exe_WDSel <= 0;
            o_exe_NPCOp <= 0;
            o_exe_pc <= 0;
            o_exe_RD1 <= 0;
            o_exe_RD2 <= 0;
            o_exe_immout <= 0;
            o_exe_rd <= 0;
            o_exe_rs1 <= 0;
            o_exe_rs2 <= 0;
            o_exe_ltype <= 0;
        end
        else begin
            o_exe_RegWrite <= i_id_RegWrite;
            o_exe_mem_w <= i_id_mem_w;
            o_exe_ALUOp <= i_id_ALUOp;
            o_exe_ALUSrc <= i_id_ALUSrc;
            o_exe_dm_ctrl <= i_id_dm_ctrl;
            o_exe_WDSel <= i_id_WDSel;
            o_exe_NPCOp <= i_id_NPCOp;
            o_exe_pc <= i_id_pc;
            o_exe_RD1 <= i_id_RD1;
            o_exe_RD2 <= i_id_RD2;
            o_exe_immout <= i_id_immout;
            o_exe_rd <= i_id_rd;
            o_exe_rs1 <= i_id_rs1;
            o_exe_rs2 <= i_id_rs2;
            o_exe_ltype <= i_id_ltype;
        end
    end
endmodule
