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
    reg [8:0] reg_p;
    reg [10:0] local_count;

    assign data_out = reg_p;
    assign count = local_count;
    assign data_in_bit = (local_count >= N) ? 1'b0 : data_in[N-1-local_count];

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            reg_p <= 0;
            local_count <= 0;
        end else if (shift) begin
            // $display("[%4t] | data_in: %0b | local_count: %2d | data_out: %24b | count: %2d", $time, data_in[K-1-local_count], local_count, data_out, count);
            reg_p[0] <= reg_p[1];
            reg_p[1] <= reg_p[2];
            reg_p[2] <= reg_p[3];
            reg_p[3] <= reg_p[4];
            reg_p[4] <= reg_p[5] ^ reg_p[0];
            reg_p[5] <= reg_p[6];
            reg_p[6] <= reg_p[7];
            reg_p[7] <= reg_p[8];
            reg_p[8] <= data_in_bit ^ reg_p[0];
            local_count <= local_count + 1;
        end
        if(shift) $display("[%4t] | REG_P | data_in: %0b | local_count: %2d | data_out: %9b | count: %2d", $time, data_in_bit, local_count, data_out, count);
    end

endmodule