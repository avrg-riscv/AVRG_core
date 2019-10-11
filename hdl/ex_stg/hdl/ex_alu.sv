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

`default_nettype none
`timescale 1ns / 1ps

module ex_alu (
    
    // System
    input wire clk_i,
    input wire rstn_i,

    // Input
    input alu_in_t op_i,
    
    // Output
    output [63:0] result_o 
)

always_ff @(posedge clk_i) begin
    if ( ~rstn_i ) begin
        result_o <= 0;
    end
    else begin
        result_o <= op_i.op_A;
    end
end

endmodule
`default_nettype wire
