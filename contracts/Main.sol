pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Main is Ownable {

    address[] private employees;
    address[] private companies;
    address[] private works;

    function Main() public {
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function addWork(address work) public onlyOwner {
        disputeStatus = true;
    }
}
