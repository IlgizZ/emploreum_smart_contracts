pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Main is Ownable {

    address[] private employees;
    address[] private companies;
    address[] private works;

    function Main() public {
    }

}
