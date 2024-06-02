module reg_c #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input shift,
    input data_in,
    output [14:0] data_out
);
    reg [14:0] reg_c;
    wire [14:0] reg_c_next;

    assign data_out = (shift) ? reg_c_next : reg_c;

    assign reg_c_next[0] = reg_c[1];
    assign reg_c_next[1] = reg_c[2];
    assign reg_c_next[2] = reg_c[3];
    assign reg_c_next[3] = reg_c[4];
    assign reg_c_next[4] = reg_c[5];
    assign reg_c_next[5] = reg_c[6];
    assign reg_c_next[6] = reg_c[7];
    assign reg_c_next[7] = reg_c[8];
    assign reg_c_next[8] = reg_c[9];
    assign reg_c_next[9] = reg_c[10];
    assign reg_c_next[10] = reg_c[11];
    assign reg_c_next[11] = reg_c[12];
    assign reg_c_next[12] = reg_c[13];
    assign reg_c_next[13] = reg_c[14];
    assign reg_c_next[14] = data_in ^ reg_c[0];

    initial begin
        reg_c = 0;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            reg_c <= 0;
        end else if (shift) begin
            // $display("[%4t] | reg_c: %15b | reg_c_next: %15b", $time, reg_c, reg_c_next);
            reg_c <= reg_c_next;
        end
    end

endmodule