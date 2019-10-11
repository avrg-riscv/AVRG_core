////////////////////////////////////////////////////////////////////////////////
//
//    ___ _   _____  _____
//   / _ | | / / _ \/ ___/
//  / __ | |/ / , _/ (_ /
// /_/ |_|___/_/|_|\___/
//
//
// Copyright 2019 AVRG
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     https://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Description:
//    
// References:
//
////////////////////////////////////////////////////////////////////////////////

typedef enum  {
    // basic ALU op
    ADD, SUB, ADDW, SUBW,
    // logic operations
    XORL, ORL, ANDL,
    // shifts
    SRA, SRL, SLL, SRLW, SLLW, SRAW,
    // comparisons
    LTS, LTU, GES, GEU, EQ, NE,
    // Multiplications
    MUL, MULH, MULHU, MULHSU, MULW,
    // Divisions
    DIV, DIVU, DIVW, DIVUW, REM, REMU, REMW, REMUW
} alu_op;

typedef struct packed {
    alu_op       op;
    logic [63:0] op_A;
    logic [63:0] op_B;
} alu_in_t;
