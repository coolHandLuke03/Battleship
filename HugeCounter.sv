`default_nettype none 

// Counts how many 1's there are in 
// OneInNineArea and output it
module HugeCounter
  (input  logic [8:0] OneInNineArea,
   output logic [3:0] NumBCD);

  always_comb begin
    NumBCD = 4'd0;
    // Go through the gauntlet to count all the 
    // bits that are 1's
    if ((OneInNineArea & 9'b0_0000_0001) != 9'd0) begin
      NumBCD ++;
    end
    if ((OneInNineArea & 9'b0_0000_0010) != 9'd0) begin
      NumBCD ++;
    end
    if ((OneInNineArea & 9'b0_0000_0100) != 9'd0) begin
      NumBCD ++;
    end
    if ((OneInNineArea & 9'b0_0000_1000) != 9'd0) begin
      NumBCD ++;
    end
    if ((OneInNineArea & 9'b0_0001_0000) != 9'd0) begin
      NumBCD ++;
    end
    if ((OneInNineArea & 9'b0_0010_0000) != 9'd0) begin
      NumBCD ++;
    end
    if ((OneInNineArea & 9'b0_0100_0000) != 9'd0) begin
      NumBCD ++;
    end
    if ((OneInNineArea & 9'b0_1000_0000) != 9'd0) begin
      NumBCD ++;
    end
    if ((OneInNineArea & 9'b1_0000_0000) != 9'd0) begin
      NumBCD ++;
    end
  end

endmodule : HugeCounter
