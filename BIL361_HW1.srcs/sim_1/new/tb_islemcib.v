`timescale 1ns / 1ps
module tb_islemcib();

    reg clk, rst;
    cevreleyici i(clk, rst);
    
    initial begin
        clk <= 0;
        rst <= 0;
    end
    
    always #5 clk <= ~clk;


endmodule
