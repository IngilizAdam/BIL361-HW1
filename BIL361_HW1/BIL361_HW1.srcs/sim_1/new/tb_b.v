`timescale 1ns / 1ps

module tb_b();

reg             clk_i;
reg             rst_i;

cevreleyici uut (
    .clk        ( clk_i ),
    .rst        ( rst_i )   
);

always begin
    clk_i = 1'b0;
    #5;
    clk_i = 1'b1;
    #5;
end

initial begin
    rst_i = 1'b1;
    repeat(10) @(posedge clk_i) #2;                         // 10 cevrim boyunca resetle
    rst_i = 1'b0;
    uut.buyruk_bellegi.buyruk_bellek['h000] = 'h00500093;   // addi x1, x0, 5
    uut.buyruk_bellegi.buyruk_bellek['h001] = 'h00700113;   // addi x2, x0, 7
    uut.buyruk_bellegi.buyruk_bellek['h002] = 'h002081b3;   // add  x3, x1, x2
    uut.buyruk_bellegi.buyruk_bellek['h003] = 'h0011a023;   // sw   x1, 0(x3)
    repeat(5) @(posedge clk_i) #2;                          // 5 cevrim gecsin
    if (uut.islemci.yazmac_obegi[3] == 'd12) begin // x3 == 12
        $display("Yazmac erisimi ve deger dogru.");
    end
    if (uut.veri_bellegi.veri_bellek[uut.islemci.yazmac_obegi[3] >> 2] == uut.islemci.yazmac_obegi[1]) begin // Bellek[x3] (Satir[x3 >> 2]) == x1
        $display("Bellek erisimi ve deger dogru.");
    end
end

endmodule
