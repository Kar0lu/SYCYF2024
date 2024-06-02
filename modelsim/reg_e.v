module reg_e #(
    parameter N = 64,
    parameter K = 40
)(
    input clk,
    input rst,
    input shift,
    input data_in,
    output [23:0] data_out
);
    reg [23:0] reg_e;
    wire [23:0] reg_e_next;

    assign data_out = reg_e_next;

    assign reg_e_next[0] = reg_e[1];
    assign reg_e_next[1] = reg_e[2];
    assign reg_e_next[2] = reg_e[3];
    assign reg_e_next[3] = reg_e[4];
    assign reg_e_next[4] = reg_e[5] ^ (data_in ^ reg_e[0]);
    assign reg_e_next[5] = reg_e[6];
    assign reg_e_next[6] = reg_e[7];
    assign reg_e_next[7] = reg_e[8];
    assign reg_e_next[8] = reg_e[9] ^ (data_in ^ reg_e[0]);
    assign reg_e_next[9] = reg_e[10];
    assign reg_e_next[10] = reg_e[11];
    assign reg_e_next[11] = reg_e[12];
    assign reg_e_next[12] = reg_e[13];
    assign reg_e_next[13] = reg_e[14];
    assign reg_e_next[14] = reg_e[15] ^ (data_in ^ reg_e[0]);
    assign reg_e_next[15] = reg_e[16];
    assign reg_e_next[16] = reg_e[17];
    assign reg_e_next[17] = reg_e[18];
    assign reg_e_next[18] = reg_e[19];
    assign reg_e_next[19] = reg_e[20] ^ (data_in ^ reg_e[0]);
    assign reg_e_next[20] = reg_e[21];
    assign reg_e_next[21] = reg_e[22];
    assign reg_e_next[22] = reg_e[23];
    assign reg_e_next[23] = data_in ^ reg_e[0];


    initial begin
        reg_e = 0;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            reg_e <= 0;
        end else if (shift) begin
            reg_e <= reg_e_next;
        end
    end

endmodule