`timescale 1ns / 1ns

module TB_InsDec();

    // 32位指令
    reg [31:0] ins;

    // 操作码位段
    wire [6:0] op;

    // 3位功能码位段  
    wire [2:0] funct3;
    
    // 7位功能码位段
    wire [6:0] funct7;
    
    // rs1地址位段
    wire [4:0] rs1;

    // rs2地址位段
    wire [4:0] rs2;

    // rd地址位段
    wire [4:0] rd;

    // 立即数
    wire [19:0] imm;

    initial begin
        /*========================================
            RV32I R-type
          ========================================*/
        /*
            add x1, x2, x3

            ins = 32'h003100B3
            ins = 32'b00000000001100010000000010110011

            op = 7'b0110011
            funct3 = 3'b000
            funct7 = 7'b0000000
            rs1 = 5'b00010
            rs2 = 5'b00011
            rd = 5'b00001
            imm = 20'd0 (X)
        */
        ins <= 32'h003100B3;
        #20;
        if (op != 7'b0110011) begin
            $error("[TB_INS_DEC] CHECK ERROR: op error");
            $stop;
        end
        if (funct3 != 3'b000) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct3 error");
            $stop;
        end
        if (funct7 != 7'b0000000) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct7 error");
            $stop;
        end
        if (rs1 != 5'b00010) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs1 error");
            $stop;
        end
        if (rs2 != 5'b00011) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs2 error");
            $stop;
        end
        if (rd != 5'b00001) begin
            $error("[TB_INS_DEC] CHECK ERROR: rd error");
            $stop;
        end
        if (imm != 20'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: imm error");
            $stop;
        end
        #20;

        /*
            sub x2, x3, x4

            ins = 32'h40418133
            ins = 32'b01000000010000011000000100110011

            op = 7'b0110011
            funct3 = 3'b000
            funct7 = 7'b0100000
            rs1 = 5'b00011
            rs2 = 5'b00100
            rd = 5'b00010
            imm = 20'd0 (X)
        */
        ins <= 32'h40418133;
        #20;
        if (op != 7'b0110011) begin
            $error("[TB_INS_DEC] CHECK ERROR: op error");
            $stop;
        end
        if (funct3 != 3'b000) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct3 error");
            $stop;
        end
        if (funct7 != 7'b0100000) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct7 error");
            $stop;
        end
        if (rs1 != 5'b00011) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs1 error");
            $stop;
        end
        if (rs2 != 5'b00100) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs2 error");
            $stop;
        end
        if (rd != 5'b00010) begin
            $error("[TB_INS_DEC] CHECK ERROR: rd error");
            $stop;
        end
        if (imm != 20'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: imm error");
            $stop;
        end
        #20;

        /*
            xor x3, x4, x5

            ins = 32'h005241B3
            ins = 32'b00000000010100100100000110110011

            op = 7'b0110011
            funct3 = 3'b100
            funct7 = 7'b0000000
            rs1 = 5'b00100
            rs2 = 5'b00101
            rd = 5'b00011
            imm = 20'd0 (X)
        */
        ins <= 32'h005241B3;
        #20;
        if (op != 7'b0110011) begin
            $error("[TB_INS_DEC] CHECK ERROR: op error");
            $stop;
        end
        if (funct3 != 3'b100) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct3 error");
            $stop;
        end
        if (funct7 != 7'b0000000) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct7 error");
            $stop;
        end
        if (rs1 != 5'b00100) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs1 error");
            $stop;
        end
        if (rs2 != 5'b00101) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs2 error");
            $stop;
        end
        if (rd != 5'b00011) begin
            $error("[TB_INS_DEC] CHECK ERROR: rd error");
            $stop;
        end
        if (imm != 20'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: imm error");
            $stop;
        end
        #20;

        /*========================================
            RV32I I-type
          ========================================*/
        /*
            add x1, x2, 0b101010101010

            ins = 32'hAAA14093
            ins = 32'b10101010101000010100000010010011

            op = 7'b0010011
            funct3 = 3'b100
            funct7 = 7'd0 (X)
            rs1 = 5'b00010
            rs2 = 5'd0 (X)
            rd = 5'b00001
            imm = 20'b101010101010
        */
        ins <= 32'hAAA14093;
        #20;
        if (op != 7'b0010011) begin
            $error("[TB_INS_DEC] CHECK ERROR: op error");
            $stop;
        end
        if (funct3 != 3'b100) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct3 error");
            $stop;
        end
        if (funct7 != 7'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct7 error");
            $stop;
        end
        if (rs1 != 5'b00010) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs1 error");
            $stop;
        end
        if (rs2 != 5'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs2 error");
            $stop;
        end
        if (rd != 5'b00001) begin
            $error("[TB_INS_DEC] CHECK ERROR: rd error");
            $stop;
        end
        if (imm != 20'b101010101010) begin
            $error("[TB_INS_DEC] CHECK ERROR: imm error");
            $stop;
        end
        #20;

        /*========================================
            RV32I S-type
          ========================================*/
        /*
            sw x1, 0b101010101010(x2)

            ins = 32'hAA20A523
            ins = 32'b10101010001000001010010100100011

            op = 7'b0100011
            funct3 = 3'b010
            funct7 = 7'd0 (X)
            rs1 = 5'b00001
            rs2 = 5'b00010
            rd = 5'd0 (X)
            imm = 20'b101010101010
        */
        ins <= 32'hAA20A523;
        #20;
        if (op != 7'b0100011) begin
            $error("[TB_INS_DEC] CHECK ERROR: op error");
            $stop;
        end
        if (funct3 != 3'b010) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct3 error");
            $stop;
        end
        if (funct7 != 7'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct7 error");
            $stop;
        end
        if (rs1 != 5'b00001) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs1 error");
            $stop;
        end
        if (rs2 != 5'b00010) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs2 error");
            $stop;
        end
        if (rd != 5'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: rd error");
            $stop;
        end
        if (imm != 20'b101010101010) begin
            $error("[TB_INS_DEC] CHECK ERROR: imm error");
            $stop;
        end
        #20;

        /*========================================
            RV32I B-type
          ========================================*/
        /*
            bgeu x1, x2, 0b101010101010

            ins = 32'hD420FA63
            ins = 32'b11010100001000001111101001100011

            op = 7'b1100011
            funct3 = 3'b111
            funct7 = 7'd0 (X)
            rs1 = 5'b00001
            rs2 = 5'b00010
            rd = 5'd0 (X)
            imm = 20'b101010101010
        */
        ins <= 32'hD420FA63;
        #20;
        if (op != 7'b1100011) begin
            $error("[TB_INS_DEC] CHECK ERROR: op error");
            $stop;
        end
        if (funct3 != 3'b111) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct3 error");
            $stop;
        end
        if (funct7 != 7'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct7 error");
            $stop;
        end
        if (rs1 != 5'b00001) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs1 error");
            $stop;
        end
        if (rs2 != 5'b00010) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs2 error");
            $stop;
        end
        if (rd != 5'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: rd error");
            $stop;
        end
        if (imm != 20'b101010101010) begin
            $error("[TB_INS_DEC] CHECK ERROR: imm error");
            $stop;
        end
        #20;

        /*========================================
            RV32I J-type
          ========================================*/
        /*
            jal x1, 0b10101010101010101010

            ins = 32'hD54550EF
            ins = 32'b11010101010001010101000011101111

            op = 7'b1101111
            funct3 = 3'd0 (X)
            funct7 = 7'd0 (X)
            rs1 = 5'd0 (X)
            rs2 = 5'd0 (X)
            rd = 5'b00001
            imm = 20'b10101010101010101010
        */
        ins <= 32'hD54550EF;
        #20;
        if (op != 7'b1101111) begin
            $error("[TB_INS_DEC] CHECK ERROR: op error");
            $stop;
        end
        if (funct3 != 3'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct3 error");
            $stop;
        end
        if (funct7 != 7'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct7 error");
            $stop;
        end
        if (rs1 != 5'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs1 error");
            $stop;
        end
        if (rs2 != 5'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs2 error");
            $stop;
        end
        if (rd != 5'b00001) begin
            $error("[TB_INS_DEC] CHECK ERROR: rd error");
            $stop;
        end
        if (imm != 20'b10101010101010101010) begin
            $error("[TB_INS_DEC] CHECK ERROR: imm error");
            $stop;
        end
        #20;

        /*========================================
            RV32I J-type
          ========================================*/
        /*
            lui x1, 0b10101010101010101010

            ins = 32'hAAAAA0B7
            ins = 32'b10101010101010101010000010110111

            op = 7'b0110111
            funct3 = 3'd0 (X)
            funct7 = 7'd0 (X)
            rs1 = 5'd0 (X)
            rs2 = 5'd0 (X)
            rd = 5'b00001
            imm = 20'b10101010101010101010
        */
        ins <= 32'hAAAAA0B7;
        #20;
        if (op != 7'b0110111) begin
            $error("[TB_INS_DEC] CHECK ERROR: op error");
            $stop;
        end
        if (funct3 != 3'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct3 error");
            $stop;
        end
        if (funct7 != 7'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: funct7 error");
            $stop;
        end
        if (rs1 != 5'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs1 error");
            $stop;
        end
        if (rs2 != 5'd0) begin
            $error("[TB_INS_DEC] CHECK ERROR: rs2 error");
            $stop;
        end
        if (rd != 5'b00001) begin
            $error("[TB_INS_DEC] CHECK ERROR: rd error");
            $stop;
        end
        if (imm != 20'b10101010101010101010) begin
            $error("[TB_INS_DEC] CHECK ERROR: imm error");
            $stop;
        end
        #20;

        $display("[TB_INS_DEC] CHECK PASSED!");
    end

    InsDec u_ins_dec(
        .ins(ins),
        .op(op),
        .funct3(funct3),
        .funct7(funct7),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm)
    );

endmodule
