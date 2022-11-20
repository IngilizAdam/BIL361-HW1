`timescale 1ns / 1ps
module veri_bellegi(
    input clk, rst,
    output [31:0] oku_veri,
    input oku_aktif,
    input [31:0] yaz_veri,
    input yaz_aktif,
    input [31:0] adres
    );

    reg [31:0] veri_bellek [127:0];
    
    reg [31:0] oku_veri_reg;

    integer i;
    initial begin
        for(i = 0; i < 128; i = i+1) begin
            veri_bellek[i] = 32'b0;
        end
    end

    always @(*) begin
        if(rst) begin
            for(i = 0; i < 128; i = i+1) begin
                veri_bellek[i] = 32'b0;
            end
        end
        else if(oku_aktif) begin
            oku_veri_reg = veri_bellek[adres >> 2];
        end
        
    end

    always @(negedge clk) begin
        if(yaz_aktif && !rst) begin
            veri_bellek[adres >> 2] = yaz_veri;
        end
    end

    assign oku_veri = oku_veri_reg;

endmodule
