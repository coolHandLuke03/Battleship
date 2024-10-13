`default_nettype none

// Determins NearMiss signal
module NearMissModule
  (input logic [3:0] X, Y,
   output logic NearMiss);

  always_comb 
    case ({X,Y})
      // (1,1), (1,3), (1,8), (1,9), (1,10)
      8'b0001_0001: NearMiss = 1;
      8'b0001_0011: NearMiss = 1;
      8'b0001_1000: NearMiss = 1;
      8'b0001_1001: NearMiss = 1;
      8'b0001_1010: NearMiss = 1;
      // (2,4), (2,7)
      8'b0010_0100: NearMiss = 1;
      8'b0010_0111: NearMiss = 1;
      // (3,4), (3,8), (3,9), (3,10)
      8'b0011_0100: NearMiss = 1;
      8'b0011_1000: NearMiss = 1;
      8'b0011_1001: NearMiss = 1;
      8'b0011_1010: NearMiss = 1;
      // (4,4)
      8'b0100_0100: NearMiss = 1;
      // (5,1), (5,2), (5,4)
      8'b0101_0001: NearMiss = 1;
      8'b0101_0010: NearMiss = 1;
      8'b0101_0100: NearMiss = 1;
      // (6,2), (6,4), (6,6)
      8'b0110_0010: NearMiss = 1;
      8'b0110_0100: NearMiss = 1;
      8'b0110_0110: NearMiss = 1;
      // (7,3), (7,5), (7,7)
      8'b0111_0011: NearMiss = 1;
      8'b0111_0101: NearMiss = 1;
      8'b0111_0111: NearMiss = 1;
      // (8,1), (8,5), (8,7)
      8'b1000_0001: NearMiss = 1;
      8'b1000_0101: NearMiss = 1;
      8'b1000_0111: NearMiss = 1;
      // (9,2), (9,6)
      8'b1001_0010: NearMiss = 1;
      8'b1001_0110: NearMiss = 1;
      // (10, 2)
      8'b1010_0010: NearMiss = 1;
      default: NearMiss = 0;
    endcase

endmodule: NearMissModule

// Determins NearMiss signal for big bomb
module NearMissModule_Big
  (input logic [3:0] X, Y,
   output logic [8:0] NearMiss);

    NearMissModule NMM1(X-4'd1, Y-4'd1, NearMiss[0]);
    NearMissModule NMM2(X     , Y-4'd1, NearMiss[1]);
    NearMissModule NMM3(X+4'd1, Y-4'd1, NearMiss[2]);
    NearMissModule NMM4(X-4'd1, Y     , NearMiss[3]);
    NearMissModule NMM5(X     , Y     , NearMiss[4]);
    NearMissModule NMM6(X+4'd1, Y     , NearMiss[5]);
    NearMissModule NMM7(X-4'd1, Y+4'd1, NearMiss[6]);
    NearMissModule NMM8(X     , Y+4'd1, NearMiss[7]);
    NearMissModule NMM9(X+4'd1, Y+4'd1, NearMiss[8]);

endmodule: NearMissModule_Big

// Determines all signals related to miss
module IsNearMiss
  (input logic [3:0] X, Y,
   input logic Big, ScoreThis, Hit, Wrong,
   output logic NearMiss, Miss);

  logic [8:0] NearMiss_Big;
  logic       Temp_miss;
  // get NearMiss_Big
  NearMissModule_Big NMMB(X,Y,NearMiss_Big);
  always_comb begin
    if (Wrong) begin
      NearMiss = 1'b0;
      Miss = 1'b0;
    end
    else if (ScoreThis == 0 || Hit == 1) begin
      //cases when ScoreThis is inactive or is Hit already
      NearMiss = 1'b0;
      Miss = 1'b0;
    end 
    else if (Big == 1) begin
      //cases when a big bomb is used
      if (NearMiss_Big == 0) begin
        // no NearMiss --> all miss
        Miss = 1'b1;
        NearMiss = 1'b0;
      end 
      else begin
        // yes NearMiss
        NearMiss = 1'b1;
        Miss = 1'b0;
      end
    end 
    else begin
      //cases when small bomb is used
      NearMiss = NearMiss_Big[4];
      Miss = ~NearMiss_Big[4];
    end
  end

endmodule: IsNearMiss