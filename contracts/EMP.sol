pragma solidity ^0.4.11;


contract EMP {

    string public name = "Emploreym";
    string public symbol = "EMP";
    uint public decimals = 18;
    uint public amount;
    address owner;

    function EMP(uint256 _amount) public {
        owner = msg.sender;
        amount = _amount;
    }

    function showOwner() public view returns (address ownerAddr) {
        return owner;
    }
}
