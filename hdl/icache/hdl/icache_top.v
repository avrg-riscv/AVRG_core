//-----------------------------------------------------
// Design Name  : icache_top
// File Name    : icache_top.v
// Function     : Parametric direct map cache 
// References   : Computer principles and design in verilog HDL 
//-----------------------------------------------------
module icache_top #(    
        // direct mapping, 2 ̂ 6 blocks, 1 word/block
        parameter integer ADDRESS_SIZE  = 40,//in bites defined=a0
        parameter integer I_WORD_SIZE = 32,//32
        parameter integer N_WORDS_BLOCK  = 4,// words per block or entry
        parameter integer CACHE_SIZE  = 2048,// bits cache
        parameter integer MEM_BUS  = 128// bits to main memory
    )
    (
        //active low reset
        input rstn_i,
        //clock
        input clk_i,
        // cpu address sets address
        input [ADDRESS_SIZE-1:0] addr_i,
        // cpu strobes cache
        input strobe_i,
        // uncached_i, don't store the value in the cache
        input uncached_i,
        // mem data out to cpu
        input [MEM_BUS-1:0] mdout_i,
        // mem ready
        input m_ready,
        // cpu data from mem, send the whole line
        output [MEM_BUS-1:0] p_din,
        // ready (to cpu)
        output p_ready,
        // cache miss
        output cache_miss,
        // mem address
        output [ADDRESS_SIZE-1:0] m_a,
        // mem strobe
        output m_strobe
        
    );
    //PARAMETERS
    //total of entries or//active low reset blocks
    localparam integer N_BLOCKS  =CACHE_SIZE/(I_WORD_SIZE*N_WORDS_BLOCK); 
    localparam integer N_BITS_BLOCK = $clog2(N_BLOCKS);
    localparam integer INDEX_WORD_BITS = $clog2(N_WORDS_BLOCK);
    localparam integer BASE_BIT_BLOCK =INDEX_WORD_BITS;
    //total of entries or blocks
    localparam integer N_BITS_TAG =ADDRESS_SIZE - N_BITS_BLOCK - INDEX_WORD_BITS;
    //total of entries or blocks
    localparam integer BASE_BIT_TAG =N_BITS_BLOCK+INDEX_WORD_BITS; 
    // 1-bit valid RAM]
    reg [N_BLOCKS-1:0] d_valid;
    // ??-bit tag [RAM]
    reg [N_BITS_TAG-1:0] d_tags [0:N_BLOCKS-1];
    // 32-bit data [RAM]
    reg [N_WORDS_BLOCK*I_WORD_SIZE-1:0] d_data [0:N_BLOCKS-1];
    // block index
    wire [N_BITS_BLOCK-1:0] index = addr_i[ (N_BITS_BLOCK-1+BASE_BIT_BLOCK)
                                        :BASE_BIT_BLOCK];
    // address tag
    wire [N_BITS_TAG-1:0] tag = addr_i[ADDRESS_SIZE-1:BASE_BIT_TAG];
    // cache write
    wire c_write;
    // data to cache
    wire [MEM_BUS-1:0] c_din;
    reg [N_BITS_TAG-1:0] tagout; 
    wire [N_WORDS_BLOCK*I_WORD_SIZE-1:0] c_dout;
    always @ (posedge clk_i) begin
        if (!rstn_i) begin
            // assign all to 0
            d_valid <={N_BLOCKS{1'b0}};
            end else if (c_write)begin
            // write valid
            d_valid[index] <= 1'b1;
            // write data
            d_data[index] <= c_din;
        end
    end
    always @ (posedge clk_i) begin
        if (c_write) begin
            // write address tag
            d_tags[index][N_BITS_TAG-1:0] <= tag;
        end
        // read cache tag
        tagout <= d_tags[index][N_BITS_TAG-1:0];
    end
    // read cache data
    assign c_dout[MEM_BUS-1:0] = d_data[index][MEM_BUS-1:0]; 
    // read cache valid
    wire valid = d_valid[index]; 
    // cache hit
    wire cache_hit = strobe_i & valid & (tagout == tag);
    // cache miss
    assign cache_miss = strobe_i & (!valid | (tagout != tag));
    // mem <-- cpu address
    assign m_a = addr_i; 
    // read on miss
    assign m_strobe = cache_miss ;
    // data ready
    assign p_ready =cache_hit | cache_miss & m_ready; 
    // write cache
    assign c_write = cache_miss & uncached_i & m_ready;
    // data from mem
    assign c_din = mdout_i;
    // data from cache or mem
    assign p_din = cache_hit? c_dout : mdout_i;
endmodule
