/*
 Asynchronous SDM NoC
 (C)2011 Wei Song
 Advanced Processor Technologies Group
 Computer Science, the Univ. of Manchester, UK
 
 Authors: 
 Wei Song     wsong83@gmail.com
 
 License: LGPL 3.0 or later
 
 The IMs of a buffered Clos for SDM-Clos routers
 *** SystemVerilog is used ***
 
 History:
 07/07/2011  Initial version. <wsong83@gmail.com>
 
*/

// the router structure definitions
`include "define.v"

module dclos1 (/*AUTOARG*/);
   parameter 