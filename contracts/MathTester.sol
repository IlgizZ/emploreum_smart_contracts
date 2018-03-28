pragma solidity ^0.4.11;
import "./Math.sol";


contract MathTester {

    using Math for uint256;

    function sqrt(uint x) public pure returns (uint) {
        return x.sqrt();
    }

    function log(uint x) public pure returns (uint) {
        return x.log();
    }

    function exp(uint x) public pure returns (uint) {
        return x.exp();
    }

}
