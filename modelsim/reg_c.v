module reg_c #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input shift,
    input [N-1:0] data_in,
    output [10:0] count,
    output [14:0] data_out
);
    reg [14:0] reg_c;
    reg [10:0] local_count;

    assign data_out = reg_c;
    assign count = local_count;
    assign data_in_bit = (local_count >= N) ? 1'b0 : data_in[N-1-local_count];

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            reg_c <= 0;
            local_count <= 0;
        end else if (shift) begin
            reg_c[0] <= reg_c[1];
            reg_c[1] <= reg_c[2];
            reg_c[2] <= reg_c[3];
            reg_c[3] <= reg_c[4];
            reg_c[4] <= reg_c[5];
            reg_c[5] <= reg_c[6];
            reg_c[6] <= reg_c[7];
            reg_c[7] <= reg_c[8];
            reg_c[8] <= reg_c[9];
            reg_c[9] <= reg_c[10];
            reg_c[10] <= reg_c[11];
            reg_c[11] <= reg_c[12];
            reg_c[12] <= reg_c[13];
            reg_c[13] <= reg_c[14];
            reg_c[14] <= data_in_bit ^ reg_c[0];
            local_count <= local_count + 1;
        end
        // if(shift) $display("[%4t] | REG_C | data_in: %0b | local_count: %2d | data_out: %15b | count: %2d", $time, data_in_bit, local_count, data_out, count);
    end

endmodule