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

        // TODO: TEST

        /*
            add x1, x2, x3

            ins = 32'h003100B3
        */
        mem[0] = 8'hB3;
        mem[1] = 8'h00;
        mem[2] = 8'h31;
        mem[3] = 8'h00;




        /*
            lw x1, 0h20(x0)

            ins = 32'h02002083
        */
        // mem[0] = 8'h83;
        // mem[1] = 8'h20;
        // mem[2] = 8'h00;
        // mem[3] = 8'h02;


        /*
            add x1, x2, x3

            ins = 32'h003100B3
        */
        // mem[4] = 8'hB3;
        // mem[5] = 8'h00;
        // mem[6] = 8'h31;
        // mem[7] = 8'h00;

        /*
            bgeu x1, x2, 0b101010101010

            ins = 32'hD420FA63
        */
        // mem[8] = 8'h63;
        // mem[9] = 8'hFA;
        // mem[10] = 8'h20;
        // mem[11] = 8'hD4;


        /*
            DATA
        */
        // mem[32] = 8'h1a;
        // mem[33] = 8'h1b;
        // mem[34] = 8'h1c;
        // mem[35] = 8'h1d;
 


        
        /*
            add x1, x2, x3

            ins = 32'h003100B3
        */
        // mem[0] = 8'hB3;
        // mem[1] = 8'h00;
        // mem[2] = 8'h31;
        // mem[3] = 8'h00;

        /*
            sub x2, x3, x4

            ins = 32'h40418133
        */
        // mem[4] = 8'h33;
        // mem[5] = 8'h81;
        // mem[6] = 8'h41;
        // mem[7] = 8'h40;

        /*
            xor x3, x4, x5

            ins = 32'h005241B3
        */
        // mem[8] = 8'hB3;
        // mem[9] = 8'h41;
        // mem[10] = 8'h52;
        // mem[11] = 8'h00;

        /*
            add x1, x2, 0b101010101010

            ins = 32'hAAA14093
        */
        // mem[12] = 8'h93;
        // mem[13] = 8'h40;
        // mem[14] = 8'hA1;
        // mem[15] = 8'hAA;

        /*
            sw x1, 0b101010101010(x2)

            ins = 32'hAA20A523
        */
        // mem[16] = 8'h23;
        // mem[17] = 8'hA5;
        // mem[18] = 8'h20;
        // mem[19] = 8'hAA;

        /*
            bgeu x1, x2, 0b101010101010

            ins = 32'hD420FA63
        */
        // mem[20] = 8'h63;
        // mem[21] = 8'hFA;
        // mem[22] = 8'h20;
        // mem[23] = 8'hD4;

        /*
            jal x1, 0b10101010101010101010

            ins = 32'hD54550EF
        */
        // mem[24] = 8'hEF;
        // mem[25] = 8'h50;
        // mem[26] = 8'h45;
        // mem[27] = 8'hD5;

        /*
            lui x1, 0b10101010101010101010

            ins = 32'hAAAAA0B7
        */
        // mem[28] = 8'hB7;
        // mem[29] = 8'hA0;
        // mem[30] = 8'hAA;
        // mem[31] = 8'hAA;
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
