class class_based_monitor extends class_base ; 
    local virtual MEM_IF monitor_vif ; 
    // Monitor creates a totally new transaction and procede it 
    //  transaction since it have the data to taken from the inteface and then be sent to scoreboard and subscriber 
    // instantiate  transaction 
    class_based_transaction mon_transc;
    // instantiate  scoreboard
    class_based_scoreboard sb_handle ; 
    // instantiate  Subscriber
    class_based_subscriber subscriber_handle ;
    // instantiate mailbox
    mailbox #(class_based_transaction) mon2subSb_mb;
    
    string key ; 
    function new (string key = "");
        mon_transc = new();
        mon2subSb_mb = new(2);
        // get_vif(key);
        this.key = key ; 
    endfunction
    
    
    task get_vif (string key = "");
        `ifdef DEBUG
            $display("-------- IAM in the MONITOR and going to Get VIF --------");
        `endif 
            // As key reprenest the Key to get the vif
            if(key == "")
                $error("FAILD to get IF :Passing empty KEY to the MONITOR");
            else
                monitor_vif = vif_associative[key];
            
            if(monitor_vif == null)
                $error("FAILD to get IF :Passing null VIF to the MONITOR");
        
        `ifdef DEBUG
            $display("-------- IAM in the MONITOR and GOT to Get VIF --------");
        `endif 
    endtask
    // Question?--> when and Who will finish this forever loop "expected to be forked join none then disable all forks" 
    
    
    task body (); 
        // get the virtual interface 
        get_vif(key);
    endtask
    
    task send_transc (input class_based_transaction transc);
        `ifdef DEBUG
                    $display("-------- IAM in the MONITOR and Sending the transaction to the SB and Subs --------");
        `endif
            mon2subSb_mb.put(transc);
            mon2subSb_mb.put(transc);
        `ifdef DEBUG
                    $display("-------- IAM in the MONITOR and Sent the transaction to the SB and Subs --------");
        `endif
    endtask
    
    task run ();
        // fork to activate the send data to the subscriber and the scoreboard 
        body();
        // fork
        //     sb_handle.run();         
        //     subscriber_handle.run(); 
        // join_none
        forever begin
            // some sign to wait before monitoring the new data ("expected to be from driver") since we should monitor the driven data 
            @(finished_driving);
            if (monitor_vif == null)begin
                $error("Passing null VIF to the monitor");
            end
            `ifdef DEBUG
                $display("-------- IAM in the MONITOR and going to monitor --------");
            `endif 
            // create new transaction 
            mon_transc = new();
            // monitor the data here 
            @(negedge monitor_vif.clk);
                mon_transc.data_in      = monitor_vif.data_in ;
                mon_transc.data_out     = monitor_vif.data_out ;
                mon_transc.addr         = monitor_vif.addr ;
                mon_transc.EN           = monitor_vif.EN ;
                mon_transc.RW           = monitor_vif.RW ;
                mon_transc.valid_out    = monitor_vif.valid_out ;
                mon_transc.rst          = monitor_vif.rst ;
            `ifdef DEBUG
                $display("-------- IAM in the MONITOR and finished monitoring --------");
            `endif 
            // Send the transaction 
            send_transc(mon_transc);
        end
        `ifdef DEBUG
                    $display("-------- IAM in the MONITOR and MONITOR DIED (there might be racing)--------");
        `endif
    endtask  
endclass