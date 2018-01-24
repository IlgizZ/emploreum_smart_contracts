pragma solidity ^0.4.11;


contract Company {

    address[] employees;
    string name;
    uint raiting;

    function Company(uint256 _amount) public {
        owner = msg.sender;
        mint(owner, _amount);
    }

    function showOwner() public view returns (address ownerAddr) {
        return owner;
    }
}
