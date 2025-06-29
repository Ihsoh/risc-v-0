module ExtCtl(
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




    // ========================================
    // 端口类型定义
    // ========================================
    input   wire            sys_clk;
    
    input   wire            sys_rst;

    input   wire            op;
    
    input   wire            rw;
    
    input   wire [ADDR_WIDTH - 1:0]     addr;

    input   wire [DATA_WIDTH - 1:0]     data_w;

    output  reg [DATA_WIDTH - 1:0]      data_r;

    input   wire [31:0]                 gpio_in;
    
    output  wire [31:0]                 gpio_out;





    // ========================================
    // 字段定义
    // ========================================

    wire [DATA_WIDTH - 1:0]             ext_gpio_ctl_data_r;




    // ========================================
    // 逻辑定义
    // ========================================

    always @(negedge sys_clk) begin
        if (op == 1'b1
                && rw == 1'b0
                && addr >= 32'hf0000000
                && addr <= 32'hf00000ff) begin
            data_r <= ext_gpio_ctl_data_r;
        end
        else begin
            data_r <= 32'd0;
        end
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
            .data_r(ext_gpio_ctl_data_r),
            .gpio_in(gpio_in),
            .gpio_out(gpio_out)
        );

endmodule
