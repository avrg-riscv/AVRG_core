//testbench for the default case where bus is 6abits
#include "Vicache_top.h"
#include "verilated.h"
//waveform
#include "verilated_vcd_c.h"
#define OUTPUTS   5  
#define N_WORDS_BLOCK   4
//enable trace
#define TRACE_DEF true 
//time for waveforms
vluint64_t main_time =0;//current simulation time
double sc_time_stamp(){ //called by $time in verilog
    return main_time;   //converts to double , to match
}
// debug function to generate waveforms and clock
// debug function to generate waveforms and clock
void ticktoc_and_trace(Vicache_top* module,VerilatedVcdC* tfp){
  //waveforms and tick clock
  if (tfp != NULL){
  module->eval();
  module->clk_i = !module->clk_i;
  module->eval();
    tfp->dump (main_time);
    main_time++;
  module->eval();
  module->clk_i = !module->clk_i;
  module->eval();
    tfp->dump (main_time);
    main_time++;
  }else{
  module->clk_i = !module->clk_i;
  module->eval();
  module->clk_i = !module->clk_i;
  module->eval();
  }
}
void tick_and_trace(Vicache_top* module,VerilatedVcdC* tfp){
  //waveforms and tick clock
  if (tfp != NULL){
  module->clk_i = !module->clk_i;
  module->eval();
    tfp->dump (main_time);
    main_time++;
  }else{
  module->clk_i = !module->clk_i;
  module->eval();
  }
}

struct TestCase {
    const char* name;
    //inputs
    bool uncached_i, rstn_i, m_ready, strobe_i;
    uint64_t addr_i; 
    WData  mdout_i[N_WORDS_BLOCK];
    
    //output expected values
    bool p_ready, cache_miss, m_strobe;
    uint64_t m_a;
    WData p_din[N_WORDS_BLOCK];
};

TestCase test_cases[] {
//TODO:REVIEW uncached_i and strobe_i malfunctioning
//only clk_i  
//name    uncached_i, rstn_i, m_ready, strobe_i, addr_i,   mdout_i,  EXPECTED:  p_ready, cache_miss, m_strobe, p_din, m_a                         
  { "Reset" ,1       ,0    ,0       ,0        ,0x1   ,{0x0,0x0,0x0,0x0}  ,0       ,0          ,0         ,0     ,0},
  { "idle"  ,1       ,1    ,0       ,0        ,0x1   ,{0x0,0x0,0x0,0x0}  ,0       ,0          ,0         ,0     ,0},
  { "req "  ,1       ,1    ,0       ,1        ,0x1   ,{0x0,0x0,0x0,0x0}  ,0       ,0          ,0         ,0     ,0},
  { "miss"  ,1       ,1    ,0       ,1        ,0x1   ,{0x0,0x0,0x0,0x0}  ,0       ,0          ,0         ,0     ,0},
  { "miss"  ,1       ,1    ,0       ,1        ,0x1   ,{0x0,0x0,0x0,0x0}  ,0       ,0          ,0         ,0     ,0},
  { "fill"  ,1       ,1    ,1       ,1        ,0x1   ,{0x1,0x2,0x2,0x3}  ,0       ,0          ,0         ,0     ,0},
  { "Hit"   ,1       ,1    ,0       ,1        ,0x2   ,{0xf,0xf,0xf,0xf}  ,0       ,0          ,0         ,0     ,0},
  { "Hit"   ,1       ,1    ,0       ,1        ,0x3   ,{0xf,0xf,0xf,0xf}  ,0       ,0          ,0         ,0     ,0},
  { "Hit"   ,1       ,1    ,0       ,1        ,0xa   ,{0xf,0xf,0xf,0xf}  ,0       ,0          ,0         ,0     ,0},
  { "req "  ,1       ,1    ,0       ,1        ,0x5   ,{0xf,0xf,0xf,0xf}  ,0       ,0          ,0         ,0     ,0},
  { "miss"  ,1       ,1    ,0       ,1        ,0x5   ,{0xf,0xf,0xf,0xf}  ,0       ,0          ,0         ,0     ,0},
  { "miss"  ,1       ,1    ,0       ,1        ,0x5   ,{0xf,0xf,0xf,0xf}  ,0       ,0          ,0         ,0     ,0},
  { "fill"  ,1       ,1    ,1       ,1        ,0x5   ,{0x4,0x5,0x6,0x7}  ,0       ,0          ,0         ,0     ,0},
  { "Hit"   ,1       ,1    ,0       ,1        ,0x6   ,{0xf,0xf,0xf,0xf}  ,0       ,0          ,0         ,0     ,0},
  { "Hit"   ,1       ,1    ,0       ,1        ,0x7   ,{0xf,0xf,0xf,0xf}  ,0       ,0          ,0         ,0     ,0},
  { "Hit"   ,1       ,1    ,0       ,1        ,0x8   ,{0xf,0xf,0xf,0xf}  ,0       ,0          ,0         ,0     ,0},
  { "req "  ,1       ,1    ,0       ,1        ,0x5000   ,{0xe,0xe,0xe,0xe}  ,0       ,0          ,0         ,0     ,0},
  { "miss"  ,1       ,1    ,0       ,1        ,0x5000   ,{0x0,0x0,0x0,0x0}  ,0       ,0          ,0         ,0     ,0},
  { "miss"  ,1       ,1    ,0       ,1        ,0x5000   ,{0x0,0x0,0x0,0x0}  ,0       ,0          ,0         ,0     ,0},
  { "fill"  ,1       ,1    ,1       ,1        ,0x5000   ,{0x1,0x2,0x2,0x3}  ,0       ,0          ,0         ,0     ,0},
  { "Hit"   ,1       ,1    ,0       ,1        ,0x5000   ,{0xf,0xf,0xf,0xf}  ,0       ,0          ,0         ,0     ,0},
//pseudo random placement not tested
};

