pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/math/SafeMath.sol";


contract Work {
    using SafeMath for uint;

    string private position;
    uint private startDate;
    uint private endDate;
    uint private weekPayment;
    address private employee;
    address private company;
    address private owner;

    modifier onlyOwnerOrCompany() {
        require(msg.sender == owner || msg.sender == company);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function Work (
      string _position,
      uint _startDate,
      uint _endDate,
      address _empoloyee,
      address _company,
      uint _weekPayment
    ) public {
        weekPayment = _weekPayment;
        position = _position;
        startDate = _startDate;
        endDate = _endDate;
        employee = _empoloyee;
        company = _company;
        owner = msg.sender;
    }
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function sendWeekSalary() public onlyOwnerOrCompany payable returns (int8) {
        require((now - startDate) % 7 < 1 days);
        if (this.balance < weekPayment)
            return -1;

        employee.transfer(weekPayment);

        if (this.balance < 2 * weekPayment)
            return 1;
        return 0;
    }

    function getWorkData () public view returns (string, uint, uint, address, address) {
        return (position, startDate, endDate, employee, company);
    }
}
