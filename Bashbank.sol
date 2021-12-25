

contract Bank {

    mapping(address=>uint) account_balances;


    //methods
    //get_balance() view
    //withdraw1 function(amount)
    //transfer: function(address,amount
    //depositing; receive()


    function get_balance() external view virtual returns(uint) {
        return account_balances[msg.sender];
    }
    
    function transfer(address recipient, uint amount) virtual public {
    
    //require(account_balance[msg.sender]>=amount, "NSF");

    account_balances[msg.sender] -= amount;
    account_balances[recipient] +=amount;
}

    function withdraw1(uint amount) virtual public {

        account_balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

    }

    receive () external payable {
        account_balances[msg.sender] += msg.value;
    }
}


contract BashBank is Bank {

    uint number_of_accounts;

    mapping(address=>uint) account_info_map;

    struct BankAccountRecord {
        uint account_number;
        string fullName;
        string profession;
        string dateOfBirth;
        address wallet_addr;
        string customer_addr;

    }

    BankAccountRecord[] bankAccountRecords;


    function register_account(
            string memory fullName_,
            string memory profession_,
            string memory dateOfBirth_,
            string memory customer_addr_) external {
        
        require(account_info_map[msg.sender] == 0,"Account already registered");

        bankAccountRecords.push(
                BankAccountRecord({
                    account_number:++number_of_accounts,
                    fullName:fullName_,
                    profession:profession_,
                    dateOfBirth:dateOfBirth_,
                    wallet_addr:msg.sender,
                    customer_addr:customer_addr_
                }));
        
        account_info_map[msg.sender] = number_of_accounts;
    }
    
     modifier OnlyRegistered() {
        require(account_info_map[msg.sender] > 0 , "User not Register, please register to use this method.");
        _;
     }

    function get_balance() external view OnlyRegistered override returns(uint) {
        return account_balances[msg.sender];
    }
    
    function transfer(address recipient, uint amount) public override OnlyRegistered {
    
    //require(account_balance[msg.sender]>=amount, "NSF");

    account_balances[msg.sender] -= amount;
    account_balances[recipient] +=amount;
}

    function withdraw1(uint amount) public override OnlyRegistered {

        account_balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

    }

}
