`default_nettype none 

// Indicates whether one given coordinate (X, Y) is 
// a hit or not
// ** Notice that a coordinate that's out of boundary 
//    is automatically a miss **
module HitModule 
  (input  logic [3:0] X,
   input  logic [3:0] Y,
   output logic Hit);

  always_comb begin
    Hit = 1'b0;
    // When X is 1
    if (X == 4'b0001) begin
        // It's a hit if Y is 2
        Hit = (Y == 4'b0010) ? 1'b1 : 1'b0;
    end
    // When X is 2
    else if (X == 4'b0010) begin
        // It's a hit if Y is 1, 2, 3, 8, 9, 10
        Hit = (Y == 4'b0001
            || Y == 4'b0010
            || Y == 4'b0011
            || Y == 4'b1000
            || Y == 4'b1001
            || Y == 4'b1010) ? 1'b1 : 1'b0;
    end
    // When X is 3
    else if (X == 4'b0011) begin
        // It's a hit if Y is 1, 2, 3
        Hit = (Y == 4'b0001
            || Y == 4'b0010
            || Y == 4'b0011) ? 1'b1 : 1'b0;
    end
    // When X is 4
    else if (X == 4'b0100) begin
        // It's a hit if Y is 1, 2, 3
        Hit = (Y == 4'b0001
            || Y == 4'b0010
            || Y == 4'b0011) ? 1'b1 : 1'b0;
    end
    // When X is 5
    else if (X == 4'b0101) begin
        // It's a hit if Y is 3
        Hit = (Y == 4'b0011) ? 1'b1 : 1'b0;
    end
    // When X is 6
    else if (X == 4'b0110) begin
        // It's a hit if Y is 3
        Hit = (Y == 4'b0011) ? 1'b1 : 1'b0;
    end
    // When X is 7
    else if (X == 4'b0111) begin
        // It's a hit if Y is 6
        Hit = (Y == 4'b0110) ? 1'b1 : 1'b0;
    end
    // When X is 8
    else if (X == 4'b1000) begin
        // It's a hit if Y is 6
        Hit = (Y == 4'b0110) ? 1'b1 : 1'b0;
    end
    // When X is 9
    else if (X == 4'b1001) begin
        // It's a hit if Y is 1
        Hit = (Y == 4'b0001) ? 1'b1 : 1'b0;
    end
    // When X is 10
    else if (X == 4'b1010) begin
        // It's a hit if Y is 1
        Hit = (Y == 4'b0001) ? 1'b1 : 1'b0;
    end
  end
    
endmodule : HitModule

