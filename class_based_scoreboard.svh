class class_based_scoreboard extends class_base;
    // make instance of the transaction class ("should be passed from the monitor")
    class_based_transaction score_transc ; 
    // instantiate mailbox
    mailbox #(class_based_transaction) mon2subSb_mb;
     
    int error_count , correct_count ; 
    
    // Golden model: memory array to mimic DUT behavior
    logic [31:0] golden_mem [15:0];
    
    function new();
        score_transc = new();
        mon2subSb_mb = new(1);
        error_count = 0;
        correct_count = 0;
        
    endfunction 
    
    task recieve_transc (output class_based_transaction transc);
        `ifdef DEBUG
            $display("-------- IAM in the SCOREBOARD and going to Wait for the transaction --------");
        `endif 
            mon2subSb_mb.get(transc);
        `ifdef DEBUG
            $display("-------- IAM in the SCOREBOARD and recieved the transaction --------");
        `endif 
    endtask

    // Golden task: Models the expected behavior of the memory
    task golden_task(input class_based_transaction transc, output logic [31:0] expected_data_out, output logic expected_valid_out);
        if (transc.rst) begin
            // On reset, outputs should be zero
            expected_data_out = 32'h0;
            expected_valid_out = 1'b0;
        end
        else begin
            if (transc.EN) begin
                if (transc.RW) begin
                    // Read operation: output data from golden memory
                    expected_data_out = golden_mem[transc.addr];
                    expected_valid_out = 1'b1;
                end
                else begin
                    // Write operation: update golden memory
                    golden_mem[transc.addr] = transc.data_in;
                    expected_valid_out = 1'b0;
                    expected_data_out = 32'hx; // Don't care on write
                end
            end
            else begin
                // EN is low, no operation
                expected_valid_out = 1'b0;
                expected_data_out = 32'hx; // Don't care when not enabled
            end
        end
    endtask

    // Check data task: Compare DUT output with golden model
    task check_data(input class_based_transaction transc);
        logic [31:0] expected_data_out;
        logic expected_valid_out;
        
        // Get expected values from golden task
        golden_task(transc, expected_data_out, expected_valid_out);
        
        // Compare valid_out
        if (transc.valid_out !== expected_valid_out) begin
            error_count++;
            $display("@%0t [SCOREBOARD ERROR] valid_out mismatch: Expected=%0b, Got=%0b | addr=%0h, EN=%0b, RW=%0b, rst=%0b", 
                     $realtime, expected_valid_out, transc.valid_out, transc.addr, transc.EN, transc.RW, transc.rst);
        end
        else if (transc.valid_out && expected_valid_out) begin
            // Only compare data_out when valid_out is high (read operation)
            if (transc.data_out !== expected_data_out) begin
                error_count++;
                $display("@%0t [SCOREBOARD ERROR] data_out mismatch: Expected=%0h, Got=%0h | addr=%0h, EN=%0b, RW=%0b", 
                         $realtime, expected_data_out, transc.data_out, transc.addr, transc.EN, transc.RW);
            end
            else begin
                correct_count++;
                `ifdef DEBUG
                    $display("@%0t [SCOREBOARD PASS] Data matched: data_out=%0h, addr=%0h", 
                             $realtime, transc.data_out, transc.addr);
                `endif
            end
        end
        else begin
            // Write operation or disabled - valid passes, consider it correct
            correct_count++;
            `ifdef DEBUG
                $display("@%0t [SCOREBOARD PASS] Operation correct: EN=%0b, RW=%0b, addr=%0h", 
                         $realtime, transc.EN, transc.RW, transc.addr);
            `endif
        end
    endtask

    //Question? --> Who will trigger the Check_data task ?
    // answer is the monitor will fork it   
    task run ();
        forever begin 
            // Recive the transaction form the monitor "BLOCKS on the transaction form the monitor" 
            recieve_transc(score_transc);
            `ifdef DEBUG
                    $display("-------- IAM in the SCOREBOARD and going to check data --------");
            `endif 
            // check data mechanism using golden task
            check_data(score_transc);
            `ifdef DEBUG
                    $display("-------- IAM in the SCOREBOARD and Finished Data checking --------");
            `endif
            // i think No one is intereset if i have finished or not ! 
            // No Sequencer whats to know when have you finished to re-randomize
            // some sign to tell the monitor that the data have been driven succesfully so it can work now
            ->finished_monitoring; 
        end
        `ifdef DEBUG
                    $display("-------- IAM in the SCOREBOARD and SCOREBOARD DIED (there might be racing)--------");
        `endif
    endtask
    
    // Report function to display final results
    function void report();
        $display("========================================");
        $display("       SCOREBOARD FINAL REPORT         ");
        $display("========================================");
        $display("Total Correct: %0d", correct_count);
        $display("Total Errors:  %0d", error_count);
        $display("Total Checks:  %0d", correct_count + error_count);
        if (error_count == 0) begin
            $display("STATUS: ALL TESTS PASSED!");
        end
        else begin
            $display("STATUS: %0d TEST(S) FAILED!", error_count);
        end
        $display("========================================");
    endfunction
endclass 