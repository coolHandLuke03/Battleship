`default_nettype none

// Determine all signals related to wrong 
module STH_X
  (input logic [3:0] X, Y,
   input logic Big, ScoreThis,
   input logic [1:0] BigLeft,
   output logic SomethingIsWrong);

  always_comb begin
    SomethingIsWrong = 0; //initialization
    if (X == 4'd0 || X > 4'd10 || Y == 4'd0 || Y > 4'd10) begin
      SomethingIsWrong = 1; //X, Y range check
    end
    if (Big == 1'b1 && BigLeft == 2'b00) begin
      SomethingIsWrong = 1; //bomb left check
    end
    if (ScoreThis == 1'b0) begin      //if inactivate
      SomethingIsWrong = 0;
    end //deactivate STH_X
  end

endmodule: STH_X

