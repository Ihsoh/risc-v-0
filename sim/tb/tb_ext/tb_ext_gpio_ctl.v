`timescale 1ns / 1ns

module TB_ExtGpioCtl(

);

    parameter  CLK_PERIOD = 20;

    parameter   ADDR_WIDTH  = 32;
    parameter   DATA_WIDTH  = 32;




    reg                             sys_clk;
    reg                             sys_rst;

    reg                             op;

    reg                             rw;

    reg [ADDR_WIDTH - 1:0]          addr;

    reg [DATA_WIDTH - 1:0]          data_w;

    wire [DATA_WIDTH - 1:0]         data_r;

    reg [31:0]                      gpio_in;

    wire [31:0]                     gpio_out;



    always #(CLK_PERIOD / 2) sys_clk = ~sys_clk;

    initial begin
        sys_clk <= 1'b0;
        sys_rst <= 1'b1;
        op <= 1'b0;
        rw <= 1'b0;
        addr <= 32'd0;
        data_w <= 32'd0;
        gpio_in <= 32'd0;

        #20;
        sys_rst <= 1'b0;




        // 写GPIO进行输出
        #20;
        op <= 1'b1;
        rw <= 1'b1;
        addr <= 32'hf0000004;
        data_w <= 32'h12345678;

        // 获取输出结果
        #100;
        $display(
            "gpio_out = %h",
            gpio_out
        );




        // 模拟GPIO输入
        #20;
        gpio_in <= 32'ha1b2c3d4;

        // 读取GPIO输入
        #20;
        op <= 1'b1;
        rw <= 1'b0;
        addr <= 32'hf0000000;

        // 获取输入结果
        #100;
        $display(
            "data_r = %h",
            data_r
        );


    end

    ExtGpioCtl
        #(
            .ADDR_WIDTH(ADDR_WIDTH),
            .DATA_WIDTH(DATA_WIDTH)
        )
        u_ext_gpio_ctl(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .op(op),
            .rw(rw),
            .addr(addr),
            .data_w(data_w),
            .data_r(data_r),
            .gpio_in(gpio_in),
            .gpio_out(gpio_out)
        );

endmodule
