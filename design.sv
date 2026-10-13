// Version A: basic MAC - multiply and add in ONE clock cycle
module mac_basic (
  input             clk, rst, en,
  input      [7:0]  a, b,
  output reg [19:0] acc
);
  always @(posedge clk) begin
    if (rst)     acc <= 0;
    else if (en) acc <= acc + a * b;
  end
endmodule

// Version B: pipelined MAC - split into 2 stations
// Station 1: multiply and store.  Station 2: add to total.
module mac_pipe (
  input             clk, rst, en,
  input      [7:0]  a, b,
  output reg [19:0] acc
);
  reg [15:0] prod;   // station 1 result
  reg        valid;  // "is prod real data?" flag
  always @(posedge clk) begin
    if (rst) begin
      prod <= 0; valid <= 0; acc <= 0;
    end else begin
      prod  <= a * b;
      valid <= en;
      if (valid) acc <= acc + prod;
    end
  end
endmodule
