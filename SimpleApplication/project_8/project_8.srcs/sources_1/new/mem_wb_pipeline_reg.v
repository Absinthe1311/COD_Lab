`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/16 21:03:45
// Design Name: 
// Module Name: mem_wb_pipeline_reg
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


module mem_wb_pipeline_reg(
    input wire clk,resetn,
    input wire i_mem_RegWrite,
    input wire [1:0]i_mem_WDSel,
    input wire [31:0] i_mem_data_in,
    input wire [31:0] i_mem_aluout,
    input wire [4:0] i_mem_rd,
    input wire [31:0] i_mem_pc_plus4,
    output reg o_wb_RegWrite,
    output reg [1:0]o_wb_WDSel,
    output reg [31:0] o_wb_data_in,
    output reg [31:0] o_wb_aluout,
    output reg [4:0] o_wb_rd,
    output reg [31:0] o_wb_pc_plus4
    );
    always@(posedge clk or posedge resetn)
    begin
        if(resetn)
        begin   
            o_wb_RegWrite <= 0;
            o_wb_WDSel <= 0;
            o_wb_data_in <= 0;
            o_wb_aluout <= 0;
            o_wb_rd <= 0;
            o_wb_pc_plus4 <= 0;
        end
        else
        begin
            o_wb_RegWrite <= i_mem_RegWrite;
            o_wb_WDSel <= i_mem_WDSel;
            o_wb_data_in <= i_mem_data_in;
            o_wb_aluout <= i_mem_aluout;
            o_wb_rd <= i_mem_rd;
            o_wb_pc_plus4 <= i_mem_pc_plus4;
        end
    end
endmodule
