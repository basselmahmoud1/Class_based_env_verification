class class_based_transaction ;
    rand bit [31:0] data_in ;
    logic [31:0] data_out;
    rand bit [3:0] addr;
    rand bit EN , RW , rst;
    logic valid_out;
    
    // Reset mostly inactive
    constraint c_rst {
        rst dist {0:=90 , 1:=10};
    }
    
    // Enable mostly active
    constraint c_EN {
        EN dist {1:=90 , 0:=10};
    }
    
    // Corner case data values
    constraint c_data_in{
        data_in dist {
            0 := 25,
            32'hFFFFFFFF := 25,
            32'h80000000 := 25,
            32'h7FFFFFFF := 25
        };
    }
    
    // Balanced read/write
    constraint c_RW {
       soft RW dist {0:=50 , 1:=50};
    }
    
    // Simple display function
    function void display(string prefix = "");
        $display("%s Time=%0t | addr=0x%0h | data_in=0x%08h | EN=%b | RW=%s | rst=%b", 
                 prefix, $time, addr, data_in, EN, (RW ? "WR" : "RD"), rst);
    endfunction
    
endclass //class_based_transaction