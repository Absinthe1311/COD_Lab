
// instruction memory
module IM_Test(input  [8:2]  addr,
            output [31:0] dout );
   
//  dist_mem_gen_0 u_dist_mem_gen_0(
//    .a(addr),
//    .spo(dout)
//  );
  
  reg  [31:0] ROM[127:0];


  assign dout = ROM[addr]; // word aligned
endmodule  
