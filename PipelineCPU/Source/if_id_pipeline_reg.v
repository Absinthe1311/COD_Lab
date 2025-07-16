`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/12 15:39:42
// Design Name: 
// Module Name: if_id_pipeline_reg
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


module if_id_pipeline_reg(
    input wire clk,resetn,pause,flush, 
    input wire [31:0] i_if_pc,i_if_instr,
    output reg [31:0] o_id_pc,
    output reg [31:0] o_id_instr
    );
    
    always@(posedge clk or posedge resetn)
    begin
        if(resetn || flush) begin
            o_id_pc <= 'b0;
            o_id_instr <= 'b0;
        end
        else if(pause) begin
            //do nothing
        end
        else begin
            o_id_instr <= i_if_instr;
            o_id_pc <= i_if_pc;
        end
    end

endmodule
