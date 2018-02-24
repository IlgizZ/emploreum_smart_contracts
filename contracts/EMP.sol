pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/token/MintableToken.sol";
import "zeppelin-solidity/contracts/payment/PullPayment.sol";


contract EMP {

    string public name = "Emploreym";
    string public symbol = "EMP";
    uint public decimals = 18;
    address owner;

    function EMP(uint256 _amount) public {
        owner = msg.sender;
    }

    function showOwner() public view returns (address ownerAddr) {
        return owner;
    }
}
