module tb;
  reg clk = 0, rst = 1, en = 0;
  reg [7:0] a = 0, b = 0;
  wire [19:0] acc_basic, acc_pipe;
  reg  [19:0] expected = 0;
  integer i;

  mac_basic u_basic (clk, rst, en, a, b, acc_basic);
  mac_pipe  u_pipe  (clk, rst, en, a, b, acc_pipe);

  always #5 clk = ~clk;   // clock: 10 time units per cycle

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
    repeat (2) @(posedge clk);
    #1 rst = 0;

    for (i = 0; i < 50; i = i + 1) begin
      a = $urandom_range(0, 255);
      b = $urandom_range(0, 255);
      en = 1;
      expected = expected + a * b;   // our "answer key"
      @(posedge clk); #1;
    end
    en = 0;
    repeat (3) @(posedge clk);       // let the pipeline empty out
    #1;

    $display("Expected  = %0d", expected);
    $display("Basic MAC = %0d", acc_basic);
    $display("Pipe MAC  = %0d", acc_pipe);
    if (acc_basic === expected && acc_pipe === expected)
      $display("PASS: both MACs match the answer key");
    else
      $display("FAIL: mismatch");
    $finish;
  end
endmodule
