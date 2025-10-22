interface MEM_IF (
    input logic clk 
);
    logic [31:0] data_in , data_out;
    logic [3:0] addr;
    logic EN , RW ,valid_out, rst;

    modport DUT (
    input data_in,addr,clk,rst,RW,EN,
    output data_out,valid_out
    );
endinterface