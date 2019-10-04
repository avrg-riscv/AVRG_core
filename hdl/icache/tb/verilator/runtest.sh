RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED} Modify the script if you need to set your verilator path ${NC}"
#____________start set path verilator
#export TOP=/home/bscuser/BSC/lowrisc
#export VERILATOR_ROOT=$TOP/verilator
#____________end set path verilator
rm -rf obj_dir 
#verilator -Wall --cc --trace icache_top.v -CFLAGS "-std=c++14"
verilator -Wall --cc --trace ../../hdl/icache_top.v --exe tb_icache_top.cpp -CFLAGS "-std=c++14"
#VERILATOR_ROOT=/home/bscuser/bin/verilator4/
cd obj_dir/
make -f Vicache_top.mk 
cd ../
./obj_dir/Vicache_top
gtkwave obj_dir/Vicache_top.vcd ICACHE.gtkw
