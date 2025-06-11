module delay 
#(
    parameter DATA_WIDTH = 24,      // Width of data input
    parameter N_cycles = 1          // Number of cycles to delay
)
(
    input logic clk_i,              // Clock signal
    input logic clr_i,              // Clear signal (active high)
    input logic [DATA_WIDTH-1:0] data_i,   // Input data
    output logic [DATA_WIDTH-1:0] data_o   // Output data
);

    // Declare delay registers
    logic [DATA_WIDTH-1:0] delay_reg [N_cycles-1:0];

    // Delay logic
    always_ff @(posedge clk_i or posedge clr_i) begin
        if (clr_i) begin
            // Clear delay registers when clr_i is asserted
            for (int i = 0; i < N_cycles; i++) begin
                delay_reg[i] <= '0;
            end
            data_o <= '0;
        end
        else begin
            // Shift the data through the delay registers
            delay_reg[0] <= data_i;
            for (int i = 1; i < N_cycles; i++) begin
                delay_reg[i] <= delay_reg[i-1];
            end
            data_o <= delay_reg[N_cycles-1];
        end
    end

endmodule
