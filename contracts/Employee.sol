pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Employee is Ownable {

    address[] workHistory;
    uint raiting;
    string firstName;
    string lastName;

    function Employee(string _firstName, string _lastName) public {
        firstName = _firstName;
        lastName = _lastName;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function addWork(address work) public onlyOwner {
        workHistory.push(work);
    }
}
