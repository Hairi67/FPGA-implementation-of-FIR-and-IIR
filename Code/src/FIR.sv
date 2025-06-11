// Main program: Use testbench from this file

module FIR 
#(
	parameter WD_IN = 24,									// Data_width of input data
	parameter WD_OUT = 24,									// Data_width of output data
	parameter CO_WD = 24,									// Data_width of coefficient data
	parameter CO_OR = 22
)
(
	// Input
	input logic clk,											// Input clock signal
	input logic reset_n,										// Negative reset signal
	input logic signed [WD_IN-1:0] data_in,			// Input data
	// Output
	output logic signed [WD_OUT-1:0] data_out			// Output data
);

logic signed [CO_WD-1:0] COEF [CO_OR-1:0] = '{24'hd4ef,
															24'h110a1,
															24'h1b9cc,
															24'h2c655,
															24'h42196,
															24'h5ae40,
															24'h74924,
															24'h8ccbb,
															24'ha14ed,
															24'hb02c6,
															24'hb7fa9,
															24'hb7fa9,
															24'hb02c6,
															24'ha14ed,
															24'h8ccbb,
															24'h74924,
															24'h5ae40,
															24'h42196,
															24'h2c655,
															24'h1b9cc,
															24'h110a1,
															24'hd4ef};
logic signed [CO_WD-1:0] coeff, data;
logic signed [2*CO_WD-1:0] tmp_reg;
reg signed [CO_WD-1:0] shift_reg [CO_OR-1:0];



always_ff @(posedge clk or negedge reset_n) begin
	integer i;
	if (!reset_n) begin
		for (i = 0; i < CO_OR; i++) begin
			shift_reg[i] = 24'sd0;
		end
	end
	else begin
		for (i = CO_OR-1; i > 0; i--) begin
			shift_reg[i] = shift_reg[i-1];
		end
		shift_reg[0] = data_in;
		coeff = 24'sd0;
		data = 24'sd0;
		tmp_reg = 48'sd0;
		for (i = 0; i < CO_OR; i++) begin
			coeff = COEF[i];
			data = shift_reg[i];
			tmp_reg = tmp_reg + coeff * data;
		end
		data_out = tmp_reg[(2*WD_OUT)-2:WD_OUT-1];
	end
end

endmodule