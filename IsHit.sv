`default_nettype none 
`include "hit.sv";
`include "WhichShipModule.sv";
`include "HugeComparator.sv";
`include "HugeCounter.sv";
`include "library.sv";

// Outputs all signals related to hit
module IsHit
  (input  logic [3:0] X,
   input  logic [3:0] Y,
   input  logic Big,
   input  logic Wrong,
   input  logic ScoreThis,
   output logic TempHit,
   output logic [6:0] NumHits,
   output logic [4:0] BiggestShipHit
   );

  // HitModule hm1 deals with normal bomb attack
  // as it would tell whether a normal attack is
  // a hit
  logic HitorMiss1;
  HitModule hm1 (.X(X), .Y(Y), .Hit(HitorMiss1));
  // BCDtoSevenSegment module BCD2Seven1 converts the
  // number of hit of a normal bomb, which is always 1,
  // into readable form for the seven segment display
  logic [6:0] ReadableBCDNormalBomb;
  BCDtoSevenSegment BCD2Seven1 (.bcd(4'b0001), .segment(ReadableBCDNormalBomb));
  // WhichShipModule wsm1 simply takes in a coordinate 
  // and outputs the type of ship hit
  logic [4:0] ShipNormalBomb;
  WhichShipModule wsm1 (.X(X), .Y(Y), .Ship(ShipNormalBomb));

  // Below we instantiate the hardware needed for the big
  // bomb case

  // Tracks if one of the nine coordinates
  // centering (X, Y) is a hit
  logic [8:0] OneInNineArea;
  logic [3:0] X1, X2, X3;
  logic [3:0] Y1, Y2, Y3;
  assign X1 = X - 4'b0001;
  assign X2 = X;
  assign X3 = X + 4'b0001;
  assign Y1 = Y - 4'b0001;
  assign Y2 = Y;
  assign Y3 = Y + 4'b0001;
  // Tells the ship type of each coordinate within
  // that 9-coordinate area
  logic [4:0] ShipBigBomb0;
  logic [4:0] ShipBigBomb1;
  logic [4:0] ShipBigBomb2;
  logic [4:0] ShipBigBomb3;
  logic [4:0] ShipBigBomb4;
  logic [4:0] ShipBigBomb5;
  logic [4:0] ShipBigBomb6;
  logic [4:0] ShipBigBomb7;
  logic [4:0] ShipBigBomb8;

  // The following 9 modules from hm2 to 10 deals with 
  // a big bomb attack as they would test to see if 
  // each coordinate within the 9-coordinate area centering 
  // the given (X, Y) is a hit
  
  logic HitorMiss2;
  // Tells whether the bottom-left coordinate is a hit
  HitModule hm2 (.X(X1), .Y(Y1), .Hit(OneInNineArea[0]));
  // Tells which ship hit of the bottom-left coordinate
  WhichShipModule wsm2 (.X(X1), .Y(Y1), .Ship(ShipBigBomb0));

  // Tells whether the bottom-middle coordinate is a hit
  HitModule hm3 (.X(X2), .Y(Y1), .Hit(OneInNineArea[1]));
  // Tells which ship hit of the bottom-middle coordinate
  WhichShipModule wsm3 (.X(X2), .Y(Y1), .Ship(ShipBigBomb1));

  // Tells whether the bottom-right coordinate is a hit
  HitModule hm4 (.X(X3), .Y(Y1), .Hit(OneInNineArea[2]));
  // Tells which ship hit of the bottom-right coordinate
  WhichShipModule wsm4 (.X(X3), .Y(Y1), .Ship(ShipBigBomb2));

  // Tells whether the middle-left coordinate is a hit
  HitModule hm5 (.X(X1), .Y(Y2), .Hit(OneInNineArea[3]));
  // Tells which ship hit of the middle-left coordinate
  WhichShipModule wsm5 (.X(X1), .Y(Y2), .Ship(ShipBigBomb3));

  // Tells whether the middle-middle coordinate is a hit
  HitModule hm6 (.X(X2), .Y(Y2), .Hit(OneInNineArea[4]));
  // Tells which ship hit of the middle-middle coordinate
  WhichShipModule wsm6 (.X(X2), .Y(Y2), .Ship(ShipBigBomb4));

  // Tells whether the middle-right coordinate is a hit
  HitModule hm7 (.X(X3), .Y(Y2), .Hit(OneInNineArea[5]));
  // Tells which ship hit of the middle-right coordinate
  WhichShipModule wsm7 (.X(X3), .Y(Y2), .Ship(ShipBigBomb5));

  // Tells whether the up-left coordinate is a hit
  HitModule hm8 (.X(X1), .Y(Y3), .Hit(OneInNineArea[6]));
  // Tells which ship hit of the up-left coordinate
  WhichShipModule wsm8 (.X(X1), .Y(Y3), .Ship(ShipBigBomb6));

  // Tells whether the up-middle coordinate is a hit
  HitModule hm9 (.X(X2), .Y(Y3), .Hit(OneInNineArea[7]));
  // Tells which ship hit of the up-middle coordinate
  WhichShipModule wsm9 (.X(X2), .Y(Y3), .Ship(ShipBigBomb7));

  // Tells whether the up-right coordinate is a hit
  HitModule hm10 (.X(X3), .Y(Y3), .Hit(OneInNineArea[8]));
  // Tells which ship hit of the up-right coordinate
  WhichShipModule wsm10 (.X(X3), .Y(Y3), .Ship(ShipBigBomb8));

  // HugeComparator compares ShipBigBomb1-9 and outputs the
  // the largest of all
  logic [4:0] ShipBigBomb;
  HugeComparator hsc1 (.S0(ShipBigBomb0), .S1(ShipBigBomb1), 
                       .S2(ShipBigBomb2), .S3(ShipBigBomb3), 
                       .S4(ShipBigBomb4), .S5(ShipBigBomb5), 
                       .S6(ShipBigBomb6), .S7(ShipBigBomb7),
                       .S8(ShipBigBomb8), .BiggestShip(ShipBigBomb));
  
  // Deal with the Number of coordinates that are hits
  logic [3:0] NumBCDCBigBomb;
  HugeCounter hc1 (.OneInNineArea(OneInNineArea), 
                   .NumBCD(NumBCDCBigBomb));

  // BCDtoSevenSegment BCD2Seven2 converts the NumBCDCBigBomb
  // to readable form
  logic [6:0] ReadableBCDBigBomb;
  BCDtoSevenSegment BCD2Seven2 (.bcd(NumBCDCBigBomb), 
                                .segment(ReadableBCDBigBomb));

  always_comb begin
    TempHit = 1'b0;
    NumHits = 7'b111_1111;
    BiggestShipHit = 5'b0_0000;
    // In the case that's using a normal bomb
    if ((Big == 1'b0) && (ScoreThis == 1'b1) && (Wrong == 1'b0)) begin
      TempHit = HitorMiss1;
      // Remember to invert ReadableBCD1 as the FPGA 
      // segment turns on when reading 0 for a segment
      NumHits = ~(ReadableBCDNormalBomb);
      BiggestShipHit = ShipNormalBomb;
    end
    // In the case that it's using a big bomb
    else if ((Big == 1'b1) && (ScoreThis == 1'b1) && (Wrong == 1'b0)) begin
      TempHit = (OneInNineArea != 9'b0_0000_0000) ? 1'b1 : 1'b0;
      NumHits = ~(ReadableBCDBigBomb);
      BiggestShipHit = ShipBigBomb;
    end
  end
    
endmodule : IsHit