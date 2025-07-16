`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 11:17:45
// Design Name: 
// Module Name: PC_add
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


module PC_add(
    input[31:0] pc,
    input[31:0] imm,
    output reg [31:0] pcImm
    );
    always @(*) begin
        pcImm = pc + imm;
    end
endmodule
