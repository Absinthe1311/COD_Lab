`include "ctrl_encode_def.v"

//对此模块进行修改，NPC模块用于选择下一条指令的地址
//下一条指令的地址交给其他模块完成

module NPC(
   input [31:0] pc4,
   input Zero,
   input [2:0] NPCOp,
   input [31:0] pcImm,  //这个的计算好像有问题
   input [31:0] rs1Imm,
   output reg[31:0] NPC,
   output reg flush
); 
   wire [2:0] True_NPCOp = {NPCOp[2:1],(NPCOp[0]&Zero)};

   always @ (*) begin
      case(True_NPCOp)
         `NPC_PLUS4:
         begin
            NPC = pc4;
            flush = 0;
         end
         `NPC_BRANCH: 
         begin
            NPC = pcImm;
            flush = 1;
         end
         `NPC_JUMP: 
         begin
            NPC = pcImm;
            flush = 1;
         end
         `NPC_JALR:   
         begin
            NPC = rs1Imm;
            flush = 1;
         end
         default: 
         begin
            NPC =pc4;
            flush = 0;
         end
      endcase
   end
endmodule
