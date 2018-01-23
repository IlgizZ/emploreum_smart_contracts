pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/token/MintableToken.sol";
import "zeppelin-solidity/contracts/payment/PullPayment.sol";


contract JCR is MintableToken {

    string public name = "Jincor Token";
    string public symbol = "JCR";
    uint public decimals = 18;

    function JCR(uint256 _amount) public {
        owner = msg.sender;
        mint(owner, _amount);
    }

    function showOwner() public view returns (address ownerAddr) {
        return owner;
    }
}
