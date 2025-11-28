class class_based_subscriber extends class_base;
    class_based_transaction subscriber_transc;
    mailbox #(class_based_transaction) mon2subSb_mb; 
    
    // Simple coverage group
    covergroup transaction_cg;
        cp_address: coverpoint subscriber_transc.addr {
            bins low = {[0:7]};
            bins high = {[8:15]};
        }
        
        cp_data: coverpoint subscriber_transc.data_in {
            bins zero = {0};
            bins all_ones = {32'hFFFFFFFF};
            bins min_neg = {32'h80000000};
            bins max_pos = {32'h7FFFFFFF};
        }
        
        cp_EN: coverpoint subscriber_transc.EN;
        cp_RW: coverpoint subscriber_transc.RW;
        cp_rst: coverpoint subscriber_transc.rst;
        
        // Cross coverage
        cross_addr_rw: cross cp_address, cp_RW;
        cross_data_rw: cross cp_data, cp_RW;
    endgroup
    
    function new();
        subscriber_transc = new();
        mon2subSb_mb = new(1);
        transaction_cg = new();
    endfunction 
    
    task recieve_transc(output class_based_transaction transc);
        `ifdef DEBUG
            $display("[%0t] [SUBSCRIBER] Waiting for transaction", $time);
        `endif 
        mon2subSb_mb.get(transc);
    endtask
    
    // Display coverage report
    function void display_coverage();
        $display("\n========== COVERAGE REPORT ==========");
        $display("Total Coverage: %.2f%%", transaction_cg.get_coverage());
        $display("=====================================\n");
    endfunction
    
    task run();
        forever begin 
            recieve_transc(subscriber_transc);
            
            `ifdef DEBUG
                subscriber_transc.display("[SUBSCRIBER]");
            `endif 
            
            transaction_cg.sample();
        end
    endtask
endclass