module sccomp(clk, rstn, reg_sel, reg_data);
   input          clk;
   input          rstn;
   input [4:0]    reg_sel;
   output [31:0]  reg_data;
   
   wire [31:0]    instr;
   wire [31:0]    PC;
   wire           MemWrite;
   wire [31:0]    dm_addr, dm_din, dm_dout;
   wire [2:0]     dm_ctrl;
   wire rst = ~rstn;
       
  // instantiation of single-cycle CPU   
   SCPU U_SCPU(
         .clk(clk),                 // input:  cpu clock
         .reset(rst),                 // input:  reset
         .inst_in(instr),             // input:  instruction
         .Data_in(dm_dout),        // input:  data to cpu  
         .mem_w(MemWrite),       // output: memory write signal
         .PC_out(PC),                   // output: PC
         .Addr_out(dm_addr),          // output: address from cpu to memory  //这个好像有问题
         .Data_out(dm_din),        // output: data from cpu to memory        //这个好像有问题*
         //.reg_sel(reg_sel),         // input:  register selection
         //.reg_data(reg_data),        // output: register data
         .dm_ctrl(dm_ctrl)
         );
         
  // instantiation of data memory  
    DM_Test   U_DM(
         .clk(clk),           // input:  cpu clock
         .DMWr(MemWrite),     // input:  ram write
         .addr(dm_addr), // input:  ram address
         .din(dm_din),        // input:  data to ram
         .DMType(dm_ctrl),     //input: DMType
         .dout(dm_dout)       // output: data from ram
         );
         
  // instantiation of intruction memory (used for simulation)
   IM_Test    U_IM ( 
      .addr(PC[8:2]),     // input:  rom address
      .dout(instr)        // output: instruction
   );
        
endmodule

