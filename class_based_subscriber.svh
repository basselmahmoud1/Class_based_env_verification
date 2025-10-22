class class_based_subscriber extends class_base;
    // make instance of the transaction class ("should be passed from the monitor")
    class_based_transaction subscriber_transc ;
    // instantiate mailbox
    mailbox #(class_based_transaction) mon2subSb_mb; 
    function new();
        subscriber_transc = new();
    endfunction 
    
    task recieve_transc (output class_based_transaction transc);
        `ifdef DEBUG
            $display("-------- IAM in the Subscriber and going to Wait for the transaction --------");
        `endif 
            mon2subSb_mb.get(transc);
        `ifdef DEBUG
            $display("-------- IAM in the Subscriber and recieved the transaction --------");
        `endif 
    endtask
    //Questin? --> Who will trigger the run task ?
    // answer is the monitor will fork it  
    task run ();
        forever begin 
            // Recive the transaction form the monitor "BLOCKS on the transaction form the monitor" 
            recieve_transc(subscriber_transc);
            `ifdef DEBUG
                    $display("-------- IAM in the Subscriber and going to sample data --------");
            `endif 
            // Sample data Code :: 
                    $display("-------- IAM in the Subscriber and Blablablabal--------");

            `ifdef DEBUG
                    $display("-------- IAM in the Subscriber and Finished Data Sampling --------");
            `endif
            // i think No one is intereset if i have finished or not !  
            // yes since this task doesnt take time 
        end
        `ifdef DEBUG
                    $display("-------- IAM in the Subscriber and Subscriber DIED (there might be racing)--------");
        `endif
    endtask
endclass 