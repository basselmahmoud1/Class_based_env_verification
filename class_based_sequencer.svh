class class_based_sequncer extends class_base;
    
    // instantiate mailbox
    mailbox #(class_based_transaction) seq2drv_mb;
    // instantiate  transaction (it isnt waiting for any one to pass the transaction)!!! 
    class_based_transaction seq_transc ;

    function new();
        seq_transc = new();
        seq2drv_mb = new(1);
    endfunction 

    task send_transc (input class_based_transaction transc);
        `ifdef DEBUG
                    $display("-------- IAM in the SEQUENCER and Sending the transaction to the Driver --------");
        `endif
            seq2drv_mb.put(transc);
        `ifdef DEBUG
                    $display("-------- IAM in the SEQUENCER and Sent the transaction to the Driver --------");
        `endif
    endtask

    task run ();
        repeat(100) begin
            // creat a new transaction 
            `ifdef DEBUG
                    $display("############################## NEW iteration ################################################");
            `endif
            seq_transc = new();
            randomize_transc();
            // send the transaction to the Driver
            send_transc(seq_transc);
            // something that prevent the sequencer from re-randomization again unitl the Sb finish checking the data
            @(finished_monitoring);
            `ifdef DEBUG
                    $display("##############################  iteration Ended  ################################################");
            `endif
        end
        // end the simulation 
        $finish ; 
    endtask

    task randomize_transc ();
        `ifdef DEBUG
                    $display("-------- IAM in the SEQUENCER and Starting randomizing --------");
        `endif
            // randomize the data
            assert(seq_transc.randomize());
        `ifdef DEBUG
                    $display("-------- IAM in the SEQUENCER and Finished randomization --------");
        `endif
    endtask
endclass 