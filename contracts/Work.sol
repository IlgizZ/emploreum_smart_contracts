pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Employee.sol";
import "./Company.sol";

contract Work is Ownable {

    uint[] private skillCodes;

    uint private duration;
    uint private startDate;
    uint private hoursWorked;
    Employee private employee;
    Company private companyContractAddress;
    address private company;
    uint private weekPayment;
    bool private disputeStatus;
    /*
      frizzing time
        [0; 6]      range of freezing delay

        -1          freezing - not enought money for next week payment

        -100        contract not start

        -200        contract ended

        -500        contract ended with disput
    */
    int private frizzing;

    event WeekPaymentSent(int code);

    function Work (
        uint[] _skillCodes,
        uint _duration,
        Employee _empoloyee,
        address _company,
        Company _companyContractAddress,
        uint _weekPayment
    )
        public
        payable
    {
        require(_duration > 0);

        skillCodes = _skillCodes;
        duration = _duration;
        employee = _empoloyee;
        company = _company;
        companyContractAddress = _companyContractAddress;
        weekPayment = _weekPayment;
        frizzing = -100;
    }

    modifier onlyOwnerOrCompany() {
        require(msg.sender == owner || msg.sender == company);
        _;
    }

    modifier onlyEmployeeOrCompany() {
        require(msg.sender == company || msg.sender == address(employee));
        _;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function deposit() public payable {
        require(frizzing >= -1);
    }

    /*
        return status:
            -1  no enough money yo week payment
            1   no enough money for next week payment
            0   ok, all right
    */
    function sendWeekSalary(uint _hours) public onlyOwnerOrCompany payable {
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

        hoursWorked += _hours;

        for (uint i = 0; i < skillCodes.length; i++) {
            employee.addSkillRatingForWork(this, _hours, skillCodes[i]);
        }
        companyContractAddress.changeRating();

        WeekPaymentSent(code);
    }

    function solveFrizzing() public payable {
        require(msg.value >= weekPayment);
        require(frizzing == -1);
        frizzing = int(((now - startDate) / 1 days + 1 days) % 7);
    }

    function disputeStatusOn() public onlyEmployeeOrCompany {
        disputeStatus = true;
    }

    function solveDispute(address winner) public onlyOwner {
        require(winner == address(employee) || winner == company);
        require(disputeStatus);

        frizzing = -500;

        if (winner == address(employee))
            winner.transfer(weekPayment);

        company.transfer(this.balance);
        /* selfdestruct(company); */
    }

    function start() public payable onlyOwner() {
        require(frizzing == -100);
        require(msg.value >= weekPayment);
        /* frizzing = int(((now - startDate) / 1 days + 1 days) % 7); */
        startDate = now;
        frizzing = 0;
        employee.addWork(this, companyContractAddress);
        companyContractAddress.addWork(this);
    }

    function finish() public onlyOwner {
        frizzing = -200;
    }

    function test2() public onlyOwner view returns(address) {
        return employee.test2();
    }

    function getWorkData ()
        public
        view
        returns (
            uint[],
            uint,
            uint,
            Employee,
            address,
            uint,
            address,
            bool,
            int
        )
    {

        return (
            skillCodes,
            startDate,
            duration,
            employee,
            company,
            weekPayment,
            owner,
            disputeStatus,
            frizzing
        );
    }

    function getWorkedHours() public view returns(uint) {
        return hoursWorked;
    }

    function getWeekPayment() public view returns(uint) {
        return weekPayment;
    }

    function getEmployee() public view returns(address) {
        return employee;
    }

    function getCompanyContractAddress() public view returns(address) {
        return companyContractAddress;
    }

    function getDisputeStatus() public view returns(bool) {
        return disputeStatus;
    }

    function hasSkill(uint skillCode) public view returns(bool) {
        for (uint i = 0; i < skillCodes.length; i++) {
            if (skillCodes[i] == skillCode)
                return true;
        }
        return false;
    }

    // R(empl) I
    function getCompanyWorkRating() public view returns(int result) {
        for (uint i = 0; i < skillCodes.length; i++) {
            result += int(employee.getSkillRatingBySkillCode(skillCodes[i]));
        }
        result *= int(hoursWorked);
        result /= int(skillCodes.length);
    }

    function getContractStatus() public view returns(int) {
        return frizzing;
    }

}
