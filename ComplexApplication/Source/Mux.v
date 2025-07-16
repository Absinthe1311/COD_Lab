`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/18 10:48:26
// Design Name: 
// Module Name: Mux
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

module Mux_3to1
#(parameter DATAWIDTH = 32)
(
    input wire [DATAWIDTH-1:0] inputA, inputB, inputC,
    input wire [1:0] select,
    output reg [DATAWIDTH-1:0] selected_out
);

    always @(*)
    case(select)
        2'b00:
            selected_out = inputA;
        2'b01:
            selected_out = inputB;
        2'b10:
            selected_out = inputC;
        default:
            selected_out = 32'bx;
    endcase
    
endmodule
