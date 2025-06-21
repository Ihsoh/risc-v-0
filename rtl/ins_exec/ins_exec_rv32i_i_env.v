module InsExec_RV32I_I_Env(
    input   wire            op,

    input   wire [6:0]      ins_dec_op,
    input   wire [2:0]      ins_dec_funct3,

    input   wire [31:0]     reg_pc_val,

    input   wire            imm_ext_type,
    input   wire [31:0]     imm_ext_ext,

    output  reg             reg_pc_w_op,
    output  reg [31:0]      reg_pc_w_val
);
    // ========================================
    // 逻辑描述
    // ========================================

    always @(
        op

        or ins_dec_op
        or ins_dec_funct3

        or imm_ext_type
        or imm_ext_ext
    ) begin
        if (op == 1'b1
                && ins_dec_op == 7'b1110011
                && ins_dec_funct3 == 3'h0) begin
            if (imm_ext_ext == 32'h0) begin
                // ECALL

                // 未实现，直接跳到下一条指令
                reg_pc_w_op <= 1'b1;
                reg_pc_w_val <= reg_pc_val + 4;
            end
            else if (imm_ext_ext == 32'h1) begin
                // EBREAK

                // 未实现，直接跳到下一条指令
                reg_pc_w_op <= 1'b1;
                reg_pc_w_val <= reg_pc_val + 4;
            end
            else begin
                reg_pc_w_op <= 1'b0;
                reg_pc_w_val <= 32'd0;
            end
        end
        else begin
            reg_pc_w_op <= 1'b0;
            reg_pc_w_val <= 32'd0;
        end
    end

endmodule
