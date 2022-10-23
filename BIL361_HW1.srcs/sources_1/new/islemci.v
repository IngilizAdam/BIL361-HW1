`timescale 1ns / 1ps
module islemci(
    input clk, rst,
    input [31:0] buyruk,
    output reg [31:0] ps
    );
    
    reg [31:0] veri_bellek [127:0];
    reg [31:0] yazmac_obegi [7:0];
    reg [31:0] buyruk_bellegi [255:0];
    reg [31:0] simdiki_buyruk;
    
    initial begin
            buyruk_bellegi[0] <= 32'h0000_0000;
            simdiki_buyruk <= 32'h0000_0000;
            ps <= 32'h0000_0004;
    end
    
    always @* begin
        if (simdiki_buyruk[6:0] == 7'b0110111) begin // LUI
            
        end
        else if (simdiki_buyruk[6:0] == 7'b0010111) begin // AUIPC
            
        end
        else if (simdiki_buyruk[6:0] == 7'b1101111) begin // JAL
            
        end
        else if (simdiki_buyruk[6:0] == 7'b1100111 && simdiki_buyruk[14:12] == 3'b000) begin // JALR
            
        end
        else if (simdiki_buyruk[6:0] == 7'b1100011 && simdiki_buyruk[14:12] == 3'b000) begin // BEQ
            
        end
        else if (simdiki_buyruk[6:0] == 7'b1100011 && simdiki_buyruk[14:12] == 3'b001) begin // BNE
            
        end
        else if (simdiki_buyruk[6:0] == 7'b1100011 && simdiki_buyruk[14:12] == 3'b100) begin // BLT
            
        end
        else if (simdiki_buyruk[6:0] == 7'b0000011 && simdiki_buyruk[14:12] == 3'b010) begin // LW
            
        end
        else if (simdiki_buyruk[6:0] == 7'b0100011 && simdiki_buyruk[14:12] == 3'b010) begin // SW
            
        end
        else if (simdiki_buyruk[6:0] == 7'b0010011 && simdiki_buyruk[14:12] == 3'b000) begin // ADDI
            
        end
        else if (simdiki_buyruk[6:0] == 7'b0110011 && simdiki_buyruk[14:12] == 3'b000 && simdiki_buyruk[31:25] == 7'b0000000) begin // ADD
            
        end
        else if (simdiki_buyruk[6:0] == 7'b0110011 && simdiki_buyruk[14:12] == 3'b000 && simdiki_buyruk[31:25] == 7'b0100000) begin // SUB
            
        end
        else if (simdiki_buyruk[6:0] == 7'b0110011 && simdiki_buyruk[14:12] == 3'b110 && simdiki_buyruk[31:25] == 7'b0000000) begin // OR
            
        end
        else if (simdiki_buyruk[6:0] == 7'b0110011 && simdiki_buyruk[14:12] == 3'b111 && simdiki_buyruk[31:25] == 7'b0000000) begin // AND
            
        end
        else if (simdiki_buyruk[6:0] == 7'b0110011 && simdiki_buyruk[14:12] == 3'b100 && simdiki_buyruk[31:25] == 7'b0000000) begin // XOR
            
        end
    end
    
    always @(posedge clk) begin
        ps <= buyruk_bellegi[0];
    end
    
endmodule
