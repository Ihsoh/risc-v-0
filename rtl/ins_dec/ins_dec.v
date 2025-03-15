module InsDec(
    // 32位指令
    input wire [31:0] ins,

    // 操作码位段
    output reg [6:0] op,

    // 3位功能码位段  
    output reg [2:0] funct3,
    
    // 7位功能码位段
    output reg [6:0] funct7,
    
    // rs1地址位段
    output reg [4:0] rs1,

    // rs2地址位段
    output reg [4:0] rs2,

    // rd地址位段
    output reg [4:0] rd,

    // 立即数
    output reg [19:0] imm
);

    // RV32I R-type
    wire [6:0] rv32i_r_op;
    wire [2:0] rv32i_r_funct3;
    wire [6:0] rv32i_r_funct7;
    wire [4:0] rv32i_r_rs1;
    wire [4:0] rv32i_r_rs2;
    wire [4:0] rv32i_r_rd;
    wire [19:0] rv32i_r_imm;

    // RV32I I-type
    wire [6:0] rv32i_i_op;
    wire [2:0] rv32i_i_funct3;
    wire [6:0] rv32i_i_funct7;
    wire [4:0] rv32i_i_rs1;
    wire [4:0] rv32i_i_rs2;
    wire [4:0] rv32i_i_rd;
    wire [19:0] rv32i_i_imm;

    // RV32I S-type
    wire [6:0] rv32i_s_op;
    wire [2:0] rv32i_s_funct3;
    wire [6:0] rv32i_s_funct7;
    wire [4:0] rv32i_s_rs1;
    wire [4:0] rv32i_s_rs2;
    wire [4:0] rv32i_s_rd;
    wire [19:0] rv32i_s_imm;

    // RV32I B-type
    wire [6:0] rv32i_b_op;
    wire [2:0] rv32i_b_funct3;
    wire [6:0] rv32i_b_funct7;
    wire [4:0] rv32i_b_rs1;
    wire [4:0] rv32i_b_rs2;
    wire [4:0] rv32i_b_rd;
    wire [19:0] rv32i_b_imm;

    // RV32I U-type
    wire [6:0] rv32i_u_op;
    wire [2:0] rv32i_u_funct3;
    wire [6:0] rv32i_u_funct7;
    wire [4:0] rv32i_u_rs1;
    wire [4:0] rv32i_u_rs2;
    wire [4:0] rv32i_u_rd;
    wire [19:0] rv32i_u_imm;

    // RV32I J-type
    wire [6:0] rv32i_j_op;
    wire [2:0] rv32i_j_funct3;
    wire [6:0] rv32i_j_funct7;
    wire [4:0] rv32i_j_rs1;
    wire [4:0] rv32i_j_rs2;
    wire [4:0] rv32i_j_rd;
    wire [19:0] rv32i_j_imm;

    always @(ins) begin
        if (ins[6:0] == 7'b0110011
                    || ins[6:0] == 7'b1100111) begin
            // RV32I R-type
            op <= rv32i_r_op;
            funct3 <= rv32i_r_funct3;
            funct7 <= rv32i_r_funct7;
            rs1 <= rv32i_r_rs1;
            rs2 <= rv32i_r_rs2;
            rd <= rv32i_r_rd;
            imm <= rv32i_r_imm;
        end
        else if (ins[6:0] == 7'b0010011
                    || ins[6:0] == 7'b0000011
                    || ins[6:0] == 7'b1110011) begin
            // RV32I I-type
            op <= rv32i_i_op;
            funct3 <= rv32i_i_funct3;
            funct7 <= rv32i_i_funct7;
            rs1 <= rv32i_i_rs1;
            rs2 <= rv32i_i_rs2;
            rd <= rv32i_i_rd;
            imm <= rv32i_i_imm;
        end
        else if (ins[6:0] == 7'b0100011) begin
            // RV32I S-type
            op <= rv32i_s_op;
            funct3 <= rv32i_s_funct3;
            funct7 <= rv32i_s_funct7;
            rs1 <= rv32i_s_rs1;
            rs2 <= rv32i_s_rs2;
            rd <= rv32i_s_rd;
            imm <= rv32i_s_imm;
        end
        else if (ins[6:0] == 7'b1100011) begin
            // RV32I B-type
            op <= rv32i_b_op;
            funct3 <= rv32i_b_funct3;
            funct7 <= rv32i_b_funct7;
            rs1 <= rv32i_b_rs1;
            rs2 <= rv32i_b_rs2;
            rd <= rv32i_b_rd;
            imm <= rv32i_b_imm;
        end
        else if (ins[6:0] == 7'b1101111) begin
            // RV32I J-type
            op <= rv32i_j_op;
            funct3 <= rv32i_j_funct3;
            funct7 <= rv32i_j_funct7;
            rs1 <= rv32i_j_rs1;
            rs2 <= rv32i_j_rs2;
            rd <= rv32i_j_rd;
            imm <= rv32i_j_imm;
        end
        else if (ins[6:0] == 7'b0110111
                    || ins[6:0] == 7'b0010111) begin
            // RV32I U-type
            op <= rv32i_u_op;
            funct3 <= rv32i_u_funct3;
            funct7 <= rv32i_u_funct7;
            rs1 <= rv32i_u_rs1;
            rs2 <= rv32i_u_rs2;
            rd <= rv32i_u_rd;
            imm <= rv32i_u_imm;
        end
        else begin
            op <= 0;
            funct3 <= 0;
            funct7 <= 0;
            rs1 <= 0;
            rs2 <= 0;
            rd <= 0;
            imm <= 0;
        end
    end

    InsDec_RV32I_R u_ins_dec_rv32i_r(
        .ins(ins),
        .op(rv32i_r_op),
        .funct3(rv32i_r_funct3),
        .funct7(rv32i_r_funct7),
        .rs1(rv32i_r_rs1),
        .rs2(rv32i_r_rs2),
        .rd(rv32i_r_rd),
        .imm(rv32i_r_imm)
    );

    InsDec_RV32I_I u_ins_dec_rv32i_i(
        .ins(ins),
        .op(rv32i_i_op),
        .funct3(rv32i_i_funct3),
        .funct7(rv32i_i_funct7),
        .rs1(rv32i_i_rs1),
        .rs2(rv32i_i_rs2),
        .rd(rv32i_i_rd),
        .imm(rv32i_i_imm)
    );

    InsDec_RV32I_S u_ins_dec_rv32i_s(
        .ins(ins),
        .op(rv32i_s_op),
        .funct3(rv32i_s_funct3),
        .funct7(rv32i_s_funct7),
        .rs1(rv32i_s_rs1),
        .rs2(rv32i_s_rs2),
        .rd(rv32i_s_rd),
        .imm(rv32i_s_imm)
    );

    InsDec_RV32I_B u_ins_dec_rv32i_b(
        .ins(ins),
        .op(rv32i_b_op),
        .funct3(rv32i_b_funct3),
        .funct7(rv32i_b_funct7),
        .rs1(rv32i_b_rs1),
        .rs2(rv32i_b_rs2),
        .rd(rv32i_b_rd),
        .imm(rv32i_b_imm)
    );

    InsDec_RV32I_J u_ins_dec_rv32i_j(
        .ins(ins),
        .op(rv32i_j_op),
        .funct3(rv32i_j_funct3),
        .funct7(rv32i_j_funct7),
        .rs1(rv32i_j_rs1),
        .rs2(rv32i_j_rs2),
        .rd(rv32i_j_rd),
        .imm(rv32i_j_imm)
    );

    InsDec_RV32I_U u_ins_dec_rv32i_u(
        .ins(ins),
        .op(rv32i_u_op),
        .funct3(rv32i_u_funct3),
        .funct7(rv32i_u_funct7),
        .rs1(rv32i_u_rs1),
        .rs2(rv32i_u_rs2),
        .rd(rv32i_u_rd),
        .imm(rv32i_u_imm)
    );

endmodule
