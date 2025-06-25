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
    data_r
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

    output  wire [DATA_WIDTH - 1:0]     data_r;




    assign data_r = 32'h1a2b3c4d;



endmodule
