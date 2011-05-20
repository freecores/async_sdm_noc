// A synthesizable cell library for asynchronous logic
// author Wei Song, songw@cs.man.ac.uk
// the Advanced Processor Technology Group
// the School of Computer Science
// the Uniersity of Manchester
// 5th May, 2009
// a latch is added, 11/08/2010 songw@cs.man.ac.uk


module c2 (
     a0
    ,a1
    ,q
    );

input a0;
input a1;
output q;

AO222EHD U1 ( .A1(q), .A2(a0), .B1(q), .B2(a1), .C1(a0), .C2(a1), .O(q) );

endmodule

// the dc2 cell for Faraday 130nm Tech
module dc2 (
     d
    ,a
    ,q
    );

input d;
input a;
output q;

AO222HHD U1 ( .A1(q), .A2(d), .B1(q), .B2(a), .C1(d), .C2(a), .O(q) );

endmodule // dc2

module c2n (
     a0
    ,a1
    ,q
    );

input a0;
input a1;
output q;

   AO12EHD U1 (.B1(a1), .B2(q), .A1(a0), .O(q));

endmodule


module c2p (
     a0
    ,a1
    ,q
    );

input a0;
input a1;
output q;


OA12EHD U1 ( .B1(a1), .B2(q), .A1(a0), .O(q) );

endmodule

// for Faraday
module mutex ( a, b, qa, qb );
input a, b;
output qa, qb;
wire   qan, qbn;

ND2HHD U1 ( .I1(a), .I2(qbn), .O(qan) );
NR3HHD U2 ( .I1(qbn), .I2(qbn), .I3(qbn), .O(qb) );
NR3HHD U3 ( .I1(qan), .I2(qan), .I3(qan), .O(qa) );
ND2KHD U4 ( .I1(b), .I2(qan), .O(qbn) );
endmodule


module c2p1 (
             a0,
             a1,
             b, 
             q  
             ); 
   input a0, a1, b;
   output q;       
                   
  wire   n1;
                   
  OA12EHD U2 ( .B1(a1), .B2(a0), .A1(q), .O(n1) );
  AO13EHD U1 ( .B1(a1), .B2(a0), .B3(b), .A1(n1), .O(q) );
                               
//assign q = (a0&a1&b)|(a0&q)|(b0&q);
endmodule // c2p1                    


module tarb ( ngnt, ntgnt, req, treq );
  output [1:0] ngnt;
  input [1:0] req;
  input ntgnt;
  output treq;
  wire   n1, n2;
  wire   [1:0] mgnt;

  mutex ME ( .a(req[0]), .b(req[1]), .qa(mgnt[0]), .qb(mgnt[1]) );
  c2n C0 ( .a0(ntgnt), .a1(n2), .q(ngnt[0]) );
  c2n C1 ( .a0(ntgnt), .a1(n1), .q(ngnt[1]) );
  ND2HHD U1 ( .I1(n1), .I2(n2), .O(treq) );
  ND2DHD U2 ( .I1(ngnt[0]), .I2(mgnt[1]), .O(n1) );
  ND2DHD U3 ( .I1(ngnt[1]), .I2(mgnt[0]), .O(n2) );
endmodule

module cr_blk ( bo, hs, cbi, rbi, rg, cg );
  input cbi, rbi, rg, cg;
  output bo, hs;
  wire   blk;

  c2p1 XG ( .a0(rg), .a1(cg), .b(blk), .q(bo) );
  c2p1 HG ( .a0(cbi), .a1(rbi), .b(bo), .q(hs) );
  NR2EHD U1 ( .I1(rbi), .I2(cbi), .O(blk) );

endmodule

module dlatch ( q, qb, d, g);
   output q, qb;
   input  d, g;

   DLAHEHD U1 (.Q(q), .QB(qb), .D(d), .G(g));
endmodule // dlatch

module delay (q, a);
   input a;
   output q;
   BUFKHD U (.O(q), .I(a));
endmodule // delay

   