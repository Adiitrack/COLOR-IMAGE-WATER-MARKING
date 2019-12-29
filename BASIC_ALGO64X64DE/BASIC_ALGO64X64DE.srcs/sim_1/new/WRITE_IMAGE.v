/******************************************************************************/
/******************     Module for writing .bmp image    		 *************/
/******************************************************************************/
module WRITE_IMAGE
#(parameter WIDTH 	= 8,							// Image width
			HEIGHT 	= 8								// Image height
			//INFILE  = "output.txt",						// Output txt
)
(
	input HCLK,												// Clock	
	input HRESETn,											// Reset active low
	input hsync,											// Hsync pulse						
    input [7:0]  DATA_WRITE_R0,						// Red 8-bit data (odd)
    input [7:0]  DATA_WRITE_G0,						// Green 8-bit data (odd)
    input [7:0]  DATA_WRITE_B0,						// Blue 8-bit data (odd)
    input [7:0]  DATA_WRITE_R1,						// Red 8-bit data (even)
    input [7:0]  DATA_WRITE_G1,						// Green 8-bit data (even)
    input [7:0]  DATA_WRITE_B1,						// Blue 8-bit data (even)
    input  data,                                     //hidedbit
	output 	reg	 Write_Done
);	
reg [7:0] out_BMP  [0 : WIDTH*HEIGHT*3 - 1];		// Temporary memory for image
reg [18:0] data_count;									// Counting data
reg [7:0] bit;
wire done;													// done flag
// counting variables
integer i;
integer k, l, m;
integer fd; 

// row and column counting for temporary memory of image 
always@(posedge HCLK, negedge HRESETn) begin
    if(!HRESETn) begin
        l <= 0;
        m <= 0;
    end else begin
        if(hsync) begin
           // if(m == WIDTH/2-1) begin
           //     m <= 0;
           //     l <= l + 1; // count to obtain row index of the out_BMP temporary memory to save image data
           // end else begin
                m <= m + 6; // count to obtain column index of the out_BMP temporary memory to save image data m=m+1
           // end
        end
    end
end
// Writing RGB888 even and odd data to the temp memory
always@(posedge HCLK, negedge HRESETn) begin
    if(!HRESETn) begin
        for(k=0;k<WIDTH*HEIGHT*3;k=k+1) begin
            out_BMP[k] <= 0;
        end
    end else begin
        if(hsync) begin
            out_BMP[m] <= DATA_WRITE_R0;
            out_BMP[m+1] <= DATA_WRITE_G0;
            out_BMP[m+2] <= DATA_WRITE_B0;
            out_BMP[m+3] <= DATA_WRITE_R1;
            out_BMP[m+4] <= DATA_WRITE_G1;
            out_BMP[m+5] <= DATA_WRITE_B1;
        end
    end
end
// data counting
always@(posedge HCLK, negedge HRESETn)
begin
    if(~HRESETn) begin
        data_count <= 0;
    end
    else begin
        if(hsync)
			data_count <= data_count + 2; // pixels counting for create done flag
    end
end
assign done = (data_count == 192)? 1'b1: 1'b0; // done flag once all pixels were processed
always@(posedge HCLK, negedge HRESETn)
begin
    if(~HRESETn) begin
        Write_Done <= 0;
    end
    else begin
		Write_Done <= done;
    end
end
//---------------------------------------------------------//
//--------------Write .bmp file		----------------------//
//----------------------------------------------------------//
initial begin
    fd = $fopen("output.txt", "wb+");
end
always@(done) begin // once the processing was done, bmp image will be created
    if(done == 1'b1) begin
        //for(i=0; i<BMP_HEADER_NUM; i=i+1) begin
        //    $fwrite(fd, "%c", BMP_header[i][7:0]); // write the header
        //end
        
        for(i=0; i<WIDTH*HEIGHT*3; i=i+6) begin
		// write R0B0G0 and R1B1G1 (6 bytes) in a loop
            $fwrite(fd, "%h\n", out_BMP[i  ][7:0]);
            $fwrite(fd, "%h\n", out_BMP[i+1][7:0]);
            $fwrite(fd, "%h\n", out_BMP[i+2][7:0]);
            $fwrite(fd, "%h\n", out_BMP[i+3][7:0]);
            $fwrite(fd, "%h\n", out_BMP[i+4][7:0]);
            $fwrite(fd, "%h\n", out_BMP[i+5][7:0]);
        end
        $fclose(fd);
    end
end
endmodule
