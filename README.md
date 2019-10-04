# core

Rules of conduct
---------------
* Follow the directory structure
* Each main module of the pipeline requires a folder within HDL.
* All HDL files within a single main module require a testbench
* You shall implement a makefile to run the testbenches. It shall contain a
  recipe for each module and the integration among them.
  
Name conventions
---------------
* inputs are sufixed with \_i
* outputs are sufixed with \_o
* internal signals are suficed with  \_int
* port signals (axi, amba, wishbone ..) shall be prefixed with the protocol
  name.
* Names of submodules within stages need to be prefixed with the name of the
  stage to prevent name conflicts
* package files need to be sufixed with \_p 
* interface files need to be sufixed with \_i

Code conventions
---------------
* Line wrap at 80 lines.
* No tabulations, 4 spaces.
