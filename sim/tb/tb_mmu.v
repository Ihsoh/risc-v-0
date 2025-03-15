`timescale 1ns / 1ns

module TB_MMU();

    parameter  CLK_PERIOD = 20;

    parameter   ADDR_WIDTH  = 32;
    parameter   DATA_WIDTH  = 32;

    parameter   BYTE_WIDTH = 8;

    parameter   SIZE    =   256;

    parameter   DELAY_BATCH_WRITE   = 100;
    parameter   DELAY_BATCH_READ    = 100;
    parameter   DELAY_READ_CHECK    = 100;

    reg             sys_clk;
    reg             sys_rst;

    reg             op;

    reg             rw;

    reg [ADDR_WIDTH - 1:0]      addr;

    reg [DATA_WIDTH - 1:0]       data_w;

    wire [DATA_WIDTH - 1:0]       data_r;

    integer i;

    initial begin
        sys_clk <= 0;
        sys_rst <= 1;
        op <= 0;
        rw <= 0;
        addr <= 0;
        data_w <= 0;

        // 批量写
        for (i = 0; i < (SIZE / ADDR_WIDTH); i = i + 1) begin
            #DELAY_BATCH_WRITE;
            sys_rst <= 0;
            data_w <= i;
            addr <= i * (ADDR_WIDTH / BYTE_WIDTH);
            rw <= 1;
            op <= 1;
        end

        // 批量读
        for (i = 0; i < (SIZE / ADDR_WIDTH); i = i + 1) begin
            #DELAY_BATCH_READ;
            addr <= i * (ADDR_WIDTH / BYTE_WIDTH);
            rw <= 0;
            op <= 1;

            #DELAY_READ_CHECK;
            if (data_r != i) begin
                $error(
                    "[TB_MMU(%d)] CHECK ERROR: Address = %d",
                    DATA_WIDTH,
                    i * (ADDR_WIDTH / BYTE_WIDTH)
                );
                $stop;
            end
        end

        $display(
            "[TB_MMU(%d)] CHECK PASSED!",
            DATA_WIDTH
        );
    end

    always #(CLK_PERIOD / 2) sys_clk = ~sys_clk;

    MMU
        #(
            .ADDR_WIDTH(ADDR_WIDTH),
            .DATA_WIDTH(DATA_WIDTH),
            .BYTE_WIDTH(BYTE_WIDTH),
            .SIZE(SIZE)
        )
        u_mmu(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .op(op),
            .rw(rw),
            .addr(addr),
            .data_w(data_w),
            .data_r(data_r)
        );

endmodule
