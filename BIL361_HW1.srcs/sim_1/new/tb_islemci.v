`timescale 1ns / 1ps
module tb_islemci();

    reg [31:0] buyruk_bellegi [255:0];

    reg clk, rst;
    reg [31:0] buyruk;
    wire [31:0] ps, yeni_adres;
    islemci i(clk, rst, buyruk, ps, yeni_adres);
    
    wire [31:0] test [7:0];
    
    assign test[0] = islemci.yazmac_obegi[0];
    assign test[1] = islemci.yazmac_obegi[1];
    assign test[2] = islemci.yazmac_obegi[2];
    assign test[3] = islemci.yazmac_obegi[3];
    assign test[4] = islemci.yazmac_obegi[4];
    assign test[5] = islemci.yazmac_obegi[5];
    assign test[6] = islemci.yazmac_obegi[6];
    assign test[7] = islemci.yazmac_obegi[7];
    
    initial begin
        clk <= 0;
        rst <= 0;
        buyruk_bellegi[0] <= 32'b000000001010_00000_000_00100_0010011;
        buyruk_bellegi[1] <= 32'b000000010100_00000_000_01000_0010011;
        buyruk_bellegi[2] <= 32'b000000001010_00000_000_01100_0010011;
        buyruk_bellegi[3] <= 32'b000000001010_00100_000_00100_0010011;
        buyruk_bellegi[4] <= 32'b1_111111_01100_01000_000_1110_1_1100011;
        buyruk_bellegi[5] <= 32'b000000010100_01100_000_01100_0010011;
    end
    
    always #5 clk <= ~clk;
    
    always @(posedge clk) begin
        buyruk = buyruk_bellegi[ps/4];
    end

    /*
    addi x1, x0, 10     // 32'b000000001010_00000_000_00100_0010011
    addi x2, x0, 20     // 32'b000000010100_00000_000_01000_0010011
    addi x3, x0, 10     // 32'b000000001010_00000_000_01100_0010011
    addi x3, x3, 10     // 32'b000000001010_00100_000_00100_0010011
    beq  x2, x3, -4     // 32'b1_111111_01100_01000_000_1110_1_1100011
    addi x3, x3, 20     // 32'b000000010100_01100_000_01100_0010011
    */

endmodule
