pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Employee.sol";
import "./Company.sol";


contract Contract is Ownable {
    using SafeMath for uint;

    uint[] private positionCodes;
    uint[] private skillCodes;

    uint private startDate;
    uint private endDate;
    Employee private employee;
    Company private company;
    uint private weekPayment;
    address private owner;
    bool private disputeStatus;
    /*
      frizzing time
        [0; 6]      range of freezing delay

        -1          freezing - not enought money for next week payment

        -200        contract ended

        -500        contract ended with disput
    */
    int private frizzing;

    event WeekPaymentSent(int code);

    function Contract (uint[] _positionCodes, uint[] _skillCodes,
                            uint _startDate, uint _endDate, Employee _empoloyee,
                            Company _company, uint _weekPayment) public payable {

        require(msg.value >= _weekPayment);
        require(_startDate >= now);
        require(_endDate > _startDate);

        disputeStatus = false;
        owner = msg.sender;

        weekPayment = _weekPayment;
        positionCodes = _positionCodes;
        skillCodes = _skillCodes;
        startDate = _startDate;
        endDate = _endDate;
        employee = _empoloyee;
        company = _company;
    }

    modifier onlyOwnerOrCompany() {
        require(msg.sender == owner || msg.sender == address(company));
        _;
    }

    modifier onlyEmployeeOrCompany() {
        require(msg.sender == owner || msg.sender == address(employee));
        _;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function deposite() public payable {
        require(frizzing >= -1);
    }

    /*
        return status:
            -1  no enough money yo week payment
            1   no enough money for next week payment
            0   ok, all right
    */
    function sendWeekSalary() public onlyOwnerOrCompany payable {
        require(frizzing >= 0);
        require((now - startDate + uint(frizzing)) % 7 < 1 days);
        require(!disputeStatus);

        int code;

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

    function solveFrizzing() public payable {
        require(msg.value > weekPayment);
        require(frizzing == -1);
        frizzing = int(((now - startDate) / 1 days + 1 days) % 7);
    }

    function disputeStatusOn() public onlyEmployeeOrCompany {
        disputeStatus = true;
    }

    function solveDisput(address winner) public onlyOwner {
        require(winner == address(employee) || winner == address(company));
        require(disputeStatus);

        frizzing = -500;

        if (winner == address(employee))
            employee.transfer(weekPayment);

        /* selfdestruct(company); */
    }

    function finish() public onlyOwner {
        frizzing = -200;
    }

    function getWorkData () public view
        returns (uint[], uint[], uint, uint, Employee, Company, uint, address, bool, int) {

            return (positionCodes, skillCodes,
                    startDate, endDate, employee, company, weekPayment, owner, disputeStatus, frizzing);
    }

    function contractStatus() public view returns(int) {
        return frizzing;
    }

}
