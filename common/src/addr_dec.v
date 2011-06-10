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
 10/06/2010  Initial version. <wsong83@gmail.com>
 
*/

module addr_dec(/*AUTOARG*/);
   input [7:0] xi, yi;		// the addresses input
   output [7:0] xo, yo;		// the addresses output

   wire [7:0] xm, ym;		// internal deduction output
   wire [3:0] co, zero, nzero, en, nen; // internal control bit
   
   // address X
   minus1 DECX0 (
		 .d_o    ( xm[3:0]  ),
		 .co     ( co[0]    ),
		 .zero   ( zero[0]  ),
		 .nzero  ( nzero[0] ),
		 .en     ( en[0]    ),
		 .nen    ( nen[0]   ),
		 .d_i    ( xi[3:0]  )
		 );

   minus1 DECX1 (
		 .d_o    ( xm[7:4]  ),
		 .co     ( co[1]    ),
		 .zero   ( zero[1]  ),
		 .nzero  ( nzero[1] ),
		 .en     ( en[1]    ),
		 .nen    ( nen[1]   ),
		 .d_i    ( xi[7:4]  )
		 );

   // address Y
   minus1 DECY0 (
		 .d_o    ( ym[3:0]  ),
		 .co     ( co[2]    ),
		 .zero   ( zero[2]  ),
		 .nzero  ( nzero[2] ),
		 .en     ( en[2]    ),
		 .nen    ( nen[2]   ),
		 .d_i    ( yi[3:0]  )
		 );

   minus1 DECY1 (
		 .d_o    ( ym[7:4]  ),
		 .co     ( co[3]    ),
		 .zero   ( zero[3]  ),
		 .nzero  ( nzero[3] ),
		 .en     ( en[3]    ),
		 .nen    ( nen[3]   ),
		 .d_i    ( yi[7:4]  )
		 );

   // handle the control bits
   assign en[0] = |nzero[1:0];	// reduce the 
   assign 