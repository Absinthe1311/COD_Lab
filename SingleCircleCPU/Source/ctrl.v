 //`include "ctrl_encode_def.v"

//123
module ctrl(Op, Funct7, Funct3, Zero, 
            RegWrite, MemWrite,
            EXTOp, ALUOp, NPCOp, 
            ALUSrc, GPRSel, WDSel,dm_ctrl
            );
            
   input  [6:0] Op;       // opcode
   input  [6:0] Funct7;    // funct7
   input  [2:0] Funct3;    // funct3
   input        Zero;
   
   output       RegWrite; // control signal for register write
   output       MemWrite; // control signal for memory write
   output [5:0] EXTOp;    // control signal to signed extension
   output [4:0] ALUOp;    // ALU opertion
   output [2:0] NPCOp;    // next pc operation
   output       ALUSrc;   // ALU source for A
	 output [2:0] dm_ctrl;
   output [1:0] GPRSel;   // general purpose register selection
   output [1:0] WDSel;    // (register) write data selection
   
//   // r format
//     wire rtype  = ~Op[6]&Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0110011
//     wire i_add  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // add 0000000 000
//     wire i_sub  = rtype& ~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // sub 0100000 000
//     wire i_or   = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& Funct3[1]&~Funct3[0]; // or 0000000 110
//     wire i_and  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& Funct3[1]& Funct3[0]; // and 0000000 111

 

//  // i format
//    wire itype_l  = ~Op[6]&~Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0000011

// // i format
//     wire itype_r  = ~Op[6]&~Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0010011
//     wire i_addi  =  itype_r& ~Funct3[2]& ~Funct3[1]& ~Funct3[0]; // addi 000
//     wire i_ori  =  itype_r& Funct3[2]& Funct3[1]&~Funct3[0]; // ori 110
	
//  //jalr
// 	wire i_jalr =Op[6]&Op[5]&~Op[4]&~Op[3]&Op[2]&Op[1]&Op[0];//jalr 1100111

//   // s format
//    wire stype  = ~Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//0100011
//    wire i_sw   =  stype& ~Funct3[2]& Funct3[1]&~Funct3[0]; // sw 010

//   // sb format
//    wire sbtype  = Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//1100011
//    wire i_beq  = sbtype& ~Funct3[2]& ~Funct3[1]&~Funct3[0]; // beq
	
//  // j format
//    wire i_jal  = Op[6]& Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0];  // jal 1101111

  //R type   
    wire rtype  = ~Op[6]&Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0110011
    wire r_add=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // add 0000000 000
    wire r_sub=rtype&~Funct7[6]&Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // sub 0100000 000
    wire r_and=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&Funct3[1]&Funct3[0]; // and 0000000 111
    wire r_or = rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&Funct3[1]&~Funct3[0]; // or 0000000 110
    wire r_xor =rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&~Funct3[1]&~Funct3[0]; // xor 0000000 100
    wire r_sll =rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&Funct3[0]; // sll 0000000 001
    wire r_srl =rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&~Funct3[1]&Funct3[0]; // srl 0000000 101
    wire r_sra =rtype&~Funct7[6]&Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&Funct3[2]&~Funct3[1]&Funct3[0]; // sra 0100000 101
    wire r_slt =rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&Funct3[1]&~Funct3[0]; // slt 0000000 010
    wire r_sltu=rtype&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&Funct3[1]&Funct3[0]; // sltu 0000000 011
 
  //I type
  //load
    wire itype_l  = ~Op[6]&~Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0000011
    wire i_lb = itype_l & ~Funct3[2] & ~Funct3[1] & ~Funct3[0];  //lb 000
    wire i_lbu = itype_l & Funct3[2] & ~Funct3[1] & ~Funct3[0];  //lbu 100
    wire i_lh = itype_l & ~Funct3[2] & ~Funct3[1] & Funct3[0];  //lh 001
    wire i_lhu = itype_l & Funct3[2] & ~Funct3[1] & Funct3[0];  //lhu 101
    wire i_lw = itype_l & ~Funct3[2] & Funct3[1] & ~Funct3[0];  //lw 010
  //i
    wire itype_r = ~Op[6] & ~Op[5] & Op[4] & ~Op[3] & ~Op[2] & Op[1] & Op[0];  //0010011
    wire i_addi = itype_r & ~Funct3[2] & ~Funct3[1] & ~Funct3[0];  // addi 000 func3
    wire i_andi = itype_r & Funct3[2] & Funct3[1] & Funct3[0];  // andi 111
    wire i_ori = itype_r & Funct3[2] & Funct3[1] & ~Funct3[0];  // ori 110
    wire i_xori = itype_r & Funct3[2] & ~Funct3[1] & ~Funct3[0];  // xori 100
    wire i_slli = itype_r & ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& ~Funct3[2]& ~Funct3[1]& Funct3[0];   //0000000 001
    wire i_srli = itype_r & ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& ~Funct3[1]& Funct3[0];  //0000000 101
    wire i_srai = itype_r & ~Funct7[6]&Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& ~Funct3[1]& Funct3[0];  //0100000 101
    wire i_slti = itype_r & ~Funct3[2] & Funct3[1] & ~Funct3[0];  // slti 010
    wire i_sltiu = itype_r & ~Funct3[2] & Funct3[1] & Funct3[0];  // sltiu 011

  //B type
    wire btype  = Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//1100011
    wire b_beq = btype & ~Funct3[2] & ~Funct3[1] & ~Funct3[0];  //beq 000
    wire b_bne = btype & ~Funct3[2] & ~Funct3[1] & Funct3[0];  //bne 001
    wire b_bge = btype & Funct3[2] & ~Funct3[1] & Funct3[0];  //bge 101
    wire b_bgeu = btype & Funct3[2] & Funct3[1] & Funct3[0];  //bgeu 111
    wire b_blt = btype & Funct3[2] & ~Funct3[1] & ~Funct3[0];  //blt 100
    wire b_bltu = btype & Funct3[2] & Funct3[1] & ~Funct3[0];  //bltu 110

  //S type
   wire stype  = ~Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//0100011
   wire s_sw   =  stype& ~Funct3[2]& Funct3[1]&~Funct3[0]; // sw 010
   wire s_sb = stype & ~Funct3[2] & ~Funct3[1] & ~Funct3[0];  //sb 000
   wire s_sh = stype && ~Funct3[2] & ~Funct3[1] & Funct3[0];  //sh 001

  //J type
   wire j_jal  = Op[6]& Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0];  // jal 1101111
	 wire i_jalr =Op[6]&Op[5]&~Op[4]&~Op[3]&Op[2]&Op[1]&Op[0]; //jalr 1100111

  //U type
   wire u_lui=~Op[6]& Op[5]&Op[4]& ~Op[3]& Op[2]& Op[1]& Op[0];//lui 0110111
   wire u_auipc=~Op[6]&~Op[5]&Op[4]& ~Op[3]& Op[2]& Op[1]& Op[0];//auipc 0010111


  // generate control signals
  assign RegWrite   = rtype | itype_r | itype_l | i_jalr | j_jal | u_lui | u_auipc; // register write
  assign MemWrite   = stype;                           // memory write
  assign ALUSrc     = itype_r   | i_jalr | u_lui | u_auipc | itype_l |stype;   // ALU B is from instruction immediate

  // signed extension
  // EXT_CTRL_ITYPE_SHAMT 6'b100000  //slli srli....
  // EXT_CTRL_ITYPE	      6'b010000
  // EXT_CTRL_STYPE	      6'b001000
  // EXT_CTRL_BTYPE	      6'b000100
  // EXT_CTRL_UTYPE	      6'b000010
  // EXT_CTRL_JTYPE	      6'b000001
  assign EXTOp[5] =  i_slli | i_srli | i_srai;
  assign EXTOp[4]    =  (itype_l | itype_r | i_jalr) & ~i_slli & ~i_srli & ~i_srai;
  assign EXTOp[3]    = stype; 
  assign EXTOp[2]    = btype; 
  assign EXTOp[1]    = u_auipc | u_lui;   
  assign EXTOp[0]    = j_jal;         


  
  
  // WDSel_FromALU 2'b00
  // WDSel_FromMEM 2'b01
  // WDSel_FromPC  2'b10 
  assign WDSel[0] = itype_l;
  assign WDSel[1] = j_jal | i_jalr;

  // NPC_PLUS4   3'b000
  // NPC_BRANCH  3'b001
  // NPC_JUMP    3'b010
  // NPC_JALR	3'b100
  assign NPCOp[0] = btype & Zero;
  assign NPCOp[1] = j_jal;
	assign NPCOp[2]=i_jalr;
  
