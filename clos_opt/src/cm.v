/*
 Asynchronous SDM NoC
 (C)2011 Wei Song
 Advanced Processor Technologies Group
 Computer Science, the Univ. of Manchester, UK
 
 Authors: 
 Wei Song     wsong83@gmail.com
 
 License: LGPL 3.0 or later
 
 A CM of a buffered Clos for SDM-Clos routers
 *** SystemVerilog is used ***
 
 History:
 08/07/2011  Initial version. <wsong83@gmail.com>
 
*/

// the router structure definitions
`include "define.v"

module cm (/*AUTOARG*/
   // Outputs
   do0, do1, do2, do3, dia, do4,
   // Inputs
   di0, di1, di2, di3, sdec, ndec, ldec, wdec, edec, di4, doa, doa4,
   rst_n
   );

   parameter KN = 5;	       // dummy parameter, the number of IMs
   parameter DW = 8;	       // the data width of each IP
   parameter SCN = DW/2;       // the number of sub-channels in one IP

   input [KN-1:0][SCN-1:0]    di0, di1, di2, di3;      // input data
   input [3:0] 		      sdec, ndec, ldec;	       // the decoded direction requests
   input [1:0] 		      wdec, edec;	       // the decoded direction requests
   output [KN-1:0][SCN-1:0]   do0, do1, do2, do3;      // output data

`ifdef ENABLE_CHANNEL_SLICING
   input [KN-1:0][SCN-1:0]    di4;                     // data input
   output [KN-1:0][SCN-1:0]   dia;		       // input ack
   output [KN-1:0][SCN-1:0]   do4;		       // data output
   input [KN-1:0][SCN-1:0]    doa, doa4;	       // output ack
`else
   input [KN-1:0] 	      di4;                     // data input
   output [KN-1:0] 	      dia;		       // input ack
   output [KN-1:0] 	      do4;		       // data output
   input [KN-1:0] 	      doa, doa4;	       // output ack
`endif // !`ifdef ENABLE_CHANNEL_SLICING
   
`ifndef ENABLE_CRRD
   output [KN-1:0] 	      cms; // the state feedback to IMs
`endif
   
   input 		      rst_n; // global active low reset

   wire [KN-1:0][SCN-1:0]     cmo0, cmo1, cmo2, cmo3; // the data output of CM
`ifdef ENABLE_CHANNEL_SLICING
   wire [KN-1:0][SCN-1:0]     cmo4, cmoa, cmoa4; // data and ack wires
`else
   wire [KN-1:0] 	      cmo4, cmoa, cmoa4; // data and ack wires
`endif
   wire [3:0] 		      wcfg, ecfg, lcfg;	// switch configuration
   wire [1:0] 		      scfg, ncfg;	// switch configuration

   genvar 		      i, j;

   // data switch
   dcb_xy #(.VCN(1), .VCW(DW))
   CM (
       .sia   ( dia[i][0]    ), 
       .wia   ( dia[i][1]    ), 
       .nia   ( dia[i][2]    ), 
       .eia   ( dia[i][3]    ), 
       .lia   ( dia[i][4]    ), 
       .so0   ( cmo0[i][0]   ), 
       .so1   ( cmo1[i][0]   ), 
       .so2   ( cmo2[i][0]   ), 
       .so3   ( cmo3[i][0]   ), 
       .so4   ( cmo4[i][0]   ), 
       .wo0   ( cmo0[i][1]   ), 
       .wo1   ( cmo1[i][1]   ), 
       .wo2   ( cmo2[i][1]   ),
       .wo3   ( cmo3[i][1]   ), 
       .wo4   ( cmo4[i][1]   ), 
       .no0   ( cmo0[i][2]   ), 
       .no1   ( cmo1[i][2]   ), 
       .no2   ( cmo2[i][2]   ), 
       .no3   ( cmo3[i][2]   ), 
       .no4   ( cmo4[i][2]   ), 
       .eo0   ( cmo0[i][3]   ), 
       .eo1   ( cmo1[i][3]   ), 
       .eo2   ( cmo2[i][3]   ), 
       .eo3   ( cmo3[i][3]   ), 
       .eo4   ( cmo4[i][3]   ), 
       .lo0   ( cmo0[i][4]   ),
       .lo1   ( cmo1[i][4]   ), 
       .lo2   ( cmo2[i][4]   ), 
       .lo3   ( cmo3[i][4]   ), 
       .lo4   ( cmo4[i][4]   ),
       .si0   ( di0[i][0]    ), 
       .si1   ( di1[i][0]    ), 
       .si2   ( di2[i][0]    ), 
       .si3   ( di3[i][0]    ), 
       .si4   ( di4[i][0]    ), 
       .wi0   ( di0[i][1]    ), 
       .wi1   ( di1[i][1]    ), 
       .wi2   ( di2[i][1]    ), 
       .wi3   ( di3[i][1]    ), 
       .wi4   ( di4[i][1]    ), 
       .ni0   ( di0[i][2]    ), 
       .ni1   ( di1[i][2]    ), 
       .ni2   ( di2[i][2]    ),
       .ni3   ( di3[i][2]    ), 
       .ni4   ( di4[i][2]    ), 
       .ei0   ( di0[i][3]    ), 
       .ei1   ( di1[i][3]    ), 
       .ei2   ( di2[i][3]    ), 
       .ei3   ( di3[i][3]    ), 
       .ei4   ( di4[i][3]    ), 
       .li0   ( di0[i][4]    ), 
       .li1   ( di1[i][4]    ), 
       .li2   ( di2[i][4]    ), 
       .li3   ( di3[i][4]    ), 
       .li4   ( di4[i][4]    ), 
       .soa   ( cmoa[i][0]   ),
       .woa   ( cmoa[i][1]   ),
       .noa   ( cmoa[i][2]   ),
       .eoa   ( cmoa[i][3]   ),
       .loa   ( cmoa[i][4]   ),
       .soa4  ( cmoa4[i][0]  ),
       .woa4  ( cmoa4[i][1]  ),
       .noa4  ( cmoa4[i][2]  ),
       .eoa4  ( cmoa4[i][3]  ),
       .loa4  ( cmoa4[i][4]  ),
       .wcfg  ( wcfg[i]      ), 
       .ecfg  ( ecfg[i]      ), 
       .lcfg  ( lcfg[i]      ), 
       .scfg  ( scfg[i]      ), 
       .ncfg  ( ncfg[i]      )
       );

   // the allocator
   cm_alloc CMD (
`ifndef ENABLE_CRRD
		 .s     ( cms   ),
`endif	       
		 .sra   (       ),
		 .wra   (       ),
		 .nra   (       ),
		 .era   (       ),
		 .lra   (       ),
		 .scfg  ( scfg  ),
		 .ncfg  ( ncfg  ),
		 .wcfg  ( wcfg  ),
		 .ecfg  ( ecfg  ),
		 .lcfg  ( lcfg  ),
		 .sr    ( sdec  ),
		 .wr    ( wdec  ),
		 .nr    ( ndec  ),
		 .er    ( edec  ),
		 .lr    ( ldec  )
		 );
   


endmodule // cm
