class class_based_driver extends class_base ; 

    local virtual MEM_IF driv_vif ; 
    // How to get the transaction since it have the data to be driven on the interface ? 
    // the answer is by using Mailbox 
    // instantiate mailbox
    mailbox #(class_based_transaction) seq2drv_mb;
    // instantiate  transaction 
    class_based_transaction driver_transc;
     
    string key ; 
    function new (string key = "");
        driver_transc = new();
        seq2drv_mb    = new(1);
        //   get_vif(key);
        this.key = key ; 
    endfunction

    task recieve_transc (output class_based_transaction transc);
        `ifdef DEBUG
            $display("-------- IAM in the Driver and going to Wait for the transaction --------");
        `endif 
            seq2drv_mb.get(transc);
        `ifdef DEBUG
            $display("-------- IAM in the Driver and recieved the transaction --------");
        `endif 
    endtask

    task body (); 
        // get the virtual interface 
        get_vif(key);
    endtask

    task get_vif (string key = "");
        `ifdef DEBUG
            $display("-------- IAM in the Driver and going to Get VIF --------");
        `endif 
            // As key reprenest the Key to get the vif
            if(key == "")
                $error("FAILD to get IF :Passing empty KEY to the DRIVER");
            else
                driv_vif = vif_associative[key];
            if(driv_vif == null)
                $error("FAILD to get IF :Passing null VIF to the driver");
        
        `ifdef DEBUG
            $display("-------- IAM in the Driver and GOT to Get VIF --------");
        `endif 
    endtask
    task run ();
        // Get the Vif 
        body();
        
        forever begin
            // get the new randomized data from the sequencer and begin to assign this data to the interface
            recieve_transc(driver_transc);
            `ifdef DEBUG
                $display("-------- IAM in the Driver and going to drive --------");
            `endif 
            // some sign to wait before driving the new data ("expected to be from scoreboard") 
                driv_vif.data_in   = driver_transc.data_in ;
                driv_vif.addr      = driver_transc.addr ;
                driv_vif.EN        = driver_transc.EN ;
                driv_vif.RW        = driver_transc.RW ;
                driv_vif.rst       = driver_transc.rst ;         
                @(negedge driv_vif.clk);
            `ifdef DEBUG
                $display("-------- IAM in the Driver and finished driving --------");
            `endif 
            // some sign to tell the monitor that the data have been driven succesfully so it can work now
            ->finished_driving ; 
        end
        `ifdef DEBUG
                    $display("-------- IAM in the Driver and Driver DIED (there might be racing)--------");
        `endif
    endtask  
endclass
    
    
    
    
    
    
    
    // task get_transaction_handle ();
    //     `ifdef DEBUG
    //         $display("-------- IAM in the Driver and going to get the new transaction handle --------");
    //     `endif 
        
    //     if(FIFO_trans_handle.size == 0)
    //         $error("FAILD to get Transaction :Passing Queue of size 0 to the driver");
    //     else 
    //         driver_transc = FIFO_trans_handle.pop_front();
    //     if(driver_transc == null)
    //         $error("FAILD to get Transaction :POPing transaction of null to the driver");
        
    //     `ifdef DEBUG
    //         $display("-------- IAM in the Driver and GOT the new transaction handle --------");
    //     `endif 
    // endtask