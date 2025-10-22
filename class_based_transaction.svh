class class_based_transaction ;
    rand bit [31:0] data_in ;
    logic [31:0] data_out;
    rand bit [3:0] addr;
    rand bit EN , RW , rst;
    logic valid_out;
    constraint c_rst {
        rst dist {0:=10 , 1:=90};
    }
    constraint c_data_in{
        data_in inside {0, 32'hFFFFFFFF, 32'h80000000, 32'h7FFFFFFF};
    }
    constraint c_RW {
        RW dist {0:=50 , 1:=50};
    }
endclass //className 