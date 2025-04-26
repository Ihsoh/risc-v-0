module InsExec_RV32I_S(
    input   wire            op,

    input   wire [6:0]      ins_dec_op,
    input   wire [2:0]      ins_dec_funct3,

    input   wire [31:0]     reg_rs1_val,
    input   wire [31:0]     reg_rs2_val,

    input   wire            imm_ext_type,
    input   wire [31:0]     imm_ext_ext,

    input   wire [31:0]     mem_r_val,

    output  reg             mem_w_op,
    output  reg [31:0]      mem_w_mem_addr,
    output  reg [31:0]      mem_w_mem_val
);

    always @(
        op

        or ins_dec_op
        or ins_dec_funct3

        or reg_rs1_val
        or reg_rs2_val

        or imm_ext_type
        or imm_ext_ext

        or mem_r_val
    ) begin
        if (op == 1'b1
                && ins_dec_op == 7'b0100011) begin
            if (ins_dec_funct3 == 3'h0) begin
                // STORE.B
                mem_w_op <= 1'b1;
                mem_w_mem_addr <= reg_rs1_val + imm_ext_ext;
                mem_w_mem_val <= {mem_r_val[31:8], reg_rs2_val[7:0]};
            end
            else if (ins_dec_funct3 == 3'h1) begin
                // STORE.H
                mem_w_op <= 1'b1;
                mem_w_mem_addr <= reg_rs1_val + imm_ext_ext;
                mem_w_mem_val <= {mem_r_val[31:16], reg_rs2_val[15:0]};
            end
            else if (ins_dec_funct3 == 3'h2) begin
                // STORE.W
                mem_w_op <= 1'b1;
                mem_w_mem_addr <= reg_rs1_val + imm_ext_ext;
                mem_w_mem_val <= reg_rs2_val;
            end
            else begin
                mem_w_op <= 1'b0;
                mem_w_mem_addr <= 32'd0;
                mem_w_mem_val <= 32'd0;
            end
        end
        else begin
            mem_w_op <= 1'b0;
            mem_w_mem_addr <= 32'd0;
            mem_w_mem_val <= 32'd0;
        end
    end

endmodule
