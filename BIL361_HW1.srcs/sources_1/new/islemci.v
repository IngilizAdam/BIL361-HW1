`timescale 1ns / 1ps
module islemci(
    input clk, rst,
    input [31:0] buyruk,
    output reg [31:0] ps,
    // bunun asagisi debug icin kullanildi
    output reg [31:0] yeni_adres
    );
    
    reg [31:0] veri_bellek [127:0];
    reg [31:0] yazmac_obegi [7:0];
    reg [31:0] buyruk_adresi;
    
    //reg [31:0] yeni_adres;
    reg [31:0] fark_sonuc;
    reg [31:0] bellek_adresi;
    
    initial begin
        ps <= 32'h0000_0000;
        yazmac_obegi[0] <= 32'h0000_0000; // R0 her zaman 0
    end
    
    always @* begin
        if (buyruk[6:0] == 7'b0110111) begin // LUI
            yazmac_obegi[buyruk[11:7]/4] = {buyruk[31:12], 12'b0};
        end
        else if (buyruk[6:0] == 7'b0010111) begin // AUIPC
            yazmac_obegi[buyruk[11:7]/4] = buyruk_adresi + {buyruk[31:12], 12'h0};
        end
        else if (buyruk[6:0] == 7'b1101111) begin // JAL
            yazmac_obegi[buyruk[11:7]/4] = ps;
            if(buyruk[31:31] == 1'b0) begin
                yeni_adres = buyruk_adresi + {11'b00000000000, buyruk[31:31], buyruk[19:12], buyruk[20:20], buyruk[30:21], 1'b0};
            end
            else begin
                yeni_adres = buyruk_adresi + {11'b11111111111, buyruk[31:31], buyruk[19:12], buyruk[20:20], buyruk[30:21], 1'b0};
            end
            ps = yeni_adres;
        end
        else if (buyruk[6:0] == 7'b1100111 && buyruk[14:12] == 3'b000) begin // JALR
            yazmac_obegi[buyruk[11:7]/4] = ps;
            if(buyruk[31:31] == 1'b0) begin
                yeni_adres = yazmac_obegi[buyruk[19:15]/4] + {20'b00000000000000000000, buyruk[31:20]};
            end
            else begin
                yeni_adres = yazmac_obegi[buyruk[19:15]/4] + {20'b11111111111111111111, buyruk[31:20]};
            end
            ps = {yeni_adres[31:1], 1'b0};
        end
        else if (buyruk[6:0] == 7'b1100011 && buyruk[14:12] == 3'b000) begin // BEQ
            if(yazmac_obegi[buyruk[19:15]/4] == yazmac_obegi[buyruk[24:20]/4]) begin
                if(buyruk[31:31] == 1'b0) begin
                    yeni_adres = buyruk_adresi + {19'b0000000000000000000, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
                else begin
                    yeni_adres = buyruk_adresi + {19'b1111111111111111111, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
                ps = yeni_adres;
            end
        end
        else if (buyruk[6:0] == 7'b1100011 && buyruk[14:12] == 3'b001) begin // BNE
            if(yazmac_obegi[buyruk[19:15]/4] != yazmac_obegi[buyruk[24:20]/4]) begin
                if(buyruk[31:31] == 1'b0) begin
                    yeni_adres = buyruk_adresi + {19'b0000000000000000000, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
                else begin
                    yeni_adres = buyruk_adresi + {19'b1111111111111111111, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
                ps = yeni_adres;
            end
        end
        else if (buyruk[6:0] == 7'b1100011 && buyruk[14:12] == 3'b100) begin // BLT
            fark_sonuc = yazmac_obegi[buyruk[19:15]/4] - yazmac_obegi[buyruk[24:20]/4];
            if(fark_sonuc[31:31] == 1'b1) begin
                if(buyruk[31:31] == 1'b0) begin
                    yeni_adres = buyruk_adresi + {19'b0000000000000000000, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
                else begin
                    yeni_adres = buyruk_adresi + {19'b1111111111111111111, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
                ps = yeni_adres;
            end
        end
        else if (buyruk[6:0] == 7'b0000011 && buyruk[14:12] == 3'b010) begin // LW
            if(buyruk[31:31] == 1'b0) begin
                bellek_adresi = yazmac_obegi[buyruk[19:15]/4] + {20'b00000000000000000000, buyruk[31:20]};
            end
            else begin
                bellek_adresi = yazmac_obegi[buyruk[19:15]/4] + {20'b11111111111111111111, buyruk[31:20]};
            end
            yazmac_obegi[buyruk[11:7]/4] = veri_bellek[bellek_adresi/4];
        end
        else if (buyruk[6:0] == 7'b0100011 && buyruk[14:12] == 3'b010) begin // SW
            if(buyruk[31:31] == 1'b0) begin
                bellek_adresi = yazmac_obegi[buyruk[19:15]/4] + {20'b00000000000000000000, buyruk[31:25], buyruk[11:7]};
            end
            else begin
                bellek_adresi = yazmac_obegi[buyruk[19:15]/4] + {20'b11111111111111111111, buyruk[31:25], buyruk[11:7]};
            end
            veri_bellek[bellek_adresi/4] = yazmac_obegi[buyruk[24:20]/4];
        end
        else if (buyruk[6:0] == 7'b0010011 && buyruk[14:12] == 3'b000) begin // ADDI
            if(buyruk[31:31] == 1'b0) begin
                yazmac_obegi[buyruk[11:7]/4] = yazmac_obegi[buyruk[19:15]/4] + {20'b00000000000000000000, buyruk[31:20]};
            end
            else begin
                yazmac_obegi[buyruk[11:7]/4] = yazmac_obegi[buyruk[19:15]/4] + {20'b11111111111111111111, buyruk[31:20]};
            end
        end
        else if (buyruk[6:0] == 7'b0110011 && buyruk[14:12] == 3'b000 && buyruk[31:25] == 7'b0000000) begin // ADD
            yazmac_obegi[buyruk[11:7]/4] = yazmac_obegi[buyruk[19:15]/4] + yazmac_obegi[buyruk[24:20]/4];
        end
        else if (buyruk[6:0] == 7'b0110011 && buyruk[14:12] == 3'b000 && buyruk[31:25] == 7'b0100000) begin // SUB
            yazmac_obegi[buyruk[11:7]/4] = yazmac_obegi[buyruk[19:15]/4] - yazmac_obegi[buyruk[24:20]/4];
        end
        else if (buyruk[6:0] == 7'b0110011 && buyruk[14:12] == 3'b110 && buyruk[31:25] == 7'b0000000) begin // OR
            yazmac_obegi[buyruk[11:7]/4] = yazmac_obegi[buyruk[19:15]/4] | yazmac_obegi[buyruk[24:20]/4];
        end
        else if (buyruk[6:0] == 7'b0110011 && buyruk[14:12] == 3'b111 && buyruk[31:25] == 7'b0000000) begin // AND
            yazmac_obegi[buyruk[11:7]/4] = yazmac_obegi[buyruk[19:15]/4] & yazmac_obegi[buyruk[24:20]/4];
        end
        else if (buyruk[6:0] == 7'b0110011 && buyruk[14:12] == 3'b100 && buyruk[31:25] == 7'b0000000) begin // XOR
            yazmac_obegi[buyruk[11:7]/4] = yazmac_obegi[buyruk[19:15]/4] ^ yazmac_obegi[buyruk[24:20]/4];
        end
    end
    
    always @(posedge clk) begin
        buyruk_adresi <= ps;
        ps <= ps + 32'b100;
    end
    
endmodule
