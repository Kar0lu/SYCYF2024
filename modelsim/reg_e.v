module reg_e #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input shift,
    input [K-1:0] data_in,
    output [5:0] count,
    output [23:0] data_out
);
    reg [23:0] local_reg;
    reg [5:0] local_count;

    assign data_out = local_reg;
    assign count = local_count;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            local_reg <= 0;
            local_count <= 0;
        end else if (shift) begin
            local_reg[0] <= local_reg[1];
            local_reg[1] <= local_reg[2];
            local_reg[2] <= local_reg[3];
            local_reg[3] <= local_reg[4];
            local_reg[4] <= local_reg[5] ^ (data_in[K-1-local_count] ^ local_reg[0]);
            local_reg[5] <= local_reg[6];
            local_reg[6] <= local_reg[7];
            local_reg[7] <= local_reg[8];
            local_reg[8] <= local_reg[9] ^ (data_in[K-1-local_count] ^ local_reg[0]);
            local_reg[9] <= local_reg[10];
            local_reg[10] <= local_reg[11];
            local_reg[11] <= local_reg[12];
            local_reg[12] <= local_reg[13];
            local_reg[13] <= local_reg[14];
            local_reg[14] <= local_reg[15] ^ (data_in[K-1-local_count] ^ local_reg[0]);
            local_reg[15] <= local_reg[16];
            local_reg[16] <= local_reg[17];
            local_reg[17] <= local_reg[18];
            local_reg[18] <= local_reg[19];
            local_reg[19] <= local_reg[20] ^ (data_in[K-1-local_count] ^ local_reg[0]);
            local_reg[20] <= local_reg[21];
            local_reg[21] <= local_reg[22];
            local_reg[22] <= local_reg[23];
            local_reg[23] <= data_in[K-1-local_count] ^ local_reg[0];
            local_count <= local_count + 1;
        end
        // if(shift) $display("[%4t] | data_in: %0b | local_count: %2d | data_out: %24b | count: %2d", $time, data_in[K-1-local_count], local_count, data_out, count);
    end

endmodule