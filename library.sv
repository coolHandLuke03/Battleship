`default_nettype none

// Selects  only one line in the output to be 1, 
// which is the en th least significant bit,
// while all the rest remain 0
module Decoder
  (input  logic [2:0] I,
   input  logic en,
   output logic [7:0] D);

  always_comb begin
    if (en == 0) begin
        D = 8'b0000_0000;
    end
    else if ((en == 1) & (I == 3'b000)) begin
      D = 8'b0000_0001;
    end  
    else if ((en == 1) & (I == 3'b001)) begin
      D = 8'b0000_0010;
    end 
    else if ((en == 1) & (I == 3'b010)) begin
      D = 8'b0000_0100;
    end 
    else if ((en == 1) & (I == 3'b011)) begin
      D = 8'b0000_1000;
    end 
    else if ((en == 1) & (I == 3'b100)) begin
      D = 8'b0001_0000;
    end 
    else if ((en == 1) & (I == 3'b101)) begin
      D = 8'b0010_0000;
    end 
    else if ((en == 1) & (I == 3'b110)) begin
      D = 8'b0100_0000;
    end 
    else if ((en == 1) & (I == 3'b111)) begin
      D = 8'b1000_0000;
    end 
  end
  
endmodule : Decoder

// Left shift the input by by bits
module BarrelShifter
  (input  logic [15:0] V,
   input  logic [3:0] by,
   output logic [15:0] S);

  always_comb begin
    S = V << by;
  end

endmodule : BarrelShifter

// Selects the S_th line of input I to be the output
module Multiplexer 
  (input  logic [7:0] I,
   input  logic [2:0] S,
   output logic Y);

  always_comb
    unique case (S)
      3'b000: Y = I[7];
      3'b001: Y = I[6];
      3'b010: Y = I[5];
      3'b011: Y = I[4];
      3'b100: Y = I[3];
      3'b101: Y = I[2];
      3'b110: Y = I[1];
      3'b111: Y = I[0];  
    endcase

endmodule : Multiplexer

// Selects one of the input stream to be the output
module Mux2to1 
  (input  logic S,
   input  logic [6:0] I0,
   input  logic [6:0] I1,
   output logic [6:0] Y);

  assign Y = S ? I1 : I0;
    
endmodule : Mux2to1

// Compares A and B
module MagComparator
  (input  logic [7:0] A,
   input  logic [7:0] B,
   output logic AltB,
   output logic AeqB,
   output logic AgtB);

  assign AltB = (A < B) ? 1 : 0;
  assign AeqB = (A == B) ? 1 : 0;
  assign AgtB = (A > B) ? 1 : 0;

endmodule : MagComparator

// Indicates whether A is equal to B
module Comparator
  (input  logic [3:0] A,
   input  logic [3:0] B,
   output logic AeqB);

   assign AeqB = (A == B) ? 1 : 0;

endmodule : Comparator
  
// Convert the innput BDC value into readable 
// format of the display
module BCDtoSevenSegment
  (input  logic [3:0] bcd,
   output logic [6:0] segment);

  always_comb
    case (bcd)
      4'd0: segment = 7'b011_1111;
      4'd1: segment = 7'b000_0110;
      4'd2: segment = 7'b101_1011;
      4'd3: segment = 7'b100_1111;
      4'd4: segment = 7'b110_0110;
      4'd5: segment = 7'b110_1101;
      4'd6: segment = 7'b111_1101;
      4'd7: segment = 7'b000_0111;
      4'd8: segment = 7'b111_1111;
      4'd9: segment = 7'b110_1111;
      default: segment = 7'b111_1111;
    endcase

endmodule : BCDtoSevenSegment

module SevenSegmentDisplay
  (input  logic [3:0] BCD7, BCD6, BCD5, BCD4, BCD3, BCD2, BCD1, BCD0,
   input  logic [7:0] blank,
   output logic [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
   
   // Outputs of BCDtoSevenSegment , which are the inverse of what FPGA reads
   logic [6:0] HEX0_n;
   logic [6:0] HEX1_n;
   logic [6:0] HEX2_n;
   logic [6:0] HEX3_n;
   logic [6:0] HEX4_n;
   logic [6:0] HEX5_n;
   logic [6:0] HEX6_n;
   logic [6:0] HEX7_n;

   BCDtoSevenSegment LED0 (.bcd(BCD0), .segment(HEX0_n));
   BCDtoSevenSegment LED1 (.bcd(BCD1), .segment(HEX1_n));
   BCDtoSevenSegment LED2 (.bcd(BCD2), .segment(HEX2_n));
   BCDtoSevenSegment LED3 (.bcd(BCD3), .segment(HEX3_n));
   BCDtoSevenSegment LED4 (.bcd(BCD4), .segment(HEX4_n));
   BCDtoSevenSegment LED5 (.bcd(BCD5), .segment(HEX5_n));
   BCDtoSevenSegment LED6 (.bcd(BCD6), .segment(HEX6_n));
   BCDtoSevenSegment LED7 (.bcd(BCD7), .segment(HEX7_n));

   always_comb begin
    // Default values for each 7 segment display, 
    // notice that for a segment to not light up
    // it's 1
     HEX0 = 7'b111_1111;
     HEX1 = 7'b111_1111;
     HEX2 = 7'b111_1111;
     HEX3 = 7'b111_1111;
     HEX4 = 7'b111_1111;
     HEX5 = 7'b111_1111;
     HEX6 = 7'b111_1111;
     HEX7 = 7'b111_1111;
     
     // Whether HEX0 should be blank
     if (!(blank & 8'b0000_0001)) begin
       // Convert to what FPGA understands
       HEX0 = ~(HEX0_n);
     end
     // Whether HEX1 should be blank
     if (!(blank & 8'b0000_0010)) begin
       // Convert to what FPGA understands
       HEX1 = ~(HEX1_n);
     end
     // Whether HEX2 should be blank
     if (!(blank & 8'b0000_0100)) begin
       // Convert to what FPGA understands
       HEX2 = ~(HEX2_n);
     end
     // Whether HEX3 should be blank
     if (!(blank & 8'b0000_1000)) begin
       // Convert to what FPGA understands
       HEX3 = ~(HEX3_n);
     end
     // Whether HEX4 should be blank
     if (!(blank & 8'b0001_0000)) begin
       // Convert to what FPGA understands
       HEX4 = ~(HEX4_n);
     end
     // Whether HEX5 should be blank
     if (!(blank & 8'b00100000)) begin
       // Convert to what FPGA understands
       HEX5 = ~(HEX5_n);
     end
     // Whether HEX6 should be blank
     if (!(blank & 8'b0100_0000)) begin
       // Convert to what FPGA understands
       HEX6 = ~(HEX6_n);
     end
     // Whether HEX7 should be blank
     if (!(blank & 8'b1000_0000)) begin
       // Convert to what FPGA understands
       HEX7 = ~(HEX7_n);
     end
   end

endmodule : SevenSegmentDisplay

