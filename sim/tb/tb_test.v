`timescale 1ns / 1ns

module TB_Test();

    parameter  CLK_PERIOD = 20;

    reg [31:0]      a;
    reg [31:0]      b;

    wire signed [31:0]     a_signed;
    wire signed [32:0]     b_signed;

    assign a_signed = $signed(a);
    assign b_signed = $signed(b);

    initial begin
        a = 1;
        b = -1;

        $display("a = %d, %b", a, a);
        $display("b = %d, %b", b, b);
        if (a > b) begin
            $display("a > b");
        end
        else begin
            $display("a <= b");
        end

        $display("$signed(a) = %d, %b", $signed(a), $signed(a));
        $display("$signed(b) = %d, %b", $signed(b), $signed(b));
        if ($signed(a) > $signed(b)) begin
            $display("$signed(a) > $signed(b)");
        end
        else begin
            $display("$signed(a) <= $signed(b)");
        end
        
        #100;
        
        $display("a_signed = %d, %b", a_signed, a_signed);
        $display("b_signed = %d, %b", b_signed, b_signed);
        if (a_signed > b_signed) begin
            $display("a_signed > b_signed");
        end
        else begin
            $display("a_signed <= b_signed");
        end

    end

endmodule
