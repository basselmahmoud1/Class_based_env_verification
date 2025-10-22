module mem16x32 (MEM_IF.DUT memif);
    reg [31:0] mem [15:0];
    always @(posedge memif.clk) begin
        if(memif.rst) begin
            memif.data_out  <= 0;
            memif.valid_out <= 0;
        end
        else begin
            if(memif.EN) begin
                // if we have simultanious read and write read first then write 
                if (memif.RW) begin
                    memif.data_out <= mem [memif.addr] ;
                    memif.valid_out <= 1 ;
                end
                else begin
                    mem[memif.addr] <= memif.data_in;  
                    memif.valid_out <= 0;
                end
            end
            else begin 
                memif.valid_out <= 0 ;            
            end 
        end
    end
endmodule