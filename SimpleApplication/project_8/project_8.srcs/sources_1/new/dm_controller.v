// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Tue Jun 20 11:12:44 2023
// Host        : LAPTOP-E4IJ843E running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub C:/Users/user/Desktop/projects/edf_file/dm_controller.v
// Design      : dm_controller
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.

//`include "ctrl_encode_def.v"
//这个模块应该也没问题
module dm_controller(mem_w, Addr_in, Data_write, dm_ctrl, 
  Data_read_from_dm, Data_read, Data_write_to_dm, wea_mem);

  input mem_w; // 判断是否是写信号
  input [31:0]Addr_in; // 读取的内存地址
  input [31:0]Data_write; 
  input [2:0]dm_ctrl;     // 内存操作的类型
  input [31:0]Data_read_from_dm;  
  output  [31:0]Data_read;        // 给CPU的经过对齐的数据
  output  [31:0]Data_write_to_dm; // 写给内存的数据
  output  [3:0]wea_mem;           // 具体每一位的wea数据
  

`define dm_word 3'b000
`define dm_halfword 3'b001
`define dm_halfword_unsigned 3'b010
`define dm_byte 3'b011
`define dm_byte_unsigned 3'b100

reg[31:0] D_read;        //之后assign赋值给Data_read
reg[31:0] D_write_to_dm; //之后assign赋值给Data_write_to_dm
reg[3:0]  w_mem;         //之后assign赋值给wea_mem;

always@(*)begin
  D_write_to_dm = 32'b0;
  w_mem = 4'b0000;
  if(mem_w)begin
    case(dm_ctrl)
      `dm_word:begin
        D_write_to_dm = Data_write;
        w_mem = 4'b1111;
      end
      `dm_halfword:begin
        case(Addr_in[1:0])
          2'b00:begin
            D_write_to_dm = {16'b0,Data_write[15:0]};
            w_mem = 4'b0011;
          end
          2'b10:begin
            D_write_to_dm = {Data_write[15:0],16'b0};
            w_mem = 4'b1100;
          end
        endcase
      end
      `dm_halfword_unsigned:begin
        case(Addr_in[1:0])
          2'b00:begin
            D_write_to_dm = {16'b0,Data_write[15:0]};
            w_mem = 4'b0011;
          end
          2'b10:begin
            D_write_to_dm = {Data_write[15:0],16'b0};
            w_mem = 4'b1100;
          end
        endcase
      end
      `dm_byte:begin
        case(Addr_in[1:0])
          2'b00:begin
            D_write_to_dm = {24'b0,Data_write[7:0]};
            w_mem = 4'b0001;
          end
          2'b01:begin
            D_write_to_dm = {16'b0,Data_write[7:0],8'b0};
            w_mem = 4'b0010;
          end
          2'b10:begin
            D_write_to_dm = {8'b0,Data_write[7:0],16'b0};
            w_mem = 4'b0100;
          end
          2'b11:begin
            D_write_to_dm = {Data_write[7:0],24'b0};
            w_mem = 4'b1000;
          end
        endcase
      end
      `dm_byte_unsigned:begin
        case(Addr_in[1:0])
          2'b00:begin
            D_write_to_dm = {24'b0,Data_write[7:0]};
            w_mem = 4'b0001;
          end
          2'b01:begin
            D_write_to_dm = {16'b0,Data_write[7:0],8'b0};
            w_mem = 4'b0010;
          end
          2'b10:begin
            D_write_to_dm = {8'b0,Data_write[7:0],16'b0};
            w_mem = 4'b0100;
          end
          2'b11:begin
            D_write_to_dm = {Data_write[7:0],24'b0};
            w_mem = 4'b1000;
          end
        endcase
      end
    endcase
  end
end

always@(*)begin
  D_read = 32'b0;
  case(dm_ctrl)
    `dm_word:begin
      D_read = Data_read_from_dm;
    end
    `dm_halfword:begin
      case(Addr_in[1:0])
        2'b00:begin
          D_read = {{16{Data_read_from_dm[15]}},Data_read_from_dm[15:0]};
        end
        2'b10:begin
          D_read = {{16{Data_read_from_dm[31]}},Data_read_from_dm[31:16]};
        end
      endcase
    end
    `dm_halfword_unsigned:begin
      case(Addr_in[1:0])
        2'b00:begin
          D_read = {{16'b0},Data_read_from_dm[15:0]};
        end
        2'b10:begin
          D_read = {{16'b0},Data_read_from_dm[31:16]};
        end
      endcase
    end
    `dm_byte:begin
      case(Addr_in[1:0])
        2'b00:begin
          D_read = {{24{Data_read_from_dm[7]}},Data_read_from_dm[7:0]};
        end
        2'b01:begin
          D_read = {{24{Data_read_from_dm[15]}},Data_read_from_dm[15:8]};
        end
        2'b10:begin
          D_read = {{24{Data_read_from_dm[23]}},Data_read_from_dm[23:16]};
        end
        2'b11:begin
          D_read = {{24{Data_read_from_dm[31]}},Data_read_from_dm[31:24]};
        end
      endcase
    end
    `dm_byte_unsigned:begin
      case(Addr_in[1:0])
        2'b00:begin
          D_read = {24'b0,Data_read_from_dm[7:0]};
        end
        2'b01:begin
          D_read = {24'b0,Data_read_from_dm[15:8]};
        end
        2'b10:begin
          D_read = {24'b0,Data_read_from_dm[23:16]};
        end
        2'b11:begin
          D_read = {24'b0,Data_read_from_dm[31:24]};
        end
      endcase
    end
  endcase
end

assign Data_read = D_read;
assign Data_write_to_dm = D_write_to_dm;
assign wea_mem = w_mem;

endmodule