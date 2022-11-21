`timescale 1ns / 1ps
module buyruk_bellegi(
    input clk, rst,
    output [31:0] veri,
    input [31:0] adres
    );

    reg [31:0] buyruk_bellek [255:0];

    reg [31:0] veri_reg;

    always @(posedge clk) begin
        veri_reg = buyruk_bellek[adres >> 2];
    end

    assign veri = veri_reg;

endmodule
