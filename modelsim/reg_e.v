module reg_e #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input shift,
    input [K-1:0] data_in,
    output [10:0] count,
    output [23:0] data_out
);
    reg [23:0] reg_e;
    reg [10:0] local_count;

    assign data_out = reg_e;
    assign count = local_count;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            reg_e <= 0;
            local_count <= 0;
        end else if (shift) begin
            reg_e[0] <= reg_e[1];
            reg_e[1] <= reg_e[2];
            reg_e[2] <= reg_e[3];
            reg_e[3] <= reg_e[4];
            reg_e[4] <= reg_e[5] ^ (data_in[K-1-local_count] ^ reg_e[0]);
            reg_e[5] <= reg_e[6];
            reg_e[6] <= reg_e[7];
            reg_e[7] <= reg_e[8];
            reg_e[8] <= reg_e[9] ^ (data_in[K-1-local_count] ^ reg_e[0]);
            reg_e[9] <= reg_e[10];
            reg_e[10] <= reg_e[11];
            reg_e[11] <= reg_e[12];
            reg_e[12] <= reg_e[13];
            reg_e[13] <= reg_e[14];
            reg_e[14] <= reg_e[15] ^ (data_in[K-1-local_count] ^ reg_e[0]);
            reg_e[15] <= reg_e[16];
            reg_e[16] <= reg_e[17];
            reg_e[17] <= reg_e[18];
            reg_e[18] <= reg_e[19];
            reg_e[19] <= reg_e[20] ^ (data_in[K-1-local_count] ^ reg_e[0]);
            reg_e[20] <= reg_e[21];
            reg_e[21] <= reg_e[22];
            reg_e[22] <= reg_e[23];
            reg_e[23] <= data_in[K-1-local_count] ^ reg_e[0];
            local_count <= local_count + 1;
        end
        // if(shift) $display("[%4t] | data_in: %0b | local_count: %2d | data_out: %24b | count: %2d", $time, data_in[K-1-local_count], local_count, data_out, count);
    end

endmodule