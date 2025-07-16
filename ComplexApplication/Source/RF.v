
  module RF(   input         clk, 
               input         rst,
               input         RFWr, 
               input  [4:0]  A1, A2, A3, 
               input  [31:0] WD, 
               output reg [31:0] RD1, RD2);

  reg [31:0] rf[31:0];

   integer i;

//   always @(posedge clk, posedge rst)
//     if (rst) begin    //  reset
//       for (i=1; i<32; i=i+1)
//         rf[i] <= 0; //  i;
//     end
      
//     else 
//       if (RFWr) begin
//         rf[A3] <= WD;
// //        $display("r[00-07]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", 0, rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7]);
// //        $display("r[08-15]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[8], rf[9], rf[10], rf[11], rf[12], rf[13], rf[14], rf[15]);
// //        $display("r[16-23]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[16], rf[17], rf[18], rf[19], rf[20], rf[21], rf[22], rf[23]);
// //        $display("r[24-31]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[24], rf[25], rf[26], rf[27], rf[28], rf[29], rf[30], rf[31]);
// //        $display("r[%2d] = 0x%8X,", A3, WD);
//       end


//   reg[31:0] RD1_reg;
//   reg[31:0] RD2_reg;
//   always @(negedge clk)
//   begin
//     RD1_reg <= (A1 != 0) ? rf[A1] : 0;
//     RD2_reg <= (A2 != 0) ? rf[A2] : 0;
//   end

//   assign RD1 = RD1_reg;
//   assign RD2 = RD2_reg;
//   //assign reg_data = (reg_sel != 0) ? rf[reg_sel] : 0; 


always @(posedge clk) begin
    if(RFWr && A3 != 5'h0) rf[A3] = WD;
end

initial begin
    for ( i = 0; i < 32; i = i + 1) begin
        rf[i] = 32'b0;
    end
    // rf[5'd2] = 32'd128; // 栈指针初始化
end

always @(negedge clk) begin
    if(A1 == 5'h0)begin
        RD1 = 32'h0000_0000;
    end else begin
        if(A1 == A3)begin
            RD1 = WD;
        end else begin
            RD1 = rf[A1];
        end
    end
end

always @(negedge clk) begin
    if(A2 == 5'h0)begin
        RD2 = 32'h0000_0000;
    end else begin
        if(A2 == A3)begin
            RD2 = WD;
        end else begin
            RD2 = rf[A2];
        end
    end
end

endmodule 
