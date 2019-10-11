# Core

    ___ _   _____  _____    ________________________
   / _ | | / / _ \/ ___/    _ ___/  __ \_  ___/  _ \
  / __ | |/ / , _/ (_ /   / /__ / /_/ /  /   /  __/
 /_/ |_|___/_/|_|\___/    \___/ \____//_/    \___/ 
 

A RISC-V 64-bit core implementing the I (base instruction set), M (integer multiplication and division) and A (atomic Instructions) (RV64IMA).

Rules of Conduct
----------------
* Follow the directory structure
* Each main module of the pipeline requires a folder within HDL.
* All HDL files within a single main module require a testbench
* You shall implement a makefile to run the testbenches. It shall contain a
  recipe for each module and the integration among them.
  
Naming Convention
-----------------
* inputs are sufixed with \_i
* outputs are sufixed with \_o
* internal signals are suficed with  \_int
* port signals (axi, amba, wishbone ..) shall be prefixed with the protocol
  name.
* Names of submodules within stages need to be prefixed with the name of the
  stage to prevent name conflicts
* package files need to be sufixed with \_p 
* interface files need to be sufixed with \_i

Coding convention
------------------
* Line wrap at 80 lines.
* No tabulations, 4 spaces.
