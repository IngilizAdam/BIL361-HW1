`timescale 1ns / 1ps
module cevreleyici(
    input clk, rst
    );

    wire [31:0] buyruk, ps, oku_veri, yaz_veri, vb_adres;
    wire oku_aktif, yaz_aktif;
    islemcib islemci(clk, rst, buyruk, ps, oku_veri, oku_aktif, yaz_veri, yaz_aktif, vb_adres);

    buyruk_bellegi buyruk_bellegi(clk, rst, buyruk, ps);
    
    veri_bellegi veri_bellegi(clk, rst, oku_veri, oku_aktif, yaz_veri, yaz_aktif, vb_adres);

endmodule
