module InsExec_RV32I_R(
    input   wire            op,

    input   wire [6:0]      ins_dec_op,
    input   wire [2:0]      ins_dec_funct3,
    input   wire [6:0]      ins_dec_funct7,

    input   wire [31:0]     reg_rs1_val,
    input   wire [31:0]     reg_rs2_val,

    input   wire [4:0]      reg_rd,

    output  reg             reg_w_op,
    output  reg [4:0]       reg_w_reg_idx,
    output  reg [31:0]      reg_w_reg_val
);

    always @(
        op

        or ins_dec_op
        or ins_dec_funct3
        or ins_dec_funct7

        or reg_rs1_val
        or reg_rs2_val

        or reg_rd
    ) begin
        if (op == 1'b1
                && ins_dec_op == 7'b0110011) begin
            if (ins_dec_funct3 == 3'h0
                    && ins_dec_funct7 == 7'h0) begin
                // ADD
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= reg_rs1_val + reg_rs2_val;
            end
            else if (ins_dec_funct3 == 3'h0
                    && ins_dec_funct7 == 7'h20) begin
                // SUB
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= reg_rs1_val - reg_rs2_val;
            end
            // ...............
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
