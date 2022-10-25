`timescale 1ns / 1ps
module tb_islemci();

    reg [31:0] buyruk_bellegi [255:0];

    reg clk, rst;
    reg [31:0] buyruk;
    wire [31:0] ps, yeni_adres;
    wire [31:0] yazmac_obegi [7:0];
    wire [31:0] veri_bellek [127:0];
    islemci i(clk, rst, buyruk, ps, yeni_adres, yazmac_obegi, veri_bellek);
    
    initial begin
        clk <= 0;
        rst <= 0;
        buyruk_bellegi[0] <= 32'b000000001010_00000_000_00100_0010011;
        buyruk_bellegi[1] <= 32'b000000010100_00000_000_01000_0010011;
        buyruk_bellegi[2] <= 32'b000000011110_00000_000_01100_0010011;
        buyruk_bellegi[3] <= 32'b1_111111_01100_00100_000_1110_1_1100011;
        buyruk_bellegi[4] <= 32'b000000010100_00000_000_01100_0010011;
    end
    
    always #5 clk <= ~clk;
    
    always @(posedge clk) begin
        buyruk = buyruk_bellegi[ps/4];
    end

    /*
    addi x1, x0, 10     // 32'b000000001010_00000_000_00100_0010011
    addi x2, x0, 20     // 32'b000000010100_00000_000_01000_0010011
    addi x3, x0, 10     // 32'b000000001010_00000_000_01100_0010011
    beq  x1, x2, 4      // 32'b1_111111_01100_00100_000_1110_1_1100011
    addi x3, x0, 20     // 32'b000000010100_00000_000_01100_0010011
    */

endmodule