// `define ALUOp_nop 5'b00000
// `define ALUOp_lui 5'b00001
// `define ALUOp_auipc 5'b00010
// `define ALUOp_add 5'b00011   // j_jal i_jalr  itype_l stype i_addi r_add 
// `define ALUOp_sub 5'b00100   // b_beq r_sub i_slti i_sltiu 
// `define ALUOp_bne 5'b00101
// `define ALUOp_blt 5'b00110
// `define ALUOp_bge 5'b00111
// `define ALUOp_bltu 5'b01000
// `define ALUOp_bgeu 5'b01001
// `define ALUOp_slt 5'b01010
// `define ALUOp_sltu 5'b01011
// `define ALUOp_xor 5'b01100  //i_xori r_xor
// `define ALUOp_or 5'b01101   //i_ori r_or
// `define ALUOp_and 5'b01110  //i_andi r_and
// `define ALUOp_sll 5'b01111  //i_slli r_sll
// `define ALUOp_srl 5'b10000  //i_srli r_srl
// `define ALUOp_sra 5'b10001  //i_srai r_sra

  assign ALUOp[0] = u_lui | i_addi | r_add | stype | i_jalr | itype_l | b_bne | b_bge | b_bgeu  | i_ori | r_or | i_slli | r_sll | i_srai | r_sra | r_sltu | i_sltiu;
  assign ALUOp[1] = u_auipc | i_addi | r_add | stype | i_jalr | itype_l | b_blt | b_bge  | i_andi | r_and | i_slli | r_sll |r_slt | r_sltu | i_slti | i_sltiu;  
  assign ALUOp[2] = b_beq | r_sub | b_bne | b_blt | b_bge | i_xori | r_xor | i_ori | r_or | i_andi | r_and | i_slli | r_sll   ;
  assign ALUOp[3] = b_bltu | b_bgeu   | i_xori | r_xor | i_ori | r_or | i_andi | r_and | i_slli | r_sll |r_slt | r_sltu | i_sltiu | i_slti;
  assign ALUOp[4] = i_srli | r_srl | i_srai | r_sra;

  //DMType
  //dm_word 3'b000
  //dm_halfword 3'b001
  //dm_halfword_unsigned 3'b010
  //dm_byte 3'b011
  //dm_byte_unsigned 3'b100
  assign dm_ctrl[2] = i_lbu;
  assign dm_ctrl[1] = i_lhu | i_lb | s_sb;
  assign dm_ctrl[0] = i_lh | i_lb | s_sb | s_sh;


endmodule

