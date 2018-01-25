pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Work is Ownable {
    using SafeMath for uint;

    string private position;
    uint private startDate;
    uint private endDate;
    address private employee;
    address private company;
    uint private weekPayment;
    address private owner;
    bool private disputeStatus;

    /*
      frizzing time
        can be int in range [0; 6]
          or
        -1 if there is not enought money
    */
    int8 private frizzing;

    event WeekPaymentSent(int8 code);

    function Work (string _position, uint _startDate, uint _endDate, address _empoloyee, address _company,
      uint _weekPayment) public payable {

        require(msg.value > _weekPayment);

        disputeStatus = false;
        owner = msg.sender;

        weekPayment = _weekPayment;
        position = _position;
        startDate = _startDate;
        endDate = _endDate;
        employee = _empoloyee;
        company = _company;
    }

    modifier onlyOwnerOrCompany() {
        require(msg.sender == owner || msg.sender == company);
        _;
    }

    modifier onlyEmployeeOrCompany() {
        require(msg.sender == owner || msg.sender == employee);
        _;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function solveFrizzing() public onlyOwnerOrCompany payable {
        require(msg.value > weekPayment);
        frizzing = int8((now - startDate) / 1 days % 7);
        require(frizzing > 0);
    }

    function solveDisput(address winner) public onlyOwner {
        require(winner == employee || winner == company);
        require(disputeStatus);

        if (winner == employee)
            employee.transfer(weekPayment);

        selfdestruct(company);
    }

    function disputeStatusOn() public onlyEmployeeOrCompany {
        disputeStatus = true;
    }

    /*
        return status:
            -1 there is no enough money
            1 there is no enough money for next week
            0 ok, all right
    */

    function sendWeekSalary() public onlyOwnerOrCompany payable {
        require(frizzing >= 0 && frizzing < 7);
        require((now - startDate + uint(frizzing)) % 7 < 1 days);
        require(!disputeStatus);

        int8 code;

        if (this.balance < weekPayment) {
            frizzing = -1;
            code = -1;
        } else {
            employee.transfer(weekPayment);

            if (this.balance < weekPayment)
                code = 1;
        }
        WeekPaymentSent(code);
    }

    function getWorkData () public view returns (string, uint, uint, address, address, uint, address, bool, int8) {
        return (position, startDate, endDate, employee, company, weekPayment, owner, disputeStatus, frizzing);
    }

}
