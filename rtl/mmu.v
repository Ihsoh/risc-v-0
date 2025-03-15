module MMU(
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

    parameter   BYTE_WIDTH = 8;

    parameter   SIZE    =   1024;

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

    MemCtl
        #(
            .ADDR_WIDTH(ADDR_WIDTH),
            .DATA_WIDTH(DATA_WIDTH),
            .BYTE_WIDTH(BYTE_WIDTH),
            .SIZE(SIZE)
        )
        u_mem_ctl(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .op(op),
            .rw(rw),
            .addr(addr),
            .data_w(data_w),
            .data_r(data_r)
        );


endmodule
