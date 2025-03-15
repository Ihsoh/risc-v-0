module ImmExt(
    input wire [19:0] imm,
    input wire type,
    output reg [31:0] ext
);

    always @(imm or type) begin
        if (type == 1'b0) begin
            // 12 => 32
            if (imm[11] == 1'b0) begin
                // 0
                ext <= {20'b00000000000000000000, imm[11:0]};
            end
            else begin
                // 1
                ext <= {20'b11111111111111111111, imm[11:0]};
            end
        end
        else begin
            // 20 => 32
            if (imm[19] == 1'b0) begin
                // 0
                ext <= {12'b000000000000, imm[19:0]};
            end
            else begin
                // 1
                ext <= {12'b111111111111, imm[19:0]};
            end
        end
    end

endmodule
