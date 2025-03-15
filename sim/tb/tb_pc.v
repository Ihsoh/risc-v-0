`timescale 1ns / 1ns

module TB_PC(

);

    parameter  CLK_PERIOD = 20;

    reg             sys_clk;
    reg             sys_rst;

    reg             pc_src;
    reg [31:0]      alu_output;
    wire [31:0]      current_pc;
    wire [31:0]      next_pc;

    initial begin
        sys_clk <= 1'b0;
        sys_rst <= 1'b1;
        pc_src <= 1'd0;
        alu_output <= 32'd0;

        #100
        sys_rst <= 1'b0;

        #100
        alu_output <= 32'd1000;
        pc_src <= 1'd1;

        #CLK_PERIOD
        alu_output <= 32'd0;
        pc_src <= 1'd0;



    end

    always #(CLK_PERIOD / 2) sys_clk = ~sys_clk;

    PC u_pc(
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),

        .pc_src(pc_src),
        .alu_output(alu_output),
        .current_pc(current_pc),
        .next_pc(next_pc)
    );

endmodule
