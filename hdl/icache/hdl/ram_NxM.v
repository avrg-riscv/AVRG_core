module ram_NxM #(
        parameter integer N_WORDS  = 8,
        parameter integer N_BITS_WORD  = 24
    )
    (
        input [$clog2(N_WORDS)-1:0] address,
        input [N_BITS_WORD-1:0] data,
        input clk,
        output [N_BITS_WORD-1:0] q,    
        input we
    );
    reg [N_BITS_WORD-1:0] ram [0:N_WORDS-1];
    
    always @(posedge clk) begin
        if (we) ram[address] <= data;
    end
    assign q = ram[address];
    integer i;
    initial begin
    for (i = 0; i < N_WORDS; i = i + 1)
        //ram[i] = N_BITS_WORD'h0;
        ram[i] =0;
    end
endmodule
