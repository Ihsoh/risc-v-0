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
    end

    /*
        处理读寄存器操作
    */
    always @(negedge sys_clk) begin
        if (sys_rst) begin
            data_r <= 0;
        end
        else begin
            if (op == 1'd1 && rw == 1'd0) begin
                if (reg_idx == 5'd0) begin
                    // 读取0号寄存器的值总是为0
                    data_r <= 32'd0;
                end
                else begin
                    // 读取除了0号寄存器以外的寄存器的值返回相应的值
                    data_r <= reg_file[reg_idx];
                end
            end
            else begin
                data_r <= 32'd0;
            end
        end
    end

    /*
        处理写寄存器操作
    */
    always @(negedge sys_clk) begin
        if (sys_rst) begin
            reg_file[reg_idx] <= reg_file[reg_idx];
        end
        else begin
            if (op == 1'd1 && rw == 1'd1) begin
                if (reg_idx == 5'd0) begin
                    // 写0号寄存器的值将被忽略
                    reg_file[reg_idx] <= reg_file[reg_idx];
                end
                else begin
                    // 写除了0号寄存器以外的寄存器的值将被写入
                    reg_file[reg_idx] <= data_w;
                end
            end
            else begin
                reg_file[reg_idx] <= reg_file[reg_idx];
            end
        end
    end

endmodule
