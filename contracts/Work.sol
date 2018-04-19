pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Employee.sol";
import "./Company.sol";
import "./Dispute.sol";


contract Work is Ownable {

    uint[] private skillCodes;

    uint private duration;
    uint private startDate;
    uint private hoursWorked;
    Employee private employeeContractAddress;
    address private employee;
    Company private companyContractAddress;
    address private company;
    uint private weekPayment;
    bool private disputeStatus;
    Dispute private dispute;
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
        address _employee,
        Employee _employeeContractAddress,
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
        employee = _employee;
        employeeContractAddress = _employeeContractAddress;
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
        require(msg.sender == company || msg.sender == employee);
        _;
    }

    modifier onlyDisput() {
        require(Dispute(msg.sender) == dispute);
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
            employeeContractAddress.addSkillRatingForWork(this, _hours, skillCodes[i]);
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
        dispute = new Dispute(employee, company, owner);
    }

    function solveDispute(address winner) public onlyDisput returns (bool) {
        require(winner == employee || winner == company);
        require(disputeStatus);

        frizzing = -500;

        if (winner == employee)
            winner.transfer(weekPayment);

        company.transfer(this.balance);
        return true;
    }

    function start() public payable onlyOwnerOrCompany() {
        require(frizzing == -100);
        require(msg.value >= weekPayment);
        /* frizzing = int(((now - startDate) / 1 days + 1 days) % 7); */
        startDate = now;
        frizzing = 0;
        employeeContractAddress.addWork(this, companyContractAddress);
        companyContractAddress.addWork(this);
    }

    function finish() public onlyOwner {
        frizzing = -200;
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
            int,
            uint,
            Company,
            address
        )
    {

        return (
            skillCodes,
            startDate,
            duration,
            employeeContractAddress,
            company,
            weekPayment,
            owner,
            disputeStatus,
            frizzing,
            hoursWorked,
            companyContractAddress,
            employee
        );
    }

    function getWorkedHours() public view returns(uint) {
        return hoursWorked;
    }

    function getWeekPayment() public view returns(uint) {
        return weekPayment;
    }

    function getEmployee() public view returns(address) {
        return employeeContractAddress;
    }

    function getCompanyContractAddress() public view returns(address) {
        return companyContractAddress;
    }

    function getDisputeStatus() public view returns(bool) {
        return disputeStatus;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getDispute() public view returns (address) {
        return dispute;
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
            result += int(employeeContractAddress.getSkillRatingBySkillCode(skillCodes[i]));
        }
        result *= int(hoursWorked);
        result /= int(skillCodes.length);
    }

    function getContractStatus() public view returns(int) {
        return frizzing;
    }

}
