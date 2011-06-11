/*
 Asynchronous SDM NoC
 (C)2011 Wei Song
 Advanced Processor Technologies Group
 Computer Science, the Univ. of Manchester, UK
 
 Authors: 
 Wei Song     wsong83@gmail.com
 
 License: LGPL 3.0 or later
 
 Reduce the XY address by one
 
 History:
 11/06/2010  Initial version. <wsong83@gmail.com>
 
*/

module addr_dec(/*AUTOARG*/
   // Outputs
   xo, yo,
   // Inputs
   xi, yi
   );
   input [7:0] xi, yi;		// the addresses input
   output [7:0] xo, yo;		// the addresses output

   wire [7:0] xm, ym;		// internal deduction output
   wire [3:0] zero, nzero, en, nen; // internal control bit
   wire       xzero;			// high when addr X is zero
   wire       yzero;			// high when addr Y is zero
   
   // address X
   minus1 DECX0 (
		 .d_o    ( xm[3:0]  ),
		 .zero   ( zero[0]  ),
		 .nzero  ( nzero[0] ),
		 .en     ( en[0]    ),
		 .nen    ( nen[0]   ),
		 .d_i    ( xi[3:0]  )
		 );

   minus1 DECX1 (
		 .d_o    ( xm[7:4]  ),
		 .zero   ( zero[1]  ),
		 .nzero  ( nzero[1] ),
		 .en     ( en[1]    ),
		 .nen    ( nen[1]   ),
		 .d_i    ( xi[7:4]  )
		 );

   // address Y
   minus1 DECY0 (
		 .d_o    ( ym[3:0]  ),
		 .zero   ( zero[2]  ),
		 .nzero  ( nzero[2] ),
		 .en     ( en[2]    ),
		 .nen    ( nen[2]   ),
		 .d_i    ( yi[3:0]  )
		 );

   minus1 DECY1 (
		 .d_o    ( ym[7:4]  ),
		 .zero   ( zero[3]  ),
		 .nzero  ( nzero[3] ),
		 .en     ( en[3]    ),
		 .nen    ( nen[3]   ),
		 .d_i    ( yi[7:4]  )
		 );

   // handle the control bits
   assign en[0] = |nzero[1:0];
   ctree #(2) XHE (.ci({zero[0],nzero[1]}), .co(en[1])); 
   c2 XZF (.a0(zero[0]), .a1(zero[1]), .q(xzero));
   ctree #(2) YLE (.ci({xzero,|nzero[3:2]}), .co(en[2]));
   ctree #(3) YHE (.ci({xzero,zero[2],nzero[3]}), .co(en[3]));
   assign nen[0] = xzero;
   assign nen[1] = zero[1]|nzero[0];
   c2 YZF (.a0(zero[2]), .a1(zero[3]), .q(yzero));
   assign nen[2] = (|nzero[1:0])|yzero;
   assign nen[3] = (|nzero[2:0])|zero[3];

endmodule // addr_dec
