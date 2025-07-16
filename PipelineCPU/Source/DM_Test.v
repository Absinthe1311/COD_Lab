  `include "ctrl_encode_def.v"
// // data memory
// 这个文件用于DM的仿真测试
module DM_Test(clk, DMWr, addr, din, DMType ,dout);
   input          clk;
   input          DMWr;
   input  [31:0]   addr;
   input  [31:0]  din;
   input [2:0]    DMType;
   output reg [31:0]  dout;
     
   reg [31:0] dmem[127:0];
   
   // always @(posedge clk)
   //    if (DMWr) begin
   //       dmem[addr[8:2]] <= din;
   //      $display("dmem[0x%8X] = 0x%8X,", addr << 2, din); 
   //    end


  //DMType
  //dm_word 3'b000
  //dm_halfword 3'b001
  //dm_halfword_unsigned 3'b010
  //dm_byte 3'b011
  //dm_byte_unsigned 3'b100
   always @(posedge clk)
      if(DMWr) begin
         case(DMType)
         `dm_byte:  dmem[addr[8:2]] = { {24{din[7]}}, din[7:0] };
         `dm_byte_unsigned:  dmem[addr[8:2]][7:0] = {{24'b0},din[7:0]};
         `dm_halfword: 
         dmem[addr[8:2]] = {{16{din[15]}},din[15:0]};
         `dm_halfword_unsigned: 
         dmem[addr[8:2]] = {{16'b0},din[15:0]};
         `dm_word:
         dmem[addr[8:2]][31:0] = din[31:0];
         endcase
      end
   
   always@(*)begin
      case(DMType)
      `dm_word: dout = dmem[addr[8:2]][31:0];
      `dm_halfword: dout = {{16{dmem[addr[8:2]][15]}},dmem[addr[8:2]][15:0]};
      `dm_halfword_unsigned: dout = {{16'b0},dmem[addr[8:2]][15:0]};
      `dm_byte: dout = {{24{dmem[addr[8:2]][7]}},dmem[addr[8:2]][7:0]};
      `dm_byte_unsigned: dout = {{24'b0},dmem[addr[8:2]][7:0]};
      endcase
   end
   
   //assign dout = dmem[addr[8:2]];
    
endmodule    


