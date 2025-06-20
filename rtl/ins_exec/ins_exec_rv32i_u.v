module InsExec_RV32I_U(
    input   wire            op,

    input   wire [6:0]      ins_dec_op,

    input   wire [31:0]     reg_pc_val,

    input   wire [4:0]      reg_rd,

    input   wire            imm_ext_type,
    input   wire [31:0]     imm_ext_ext,

    output  reg             reg_w_op,
    output  reg [4:0]       reg_w_reg_idx,
    output  reg [31:0]      reg_w_reg_val
);

    always @(
        op

        or ins_dec_op

        or reg_pc_val

        or reg_rd

        or imm_ext_type
        or imm_ext_ext
    ) begin
        if (op == 1'b1
                && ins_dec_op == 7'b0110111) begin
            // LUI
            reg_w_op <= 1'b1;
            reg_w_reg_idx <= reg_rd;
            reg_w_reg_val <= imm_ext_ext << 12;
        end
        else if (op == 1'b1
                && ins_dec_op == 7'b0010111) begin
            // AUIPC
            reg_w_op <= 1'b1;
            reg_w_reg_idx <= reg_rd;
            reg_w_reg_val <= reg_pc_val + (imm_ext_ext << 12);
        end
        else begin
            reg_w_op <= 1'b0;
            reg_w_reg_idx <= 5'd0;
            reg_w_reg_val <= 32'd0;
        end
    end

endmodule
