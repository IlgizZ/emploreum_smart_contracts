pragma solidity ^0.4.11;


contract Main {

    address[] employees;
    address[] companies;
    address[] works;

    function Main(uint256 _amount) public {
        owner = msg.sender;
        mint(owner, _amount);
    }

    function showOwner() public view returns (address ownerAddr) {
        return owner;
    }
}
