module RegFile(
    // 时钟
    sys_clk,

    // 复位
    sys_rst,

    // 操作
    // 0 = 无操作
    // 1 = 操作
    op,

    // 读写标志位
    // 0=读
    // 1=写
    rw,

    // 寄存器
    reg_idx,

    // 数据（写）
    data_w,

    // 数据（读）
    data_r
);
    // ========================================
    // 常量定义
    // ========================================
    parameter   REG_IDX_WIDTH  = 5;
    parameter   DATA_WIDTH  = 32;

    parameter   BYTE_WIDTH = 8;

    parameter   REG_COUNT    =   32;

    // ========================================
    // 端口类型定义
    // ========================================
    input   wire            sys_clk;
    
    input   wire            sys_rst;

    input   wire            op;
    
    input   wire            rw;
    
    input   wire [REG_IDX_WIDTH - 1:0]      reg_idx;

    input   wire [DATA_WIDTH - 1:0]         data_w;

    output  reg [DATA_WIDTH - 1:0]          data_r;

    // ========================================
    // 字段定义
    // ========================================
    reg [DATA_WIDTH - 1:0]      reg_file[REG_COUNT - 1:0];

    integer i;
    initial begin
        for (i = 0; i < REG_COUNT; i = i + 1) begin
            reg_file[i] = 0;
        end


        // TODO: TEST

        reg_file[1] <= 32'd0;

        reg_file[2] <= 32'd1;

        reg_file[3] <= 32'd2;

        // reg_file[0] <= 32'h0a0b0c0d;

        // reg_file[1] <= 32'h1a1b1c1d;

        // reg_file[2] <= 32'h2a2b2c2d;

        // reg_file[3] <= 32'h3a3b3c3d;

        // reg_file[4] <= 32'h4a4b4c4d;






    end

    always @(negedge sys_clk) begin
        if (sys_rst) begin
            data_r <= 0;
        end
        else begin
            if (op == 1'd1 && rw == 1'd0) begin
                data_r <= reg_file[reg_idx];
            end
            else begin
                data_r <= 32'd0;
            end
        end
    end

    always @(negedge sys_clk) begin
        if (sys_rst) begin
            reg_file[reg_idx] <= reg_file[reg_idx];
        end
        else begin
            if (op == 1'd1 && rw == 1'd1) begin
                reg_file[reg_idx] <= data_w;
            end
            else begin
                reg_file[reg_idx] <= reg_file[reg_idx];
            end
        end
    end

endmodule