int main(int argc, char **argv, char **env) {
  //enable waveforms
  bool vcdTrace= TRACE_DEF;
  VerilatedVcdC* tfp =NULL;
  //declare my module
  Verilated::commandArgs(argc, argv);
  Vicache_top* CACHE = new Vicache_top;
  //enable waveforms
  if(vcdTrace)
  {
    Verilated::traceEverOn(true);
    tfp= new VerilatedVcdC;
    CACHE->trace(tfp,99);
    std::string vcdname = argv[0];
    vcdname += ".vcd";
    std::cout << vcdname << std::endl;
    tfp->open(vcdname.c_str());
  }
  //casted values of the register
  //reset
  CACHE->rstn_i= 0;
  //waveforms and tick clock
  ticktoc_and_trace(CACHE,tfp);
  //enable
  CACHE->rstn_i= 1;
  //waveforms and tick clock
  ticktoc_and_trace(CACHE,tfp);

  // while (!Verilated::gotFinish()) { 
  int num_test_cases = sizeof(test_cases)/sizeof(TestCase);

  for(int k = 0; k < num_test_cases; k++) {
    TestCase *test_case = &test_cases[k];
    //casted values of expected outputs
    //uint64_t e_out_regs[OUTPUTS]={test_case->p_ready, test_case->cache_miss, test_case->m_strobe, test_case->p_din, test_case->m_a};
    //uint64_t output_regs[OUTPUTS]={CACHE->p_ready, CACHE->cache_miss, CACHE->m_strobe, CACHE->p_din, CACHE->m_a};
    
    CACHE->uncached_i = test_case->uncached_i; 
    CACHE->rstn_i = test_case->rstn_i; 
    CACHE->m_ready = test_case->m_ready; 
    CACHE->strobe_i = test_case->strobe_i; 
    CACHE->addr_i = test_case->addr_i; 
    CACHE->mdout_i[0] = test_case->mdout_i[0]; 
    CACHE->mdout_i[1] = test_case->mdout_i[1]; 
    CACHE->mdout_i[2] = test_case->mdout_i[2]; 
    CACHE->mdout_i[3] = test_case->mdout_i[3]; 
    
    ticktoc_and_trace(CACHE,tfp);
  }
  //waveforms

  if (tfp != NULL){
    tfp->dump (main_time);
    main_time++;
  }
  tfp->close();
  CACHE->final();
  delete tfp;
  delete CACHE;
exit(0);
}

