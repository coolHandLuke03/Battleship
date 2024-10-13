`default_nettype none 

// Tells what if the biggest ship hit by the big bomb
module HugeComparator
  (input  logic [4:0] S0,
   input  logic [4:0] S1,
   input  logic [4:0] S2,
   input  logic [4:0] S3,
   input  logic [4:0] S4,
   input  logic [4:0] S5,
   input  logic [4:0] S6, 
   input  logic [4:0] S7, 
   input  logic [4:0] S8,
   output logic [4:0] BiggestShip);
  
  always_comb begin
    BiggestShip = S0;
    // Go through the gauntlet to select the biggest ship hit
    if (S1 > S0) begin
      BiggestShip = S1;
    end
    if (S2 > S1) begin
      BiggestShip = S2;
    end
    if (S3 > S2) begin
      BiggestShip = S3;
    end
    if (S4 > S3) begin
      BiggestShip = S4;
    end
    if (S5 > S4) begin
      BiggestShip = S5;
    end
    if (S6 > S5) begin
      BiggestShip = S6;
    end
    if (S7 > S6) begin
      BiggestShip = S7;
    end
    if (S8 > S7) begin
      BiggestShip = S8;
    end
  end

endmodule : HugeComparator