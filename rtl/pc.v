module PC(
    // 时钟
    input                   sys_clk,
    
    // 下降沿复位
    input                   sys_rst,
    
    // 操作
    // 0 = 无操作
    // 1 = PC递增
    input                   op,

    // 数据选择器
    input                   pc_src,
    
    input   [31:0]          alu_output,
    output  reg [31:0]      current_pc,
    output  reg [31:0]      next_pc
);

    initial begin
        current_pc <= 32'd0;
        next_pc <= 32'd0;
    end

    always @(negedge sys_clk) begin
        if (sys_rst) begin
            current_pc <= 32'd0;
            next_pc <= 32'd4;
        end
        else if (op == 1'd1) begin
            case (pc_src)
                1'b0: begin
                    current_pc <= next_pc;
                    next_pc <= next_pc + 4;
                end
                1'b1: begin
                    current_pc <= next_pc;
                    next_pc <= alu_output;
                end
                default: begin
                    current_pc <= current_pc;
                    next_pc <= next_pc;
                end
            endcase
        end
        else begin
            next_pc <= next_pc;
        end
    end

    // always @(negedge sys_clk) begin
    //     if (sys_rst) begin
    //         next_pc <= next_pc;
    //     end
    //     else if (op == 1'd1) begin
    //         case (pc_src)
    //             1'b0: begin
    //                 next_pc <= next_pc + 4;
    //             end
    //             1'b1: begin
    //                 next_pc <= alu_output;
    //             end
    //             default: begin
    //                 next_pc <= next_pc + 4;
    //             end
    //         endcase
    //     end
    //     else begin
    //         next_pc <= next_pc;
    //     end
    // end

    // always @(posedge sys_clk or negedge sys_rst) begin
    //     if (sys_rst) begin
    //         current_pc <= 32'd0;
    //         next_pc <= 32'd0;
    //     end
    //     else begin
    //         current_pc <= next_pc;
    //         next_pc <= next_pc;
    //     end
    // end

endmodule
