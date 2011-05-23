/*
 Asynchronous SDM NoC
 (C)2011 Wei Song
 Advanced Processor Technologies Group
 Computer Science, the Univ. of Manchester, UK
 
 Authors: 
 Wei Song     wsong83@gmail.com
 
 License: LGPL 3.0 or later
 
 Router configuration header file for SDM routers.
 
 History:
 20/09/2009  Initial version. <wsong83@gmail.com>
 23/05/2011  Clean up for opensource. <wsong83@gmail.com>
 
*/

// if VCN > 1, set ENABLE_CLOS to use the 2-stage Clos switch for less switching area
`define ENABLE_CLOS

// set to enable channel slicing for fast data paths
`define ENABLE_CHANNEL_SLICING

// set to use the early acknowledge of lokkahead pipelines in the critical cycle
`define ENABLE_LOOKAHEAD

// always set in wormhole and SDM routers to enable the eof bit in data pipeline stages
`define ENABLE_EOF
