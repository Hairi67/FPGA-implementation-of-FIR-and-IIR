// Main program: Use testbench from this file

module FIR
#(
	parameter WD_IN = 24,									// Data_width of input data
	parameter WD_OUT = 24,									// Data_width of output data
	parameter CO_WD = 24,									// Data_width of coefficient data
	parameter CO_OR = 30
)
(
	// Input
	input logic clk,											// Input clock signal
	input logic reset_n,										// Negative reset signal
	input logic signed [WD_IN-1:0] data_in,			// Input data
	// Output
	output logic signed [WD_OUT-1:0] data_out			// Output data
	
	// Test:
//	output logic [CO_WD-1:0] delay_buffer,
//	output logic signed [2*CO_WD-1:0] tmp_reg
);

logic signed [CO_WD-1:0] COEF [CO_OR-1:0] = '{'{
24'h0093C3,
24'h00AAEB,
24'h00EAE7,
24'h0152BF,
24'h01DF30,
24'h028AD1,
24'h034E4F,
24'h0420D0,
24'h04F869,
24'h05CAAB,
24'h068D32,
24'h07363D,
24'h07BD3B,
24'h081B45,
24'h084B89,
24'h084B89,
24'h081B45,
24'h07BD3B,
24'h07363D,
24'h068D32,
24'h05CAAB,
24'h04F869,
24'h0420D0,
24'h034E4F,
24'h028AD1,
24'h01DF30,
24'h0152BF,
24'h00EAE7,
24'h00AAEB,
24'h0093C3};

// Delay stage 1: Load the input data the delay 1 cycle
logic signed [WD_IN-1:0] data_dl_s1;
delay 
#(
	.DATA_WIDTH					(WD_IN),
	.N_cycles					(1)
)
delay_s1
(
	.clk_i						(clk),
	.clr_i						(!reset_n),
	.data_i						(data_in),
	.data_o						(data_dl_s1)
);

// Multiply and delay 1 cycles after multiplying
logic signed [WD_IN+CO_WD-1:0] mem_dl_s2 [(2*CO_OR)-1:0];

always_ff @(posedge clk or negedge reset_n) begin
	integer i;
	if (!reset_n) begin													// Negative reset
		for (i = 0; i < 2*CO_OR; i++) begin
			mem_dl_s2[i] <= 0;
		end
	end
	else begin
		for (i = 0; i < CO_OR; i++) begin							// Multiply input data with approriate coefficient
			mem_dl_s2[i] <= data_dl_s1 * COEF[i];
		end
		for (i = CO_OR; i < 2*CO_OR; i++) begin					// Delay 1 cycles after multiply
			mem_dl_s2[i] <= mem_dl_s2[i-CO_OR];
		end
	end
end

// Add:
logic signed [WD_IN+CO_WD-1:0] acc [CO_OR:0];
always_ff @(posedge clk or negedge reset_n) begin
	integer j;
	if (!reset_n) begin
		data_out <= 24'sd0;
		for (j = 0; j < CO_OR; j++) begin
			acc[j] <= 48'sd0;
		end
	end
	else begin
		acc[CO_OR] <= 48'sd0;
		for (j = 0; j < CO_OR-1; j++) begin
			acc[j] <= mem_dl_s2[CO_OR+j] + acc[j+1];
		end
		data_out <= acc[0][(2*WD_OUT)-2:WD_OUT-1];
	end
end

endmodule 