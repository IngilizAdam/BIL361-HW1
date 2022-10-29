`timescale 1ns / 1ps
module tb_islemci();

    reg [31:0] buyruk_bellegi [255:0];

    reg clk, rst;
    reg [31:0] buyruk;
    wire [31:0] ps;
    islemci i(clk, rst, buyruk, ps);
    
    initial begin
        clk <= 0;
        rst <= 0;
        buyruk_bellegi[0]  <= 32'b000000000010_00000_000_00001_0010011;
        buyruk_bellegi[1]  <= 32'b000000000100_00000_000_00010_0010011;
        buyruk_bellegi[2]  <= 32'b000000000110_00000_000_00011_0010011;
        buyruk_bellegi[3]  <= 32'b000000001000_00000_000_00100_0010011;
        buyruk_bellegi[4]  <= 32'b000000001010_00000_000_00101_0010011;
        buyruk_bellegi[5]  <= 32'h00102023;
        buyruk_bellegi[6]  <= 32'h00202223;
        buyruk_bellegi[7]  <= 32'h00302423;
        buyruk_bellegi[8]  <= 32'h00402623;
        buyruk_bellegi[9]  <= 32'h00502823;
        buyruk_bellegi[10] <= 32'b000000010100_00000_000_00001_0010011;
        buyruk_bellegi[11] <= 32'b000000011110_00000_000_00010_0010011;
        buyruk_bellegi[12] <= 32'b000000101000_00000_000_00011_0010011;
        buyruk_bellegi[13] <= 32'b000000110010_00000_000_00100_0010011;
        buyruk_bellegi[14] <= 32'b000000111100_00000_000_00101_0010011;
        buyruk_bellegi[15] <= 32'h00102a23;
        buyruk_bellegi[16] <= 32'h00202c23;
        buyruk_bellegi[17] <= 32'h00302e23;
        buyruk_bellegi[18] <= 32'h02402023;
        buyruk_bellegi[19] <= 32'h02502223;
        buyruk_bellegi[20] <= 32'h00002083;
        buyruk_bellegi[21] <= 32'h00402103;
        buyruk_bellegi[22] <= 32'h002080b3;
        buyruk_bellegi[23] <= 32'h00802103;
        buyruk_bellegi[24] <= 32'h002080b3;
        buyruk_bellegi[25] <= 32'h00c02103;
        buyruk_bellegi[26] <= 32'h002080b3;
        buyruk_bellegi[27] <= 32'h01002103;
        buyruk_bellegi[28] <= 32'h002080b3;
        buyruk_bellegi[29] <= 32'h01402103;
        buyruk_bellegi[30] <= 32'h01802183;
        buyruk_bellegi[31] <= 32'h00310133;
        buyruk_bellegi[32] <= 32'h01c02183;
        buyruk_bellegi[33] <= 32'h00310133;
        buyruk_bellegi[34] <= 32'h02002183;
        buyruk_bellegi[35] <= 32'h00310133;
        buyruk_bellegi[36] <= 32'h02402183;
        buyruk_bellegi[37] <= 32'h00310133;
        buyruk_bellegi[38] <= 32'h401101b3;
        buyruk_bellegi[39] <= 32'h1e302e23;
    end
    
    always #5 clk <= ~clk;
    
    always @(posedge clk) begin
        buyruk = buyruk_bellegi[ps/4];
    end

    /* C sikkindaki program
    1   addi x1, x0, 2      // 32'b000000000010_00000_000_00001_0010011
    2   addi x2, x0, 4      // 32'b000000000100_00000_000_00010_0010011
    3   addi x3, x0, 6      // 32'b000000000110_00000_000_00011_0010011
    4   addi x4, x0, 8      // 32'b000000001000_00000_000_00100_0010011
    5   addi x5, x0, 10     // 32'b000000001010_00000_000_00101_0010011
    6   sw x1, 0(x0)        // 32'h00102023
    7   sw x2, 4(x0)        // 32'h00202223
    8   sw x3, 8(x0)        // 32'h00302423
    9   sw x4, 12(x0)       // 32'h00402623
    10  sw x5, 16(x0)       // 32'h00502823
    11  addi x1, x0, 20     // 32'b000000010100_00000_000_00001_0010011
    12  addi x2, x0, 30     // 32'b000000011110_00000_000_00010_0010011
    13  addi x3, x0, 40     // 32'b000000101000_00000_000_00011_0010011
    14  addi x4, x0, 50     // 32'b000000110010_00000_000_00100_0010011
    15  addi x5, x0, 60     // 32'b000000111100_00000_000_00101_0010011
    16  sw x1, 20(x0)       // 32'h00102a23
    17  sw x2, 24(x0)       // 32'h00202c23
    18  sw x3, 28(x0)       // 32'h00302e23
    19  sw x4, 32(x0)       // 32'h02402023
    20  sw x5, 36(x0)       // 32'h02502223
    21  lw x1, 0(x0)        // 32'h00002083
    22  lw x2, 4(x0)        // 32'h00402103
    23  add x1, x1, x2      // 32'h002080b3
    24  lw x2, 8(x0)        // 32'h00802103
    25  add x1, x1, x2      // 32'h002080b3
    26  lw x2, 12(x0)       // 32'h00c02103
    27  add x1, x1, x2      // 32'h002080b3
    28  lw x2, 16(x0)       // 32'h01002103
    29  add x1, x1, x2      // 32'h002080b3
    30  lw x2, 20(x0)       // 32'h01402103
    31  lw x3, 24(x0)       // 32'h01802183
    32  add x2, x2, x3      // 32'h00310133
    33  lw x3, 28(x0)       // 32'h01c02183
    34  add x2, x2, x3      // 32'h00310133
    35  lw x3, 32(x0)       // 32'h02002183
    36  add x2, x2, x3      // 32'h00310133
    37  lw x3, 36(x0)       // 32'h02402183
    38  add x2, x2, x3      // 32'h00310133
    39  sub x3, x2, x1      // 32'h401101b3
    40  sw x3, 508(x0)      // 32'h1e302e23
    */

endmodule
