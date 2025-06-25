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
    data_r,

    // 操作（外部）
    // 0 = 无操作
    // 1 = 操作
    ext_op,

    // 读写标志位（外部）
    // 0=读
    // 1=写
    ext_rw,

    // 读写地址（外部）
    ext_addr,

    // 数据（写）（外部）
    ext_data_w,

    // 数据（读）（外部）
    ext_data_r,
);

    // ========================================
    // 常量定义
    // ========================================
    parameter   ADDR_WIDTH  = 32;
    parameter   DATA_WIDTH  = 32;

    parameter   BYTE_WIDTH = 8;

    parameter   SIZE    =   1024;




    parameter   EXT_ADDR_WITH = 32'hf0000000;

    // ========================================
    // 端口类型定义
    // ========================================
    input   wire                        sys_clk;
    input   wire                        sys_rst;

    input   wire                        op;
    input   wire                        rw;
    input   wire [ADDR_WIDTH - 1:0]     addr;
    input   wire [DATA_WIDTH - 1:0]     data_w;
    output  wire [DATA_WIDTH - 1:0]     data_r;

    output  wire                        ext_op;
    output  wire                        ext_rw;
    output  wire [ADDR_WIDTH - 1:0]     ext_addr;
    output  wire [DATA_WIDTH - 1:0]     ext_data_w;
    input   wire [DATA_WIDTH - 1:0]     ext_data_r;


    // ========================================
    // 字段定义定义
    // ========================================

    wire                        op_mem;

    wire [DATA_WIDTH - 1:0]     mem_data_r;


    // ========================================
    // 逻辑定义
    // ========================================

    assign mem_op = addr < EXT_ADDR_WITH ? op : 1'b0;
    
    assign ext_op = addr >= EXT_ADDR_WITH ? op : 1'b0;
    assign ext_rw = rw;
    assign ext_addr = addr;
    assign ext_data_w = data_w;
    
    assign data_r = mem_op == 1'b1 ? mem_data_r : ext_data_r;

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
            .op(mem_op),
            .rw(rw),
            .addr(addr),
            .data_w(data_w),
            .data_r(mem_data_r)
        );


endmodule
