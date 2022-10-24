`timescale 1ns / 1ps
module tb_islemci();

    reg clk, rst;
    reg [31:0] buyruk;
    wire [31:0] ps, yeni_adres;
    islemci i(clk, rst, buyruk, ps, yeni_adres);
    
    initial begin
        clk <= 0;
        rst <= 0;
        buyruk <= 0;
    end
    
    always #5 clk<=~clk;
    
    always @(posedge clk) begin
        if(ps == 12) begin
            buyruk <= 32'b01011010010101101011001001101111;
        end
        else begin
            buyruk <= buyruk+1;
        end
    end

endmodule
