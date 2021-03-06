`timescale 1ns/1ps 
/**************************************************************************/
/******************** Testbench for simulation ****************************/
/**************************************************************************/

`include "parameter.v"				// include definition file

module tb_simulation;

//-------------------------------------------------
// Internal Signals
//-------------------------------------------------

reg HCLK, HRESETn;
wire          vsync;
wire          hsync;
wire [ 7 : 0] data_R0;
wire [ 7 : 0] data_G0;
wire [ 7 : 0] data_B0;
wire [ 7 : 0] data_R1;
wire [ 7 : 0] data_G1;
wire [ 7 : 0] data_B1;
wire enc_done;
wire s;
wire [7:0] avg;
wire [7:0] loc;
wire [7:0]  diff;
wire [7:0] newdata_r0;
wire [7:0] newdata_r1;
//-------------------------------------------------
// Components
//-------------------------------------------------

image_read 
#()
	u_image_read
( 
    .HCLK	                (HCLK    ),
    .HRESETn	            (HRESETn ),
    .VSYNC	                (vsync   ),
    .HSYNC	                (hsync   ),
    .DATA_R0	            (data_R0 ),
    .DATA_G0	            (data_G0 ),
    .DATA_B0	            (data_B0 ),
    .DATA_R1	            (data_R1 ),
    .DATA_G1	            (data_G1 ),
    .DATA_B1	            (data_B1 ),
	.ctrl_done				(enc_done),
	.S                     (s),
	.AVG                   (avg),
	.LOC                   (loc),
	.DIFF                  (diff),
	.NEWDATA_R0            (newdata_r0),
	.NEWDATA_R1             (newdata_r1)
); 
image_write 
#()
	u_image_write
(
	.HCLK(HCLK),
	.HRESETn(HRESETn),
	.hsync(hsync),
   .DATA_WRITE_R0(newdata_r0),
   .DATA_WRITE_G0(data_G0),
   .DATA_WRITE_B0(data_B0),
   .DATA_WRITE_R1(newdata_r1),
   .DATA_WRITE_G1(data_G1),
   .DATA_WRITE_B1(data_B1),
	.Write_Done()
);

//-------------------------------------------------
// Test Vectors
//-------------------------------------------------
initial begin 
    HCLK = 0;
    forever #10 HCLK = ~HCLK;
end

initial begin
    HRESETn     = 0;
    #25 HRESETn = 1;
end


endmodule

