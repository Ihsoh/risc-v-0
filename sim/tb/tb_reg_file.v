`timescale 1ns / 1ns

module TB_RegFile();

    parameter  CLK_PERIOD = 20;

    parameter   REG_IDX_WIDTH  = 5;
    parameter   DATA_WIDTH  = 32;

    parameter   BYTE_WIDTH = 8;

    parameter   REG_COUNT    =   32;

    parameter   DELAY_BATCH_WRITE   = 100;
    parameter   DELAY_BATCH_READ    = 100;
    parameter   DELAY_READ_CHECK    = 100;


    reg             sys_clk;
    
    reg             sys_rst;

    reg             op;
    
    reg             rw;
    
    reg [REG_IDX_WIDTH - 1:0]        reg_idx;

    reg [DATA_WIDTH - 1:0]           data_w;

    wire [DATA_WIDTH - 1:0]          data_r;

    integer i;

    initial begin
        sys_clk <= 0;
        sys_rst <= 1;
        op <= 0;
        rw <= 0;
        reg_idx <= 0;
        data_w <= 0;

        // 批量写
        for (i = 0; i < REG_COUNT; i = i + 1) begin
            #DELAY_BATCH_WRITE;
            sys_rst <= 0;
            data_w <= i;
            reg_idx <= i;
            rw <= 1;
            op <= 1;
        end

        // 批量度
        for (i = 0; i < REG_COUNT; i = i + 1) begin
            #DELAY_BATCH_READ;
            reg_idx <= i;
            rw <= 0;
            op <= 1;

            #DELAY_READ_CHECK;
            if (data_r != i) begin
                $error(
                    "[TB_REG_FILE(%d)] CHECK ERROR: Register Index = %d",
                    DATA_WIDTH,
                    i
                );
                $stop;
            end
        end

        $display(
            "[TB_REG_FILE(%d)] CHECK PASSED!",
            DATA_WIDTH
        );
    end

    always #(CLK_PERIOD / 2) sys_clk = !sys_clk;

    RegFile
        #(
            .REG_IDX_WIDTH(REG_IDX_WIDTH),
            .DATA_WIDTH(DATA_WIDTH),
            .BYTE_WIDTH(BYTE_WIDTH),
            .REG_COUNT(REG_COUNT)
        )
        u_reg_file(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .op(op),
            .rw(rw),
            .reg_idx(reg_idx),
            .data_w(data_w),
            .data_r(data_r)
        );

endmodule
