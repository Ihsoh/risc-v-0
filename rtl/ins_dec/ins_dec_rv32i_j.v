module InsDec_RV32I_J(
    // 32位指令
    input wire [31:0] ins,

    // 操作码位段
    output wire [6:0] op,

    // 3位功能码位段  
    output wire [2:0] funct3,
    
    // 7位功能码位段
    output wire [6:0] funct7,
    
    // rs1地址位段
    output wire [4:0] rs1,

    // rs2地址位段
    output wire [4:0] rs2,

    // rd地址位段
    output wire [4:0] rd,

    // 立即数
    output wire [19:0] imm
);

    assign op = ins[6:0];
    assign funct3 = 3'd0;
    assign funct7 = 7'd0;
    assign rs1 = 5'd0;
    assign rs2 = 5'd0;
    assign rd = ins[11:7];
    assign imm = {ins[31:31], ins[19:12], ins[20:20], ins[30:21]};

endmodule