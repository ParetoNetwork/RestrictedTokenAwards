pragma solidity ^0.4.25;

import "../installed_contracts/oraclize-api/contracts/usingOraclize.sol";

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
        assert(token.transfer(to, value));
    }

    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
        assert(token.transferFrom(from, to, value));
    }

    function safeApprove(ERC20 token, address spender, uint256 value) internal {
        assert(token.approve(spender, value));
    }
}

/**
 * @title RTU
 * @dev RTU is a token holder contract that will monthly send token to the beneficiary
 */
contract RTU is usingOraclize {
    using SafeERC20 for ERC20Basic;
    using SafeMath for uint256;

    // ERC20 basic token contract being held
    ERC20Basic public token;

    // beneficiary of tokens after they are released
    address public beneficiary;

    address public owner;
    
    uint public token_amount = 0;

    bool[] public months;

    uint public total_months = 0;
    
    uint public current_month = 0;
  
    enum Status {
        OPEN,
        CANCELLED
    }
    
    Status public currentStatus;


    /// @param _beneficiary is the address which will be receiving the vesting tokens
    constructor(address _token, address _beneficiary, uint _noOfMonths) public payable{
        token = ERC20Basic(_token);
        beneficiary = _beneficiary;
        owner = msg.sender;
        currentStatus = Status.OPEN;
        total_months = _noOfMonths;
        months.length = _noOfMonths;
        init();
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    event OwnerChanged(address newOwner);
  
    /// @param _newOwner is the address which will be set as the new owner of this RTU contract
    function changeOwner(address _newOwner) public onlyOwner{
        require(_newOwner != 0x0);
        owner = _newOwner;
        
        emit OwnerChanged(_newOwner);
    }
    
    event BeneficiaryChanged(address newBeneficiary);
    
    /// @param _beneficiary is the address which will be set as the new beneficiary of this RTU contract
    function changeBeneficiary(address _beneficiary) public onlyOwner{
        require(_beneficiary != 0x0);
        beneficiary = _beneficiary;
        
        emit BeneficiaryChanged(_beneficiary);
    }
    
    event CancelledAndWithdrawn(address owner, uint balance);
    
        /// @notice this funnction cancel the RTU and withdraw all the non vested tokens to the owner
    function cancelAndWithdraw() public onlyOwner{
        currentStatus = Status.CANCELLED;
        
        uint balance = token.balanceOf(address(this));
        token.safeTransfer(owner, balance);
        
        emit CancelledAndWithdrawn(owner, balance);
    }
  
    function init() internal{
        oraclize_query(60, "URL", "");
    }
    
    event Released(address beneficiary, uint amount, uint month);
  
    /// @notice this function called by the oraclize contract
    function __callback(bytes32 myid, string result) public {
        if (msg.sender != oraclize_cbAddress()) revert();

        require(currentStatus == Status.OPEN);

        if(months[current_month] != true){
                
            if(token_amount == 0){
                    
                uint256 amount = token.balanceOf(address(this));
                require(amount > 0);
                    
                token_amount = amount.div(total_months);

            }
            
            token.safeTransfer(beneficiary, token_amount);

            months[current_month] = true;

            emit Released(beneficiary, token_amount, current_month+1);
        } 
        
        current_month = current_month.add(1);
       
        // enable scheduler for the next month
        if(token.balanceOf(address(this)) >= token_amount){
            oraclize_query(60, "URL", "");
        }

    }

    function makeManualPayment(uint _month) public onlyOwner{
        require(currentStatus == Status.OPEN);
                
        require(months[_month - 1] == false);
        
        if(token_amount == 0){
                    
            uint256 amount = token.balanceOf(address(this));
            require(amount > 0);
                    
            token_amount = amount.div(total_months);

        }
            
        token.safeTransfer(beneficiary, token_amount);

        months[_month - 1] = true;

        emit Released(beneficiary, token_amount, _month);
                
    }
    
    //fallback
    function() public payable{
        
    }


}