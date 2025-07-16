`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/18 10:48:08
// Design Name: 
// Module Name: Forward
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


module Forward(
    input wire[4:0] exe_rs1,
    input wire[4:0] exe_rs2,
    input wire[4:0] mem_rd,
    input wire[4:0] wb_rd,
    input mem_RegWrite,
    input wb_RegWrite,
    output reg[1:0] ForwardA,
    output reg[1:0] ForwardB
    );

    always @(*)
    begin
        if(mem_RegWrite && (mem_rd != 0) && (mem_rd == exe_rs1))
            ForwardA = 2'b10;
        else if(wb_RegWrite && (wb_rd != 0) && (wb_rd == exe_rs1))
            ForwardA = 2'b01;
        else
            ForwardA = 2'b00;

        if(mem_RegWrite && (mem_rd != 0) && (mem_rd == exe_rs2))
            ForwardB = 2'b10;
        else if(wb_RegWrite && (wb_rd != 0) && (wb_rd == exe_rs2))
            ForwardB = 2'b01;
        else
            ForwardB = 2'b00;
    end
endmodule
