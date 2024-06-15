module reg_p #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input shift,
    input [N-1:0] data_in,
    output [10:0] count,
    output [8:0] data_out
);
    reg [8:0] local_reg;
    reg [10:0] local_count;

    assign data_out = local_reg;
    assign count = local_count;
    assign data_in_bit = (local_count >= N) ? 1'b0 : data_in[N-1-local_count];

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            local_reg <= 0;
            local_count <= 0;
        end else if (shift) begin
            local_reg[0] <= local_reg[1];
            local_reg[1] <= local_reg[2];
            local_reg[2] <= local_reg[3];
            local_reg[3] <= local_reg[4];
            local_reg[4] <= local_reg[5] ^ local_reg[0];
            local_reg[5] <= local_reg[6];
            local_reg[6] <= local_reg[7];
            local_reg[7] <= local_reg[8];
            local_reg[8] <= data_in_bit ^ local_reg[0];
            local_count <= local_count + 1;
        end
        // if(shift) $display("[%4t] | local_reg | data_in: %0b | local_count: %2d | data_out: %9b | count: %2d", $time, data_in_bit, local_count, data_out, count);
    end

endmodule