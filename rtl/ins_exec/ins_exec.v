module InsExec(
    input   wire            sys_clk,

    input   wire            op,

    input   wire [6:0]      ins_dec_op,
    input   wire [2:0]      ins_dec_funct3,
    input   wire [6:0]      ins_dec_funct7,

    input   wire [5:0]      reg_rs1,
    input   wire [31:0]     reg_rs1_val,
    
    input   wire [5:0]      reg_rs2,
    input   wire [31:0]     reg_rs2_val,

    input   wire [5:0]      reg_rd,

    input   wire            imm_ext_type,
    input   wire [31:0]     imm_ext_ext,

    input   wire [31:0]     mem_r_addr,
    input   wire [31:0]     mem_r_val,

    output  reg             reg_w_op,
    output  reg [4:0]       reg_w_reg_idx,
    output  reg [31:0]      reg_w_reg_val,

    output  reg             mem_w_op,
    output  reg [31:0]      mem_w_mem_addr,
    output  reg [31:0]      mem_w_mem_val
);

    // RV32I R-type
    wire            rv32i_r_reg_w_op;
    wire [4:0]      rv32i_r_reg_w_reg_idx;
    wire [31:0]     rv32i_r_reg_w_reg_val;

    always @(negedge sys_clk) begin
        if (op == 1'b1
                && ins_dec_op == 7'b0110011) begin
            reg_w_op <= rv32i_r_reg_w_op;
            reg_w_reg_idx <= rv32i_r_reg_w_reg_idx;
            reg_w_reg_val <= rv32i_r_reg_w_reg_val;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;
        end
        else begin
            reg_w_op <= 1'd0;
            reg_w_reg_idx <= 5'd0;
            reg_w_reg_val <= 32'd0;

            mem_w_op <= 1'd0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;
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

        .reg_w_op(rv32i_r_reg_w_op),
        .reg_w_reg_idx(rv32i_r_reg_w_reg_idx),
        .reg_w_reg_val(rv32i_r_reg_w_reg_val)
    );

endmodule
