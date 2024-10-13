`default_nettype none
`include "battleship.sv";

// Module used to connect SV design to hardware pins
// for battleship
module ChipInterface
  (input  logic [17:0] SW,
   input  logic [7:0]  KEY,
   output logic [17:0] LEDR,
   output logic [6:0]  HEX0, HEX6, HEX7,
   output logic [7:0]  LEDG);
 
  // Declare internal signals
  logic ScoreThis;
  logic [3:0] X, Y;
  logic Big;
  logic [1:0] BigLeft;
  logic SomethingIsWrong;
  logic Hit;
  logic NearMiss;
  logic Miss;
  logic [4:0] BiggestShipHit;
  logic [6:0] NumHits;

  // Connection between internal signals
  // and the actual inputs & outputs
  assign X = SW[7:4];
  assign Y = SW[3:0];
  assign Big = SW[17];
  assign BigLeft = SW[15:14];
  assign ScoreThis = ~KEY[0];
  assign LEDR[17:12] = (Hit) ? 6'b11_1111 : 6'b00_0000;
  assign LEDR[11:6] = (NearMiss) ? 6'b11_1111 : 6'b00_0000;
  assign LEDR[5:0] = (Miss) ? 6'b11_1111 : 6'b00_0000;
  assign LEDG[4:0] = BiggestShipHit;
  assign HEX0 = NumHits;
  assign HEX6 = (SomethingIsWrong) ? 7'b000_0000 : 7'b111_1111;
  assign HEX7 = (SomethingIsWrong) ? 7'b000_0000 : 7'b111_1111;
  // Instantiate the battleship device
  Battleship BS_device (.X(X), .Y(Y), .Big(Big),
                        .ScoreThis(ScoreThis), .BigLeft(BigLeft),
                        .Hit(Hit), .NearMiss(NearMiss),
                        .Miss(Miss), .NumHits(NumHits),
                        .BiggestShipHit(BiggestShipHit),
                        .SomethingIsWrong(SomethingIsWrong));

endmodule: ChipInterface