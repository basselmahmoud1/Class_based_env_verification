module top ();
    import pack::*;
    logic clk ; 
    initial begin
        clk = 0 ; 
        forever begin
            #1; clk = ~clk ; 
        end
    end
    // instatiate the env
    class_based_env env ; 

    MEM_IF memif (clk);
    mem16x32 mem (memif);
    initial begin
        `ifdef DEBUG
                $display("-------- IAM in the TOP and Going to start simulation --------");
        `endif 
        env = new(memif);
        env.connect();
        env.run();
        `ifdef DEBUG
                $display("-------- IAM in the TOP and Finished simulation --------");
        `endif 
    end

    // Print some logs after the sim finishes 
    final begin
        $display(" SIM Finished successfully ");
        // print some how the correct and the error counts
        env.report();    
    end  

endmodule 