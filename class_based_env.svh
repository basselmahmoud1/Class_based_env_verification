class class_based_env extends class_base;
    // instantiate  sequencer
    class_based_sequncer seqencer_handle ; 
    // instantiate  Driver 
    class_based_driver dirver_handle ; 
    // instantiate  Monitor
    class_based_monitor monitor_handle ;
    // instantiate  Scoreboard
    class_based_scoreboard sb_handle ;
    // instantiate  Subscriber
    class_based_subscriber subscriber_handle ;
    
    // instantiate 2 mailboxes one for the sequencer driver communication 
    //and the other for the monitor-sb-subs communication
    mailbox #(class_based_transaction) seq2drv_mb;
    mailbox #(class_based_transaction) mon2subSb_mb;
    // Virtual interface to be passed to the associative array 
    local virtual MEM_IF env_vif ; 

    function new(virtual MEM_IF env_vif);
        // classes handles 
        seqencer_handle   = new();
        dirver_handle     = new("VIF_driv");
        monitor_handle    = new("VIF_mon");
        sb_handle         = new();
        subscriber_handle = new();
        // handle for the mail box 
        seq2drv_mb        = new(1);
        mon2subSb_mb      = new(1);
        //Assign the interface with the virtual interface passed form the top module 
        this.env_vif = env_vif;
    endfunction
    task connect ();
        `ifdef DEBUG
                    $display("-------- IAM in the ENV and going to Connect the seq2drv_mb --------");
        `endif 
        seqencer_handle.seq2drv_mb     = seq2drv_mb ; 
        dirver_handle.seq2drv_mb       = seq2drv_mb ; 
        `ifdef DEBUG
                    $display("-------- IAM in the ENV and going to Connect the mon2subSb_mb --------");
        `endif
         monitor_handle.mon2subSb_mb     = mon2subSb_mb ; 
         sb_handle.mon2subSb_mb          = mon2subSb_mb ; 
         subscriber_handle.mon2subSb_mb  = mon2subSb_mb ;
         `ifdef DEBUG
                    $display("-------- IAM in the ENV and going to Put Vif in the Database --------");
        `endif
        // put the vif in thte associative array 
        vif_associative["VIF_driv"] = env_vif ;
        vif_associative["VIF_mon"] = env_vif ;
    endtask
    // We must take the Interface form the Top and pass it to the monitor and the driver 
    task run ();
        `ifdef DEBUG
                    $display("-------- IAM in the ENV and going to Fork and run the env --------");
        `endif
        fork
            seqencer_handle.run();   
            dirver_handle.run();     
            monitor_handle.run();    
            sb_handle.run();         
            subscriber_handle.run(); 
        join_none 
        `ifdef DEBUG
                    $display("-------- IAM in the ENV and ENV DIED (there might be racing)--------");
        `endif
    endtask 
endclass //class_based_env extends superClass