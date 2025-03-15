`timescale 1ns / 1ns

module TB_CtlUnit(

);

    parameter  CLK_PERIOD = 20;

    reg             sys_clk;
    reg             sys_rst;

    initial begin
        sys_clk = 0;
        sys_rst <= 1;

        #CLK_PERIOD
        sys_rst <= 0;
    end

    always #(CLK_PERIOD / 2) sys_clk = ~sys_clk;

    CtlUnit
        #(
        )
        u_ctl_unit(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst)
        );


endmodule
