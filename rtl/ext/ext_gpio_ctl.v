module ExtGpioCtl(
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

    // 读写地址
    addr,

    // 数据（写）
    data_w,

    // 数据（读）
    data_r,

    // GPIO输入
    gpio_in,

    // GPIO输出
    gpio_out
);

    // ========================================
    // 常量定义
    // ========================================
    parameter   ADDR_WIDTH  = 32;
    parameter   DATA_WIDTH  = 32;



    // 范围：0xf0000000 ~ 0xf00000ff
    parameter   GPIO_IN_VAL_ADDR = 32'hf0000000;
    parameter   GPIO_OUT_VAL_ADDR = 32'hf0000004;




    // ========================================
    // 端口类型定义
    // ========================================
    input   wire                        sys_clk;
    
    input   wire                        sys_rst;

    input   wire                        op;
    
    input   wire                        rw;
    
    input   wire [ADDR_WIDTH - 1:0]     addr;

    input   wire [DATA_WIDTH - 1:0]     data_w;

    output  reg [DATA_WIDTH - 1:0]      data_r;

    input   wire [31:0]                 gpio_in;
    
    output  reg [31:0]                  gpio_out;




    // ========================================
    // 字段定义
    // ========================================

    reg [31:0]                          gpio_in_val;

    reg [31:0]                          gpio_out_val;




    // ========================================
    // 逻辑定义
    // ========================================

    initial begin
        gpio_in_val <= 32'd0;
        gpio_out_val <= 32'd0;
    end

    // 处理gpio_out_val写
    always @(negedge sys_clk) begin
        if (sys_rst == 1'b1) begin
            gpio_out_val <= 32'd0;
        end
        else begin
            if (op == 1'b1
                    && rw == 1'b1
                    && addr == GPIO_OUT_VAL_ADDR) begin
                gpio_out_val <= data_w;
            end
            else begin
                gpio_out_val <= gpio_out_val;
            end
        end
    end

    // 处理读
    always @(negedge sys_clk) begin
        if (sys_rst == 1'b1) begin
            data_r <= 32'd0;
        end
        else begin
            if (op == 1'b1
                    && rw == 0'b0) begin
                if (addr == GPIO_IN_VAL_ADDR) begin
                    data_r <= gpio_in_val;
                end
                else if (addr == GPIO_OUT_VAL_ADDR) begin
                    data_r <= gpio_out_val;
                end
                else begin
                    data_r <= 32'd0;
                end
            end
            else begin
                data_r <= 32'd0;
            end
        end
    end

    // 处理输出
    always @(negedge sys_clk) begin
        if (sys_rst == 1'b1) begin
            gpio_out <= 32'd0;
        end
        else begin
            gpio_out <= gpio_out_val;
        end
    end

    // 处理输入
    always @(negedge sys_clk) begin
        if (sys_rst == 1'b1) begin
            gpio_in_val <= 32'd0;
        end
        else begin
            gpio_in_val <= gpio_in;
        end
    end

endmodule
