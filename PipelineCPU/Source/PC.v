module PC( clk, rst, NPC, PC ,pause,flush);
  input            pause;
  input              clk;
  input              rst;
  input       [31:0] NPC;
  input            flush;
  output reg  [31:0] PC;

  always @(posedge clk or posedge rst)
  begin
    if (rst) begin
      PC <= 32'h0000_0000;
//      PC <= 32'h0000_3000;
    end
    else if(flush) begin
      PC <= NPC;
    end
    else if(pause) begin
      //do nothing
    end
    else
      PC <= NPC;
  end
endmodule

