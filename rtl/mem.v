module Mem(
    // 时钟
    sys_clk,

    // 复位
    sys_rst,

    // 操作
    // 0=无
    // 1=发起操作
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

    output  reg [DATA_WIDTH - 1:0]      data_r;

    // ========================================
    // 字段定义
    // ========================================
    (* ram_style="block" *) reg [BYTE_WIDTH - 1:0]      mem[SIZE - 1:0];

    integer i;
    initial begin
        for (i = 0; i < SIZE - 1; i = i + 1) begin
            mem[i] = 0;
        end

        mem[0 * 4 + 0] = 8'h37;
        mem[0 * 4 + 1] = 8'h05;
        mem[0 * 4 + 2] = 8'h00;
        mem[0 * 4 + 3] = 8'hf0;

        mem[1 * 4 + 0] = 8'h13;
        mem[1 * 4 + 1] = 8'h05;
        mem[1 * 4 + 2] = 8'h05;
        mem[1 * 4 + 3] = 8'h00;

        mem[2 * 4 + 0] = 8'hb7;
        mem[2 * 4 + 1] = 8'h05;
        mem[2 * 4 + 2] = 8'h00;
        mem[2 * 4 + 3] = 8'hf0;
        
        mem[3 * 4 + 0] = 8'h93;
        mem[3 * 4 + 1] = 8'h85;
        mem[3 * 4 + 2] = 8'h45;
        mem[3 * 4 + 3] = 8'h00;

        mem[4 * 4 + 0] = 8'h37;
        mem[4 * 4 + 1] = 8'hc6;
        mem[4 * 4 + 2] = 8'hb2;
        mem[4 * 4 + 3] = 8'ha1;

        mem[5 * 4 + 0] = 8'h13;
        mem[5 * 4 + 1] = 8'h06;
        mem[5 * 4 + 2] = 8'h46;
        mem[5 * 4 + 3] = 8'h3d;
        
        mem[6 * 4 + 0] = 8'h23;
        mem[6 * 4 + 1] = 8'ha0;
        mem[6 * 4 + 2] = 8'hc5;
        mem[6 * 4 + 3] = 8'h00;
        
        mem[7 * 4 + 0] = 8'h83;
        mem[7 * 4 + 1] = 8'h26;
        mem[7 * 4 + 2] = 8'h05;
        mem[7 * 4 + 3] = 8'h00;

    end

    genvar gi;
    generate
        for (gi = 0; gi < (DATA_WIDTH / BYTE_WIDTH); gi = gi + 1) begin: GENERATE_FOR_LOOP
            always @(negedge sys_clk) begin
                if (sys_rst) begin
                    data_r[(BYTE_WIDTH * (gi + 1)) - 1 : (BYTE_WIDTH * gi)]
                        <= 0;
                end
                else begin
                    if (op == 1'd1 && rw == 1'd0) begin
                        data_r[(BYTE_WIDTH * (gi + 1)) - 1 : (BYTE_WIDTH * gi)]
                            <= mem[addr + gi];
                    end
                    else begin
                        data_r[(BYTE_WIDTH * (gi + 1)) - 1 : (BYTE_WIDTH * gi)]
                            <= data_r[(BYTE_WIDTH * (gi + 1)) - 1 : (BYTE_WIDTH * gi)];
                    end
                    
                end
            end

            always @(negedge sys_clk) begin
                if (sys_rst) begin
                    mem[addr + gi] <= mem[addr + gi];
                end
                else begin
                    if (op == 1'd1 && rw == 1'd1) begin
                        mem[addr + gi] <= data_w[(BYTE_WIDTH * (gi + 1)) - 1 : (BYTE_WIDTH * gi)];
                    end
                    else begin
                        mem[addr + gi] <= mem[addr + gi];
                    end
                end
            end
        end
    endgenerate

endmodule
