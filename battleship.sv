`default_nettype none 
`include "IsHit.sv";
`include "IsMiss.sv";
`include "STH_X.sv";

// Main battleship module
module Battleship 
  (input  logic [3:0] X,
   input  logic [3:0] Y,
   input  logic Big,
   input  logic [1:0] BigLeft,
   input  logic ScoreThis,
   output logic Hit,
   output logic NearMiss,
   output logic Miss,
   output logic [6:0] NumHits,
   output logic [4:0] BiggestShipHit,
   output logic SomethingIsWrong);
  
  logic Wrong, TempHit;
  // Module that determines whether something's wrong
  STH_X wrongModule (.X(X), .Y(Y), .Big(Big),
                     .ScoreThis(ScoreThis),
                     .BigLeft(BigLeft),
                     .SomethingIsWrong(Wrong));
  // Module that determines all the signals related to hit
  IsHit mainHitModule (.X(X), .Y(Y), .Big(Big),
                       .Wrong(Wrong), .ScoreThis(ScoreThis),
                       .TempHit(TempHit), .NumHits(NumHits),
                       .BiggestShipHit(BiggestShipHit));
  // Module that determines all the signlas related to miss
  IsNearMiss mainMissModule (.X(X), .Y(Y), .Big(Big), .ScoreThis(ScoreThis),
                         .Hit(Hit), .NearMiss(NearMiss), .Miss(Miss));
  // Declaration of internal signal
  assign SomethingIsWrong = Wrong;
  assign Hit = TempHit;
  
endmodule : Battleship