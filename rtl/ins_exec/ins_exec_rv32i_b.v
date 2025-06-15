module InsExec_RV32I_B(
    input   wire            op,

    input   wire [6:0]      ins_dec_op,
    input   wire [2:0]      ins_dec_funct3,

    input   wire [31:0]     reg_rs1_val,
    input   wire [31:0]     reg_rs2_val,

    input   wire [31:0]     reg_pc_val,

    input   wire            imm_ext_type,
    input   wire [31:0]     imm_ext_ext,

    output  reg             reg_pc_w_op,
    output  reg [31:0]      reg_pc_w_val
);

    always @(
        op

        or ins_dec_op
        or ins_dec_funct3

        or reg_rs1_val
        or reg_rs2_val

        or imm_ext_type
        or imm_ext_ext
    ) begin
        if (op == 1'b1
                && ins_dec_op == 7'b1100011) begin
            if (ins_dec_funct3 == 3'h0) begin
                // BEQ
                if ($signed(reg_rs1_val) == $signed(reg_rs2_val)) begin
                    reg_pc_w_op <= 1'b1;
                    reg_pc_w_val <= reg_pc_val + imm_ext_ext;
                end
                else begin
                    reg_pc_w_op <= 1'b0;
                    reg_pc_w_val <= 32'd0;
                end
            end
            else if (ins_dec_funct3 == 3'h1) begin
                // BNE
                if ($signed(reg_rs1_val) != $signed(reg_rs2_val)) begin
                    reg_pc_w_op <= 1'b1;
                    reg_pc_w_val <= reg_pc_val + imm_ext_ext;
                end
                else begin
                    reg_pc_w_op <= 1'b0;
                    reg_pc_w_val <= 32'd0;
                end
            end
            else if (ins_dec_funct3 == 3'h4) begin
                // BLT
                if ($signed(reg_rs1_val) < $signed(reg_rs2_val)) begin
                    reg_pc_w_op <= 1'b1;
                    reg_pc_w_val <= reg_pc_val + imm_ext_ext;
                end
                else begin
                    reg_pc_w_op <= 1'b0;
                    reg_pc_w_val <= 32'd0;
                end
            end
            else if (ins_dec_funct3 == 3'h5) begin
                // BGE
                if ($signed(reg_rs1_val) >= $signed(reg_rs2_val)) begin
                    reg_pc_w_op <= 1'b1;
                    reg_pc_w_val <= reg_pc_val + imm_ext_ext;
                end
                else begin
                    reg_pc_w_op <= 1'b0;
                    reg_pc_w_val <= 32'd0;
                end
            end
            else if (ins_dec_funct3 == 3'h6) begin
                // BLTU
                if (reg_rs1_val < reg_rs2_val) begin
                    reg_pc_w_op <= 1'b1;
                    reg_pc_w_val <= reg_pc_val + imm_ext_ext;
                end
                else begin
                    reg_pc_w_op <= 1'b0;
                    reg_pc_w_val <= 32'd0;
                end
            end
            else if (ins_dec_funct3 == 3'h7) begin
                // BGEU
                if (reg_rs1_val >= reg_rs2_val) begin
                    reg_pc_w_op <= 1'b1;
                    reg_pc_w_val <= reg_pc_val + imm_ext_ext;
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
        else begin
            reg_pc_w_op <= 1'b0;
            reg_pc_w_val <= 32'd0;
        end
    end

endmodule
