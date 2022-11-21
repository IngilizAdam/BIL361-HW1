`timescale 1ns / 1ps
module islemci(
    input clk, rst,
    input [31:0] buyruk,
    output [31:0] ps
    );
    
    reg [31:0] veri_bellek [127:0];
    reg [31:0] yazmac_obegi [7:0];
    reg [31:0] buyruk_adresi;
    
    reg [31:0] fark_sonuc;

    reg [31:0] ps_sonraki;
    reg [4:0] rd_adres;
    reg [31:0] rd_veri;
    reg [31:0] bellek_adresi;
    reg [31:0] bellek_veri;

    reg yazmaca_yaz, bellege_yaz;
    
    integer i;
    initial begin
        buyruk_adresi <= 0;
        ps_sonraki <= 32'b0;
        for(i = 0; i < 128; i = i + 1)
            veri_bellek[i] = 32'b0;

        for(i = 0; i < 8; i = i + 1)
            yazmac_obegi[i] = 32'b0;
        yazmaca_yaz <= 1'b0;
        bellege_yaz <= 1'b0;
    end
    
    always @(*) begin
        yazmaca_yaz = 0;
        bellege_yaz = 0;
        ps_sonraki = buyruk_adresi;
        if(rst == 1'b1) begin
            ps_sonraki = 32'b0;
        end
        else if (buyruk[6:0] == 7'b0110111) begin // LUI
            rd_adres = buyruk[11:7];
            rd_veri = {buyruk[31:12], 12'b0};
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
            ps_sonraki = buyruk_adresi+4;
        end
        else if (buyruk[6:0] == 7'b0010111) begin // AUIPC
            rd_adres = buyruk[11:7];
            rd_veri = buyruk_adresi + {buyruk[31:12], 12'h0};
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
            ps_sonraki = buyruk_adresi+4;
        end
        else if (buyruk[6:0] == 7'b1101111) begin // JAL
            rd_adres = buyruk[11:7];
            rd_veri = buyruk_adresi+4;
            if(buyruk[31:31] == 1'b0) begin
                ps_sonraki = buyruk_adresi + {11'b00000000000, buyruk[31:31], buyruk[19:12], buyruk[20:20], buyruk[30:21], 1'b0};
            end
            else begin
                ps_sonraki = buyruk_adresi + {11'b11111111111, buyruk[31:31], buyruk[19:12], buyruk[20:20], buyruk[30:21], 1'b0};
            end
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
        end
        else if (buyruk[6:0] == 7'b1100111 && buyruk[14:12] == 3'b000) begin // JALR
            rd_adres = buyruk[11:7];
            rd_veri = buyruk_adresi;
            if(buyruk[31:31] == 1'b0) begin
                ps_sonraki = yazmac_obegi[buyruk[19:15]] + {20'b00000000000000000000, buyruk[31:20], 1'b0};
            end
            else begin
                ps_sonraki = yazmac_obegi[buyruk[19:15]] + {20'b11111111111111111111, buyruk[31:20], 1'b0};
            end
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
        end
        else if (buyruk[6:0] == 7'b1100011 && buyruk[14:12] == 3'b000) begin // BEQ
            if(yazmac_obegi[buyruk[19:15]] == yazmac_obegi[buyruk[24:20]]) begin
                if(buyruk[31:31] == 1'b0) begin
                    ps_sonraki = buyruk_adresi + {19'b0000000000000000000, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
                else begin
                    ps_sonraki = buyruk_adresi + {19'b1111111111111111111, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
            end
            else begin
                ps_sonraki = buyruk_adresi+4;
            end
            yazmaca_yaz = 1'b0;
            bellege_yaz = 1'b0;
        end
        else if (buyruk[6:0] == 7'b1100011 && buyruk[14:12] == 3'b001) begin // BNE
            if(yazmac_obegi[buyruk[19:15]] != yazmac_obegi[buyruk[24:20]]) begin
                if(buyruk[31:31] == 1'b0) begin
                    ps_sonraki = buyruk_adresi + {19'b0000000000000000000, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
                else begin
                    ps_sonraki = buyruk_adresi + {19'b1111111111111111111, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
            end
            else begin
                ps_sonraki = buyruk_adresi+4;
            end
            yazmaca_yaz = 1'b0;
            bellege_yaz = 1'b0;
        end
        else if (buyruk[6:0] == 7'b1100011 && buyruk[14:12] == 3'b100) begin // BLT
            fark_sonuc = yazmac_obegi[buyruk[19:15]] - yazmac_obegi[buyruk[24:20]];
            if(fark_sonuc[31:31] == 1'b1) begin
                if(buyruk[31:31] == 1'b0) begin
                    ps_sonraki = buyruk_adresi + {19'b0000000000000000000, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
                else begin
                    ps_sonraki = buyruk_adresi + {19'b1111111111111111111, buyruk[31:31], buyruk[7:7], buyruk[30:25], buyruk[11:8], 1'b0};
                end
            end
            else begin
                ps_sonraki = buyruk_adresi+4;
            end
            yazmaca_yaz = 1'b0;
            bellege_yaz = 1'b0;
        end
        else if (buyruk[6:0] == 7'b0000011 && buyruk[14:12] == 3'b010) begin // LW
            if(buyruk[31:31] == 1'b0) begin
                bellek_adresi = yazmac_obegi[buyruk[19:15]] + {20'b00000000000000000000, buyruk[31:20]};
            end
            else begin
                bellek_adresi = yazmac_obegi[buyruk[19:15]] + {20'b11111111111111111111, buyruk[31:20]};
            end
            rd_adres = buyruk[11:7];
            rd_veri = veri_bellek[bellek_adresi/4];
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
            ps_sonraki = buyruk_adresi+4;
        end
        else if (buyruk[6:0] == 7'b0100011 && buyruk[14:12] == 3'b010) begin // SW
            if(buyruk[31:31] == 1'b0) begin
                bellek_adresi = yazmac_obegi[buyruk[19:15]] + {20'b00000000000000000000, buyruk[31:25], buyruk[11:7]};
            end
            else begin
                bellek_adresi = yazmac_obegi[buyruk[19:15]] + {20'b11111111111111111111, buyruk[31:25], buyruk[11:7]};
            end
            bellek_veri = yazmac_obegi[buyruk[24:20]];
            yazmaca_yaz = 1'b0;
            bellege_yaz = 1'b1;
            ps_sonraki = buyruk_adresi+4;
        end
        else if (buyruk[6:0] == 7'b0010011 && buyruk[14:12] == 3'b000) begin // ADDI
            if(buyruk[31:31] == 1'b0) begin
                rd_veri = yazmac_obegi[buyruk[19:15]] + {20'b00000000000000000000, buyruk[31:20]};
            end
            else begin
                rd_veri = yazmac_obegi[buyruk[19:15]] + {20'b11111111111111111111, buyruk[31:20]};
            end
            rd_adres = buyruk[11:7];
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
            ps_sonraki = buyruk_adresi+4;
        end
        else if (buyruk[6:0] == 7'b0110011 && buyruk[14:12] == 3'b000 && buyruk[31:25] == 7'b0000000) begin // ADD
            rd_veri = yazmac_obegi[buyruk[19:15]] + yazmac_obegi[buyruk[24:20]];
            rd_adres = buyruk[11:7];
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
            ps_sonraki = buyruk_adresi+4;
        end
        else if (buyruk[6:0] == 7'b0110011 && buyruk[14:12] == 3'b000 && buyruk[31:25] == 7'b0100000) begin // SUB
            rd_veri = yazmac_obegi[buyruk[19:15]] - yazmac_obegi[buyruk[24:20]];
            rd_adres = buyruk[11:7];
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
            ps_sonraki = buyruk_adresi+4;
        end
        else if (buyruk[6:0] == 7'b0110011 && buyruk[14:12] == 3'b110 && buyruk[31:25] == 7'b0000000) begin // OR
            rd_veri = yazmac_obegi[buyruk[19:15]] | yazmac_obegi[buyruk[24:20]];
            rd_adres = buyruk[11:7];
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
            ps_sonraki = buyruk_adresi+4;
        end
        else if (buyruk[6:0] == 7'b0110011 && buyruk[14:12] == 3'b111 && buyruk[31:25] == 7'b0000000) begin // AND
            rd_veri = yazmac_obegi[buyruk[19:15]] & yazmac_obegi[buyruk[24:20]];
            rd_adres = buyruk[11:7];
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
            ps_sonraki = buyruk_adresi+4;
        end
        else if (buyruk[6:0] == 7'b0110011 && buyruk[14:12] == 3'b100 && buyruk[31:25] == 7'b0000000) begin // XOR
            rd_veri = yazmac_obegi[buyruk[19:15]] ^ yazmac_obegi[buyruk[24:20]];
            rd_adres = buyruk[11:7];
            yazmaca_yaz = 1'b1;
            bellege_yaz = 1'b0;
            ps_sonraki = buyruk_adresi+4;
        end
    end
    
    always @(posedge clk) begin
        buyruk_adresi <= ps_sonraki;
    end

    always @(negedge clk) begin
        if(rst) begin
            for(i = 0; i < 128; i = i + 1)
                veri_bellek[i] <= 32'b0;
            for(i = 0; i < 8; i = i + 1)
                yazmac_obegi[i] <= 32'b0;
        end
        else begin
            if(yazmaca_yaz && rd_adres != 32'b0) begin
                yazmac_obegi[rd_adres] <= rd_veri;
            end
            if(bellege_yaz) begin
                veri_bellek[bellek_adresi/4] <= bellek_veri;
            end
        end
    end
    
    assign ps = ps_sonraki;
    
endmodule
