`timescale 1ns / 1ns

module TB_CtlUnit(

);

    parameter  CLK_PERIOD = 20;

    reg             sys_clk;
    reg             sys_rst;

    reg [31:0]      gpio_in;
    wire [31:0]     gpio_out;

    initial begin
        sys_clk = 0;
        sys_rst <= 1;
        gpio_in <= 32'h12345678;

        #CLK_PERIOD
        sys_rst <= 0;

        #5000;
        $display(
            "gpio_out=%h\n",
            gpio_out
        );

    end

    always #(CLK_PERIOD / 2) sys_clk = ~sys_clk;

    CtlUnit
        #(
        )
        u_ctl_unit(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .gpio_in(gpio_in),
            .gpio_out(gpio_out)
        );


endmodule
