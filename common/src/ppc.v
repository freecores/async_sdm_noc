/*
 Asynchronous SDM NoC
 (C)2011 Wei Song
 Advanced Processor Technologies Group
 Computer Science, the Univ. of Manchester, UK
 
 Authors: 
 Wei Song     wsong83@gmail.com
 
 License: LGPL 3.0 or later
 
 Pipeline controller
 
 References
 See the STG and compiled verilog in sdm/stg/, ibctl.g and ibctl.v
 
 History:
 21/06/2009  Initial version. <wsong83@gmail.com>
 
*/

module ppc(/*AUTOARG*/
   // Outputs
   decan,
   // Inputs
   eof, doa
   );
   input 	      eof, doa;
   wire 	      deca;	// the ack to eof
   output 	      decan;	// the ack to routing requests

   c2p CEoF (.q(deca), .a(doa), .b(eof));
   assign decan = ~deca;
   
endmodule // ppc

   
   