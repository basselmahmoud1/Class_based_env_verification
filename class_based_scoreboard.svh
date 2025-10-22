class class_based_scoreboard extends class_base;
    // make instance of the transaction class ("should be passed from the monitor")
    class_based_transaction score_transc ; 
    // instantiate mailbox
    mailbox #(class_based_transaction) mon2subSb_mb;
     
    int error_count , correct_count ; 
    function new();
        score_transc = new();
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

    //Question? --> Who will trigger the Check_data task ?
    // answer is the monitor will fork it   
    task run ();
        forever begin 
            // Recive the transaction form the monitor "BLOCKS on the transaction form the monitor" 
            recieve_transc(score_transc);
            `ifdef DEBUG
                    $display("-------- IAM in the SCOREBOARD and going to check data --------");
            `endif 
            // check data mechanism
                    $display("-------- IAM in the SCOREBOARD and Blablablabal--------");
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
endclass 