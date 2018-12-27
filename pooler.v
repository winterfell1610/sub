`timescale 1ns / 1ps

module pooler(
    input         clk,
    input         ce,
    input         master_rst,
    input  [7:0]  data_in,
    output [7:0]  data_out,
    output        valid_op,
    output        end_op
    );
    wire rst_m,op_en,pause_ip,load_sr,global_rst;
    wire [1:0] sel;
    wire [7:0] comp_op;
    wire [7:0] shift_out;
    wire [7:0] reg_op;
    wire [7:0] mux_out;

    wire [7:0] data_in_temp;
    assign data_in_temp = data_in ;
    /*reg  [7:0] mux_out_temp;
    always @(posedge clk ) begin
      mux_out_temp <= mux_out;
    end
    */
    wire temp_rst;
    //parameter m = 9'h00c;
    //parameter p = 9'h003;
    assign temp_rst = master_rst;
    control_logic2  control0(
	    clk,
	    master_rst,
	    ce,
	    sel,
	    rst_m,
	    valid_op,
	    load_sr,
	    global_rst,
	    end_op);
    
    comparator2 comparator1(
	    data_in_temp,
	    mux_out,
	    comp_op);
    wire temp2;
    
    max_reg max_reg2(
    	.clk(clk),
	    .din(comp_op),
	    .rst_m(rst_m),
	    .global_rst(temp2),
	    .master_rst(master_rst),
	    .reg_op(reg_op)
      );
    
    reg [7:0] temp;
    
    shifter_row shift3 (
      //.clk(clk),    // input wire CLK
      //.A((m/p)-4),  // input wire [7 : 0] A
      //.A(0),  // input wire [7 : 0] A
      .in(comp_op),  // input wire [7 : 0] D
      .CE(load_sr), // input wire CE
      .rst(global_rst||temp_rst),  // input wire SCLR
      .shift_out(shift_out)         // output wire [7 : 0] Q
    );
    input_mux mux4(shift_out,reg_op,sel,mux_out);
    assign data_out = reg_op;
   //assign data_out = (valid_op)? reg_op:data_out;
endmodule
