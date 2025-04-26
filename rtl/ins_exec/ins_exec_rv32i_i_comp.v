module InsExec_RV32I_I_Comp(
    input   wire            op,

    input   wire [6:0]      ins_dec_op,
    input   wire [2:0]      ins_dec_funct3,

    input   wire [31:0]     reg_rs1_val,

    input   wire            imm_ext_type,
    input   wire [31:0]     imm_ext_ext,

    input   wire [4:0]      reg_rd,

    output  reg             reg_w_op,
    output  reg [4:0]       reg_w_reg_idx,
    output  reg [31:0]      reg_w_reg_val
);

    always @(
        op

        or ins_dec_op
        or ins_dec_funct3

        or reg_rs1_val

        or imm_ext_type
        or imm_ext_ext

        or reg_rd

        or reg_w_op
        or reg_w_reg_idx
        or reg_w_reg_val
    ) begin
        if (op == 1'b1
                && ins_dec_op == 7'b0010011) begin
            if (ins_dec_funct3 == 3'h0) begin
                // ADDI
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= $signed(reg_rs1_val) + $signed(imm_ext_ext);
            end
            else if (ins_dec_funct3 == 3'h4) begin
                // XORI
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= reg_rs1_val ^ imm_ext_ext;
            end
            else if (ins_dec_funct3 == 3'h6) begin
                // ORI
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= reg_rs1_val | imm_ext_ext;
            end
            else if (ins_dec_funct3 == 3'h7) begin
                // ANDI
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= reg_rs1_val & imm_ext_ext;
            end
            else if (ins_dec_funct3 == 3'h1
                    && imm_ext_ext[11:5] == 7'h0) begin
                // SLLI
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= reg_rs1_val << imm_ext_ext[4:0];
            end
            else if (ins_dec_funct3 == 3'h5
                    && imm_ext_ext[11:5] == 7'h0) begin
                // SRLI
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= reg_rs1_val >> imm_ext_ext[4:0];
            end
            else if (ins_dec_funct3 == 3'h5
                    && imm_ext_ext[11:5] == 7'h20) begin
                // SRAI
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= reg_rs1_val >>> imm_ext_ext[4:0];
            end
            else if (ins_dec_funct3 == 3'h2) begin
                // SLTI
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= ($signed(reg_rs1_val) < $signed(imm_ext_ext)) ? 32'd1 : 32'd0;
            end
            else if (ins_dec_funct3 == 3'h3) begin
                // SLTIU
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= (reg_rs1_val < imm_ext_ext) ? 32'd1 : 32'd0;
            end
            else begin
                reg_w_op <= 1'b0;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= 32'd0;
            end
        end
        else begin
            reg_w_op <= 1'b0;
            reg_w_reg_idx <= 5'd0;
            reg_w_reg_val <= 32'd0;
        end
    end

endmodule
