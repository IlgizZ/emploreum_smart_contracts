pragma solidity ^0.4.11;


contract Employee {

    address[] workHistory;
    string firstName;
    string lastName;
    uint raiting;

    function Employee(uint256 _amount) public {
        owner = msg.sender;
        mint(owner, _amount);
    }

    function showOwner() public view returns (address ownerAddr) {
        return owner;
    }
}
