module CtlUnit(
    // 时钟
    input                   sys_clk,
    
    // 下降沿复位
    input                   sys_rst
);

    // ========================================
    // 常量定义
    // ========================================
    
    // CTL_UNIT
    parameter   STATUS_INS_FETCH = 0;
    parameter   STATUS_INS_DEC = 1;
    parameter   STATUS_REG_R = 2;
    parameter   STATUS_MEM_R = 3;
    parameter   STATUS_EXEC = 4;
    parameter   STATUS_REG_W = 5;
    parameter   STATUS_MEM_W = 6;
    parameter   STATUS_PC_NEXT = 7;



    // PC
    // 无...

    // 寄存器文件
    parameter   REG_FILE_REG_IDX_WIDTH  = 5;
    parameter   REG_FILE_DATA_WIDTH  = 32;
    parameter   REG_FILE_BYTE_WIDTH = 8;
    parameter   REG_FILE_REG_COUNT    =   32;

    // MMU
    parameter   MMU_ADDR_WIDTH  = 32;
    parameter   MMU_DATA_WIDTH  = 32;

    parameter   MMU_BYTE_WIDTH = 8;

    parameter   MMU_SIZE    =   1024;

    // ========================================
    // 端口类型定义
    // ========================================
    
    // PC
    reg                         pc_op;
    reg                         pc_pc_src;
    reg  [31:0]                 pc_alu_output;
    wire [31:0]                 pc_current_pc;
    wire [31:0]                 pc_next_pc;

    // 寄存器文件
    wire                                    reg_file_op;
    wire                                    reg_file_rw;
    wire [REG_FILE_REG_IDX_WIDTH - 1:0]     reg_file_reg_idx;
    wire [REG_FILE_DATA_WIDTH - 1:0]        reg_file_data_w;
    wire [REG_FILE_DATA_WIDTH - 1:0]        reg_file_data_r;

    // MMU
    wire                            mmu_op;
    wire                            mmu_rw;
    wire [MMU_ADDR_WIDTH - 1:0]     mmu_addr;
    wire [MMU_DATA_WIDTH - 1:0]     mmu_data_w;
    wire [MMU_DATA_WIDTH - 1:0]     mmu_data_r;

    // 外部模块
    wire                            ext_op;
    wire                            ext_rw;
    wire [MMU_ADDR_WIDTH - 1:0]     ext_addr;
    wire [MMU_DATA_WIDTH - 1:0]     ext_data_w;
    wire [MMU_DATA_WIDTH - 1:0]     ext_data_r;

    // 指令解码
    wire [6:0]  ins_dec_op;
    wire [2:0]  ins_dec_funct3;
    wire [6:0]  ins_dec_funct7;
    wire [4:0]  ins_dec_rs1;
    wire [4:0]  ins_dec_rs2;
    wire [4:0]  ins_dec_rd;
    wire [19:0] ins_dec_imm;

    // 立即数扩展
    reg             imm_ext_type;
    wire [31:0]     imm_ext_ext;

    // 指令执行
    reg             ins_exec_op;

    wire            ins_exec_reg_w_op;
    wire [4:0]      ins_exec_reg_w_reg_idx;
    wire [31:0]     ins_exec_reg_w_reg_val;

    wire            ins_exec_mem_w_op;
    wire [31:0]     ins_exec_mem_w_mem_addr;
    wire [31:0]     ins_exec_mem_w_mem_val;

    wire            ins_exec_reg_pc_w_op;
    wire [31:0]     ins_exec_reg_pc_w_val;

    // ========================================
    // 字段定义
    // ========================================
    
    // 状态
    reg [3:0]       status;

    reg             st_done_ins_fetch_0;
    reg             st_done_ins_fetch;

    reg             st_done_ins_dec;

    reg             st_done_reg_r_0;
    reg             st_done_reg_r_0_a;
    reg             st_done_reg_r_0_b;
    reg             st_done_reg_r_1;
    reg             st_done_reg_r_1_a;
    reg             st_done_reg_r_1_b;
    reg             st_done_reg_r;
    
    
    reg             st_done_mem_r_0;
    reg             st_done_mem_r_1;
    reg             st_done_mem_r_1_a;
    reg             st_done_mem_r_1_b;
    reg             st_done_mem_r;

    reg             st_done_exec_0;
    reg             st_done_exec_1;
    reg             st_done_exec;

    reg             st_done_reg_w_0;
    reg             st_done_reg_w_1;
    reg             st_done_reg_w;

    reg             st_done_mem_w_0;
    reg             st_done_mem_w_1;
    reg             st_done_mem_w;

    reg             st_done_pc_next;

    // MMU
    reg                             union_mmu_op_ins_fetch;
    reg                             union_mmu_rw_ins_fetch;
    reg [MMU_ADDR_WIDTH - 1:0]      union_mmu_addr_ins_fetch;
    reg [MMU_DATA_WIDTH - 1:0]      union_mmu_data_w_ins_fetch;

    reg                             union_mmu_op_mem_r;
    reg                             union_mmu_rw_mem_r;
    reg [MMU_ADDR_WIDTH - 1:0]      union_mmu_addr_mem_r;
    reg [MMU_DATA_WIDTH - 1:0]      union_mmu_data_w_mem_r;

    reg                             union_mmu_op_mem_w;
    reg                             union_mmu_rw_mem_w;
    reg [MMU_ADDR_WIDTH - 1:0]      union_mmu_addr_mem_w;
    reg [MMU_DATA_WIDTH - 1:0]      union_mmu_data_w_mem_w;

    // 寄存器文件
    reg                                     union_reg_file_op_reg_r;
    reg                                     union_reg_file_rw_reg_r;
    reg [REG_FILE_REG_IDX_WIDTH - 1:0]      union_reg_file_reg_idx_reg_r;
    reg [REG_FILE_DATA_WIDTH - 1:0]         union_reg_file_data_w_reg_r;

    reg                                     union_reg_file_op_reg_w;
    reg                                     union_reg_file_rw_reg_w;
    reg [REG_FILE_REG_IDX_WIDTH - 1:0]      union_reg_file_reg_idx_reg_w;
    reg [REG_FILE_DATA_WIDTH - 1:0]         union_reg_file_data_w_reg_w;

    // 指令
    reg [31:0]      current_ins;

    // 寄存器读取
    reg [31:0]      reg_r_rs1;
    reg [31:0]      reg_r_rs2;

    // 内存读取
    reg [31:0]      mem_r_addr;
    reg [31:0]      mem_r_val;

    // 指令执行
    // ......

    // 寄存器写入
    reg                                     reg_w_op;
    reg [REG_FILE_REG_IDX_WIDTH - 1:0]      reg_w_reg_idx;
    reg [REG_FILE_DATA_WIDTH - 1:0]         reg_w_reg_val;

    // 内存写入
    reg                             mem_w_op;
    reg [MMU_ADDR_WIDTH - 1:0]      mem_w_mem_addr;
    reg [MMU_DATA_WIDTH - 1:0]      mem_w_mem_val;

    // PC递增
    reg                             reg_pc_w_op;
    reg [31:0]                      reg_pc_w_val;



    // ========================================
    // 逻辑
    // ========================================

    initial begin
        // 状态
        status <= STATUS_INS_FETCH;

        st_done_ins_fetch_0 <= 1'd0;
        st_done_ins_fetch <= 1'd0;
        
        st_done_ins_dec <= 1'd0;
        
        st_done_reg_r_0 <= 1'd0;
        st_done_reg_r_0_a <= 1'd0;
        st_done_reg_r_0_b <= 1'd0;
        st_done_reg_r_1 <= 1'd0;
        st_done_reg_r_1_a <= 1'd0;
        st_done_reg_r_1_b <= 1'd0;
        st_done_reg_r <= 1'd0;


        st_done_mem_r_0 <= 1'd0;
        st_done_mem_r_1 <= 1'd0;
        st_done_mem_r_1_a <= 1'd0;
        st_done_mem_r_1_b <= 1'd0;
        st_done_mem_r <= 1'd0;
        
        st_done_exec_0 <= 1'd0;
        st_done_exec_1 <= 1'd0;
        st_done_exec <= 1'd0;
        
        st_done_reg_w_0 <= 1'd0;
        st_done_reg_w_1 <= 1'd0;
        st_done_reg_w <= 1'd0;
        
        st_done_mem_w_0 <= 1'd0;
        st_done_mem_w_1 <= 1'd0;
        st_done_mem_w <= 1'd0;

        st_done_pc_next <= 1'd0;

        // MMU
        union_mmu_op_ins_fetch <= 1'd0;
        union_mmu_rw_ins_fetch <= 1'd0;
        union_mmu_addr_ins_fetch <= 32'd0;
        union_mmu_data_w_ins_fetch <= 32'd0;

        union_mmu_op_mem_r <= 1'd0;
        union_mmu_rw_mem_r <= 1'd0;
        union_mmu_addr_mem_r <= 32'd0;
        union_mmu_data_w_mem_r <= 32'd0;

        union_mmu_op_mem_w <= 1'd0;
        union_mmu_rw_mem_w <= 1'd0;
        union_mmu_addr_mem_w <= 32'd0;
        union_mmu_data_w_mem_w <= 32'd0;

        // 寄存器
        union_reg_file_op_reg_r <= 1'b0;
        union_reg_file_rw_reg_r <= 1'b0;
        union_reg_file_reg_idx_reg_r <= 32'd0;
        union_reg_file_data_w_reg_r <= 32'd0;

        union_reg_file_op_reg_w <= 1'b0;
        union_reg_file_rw_reg_w <= 1'b0;
        union_reg_file_reg_idx_reg_w <= 32'd0;
        union_reg_file_data_w_reg_w <= 32'd0;

        // 指令
        current_ins <= 32'd0;

        // 指令执行
        ins_exec_op <= 1'b0;

        // 寄存器写入
        reg_w_op = 1'b0;
        reg_w_reg_idx = 32'd0;
        reg_w_reg_val = 32'd0;

        // 内存写入
        mem_w_op = 1'b0;
        mem_w_mem_addr = 32'd0;
        mem_w_mem_val = 32'd0;

    end

    assign mmu_op = union_mmu_op_ins_fetch
                    | union_mmu_op_mem_r
                    | union_mmu_op_mem_w;
    assign mmu_rw = union_mmu_rw_ins_fetch
                    | union_mmu_rw_mem_r
                    | union_mmu_rw_mem_w;
    assign mmu_addr = union_mmu_addr_ins_fetch
                    | union_mmu_addr_mem_r
                    | union_mmu_addr_mem_w;
    assign mmu_data_w = union_mmu_data_w_ins_fetch
                    | union_mmu_data_w_mem_r
                    | union_mmu_data_w_mem_w;

    assign reg_file_op = union_reg_file_op_reg_r
                    | union_reg_file_op_reg_w;
    assign reg_file_rw = union_reg_file_rw_reg_r
                    | union_reg_file_rw_reg_w;
    assign reg_file_reg_idx = union_reg_file_reg_idx_reg_r
                    | union_reg_file_reg_idx_reg_w;
    assign reg_file_data_w = union_reg_file_data_w_reg_r
                    | union_reg_file_data_w_reg_w;

    always @(negedge sys_clk) begin
        if (sys_rst) begin
            status <= STATUS_INS_FETCH;
        end else begin
            case (status)
                STATUS_INS_FETCH: begin
                    if (st_done_ins_fetch) begin
                        status <= STATUS_INS_DEC;
                    end
                    else begin
                        status <= status;
                    end
                end
                STATUS_INS_DEC: begin
                    if (st_done_ins_dec) begin
                        status <= STATUS_REG_R;
                    end
                    else begin
                        status <= status;
                    end
                end
                STATUS_REG_R: begin
                    if (st_done_reg_r) begin
                        status <= STATUS_MEM_R;
                    end
                    else begin
                        status <= status;
                    end
                end
                STATUS_MEM_R: begin
                    if (st_done_mem_r) begin
                        status <= STATUS_EXEC;
                    end
                    else begin
                        status <= status;
                    end
                end
                STATUS_EXEC: begin
                    if (st_done_exec) begin
                        status <= STATUS_REG_W;
                    end
                    else begin
                        status <= status;
                    end
                end
                STATUS_REG_W: begin
                    if (st_done_reg_w) begin
                        status <= STATUS_MEM_W;
                    end
                    else begin
                        status <= status;
                    end
                end
                STATUS_MEM_W: begin
                    if (st_done_mem_w) begin
                        status <= STATUS_PC_NEXT;
                    end
                    else begin
                        status <= status;
                    end
                end
                STATUS_PC_NEXT: begin
                    if (st_done_pc_next) begin
                        status <= STATUS_INS_FETCH;
                    end
                    else begin
                        status <= status;
                    end
                end
                default: begin
                    status <= status;
                end
            endcase
        end
    end

    // 状态处理器：STATUS_INS_FETCH
    // 从内存中获取指令
    always @(negedge sys_clk) begin
        if (sys_rst) begin
            union_mmu_op_ins_fetch <= 1'd0;
            union_mmu_rw_ins_fetch <= 1'd0;
            union_mmu_addr_ins_fetch <= 32'd0;
            union_mmu_data_w_ins_fetch <= 32'd0;

            st_done_ins_fetch_0 <= 1'd0;
            st_done_ins_fetch <= 1'd0;
        end
        else if (status == STATUS_INS_FETCH) begin
            // 从内存中读取指令
            union_mmu_op_ins_fetch <= 1'd1;
            union_mmu_rw_ins_fetch <= 1'd0;
            union_mmu_addr_ins_fetch <= pc_current_pc;
            union_mmu_data_w_ins_fetch <= 32'd0;

            current_ins <= mmu_data_r;

            // 操作结束
            st_done_ins_fetch_0 <= 1'd1;
            st_done_ins_fetch <= st_done_ins_fetch_0;
        end
        else begin
            union_mmu_op_ins_fetch <= 1'd0;
            union_mmu_rw_ins_fetch <= 1'd0;
            union_mmu_addr_ins_fetch <= 32'd0;
            union_mmu_data_w_ins_fetch <= 32'd0;

            st_done_ins_fetch_0 <= 1'd0;
            st_done_ins_fetch <= 1'd0;
        end
    end

    // 状态处理器：STATUS_INS_DEC
    // 指令解码
    always @(negedge sys_clk) begin
        if (sys_rst) begin
            st_done_ins_dec <= 1'd0;
        end
        else if (status == STATUS_INS_DEC) begin 
            
            if (ins_dec_op == 7'b0010011
                    || ins_dec_op == 7'b0000011
                    || ins_dec_op == 7'b0100011
                    || ins_dec_op == 7'b1100011
                    || ins_dec_op == 7'b1100111
                    || ins_dec_op == 7'b1110111) begin
                // I-type S-type B-type
                // 12 => 32
                imm_ext_type <= 0'b0;
            end
            else begin
                // U-type J-type
                // * R-type也当做20位扩展，单纯为了方便
                // 20 => 32
                imm_ext_type <= 0'b1;
            end

            st_done_ins_dec <= 1'd1;
        end
        else begin
            st_done_ins_dec <= 1'd0;
        end
    end

    // 状态处理器：STATUS_REG_R
    // 读寄存器值
    always @(negedge sys_clk) begin
        if (sys_rst) begin
            union_reg_file_op_reg_r <= 0'd0;
            union_reg_file_rw_reg_r <= 0'd0;
            union_reg_file_reg_idx_reg_r <= 0'd0;
            union_reg_file_data_w_reg_r <= 0'd0;

            reg_r_rs1 <= 0'd0;
            reg_r_rs2 <= 0'd0;

            st_done_reg_r_0 <= 1'd0;
            st_done_reg_r_0_a <= 1'd0;
            st_done_reg_r_0_b <= 1'd0;
            st_done_reg_r_1 <= 1'd0;
            st_done_reg_r_1_a <= 1'd0;
            st_done_reg_r_1_b <= 1'd0;
            st_done_reg_r <= 1'd0;
        end
        else if (status == STATUS_REG_R) begin 
            if (ins_dec_op == 7'b0010011
                    || ins_dec_op == 7'b0000011
                    || ins_dec_op == 7'b1100111
                    || ins_dec_op == 7'b1110011) begin
                // I-type
                // rs1
                union_reg_file_op_reg_r <= 0'd1;
                union_reg_file_rw_reg_r <= 0'd0;
                union_reg_file_reg_idx_reg_r <= ins_dec_rs1;
                union_reg_file_data_w_reg_r <= 0'd0;

                reg_r_rs1 <= reg_file_data_r;
                reg_r_rs2 <= 32'd0;

                st_done_reg_r_0 <= 1'd1;
                st_done_reg_r <= st_done_reg_r_0;
            end
            else if (ins_dec_op == 7'b0110011
                        || ins_dec_op == 7'b0100011
                        || ins_dec_op == 7'b1100011) begin
                // R-type S-type B-type
                // rs1 & rs2

                if (st_done_reg_r_0 == 1'b0) begin
                    // rs1
                    union_reg_file_op_reg_r <= 0'd1;
                    union_reg_file_rw_reg_r <= 0'd0;
                    union_reg_file_reg_idx_reg_r <= ins_dec_rs1;
                    union_reg_file_data_w_reg_r <= 0'd0;

                    reg_r_rs1 <= reg_file_data_r;
                    reg_r_rs2 <= 32'd0;

                    st_done_reg_r_0_a <= 1'b1;
                    st_done_reg_r_0_b <= st_done_reg_r_0_a;
                    st_done_reg_r_0 <= st_done_reg_r_0_b;
                end
                else if (st_done_reg_r_0 == 1'b1
                            && st_done_reg_r_1 == 1'b0) begin
                    // rs2
                    union_reg_file_op_reg_r <= 0'd1;
                    union_reg_file_rw_reg_r <= 0'd0;
                    union_reg_file_reg_idx_reg_r <= ins_dec_rs2;
                    union_reg_file_data_w_reg_r <= 0'd0;

                    reg_r_rs1 <= 32'd0;
                    reg_r_rs2 <= reg_file_data_r;
                    
                    st_done_reg_r_1_a <= 1'b1;
                    st_done_reg_r_1_b <= st_done_reg_r_1_a;
                    st_done_reg_r_1 <= st_done_reg_r_1_b;
                end
                else begin
                    union_reg_file_op_reg_r <= 0'd0;
                    union_reg_file_rw_reg_r <= 0'd0;
                    union_reg_file_reg_idx_reg_r <= 0'd0;
                    union_reg_file_data_w_reg_r <= 0'd0;

                    reg_r_rs1 <= 0'd0;
                    reg_r_rs2 <= 0'd0;

                    st_done_reg_r <= 1'd1;
                end
            end
            else begin
                union_reg_file_op_reg_r <= 0'd0;
                union_reg_file_rw_reg_r <= 0'd0;
                union_reg_file_reg_idx_reg_r <= 0'd0;
                union_reg_file_data_w_reg_r <= 0'd0;

                reg_r_rs1 <= 0'd0;
                reg_r_rs2 <= 0'd0;

                st_done_reg_r <= 1'd1;
            end
        end
        else begin
            union_reg_file_op_reg_r <= 0'd0;
            union_reg_file_rw_reg_r <= 0'd0;
            union_reg_file_reg_idx_reg_r <= 0'd0;
            union_reg_file_data_w_reg_r <= 0'd0;

            st_done_reg_r_0 <= 1'd0;
            st_done_reg_r_0_a <= 1'd0;
            st_done_reg_r_0_b <= 1'd0;
            st_done_reg_r_1 <= 1'd0;
            st_done_reg_r_1_a <= 1'd0;
            st_done_reg_r_1_b <= 1'd0;
            st_done_reg_r <= 1'd0;
        end
    end

    // 状态处理器：STATUS_MEM_R
    // 读内存值
    always @(negedge sys_clk) begin
        if (sys_rst) begin
            union_mmu_op_mem_r <= 1'd0;
            union_mmu_rw_mem_r <= 1'd0;
            union_mmu_addr_mem_r <= 32'd0;
            union_mmu_data_w_mem_r <= 32'd0;

            mem_r_addr <= 32'd0;
            mem_r_val <= 32'd0;

            st_done_mem_r_0 <= 1'd0;
            st_done_mem_r_1 <= 1'd0;
            st_done_mem_r_1_a <= 1'd0;
            st_done_mem_r_1_b <= 1'd0;
            st_done_mem_r <= 1'd0;
        end
        else if (status == STATUS_MEM_R) begin 
            if (ins_dec_op == 7'b0000011
                    || ins_dec_op == 7'b0100011) begin
                if (st_done_mem_r_0 == 1'b0) begin
                    mem_r_addr <= reg_r_rs1 + ins_dec_imm;

                    st_done_mem_r_0 <= 1'b1;
                end
                else if (st_done_mem_r_0 == 1'b1
                            && st_done_mem_r_1 == 1'b0) begin
                    union_mmu_op_mem_r <= 1'd1;
                    union_mmu_rw_mem_r <= 1'd0;
                    union_mmu_addr_mem_r <= mem_r_addr;
                    union_mmu_data_w_mem_r <= 32'd0;

                    mem_r_val <= mmu_data_r;
                    
                    st_done_mem_r_1_a <= 1'b1;
                    st_done_mem_r_1_b <= st_done_mem_r_1_a;
                    st_done_mem_r_1 <= st_done_mem_r_1_b;
                end
                else begin
                    st_done_mem_r <= 1'd1;
                end
            end
            else begin
                st_done_mem_r <= 1'd1;
            end
        end
        else begin
            union_mmu_op_mem_r <= 1'd0;
            union_mmu_rw_mem_r <= 1'd0;
            union_mmu_addr_mem_r <= 32'd0;
            union_mmu_data_w_mem_r <= 32'd0;

            st_done_mem_r_0 <= 1'd0;
            st_done_mem_r_1 <= 1'd0;
            st_done_mem_r_1_a <= 1'd0;
            st_done_mem_r_1_b <= 1'd0;
            st_done_mem_r <= 1'd0;
        end
    end

    // 状态处理器：STATUS_EXEC
    // 执行
    always @(negedge sys_clk) begin
        if (sys_rst) begin
            ins_exec_op <= 1'b0;

            reg_w_op <= 1'b0;
            reg_w_reg_idx <= 5'd0;
            reg_w_reg_val <= 32'd0;

            mem_w_op <= 1'b0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'h0;

            reg_pc_w_op <= 1'b0;
            reg_pc_w_val <= 32'd0;

            st_done_exec_0 <= 1'd0;
            st_done_exec_1 <= 1'd0;
            st_done_exec <= 1'd0;
        end
        else if (status == STATUS_EXEC) begin 
            ins_exec_op <= 1'b1;

            reg_w_op <= ins_exec_reg_w_op;
            reg_w_reg_idx <= ins_exec_reg_w_reg_idx;
            reg_w_reg_val <= ins_exec_reg_w_reg_val;

            mem_w_op <= ins_exec_mem_w_op;
            mem_w_mem_addr <= ins_exec_mem_w_mem_addr;
            mem_w_mem_val <= ins_exec_mem_w_mem_val;

            reg_pc_w_op <= ins_exec_reg_pc_w_op;
            reg_pc_w_val <= ins_exec_reg_pc_w_val;
            
            st_done_exec_0 <= 1'd1;
            st_done_exec_1 <= st_done_exec_0;
            st_done_exec <= st_done_exec_1;
        end
        else begin
            ins_exec_op <= 1'b0;

            if (st_done_pc_next == 1'd1) begin
                reg_w_op <= 1'b0;
                reg_w_reg_idx <= 5'd0;
                reg_w_reg_val <= 32'd0;

                mem_w_op <= 1'b0;
                mem_w_mem_addr <= 32'd0;
                mem_w_mem_val <= 32'h0;

                reg_pc_w_op <= 1'b0;
                reg_pc_w_val <= 32'd0;
            end
            else begin
                reg_w_op <= reg_w_op;
                reg_w_reg_idx <= reg_w_reg_idx;
                reg_w_reg_val <= reg_w_reg_val;

                mem_w_op <= mem_w_op;
                mem_w_mem_addr <= mem_w_mem_addr;
                mem_w_mem_val <= mem_w_mem_val;

                reg_pc_w_op <= reg_pc_w_op;
                reg_pc_w_val <= reg_pc_w_val;
            end

            st_done_exec_0 <= 1'd0;
            st_done_exec_1 <= 1'd0;
            st_done_exec <= 1'd0;
        end
    end

    // 状态处理器：STATUS_REG_W
    // 写寄存器值
    always @(negedge sys_clk) begin
        if (sys_rst) begin
            union_reg_file_op_reg_w <= 1'd0;
            union_reg_file_rw_reg_w <= 1'd0;
            union_reg_file_reg_idx_reg_w <= 5'd0;
            union_reg_file_data_w_reg_w <= 32'd0;

            st_done_reg_w_0 <= 1'd0;
            st_done_reg_w_1 <= 1'd0;
            st_done_reg_w <= 1'd0;
        end
        else if (status == STATUS_REG_W) begin 
            if (reg_w_op == 1'b1) begin
                union_reg_file_op_reg_w <= 1'd1;
                union_reg_file_rw_reg_w <= 1'd1;
                union_reg_file_reg_idx_reg_w <= reg_w_reg_idx;
                union_reg_file_data_w_reg_w <= reg_w_reg_val;

                st_done_reg_w_0 <= 1'd1;
                st_done_reg_w_1 <= st_done_reg_w_0;
                st_done_reg_w <= st_done_reg_w_1;
            end
            else begin
                st_done_reg_w <= 1'd1;
            end
        end
        else begin
            union_reg_file_op_reg_w <= 1'd0;
            union_reg_file_rw_reg_w <= 1'd0;
            union_reg_file_reg_idx_reg_w <= 5'd0;
            union_reg_file_data_w_reg_w <= 32'd0;

            st_done_reg_w_0 <= 1'd0;
            st_done_reg_w_1 <= 1'd0;
            st_done_reg_w <= 1'd0;
        end
    end

    // 状态处理器：STATUS_MEM_W
    // 写内存值
    always @(negedge sys_clk) begin
        if (sys_rst) begin
            union_mmu_op_mem_w <= 1'd0;
            union_mmu_rw_mem_w <= 1'd0;
            union_mmu_addr_mem_w <= 32'd0;
            union_mmu_data_w_mem_w <= 32'd0;

            st_done_mem_w_0 <= 1'd0;
            st_done_mem_w_1 <= 1'd0;
            st_done_mem_w <= 1'd0;
        end
        else if (status == STATUS_MEM_W) begin 
            if (mem_w_op == 1'b1) begin
                union_mmu_op_mem_w <= 1'd1;
                union_mmu_rw_mem_w <= 1'd1;
                union_mmu_addr_mem_w <= mem_w_mem_addr;
                union_mmu_data_w_mem_w <= mem_w_mem_val;

                st_done_mem_w_0 <= 1'd1;
                st_done_mem_w_1 <= st_done_mem_w_0;
                st_done_mem_w <= st_done_mem_w_1;
            end
            else begin
               st_done_mem_w <= 1'd1; 
            end
        end
        else begin
            union_mmu_op_mem_w <= 1'd0;
            union_mmu_rw_mem_w <= 1'd0;
            union_mmu_addr_mem_w <= 32'd0;
            union_mmu_data_w_mem_w <= 32'd0;

            st_done_mem_w_0 <= 1'd0;
            st_done_mem_w_1 <= 1'd0;
            st_done_mem_w <= 1'd0;
        end
    end

    // 状态处理器：STATUS_PC_NEXT
    // PC递增
    always @(sys_clk) begin
        if (sys_rst) begin
            pc_op <= 1'd0;

            st_done_pc_next <= 1'd0;
        end
        else if (status == STATUS_PC_NEXT) begin 
            if (reg_pc_w_op == 1'd1) begin
                pc_op <= 1'd1;
                pc_pc_src <= 1'd1;
                pc_alu_output <= reg_pc_w_val;
            end
            else begin
                pc_op <= 1'd1;
                pc_pc_src <= 1'd0;
                pc_alu_output <= 1'd0;
            end

            st_done_pc_next <= 1'd1;
        end
        else begin
            pc_op <= 1'd0;

            st_done_pc_next <= 1'd0;
        end
    end










    // ========================================
    // 模块例化
    // ========================================

    // PC模块
    PC
        #(
        )
        u_pc(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .op(pc_op),
            .pc_src(pc_pc_src),
            .alu_output(pc_alu_output),
            .current_pc(pc_current_pc),
            .next_pc(pc_next_pc)
        );

    // 寄存器文件模块
    RegFile
        #(
            .REG_IDX_WIDTH(REG_FILE_REG_IDX_WIDTH),
            .DATA_WIDTH(REG_FILE_DATA_WIDTH),
            .BYTE_WIDTH(REG_FILE_BYTE_WIDTH),
            .REG_COUNT(REG_FILE_REG_COUNT)
        )
        u_reg_file(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .op(reg_file_op),
            .rw(reg_file_rw),
            .reg_idx(reg_file_reg_idx),
            .data_w(reg_file_data_w),
            .data_r(reg_file_data_r)
        );

    // MMU模块
    MMU
        #(
            .ADDR_WIDTH(MMU_ADDR_WIDTH),
            .DATA_WIDTH(MMU_DATA_WIDTH),
            .BYTE_WIDTH(MMU_BYTE_WIDTH),
            .SIZE(MMU_SIZE)
        )
        u_mmu(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .op(mmu_op),
            .rw(mmu_rw),
            .addr(mmu_addr),
            .data_w(mmu_data_w),
            .data_r(mmu_data_r),
            .ext_op(ext_op),
            .ext_rw(ext_rw),
            .ext_addr(ext_addr),
            .ext_data_w(ext_data_w),
            .ext_data_r(ext_data_r)
        );

    // 外部模块
    ExtCtl
        #(
            .ADDR_WIDTH(MMU_ADDR_WIDTH),
            .DATA_WIDTH(MMU_DATA_WIDTH)
        )
        u_ext_ctl(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .op(ext_op),
            .rw(ext_rw),
            .addr(ext_addr),
            .data_w(ext_data_w),
            .data_r(ext_data_r)
        );

    // 指令解码模块
    InsDec u_ins_dec(
        .ins(current_ins),
        .op(ins_dec_op),
        .funct3(ins_dec_funct3),
        .funct7(ins_dec_funct7),
        .rs1(ins_dec_rs1),
        .rs2(ins_dec_rs2),
        .rd(ins_dec_rd),
        .imm(ins_dec_imm)
    );

    // 立即数扩展模块
    ImmExt u_imm_ext(
        .imm(ins_dec_imm),
        .type(imm_ext_type),
        .ext(imm_ext_ext)
    );

    // 指令执行模块
    InsExec u_ins_exec(
        .sys_clk(sys_clk),

        .op(ins_exec_op),

        .ins_dec_op(ins_dec_op),
        .ins_dec_funct3(ins_dec_funct3),
        .ins_dec_funct7(ins_dec_funct7),

        .reg_rs1(ins_dec_rs1),
        .reg_rs1_val(reg_r_rs1),

        .reg_rs2(ins_dec_rs2),
        .reg_rs2_val(reg_r_rs2),

        .reg_pc_val(pc_current_pc),

        .reg_rd(ins_dec_rd),

        .imm_ext_type(imm_ext_type),
        .imm_ext_ext(imm_ext_ext),

        .mem_r_addr(mem_r_addr),
        .mem_r_val(mem_r_val),

        .reg_w_op(ins_exec_reg_w_op),
        .reg_w_reg_idx(ins_exec_reg_w_reg_idx),
        .reg_w_reg_val(ins_exec_reg_w_reg_val),

        .mem_w_op(ins_exec_mem_w_op),
        .mem_w_mem_addr(ins_exec_mem_w_mem_addr),
        .mem_w_mem_val(ins_exec_mem_w_mem_val),

        .reg_pc_w_op(ins_exec_reg_pc_w_op),
        .reg_pc_w_val(ins_exec_reg_pc_w_val)
    );

endmodule
