`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 17:34:52
// Design Name: 
// Module Name: EXT_Imm
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


module EXT_Imm(
    input[31:0] instr,
    output[4:0] iimm_shamt,
    output[11:0] iimm,
    output[11:0] simm,
    output[11:0] bimm,
    output[19:0] uimm,
    output[19:0] jimm
    );

    assign iimm_shamt = instr[24:20];
    assign iimm = instr[31:20];
    assign simm = {instr[31:25],instr[11:7]}; 
    assign bimm = {instr[31],instr[7],instr[30:25],instr[11:8]};
    assign uimm = {instr[31:12]};
    assign jimm = {instr[31],instr[19:12],instr[20],instr[30:21]};
endmodule
