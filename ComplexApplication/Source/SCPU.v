`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/26 15:52:52
// Design Name: 
// Module Name: SCPU
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

`include "ctrl_encode_def.v"
module SCPU(
    input wire clk,
    input wire reset,
    input wire MIO_ready,  //Not used

    input wire [31:0] inst_in,  //指令输入总线
    input wire [31:0] Data_in, //   数据输入总线
    input wire INT,  //中断
    output wire [2:0] dm_ctrl, // 在top中使用，但是没有定义，现在补充这个定义

    output wire mem_w,  //存储器读写控制
    output wire [31:0] PC_out, //程序空间访问指针  在IF阶段已经赋值
    output wire [31:0] Addr_out, //数据空间访问地址 
    output wire [31:0] Data_out, //数据输出总线
    output wire CPU_MIO //Not used
    );

    /****** Signal Declarations *******/
    wire pause;         //用于数据冒险的停顿
    wire flush;         //用于控制冒险的清空
    /************ IF Stage ************/
    wire [31:0] if_pc;       //if阶段取出来的pc
    wire [31:0] pc_next;     //next value of pc
    wire [31:0] if_pc_plus4; //if_pc+4
    assign PC_out = if_pc;  //通过if_pc传给PC_out在IM中取指

    /************ ID Stage ************/
    //get the pc and instr from the pipeline register
    wire [31:0] id_pc;
    wire [31:0] id_instr;
    //decode the instr
    //1.for the ctrl
    wire [6:0] Op;  // = inst_in[6:0];
    wire [2:0] Funct3;  // = inst_in[14:12];
    wire [6:0] Funct7;  // = inst_in[31:25];
    //2.for the RF
    wire [4:0] id_rs1;  // = inst_in[19:15];
    wire [4:0] id_rs2;  // = inst_in[24:20];
    wire [4:0] id_rd;   // = inst_in[11:7]; //pass to tht id/exe reg
    //3.for the EXT
    wire [4:0] iimm_shamt ;//inst_in[24:20];
    wire [11:0] iimm ;// inst_in[31:20];
    wire [11:0] simm ; //{instr[31:25],instr[11:7]};
    wire [11:0] bimm ;//= {inst_in[31],inst_in[7],inst_in[30:25],inst_in[11:8]};
    wire [19:0] uimm ;// inst_in[31:12];
    wire [19:0] jimm ;// {inst_in[31],inst_in[19:12],inst_in[20],inst_in[30:21]};
    //output in the ID stage
    //1.from the ctrl
    wire id_RegWrite;
    wire id_mem_w;
    wire [4:0] id_ALUOp;
    wire id_ALUSrc;
    wire [2:0] id_dm_ctrl;
    wire [1:0] id_WDSel;
    wire [2:0] id_NPCOp;
    wire [5:0] EXTOp;
    wire id_ltype;  //这个信号用于显示是否要读内存，用于之后的hazard_dection_unit
    wire [1:0] GPRSel; //好像还没用到
    //2.from the RF
    wire [31:0] id_RD1;
    wire [31:0] id_RD2;
    //3.from the EXT
    wire [31:0] id_immout;


    /************ EXE Stage ************/
    //get the data from the pipeline register
    wire exe_RegWrite;
    wire exe_mem_w;
    wire [4:0] exe_ALUOp;
    wire exe_ALUSrc;
    wire [2:0] exe_dm_ctrl;
    wire [1:0] exe_WDSel;
    wire [2:0] exe_NPCOp;
    wire [31:0] exe_pc;
    wire [31:0] exe_RD1;
    wire [31:0] exe_RD2;
    wire [4:0] exe_rd;
    wire [31:0] exe_immout;
    wire [4:0] exe_rs1; //for the forward unit
    wire [4:0] exe_rs2; //for the forward unit
    wire exe_ltype; //for the hazard detection unit
    //input in the exe stage
    //wire [31:0] B_temp = (exe_ALUSrc) ? exe_immout : exe_RD2;
    //wire [31:0] B_temp;
    wire [31:0]true_exe_RD2;
    //the real input for the ALU
    wire [31:0] A;
    wire [31:0] B;
    //output in the exe stage
    wire [31:0] exe_aluout; 
    wire exe_Zero;
    //output from the ForwardA
    wire [1:0] ForwardA;
    //output from the ForwardB
    wire [1:0] ForwardB;
    //output from the add_4
    wire [31:0] exe_pc_plus4;
    //output from the pc_add
    wire [31:0] exe_pcImm;

    /************ MEM Stage ************/
    //get the data from the pipeline register
    wire [31:0] mem_pc_plus4;
    wire mem_RegWrite;
    wire mem_mem_w;
    wire [2:0] mem_dm_ctrl;
    wire [1:0] mem_WDSel;
    wire [31:0] mem_aluout;
    wire [4:0] mem_rd;
    wire [31:0] mem_RD2;
    wire [31:0] mem_data_in;
    //用于NPC
    wire [2:0] mem_NPCOp; 
    wire mem_Zero;
    wire [31:0] mem_pcImm;

    /************ WB Stage ************/
    //get the data from the pipeline register
    wire [31:0] wb_pc_plus4;
    wire wb_RegWrite;
    wire [1:0]wb_WDSel;
    wire [31:0] wb_data_in;
    wire [31:0] wb_aluout;
    wire [4:0] wb_rd;
    //wire [31:0] wb_pc_plus4 = wb_pc + 4; //好像有问题
    //wire [31:0] wb_pc_plus4;
    wire [31:0] wb_WD; //the data write to reg
    /************************************************************************************/
    /************************************************************************************/
    /************************************************************************************/

    
    /********************************** IF Stage ******************************************/
    /************ PC ************/
    PC U_PC(
        .clk(clk),.rst(reset),.NPC(pc_next),.PC(if_pc),.pause(pause),.flush(flush)
    );  //checked
    /************ add_4 ************/
    add_4 U_add_4_if(
        .pc(if_pc),.pc_4(if_pc_plus4)
    );
    /*********** NPC ************/
    NPC U_NPC(
        .pc4(if_pc_plus4),.Zero(mem_Zero),.NPCOp(mem_NPCOp),.pcImm(mem_pcImm),.rs1Imm(mem_aluout),
        .NPC(pc_next),.flush(flush)
    );

    /***************** IF/ID REG ****************/
    if_id_pipeline_reg if_id_reg(
        .clk(clk),.resetn(reset),.pause(pause),
        // .i_we(0), //not used now
        // .i_flush(0), //not used now
        .i_if_pc(if_pc),.i_if_instr(inst_in),
        .o_id_pc(id_pc),.o_id_instr(id_instr),
        .flush(flush)
    );  //checked

    /********************************** ID Stage ******************************************/
    /************ id ************/ //for the instruction decode
    id U_id(
        .instr(id_instr),.opcode(Op),.funct3(Funct3),.funct7(Funct7),
        .rs1(id_rs1),.rs2(id_rs2),.rd(id_rd)
    );
    /************ EXT_Imm ************/ //for the input of ext
    EXT_Imm U_EXT_Imm(
        .instr(id_instr),.iimm_shamt(iimm_shamt),
        .iimm(iimm),.simm(simm),.bimm(bimm),.uimm(uimm),.jimm(jimm)
    );
    /*********** CONTROL UNIT **********/
    ctrl U_ctrl(
        .Op(Op),.Funct7(Funct7),.Funct3(Funct3),
        .RegWrite(id_RegWrite),.MemWrite(id_mem_w),
        .EXTOp(EXTOp),.ALUOp(id_ALUOp),.NPCOp(id_NPCOp),
        .ALUSrc(id_ALUSrc),.GPRSel(GPRSel),.WDSel(id_WDSel),.dm_ctrl(id_dm_ctrl),
        .id_ltype(id_ltype)
    );  //checked
    /*********** RF ************/
    RF U_RF(
        .clk(clk),.rst(reset),
        .RFWr(wb_RegWrite),
        .A1(id_rs1),.A2(id_rs2),.A3(wb_rd),
        .WD(wb_WD),
        .RD1(id_RD1),.RD2(id_RD2)
    );  
    /*********** EXT ************/
    EXT U_EXT(
        .iimm_shamt(iimm_shamt),.iimm(iimm),.simm(simm),.bimm(bimm),
        .uimm(uimm),.jimm(jimm),
        .EXTOp(EXTOp),.immout(id_immout)
    );  //checked

    /***************** ID/EXE REG ****************/   
    id_exe_pipeline_reg id_exe_reg(
        .clk(clk),.resetn(reset),.pause(pause),.flush(flush),
        .i_id_RegWrite(id_RegWrite),
        .i_id_mem_w(id_mem_w),
        .i_id_ALUOp(id_ALUOp),
        .i_id_ALUSrc(id_ALUSrc),
        .i_id_dm_ctrl(id_dm_ctrl),
        .i_id_WDSel(id_WDSel),
        .i_id_NPCOp(id_NPCOp),
        .i_id_pc(id_pc),
        .i_id_RD1(id_RD1),
        .i_id_RD2(id_RD2),
        .i_id_immout(id_immout),
        .i_id_rd(id_rd),
        .i_id_rs1(id_rs1),
        .i_id_rs2(id_rs2),
        .i_id_ltype(id_ltype),
        .o_exe_RegWrite(exe_RegWrite),
        .o_exe_mem_w(exe_mem_w),
        .o_exe_ALUOp(exe_ALUOp),
        .o_exe_ALUSrc(exe_ALUSrc),
        .o_exe_dm_ctrl(exe_dm_ctrl),
        .o_exe_WDSel(exe_WDSel),
        .o_exe_NPCOp(exe_NPCOp),
        .o_exe_pc(exe_pc),
        .o_exe_RD1(exe_RD1),
        .o_exe_RD2(exe_RD2),
        .o_exe_immout(exe_immout),
        .o_exe_rd(exe_rd),
        .o_exe_rs1(exe_rs1),
        .o_exe_rs2(exe_rs2),
        .o_exe_ltype(exe_ltype)
    );  //checked

    /********************************** EXE Stage ******************************************/
    /************ ALU ************/
    alu U_alu(
        .A(A),.B(B),.ALUOp(exe_ALUOp),.PC(exe_pc),.C(exe_aluout),.Zero(exe_Zero)
    ); //checked
    // /************ Mux_2to1 ************/
    // Mux_2to1 U_MuxB_temp(
    //     .a(exe_RD2),.b(exe_immout),.signal(exe_ALUSrc),.out(B_temp)
    // );
    /************ Mux_3to1 ************/
    Mux_3to1 U_MuxA(
        .inputA(exe_RD1),.inputB(wb_WD),.inputC(mem_aluout),.select(ForwardA),.selected_out(A)
    );
    Mux_3to1 U_MuxB(
        .inputA(exe_RD2),.inputB(wb_WD),.inputC(mem_aluout),.select(ForwardB),.selected_out(true_exe_RD2)
    );
    /************ Mux_2to1 ************/
    Mux_2to1 U_MuxB_temp(
        .a(true_exe_RD2),.b(exe_immout),.signal(exe_ALUSrc),.out(B)
    );
    /************ add_4 ************/
    add_4 U_add_4_exe(
        .pc(exe_pc),.pc_4(exe_pc_plus4)
    );
    /************ pc_add ************/
    PC_add U_PC_add(
        .pc(exe_pc),.imm(exe_immout),.pcImm(exe_pcImm)
    );
    /***************** EXE/MEM REG ****************/    
    exe_mem_pipeline_reg exe_mem_reg(
        .clk(clk),.resetn(reset),.flush(flush),
        .i_exe_RegWrite(exe_RegWrite),
        .i_exe_mem_w(exe_mem_w),
        .i_exe_dm_ctrl(exe_dm_ctrl),
        .i_exe_WDSel(exe_WDSel),
        .i_exe_aluout(exe_aluout),
        .i_exe_rd(exe_rd),
        .i_exe_RD2(true_exe_RD2),
        .i_exe_pc_plus4(exe_pc_plus4),
        .i_exe_pcImm(exe_pcImm),
        .i_exe_Zero(exe_Zero),
        .i_exe_NPCOp(exe_NPCOp),
        .o_mem_RegWrite(mem_RegWrite),
        .o_mem_mem_w(mem_mem_w),
        .o_mem_dm_ctrl(mem_dm_ctrl),
        .o_mem_WDSel(mem_WDSel),
        .o_mem_aluout(mem_aluout),
        .o_mem_rd(mem_rd),
        .o_mem_RD2(mem_RD2),
        .o_mem_pc_plus4(mem_pc_plus4),
        .o_mem_pcImm(mem_pcImm),
        .o_mem_Zero(mem_Zero),
        .o_mem_NPCOp(mem_NPCOp)
    );

    /********************************** Mem Stage ******************************************/
    /************ Assignment to output variables for using DM ************/ //放在一个模块里面试试 mem_data_in
    // assign Addr_out = mem_aluout;
    // assign Data_out = mem_RD2;
    // assign mem_w = mem_mem_w;
    // assign dm_ctrl = mem_dm_ctrl;
    /************ DM ************/
    DM U_DM(
        .mem_aluout(mem_aluout),.data_in(Data_in),
        .mem_RD2(mem_RD2),.mem_mem_w(mem_mem_w),
        .mem_dm_ctrl(mem_dm_ctrl),
        .mem_data_in(mem_data_in),.Addr_out(Addr_out),.Data_out(Data_out),
        .mem_w(mem_w),.dm_ctrl(dm_ctrl)
    );

    /***************** MEM/WB REG ****************/  
    mem_wb_pipeline_reg mem_wb_reg(
        .clk(clk),.resetn(reset),
        .i_mem_RegWrite(mem_RegWrite),
        .i_mem_WDSel(mem_WDSel),
        .i_mem_data_in(mem_data_in),
        .i_mem_aluout(mem_aluout),
        .i_mem_rd(mem_rd),
        .i_mem_pc_plus4(mem_pc_plus4),
        .o_wb_RegWrite(wb_RegWrite),
        .o_wb_WDSel(wb_WDSel),
        .o_wb_data_in(wb_data_in),
        .o_wb_aluout(wb_aluout),
        .o_wb_rd(wb_rd),
        .o_wb_pc_plus4(wb_pc_plus4)
    );
    


    /********************************** WB Stage ******************************************/
    /************ mux_3to1 ************/ 
    Mux_3to1 U_MuxWD(
        .inputA(wb_aluout),.inputB(wb_data_in),.inputC(wb_pc_plus4),.select(wb_WDSel),.selected_out(wb_WD)
    );


    /*==================================    Forward Unit    =================================================*/
    Forward U_Forward(
        .exe_rs1(exe_rs1),.exe_rs2(exe_rs2),.mem_rd(mem_rd),.wb_rd(wb_rd),.mem_RegWrite(mem_RegWrite),.wb_RegWrite(wb_RegWrite),
        .ForwardA(ForwardA),.ForwardB(ForwardB)
    );

    /*==================================    Hazard Detection Unit    =================================================*/
    hazard_detection_unit U_hazard_detection_unit(
        .id_rs1(id_rs1),.id_rs2(id_rs2),.exe_rd(exe_rd),.exe_ltype(exe_ltype),.pause(pause)
    );
endmodule