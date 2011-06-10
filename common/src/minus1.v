/*
 Asynchronous SDM NoC
 (C)2011 Wei Song
 Advanced Processor Technologies Group
 Computer Science, the Univ. of Manchester, UK
 
 Authors: 
 Wei Song     wsong83@gmail.com
 
 License: LGPL 3.0 or later
 
 1-of-4 data decrease by one
 
 History:
 10/06/2010  Initial version. <wsong83@gmail.com>
 
*/

module minus1 (/*AUTOARG*/
   // Outputs
   d_o, co, zero, nzero,
   // Inputs
   en, nen, d_i
   );

   input en, nen;		// enable and disable
   input [3:0] d_i;		// the data to be reduced by one
   output [3:0] d_o;		// the data output of deduction
   output       co;		// the carry output
   output 	zero;		// the zero output
   output 	nzero;		// the non-zero status

   wire [3:0] d_d;		// the deducted data
   wire [3:0] d_r;		// the remained data

   // remain the data
   c2 CR0 (.a0(d_i[0]), .a1(nen), .q(d_r[0]));
   c2 CR1 (.a0(d_i[1]), .a1(nen), .q(d_r[1]));
   c2 CR2 (.a0(d_i[2]), .a1(nen), .q(d_r[2]));
   c2 CR3 (.a0(d_i[3]), .a1(nen), .q(d_r[3]));

   // reduce the data
   c2 CD0 (.a0(d_i[1]), .a1(en), .q(d_d[0]));
   c2 CD1 (.a0(d_i[2]), .a1(en), .q(d_d[1]));
   c2 CD2 (.a0(d_i[3]), .a1(en), .q(d_d[2]));
   c2 CD2 (.a0(d_i[0]), .a1(en), .q(d_d[2]));
   
   assign d_o = d_d | d_r;

   assign zero = d_i[0];
   assign nzero = |d_i[3:1];

endmodule // minus1

 