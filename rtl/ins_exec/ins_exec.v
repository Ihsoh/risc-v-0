module InsExec(
    input   wire            sys_clk,

    input   wire            op,

    input   wire [6:0]      ins_dec_op,
    input   wire [2:0]      ins_dec_funct3,
    input   wire [6:0]      ins_dec_funct7,

    input   wire [4:0]      reg_rs1,
    input   wire [31:0]     reg_rs1_val,
    
    input   wire [4:0]      reg_rs2,
    input   wire [31:0]     reg_rs2_val,

    input   wire [31:0]     reg_pc_val,

    input   wire [4:0]      reg_rd,

    input   wire            imm_ext_type,
    input   wire [31:0]     imm_ext_ext,

    input   wire [31:0]     mem_r_addr,
    input   wire [31:0]     mem_r_val,

    output  reg             reg_w_op,
    output  reg [4:0]       reg_w_reg_idx,
    output  reg [31:0]      reg_w_reg_val,

    output  reg             mem_w_op,
    output  reg [31:0]      mem_w_mem_addr,
    output  reg [31:0]      mem_w_mem_val,

    output  reg             reg_pc_w_op,
    output  reg [31:0]      reg_pc_w_val
);

    // InsExec_RV32I_R
    wire            rv32i_r_reg_w_op;
    wire [4:0]      rv32i_r_reg_w_reg_idx;
    wire [31:0]     rv32i_r_reg_w_reg_val;

    // InsExec_RV32I_I_Comp
    wire            rv32i_i_comp_reg_w_op;
    wire [4:0]      rv32i_i_comp_reg_w_reg_idx;
    wire [31:0]     rv32i_i_comp_reg_w_reg_val;

    // InsExec_RV32I_I_Ld
    wire            rv32i_i_ld_reg_w_op;
    wire [4:0]      rv32i_i_ld_reg_w_reg_idx;
    wire [31:0]     rv32i_i_ld_reg_w_reg_val;

    // InsExec_RV32I_S
    wire            rv32i_s_mem_w_op;
    wire [31:0]     rv32i_s_mem_w_mem_addr;
    wire [31:0]     rv32i_s_mem_w_mem_val;

    // InsExec_RV32I_B
    wire            rv32i_b_reg_pc_w_op;
    wire [31:0]     rv32i_b_reg_pc_w_val;

    // InsExec_RV32I_J
    wire            rv32i_j_reg_pc_w_op;
    wire [31:0]     rv32i_j_reg_pc_w_val;

    wire            rv32i_j_reg_w_op;
    wire [4:0]      rv32i_j_reg_w_reg_idx;
    wire [31:0]     rv32i_j_reg_w_reg_val;

    // InsExec_RV32I_I_JALR
    wire            rv32i_i_jalr_reg_pc_w_op;
    wire [31:0]     rv32i_i_jalr_reg_pc_w_val;

    wire            rv32i_i_jalr_reg_w_op;
    wire [4:0]      rv32i_i_jalr_reg_w_reg_idx;
    wire [31:0]     rv32i_i_jalr_reg_w_reg_val;

    // InsExec_RV32I_U
    wire            rv32i_u_reg_w_op;
    wire [4:0]      rv32i_u_reg_w_reg_idx;
    wire [31:0]     rv32i_u_reg_w_reg_val;

    // InsExec_RV32I_I_ENV
    wire            rv32i_i_env_reg_pc_w_op;
    wire [31:0]     rv32i_i_env_reg_pc_w_val;


    always @(negedge sys_clk) begin
        if (op == 1'b1
                && ins_dec_op == 7'b0110011) begin
            reg_w_op <= rv32i_r_reg_w_op;
            reg_w_reg_idx <= rv32i_r_reg_w_reg_idx;
            reg_w_reg_val <= rv32i_r_reg_w_reg_val;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;

            reg_pc_w_op <= 1'd0;
            reg_pc_w_val <= 32'd0;
        end
        else if (op == 1'b1
                && ins_dec_op == 7'b0010011) begin
            reg_w_op <= rv32i_i_comp_reg_w_op;
            reg_w_reg_idx <= rv32i_i_comp_reg_w_reg_idx;
            reg_w_reg_val <= rv32i_i_comp_reg_w_reg_val;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;

            reg_pc_w_op <= 1'd0;
            reg_pc_w_val <= 32'd0;
        end
        else if (op == 1'b1
                && ins_dec_op == 7'b0000011) begin
            reg_w_op <= rv32i_i_ld_reg_w_op;
            reg_w_reg_idx <= rv32i_i_ld_reg_w_reg_idx;
            reg_w_reg_val <= rv32i_i_ld_reg_w_reg_val;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;

            reg_pc_w_op <= 1'd0;
            reg_pc_w_val <= 32'd0;
        end
        else if (op == 1'b1
                && ins_dec_op == 7'b0100011) begin
            reg_w_op <= 1'd0;
            reg_w_reg_idx <= 5'd0;
            reg_w_reg_val <= 32'd0;

            mem_w_op <= rv32i_s_mem_w_op;
            mem_w_mem_addr <= rv32i_s_mem_w_mem_addr;
            mem_w_mem_val <= rv32i_s_mem_w_mem_val;

            reg_pc_w_op <= 1'd0;
            reg_pc_w_val <= 32'd0;
        end
        else if (op == 1'b1
                && ins_dec_op == 7'b1100011) begin
            reg_w_op <= 1'd0;
            reg_w_reg_idx <= 5'd0;
            reg_w_reg_val <= 32'd0;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;

            reg_pc_w_op <= rv32i_b_reg_pc_w_op;
            reg_pc_w_val <= rv32i_b_reg_pc_w_val;
        end
        else if (op == 1'b1
                && ins_dec_op == 7'b1101111) begin
            reg_w_op <= rv32i_j_reg_w_op;
            reg_w_reg_idx <= rv32i_j_reg_w_reg_idx;
            reg_w_reg_val <= rv32i_j_reg_w_reg_val;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;

            reg_pc_w_op <= rv32i_j_reg_pc_w_op;
            reg_pc_w_val <= rv32i_j_reg_pc_w_val;
        end
        else if (op == 1'b1
                && ins_dec_op == 7'b1100111) begin
            reg_w_op <= rv32i_i_jalr_reg_w_op;
            reg_w_reg_idx <= rv32i_i_jalr_reg_w_reg_idx;
            reg_w_reg_val <= rv32i_i_jalr_reg_w_reg_val;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;

            reg_pc_w_op <= rv32i_i_jalr_reg_pc_w_op;
            reg_pc_w_val <= rv32i_i_jalr_reg_pc_w_val;
        end
        else if (op == 1'b1
                && (ins_dec_op == 7'b0110111 || ins_dec_op == 7'b0010111)) begin
            reg_w_op <= rv32i_u_reg_w_op;
            reg_w_reg_idx <= rv32i_u_reg_w_reg_idx;
            reg_w_reg_val <= rv32i_u_reg_w_reg_val;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;

            reg_pc_w_op <= 1'd0;
            reg_pc_w_val <= 32'd0;
        end
        else if (op == 1'b1
                && ins_dec_op == 7'b1110011) begin
            reg_w_op <= 1'd0;
            reg_w_reg_idx <= 5'd0;
            reg_w_reg_val <= 32'd0;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;

            reg_pc_w_op <= rv32i_i_env_reg_pc_w_op;
            reg_pc_w_val <= rv32i_i_env_reg_pc_w_val;
        end
        else begin
            reg_w_op <= 1'd0;
            reg_w_reg_idx <= 5'd0;
            reg_w_reg_val <= 32'd0;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;

            reg_pc_w_op <= 1'd0;
            reg_pc_w_val <= 32'd0;
        end
    end

    InsExec_RV32I_R u_ins_exec_rv32i_r(
        .op(op),

        .ins_dec_op(ins_dec_op),
        .ins_dec_funct3(ins_dec_funct3),
        .ins_dec_funct7(ins_dec_funct7),

        .reg_rs1_val(reg_rs1_val),
        .reg_rs2_val(reg_rs2_val),

        .reg_rd(reg_rd),

        .reg_w_op(rv32i_r_reg_w_op),
        .reg_w_reg_idx(rv32i_r_reg_w_reg_idx),
        .reg_w_reg_val(rv32i_r_reg_w_reg_val)
    );

    InsExec_RV32I_I_Comp u_ins_exec_rv32i_i_comp(
        .op(op),

        .ins_dec_op(ins_dec_op),
        .ins_dec_funct3(ins_dec_funct3),

        .reg_rs1_val(reg_rs1_val),

        .imm_ext_type(imm_ext_type),
        .imm_ext_ext(imm_ext_ext),

        .reg_rd(reg_rd),

        .reg_w_op(rv32i_i_comp_reg_w_op),
        .reg_w_reg_idx(rv32i_i_comp_reg_w_reg_idx),
        .reg_w_reg_val(rv32i_i_comp_reg_w_reg_val)
    );

    InsExec_RV32I_I_Ld u_ins_exec_rv32i_i_ld(
        .op(op),

        .ins_dec_op(ins_dec_op),
        .ins_dec_funct3(ins_dec_funct3),

        .mem_val(mem_r_val),

        .reg_rd(reg_rd),

        .reg_w_op(rv32i_i_ld_reg_w_op),
        .reg_w_reg_idx(rv32i_i_ld_reg_w_reg_idx),
        .reg_w_reg_val(rv32i_i_ld_reg_w_reg_val)
    );

    InsExec_RV32I_S u_ins_exec_rv32i_s(
        .op(op),
        
        .ins_dec_op(ins_dec_op),
        .ins_dec_funct3(ins_dec_funct3),

        .reg_rs1_val(reg_rs1_val),
        .reg_rs2_val(reg_rs2_val),

        .imm_ext_type(imm_ext_type),
        .imm_ext_ext(imm_ext_ext),

        .mem_r_val(mem_r_val),
        
        .mem_w_op(rv32i_s_mem_w_op),
        .mem_w_mem_addr(rv32i_s_mem_w_mem_addr),
        .mem_w_mem_val(rv32i_s_mem_w_mem_val)
    );

    InsExec_RV32I_B u_ins_exec_rv32i_b(
        .op(op),
        
        .ins_dec_op(ins_dec_op),
        .ins_dec_funct3(ins_dec_funct3),

        .reg_rs1_val(reg_rs1_val),
        .reg_rs2_val(reg_rs2_val),

        .reg_pc_val(reg_pc_val),

        .imm_ext_type(imm_ext_type),
        .imm_ext_ext(imm_ext_ext),

        .reg_pc_w_op(rv32i_b_reg_pc_w_op),
        .reg_pc_w_val(rv32i_b_reg_pc_w_val)
    );

    InsExec_RV32I_J u_ins_exec_rv32i_j(
        .op(op),
        
        .ins_dec_op(ins_dec_op),

        .reg_pc_val(reg_pc_val),

        .reg_rd(reg_rd),

        .imm_ext_type(imm_ext_type),
        .imm_ext_ext(imm_ext_ext),

        .reg_pc_w_op(rv32i_j_reg_pc_w_op),
        .reg_pc_w_val(rv32i_j_reg_pc_w_val),

        .reg_w_op(rv32i_j_reg_w_op),
        .reg_w_reg_idx(rv32i_j_reg_w_reg_idx),
        .reg_w_reg_val(rv32i_j_reg_w_reg_val)
    );

    InsExec_RV32I_I_JALR u_ins_exec_rv32i_i_jalr(
        .op(op),

        .ins_dec_op(ins_dec_op),
        .ins_dec_funct3(ins_dec_funct3),

        .reg_rs1_val(reg_rs1_val),

        .reg_pc_val(reg_pc_val),

        .reg_rd(reg_rd),

        .imm_ext_type(imm_ext_type),
        .imm_ext_ext(imm_ext_ext),

        .reg_pc_w_op(rv32i_i_jalr_reg_pc_w_op),
        .reg_pc_w_val(rv32i_i_jalr_reg_pc_w_val),

        .reg_w_op(rv32i_i_jalr_reg_w_op),
        .reg_w_reg_idx(rv32i_i_jalr_reg_w_reg_idx),
        .reg_w_reg_val(rv32i_i_jalr_reg_w_reg_val)
    );

    InsExec_RV32I_U u_ins_exec_rv32i_u(
        .op(op),

        .ins_dec_op(ins_dec_op),

        .reg_pc_val(reg_pc_val),

        .reg_rd(reg_rd),

        .imm_ext_type(imm_ext_type),
        .imm_ext_ext(imm_ext_ext),

        .reg_w_op(rv32i_u_reg_w_op),
        .reg_w_reg_idx(rv32i_u_reg_w_reg_idx),
        .reg_w_reg_val(rv32i_u_reg_w_reg_val)
    );

endmodule
