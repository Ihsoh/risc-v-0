module InsExec_RV32I_I_Ld(
    input   wire            op,

    input   wire [6:0]      ins_dec_op,
    input   wire [2:0]      ins_dec_funct3,

    input   wire [31:0]     mem_val,

    input   wire [4:0]      reg_rd,

    output  reg             reg_w_op,
    output  reg [4:0]       reg_w_reg_idx,
    output  reg [31:0]      reg_w_reg_val
);


    always @(
        op

        or ins_dec_op
        or ins_dec_funct3

        or reg_rd
    ) begin
        if (op == 1'b1
                && ins_dec_op == 7'b0000011) begin
            if (ins_dec_funct3 == 3'h0) begin
                // LOAD.B
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;

                if (mem_val[7] == 1'b1) begin
                    reg_w_reg_val <= {24'b1, mem_val[7:0]};
                end
                else begin
                    reg_w_reg_val <= {24'b0, mem_val[7:0]};
                end
            end
            else if (ins_dec_funct3 == 3'h1) begin
                // LOAD.H
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;

                if (mem_val[7] == 1'b1) begin
                    reg_w_reg_val <= {16'b1, mem_val[15:0]};
                end
                else begin
                    reg_w_reg_val <= {16'b0, mem_val[15:0]};
                end
            end
            else if (ins_dec_funct3 == 3'h2) begin
                // LOAD.W
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= mem_val;
            end
            else if (ins_dec_funct3 == 3'h4) begin
                // LOAD.B.U
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= {24'b0, mem_val[7:0]};
            end
            else if (ins_dec_funct3 == 3'h5) begin
                // LOAD.H.U
                reg_w_op <= 1'b1;
                reg_w_reg_idx <= reg_rd;
                reg_w_reg_val <= {16'b0, mem_val[15:0]};
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
