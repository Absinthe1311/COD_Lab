`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/19 15:56:25
// Design Name: 
// Module Name: hazard_detection_unit
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

//用于数据冒险的停顿
module hazard_detection_unit(
    input wire[4:0] id_rs1,
    input wire[4:0] id_rs2,
    input wire[4:0] exe_rd,
    input wire exe_ltype,
    output reg pause
    );
    always @(*)
    begin
        pause = 1'b0;
        if(((id_rs1 == exe_rd )|| (id_rs2 == exe_rd)) && exe_ltype)begin
            pause = 1;
        end
    end
endmodule
