pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Work is Ownable {

    uint[] private skillCodes;

    uint private duration;
    uint private startDate;
    address private employee;
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
        address _empoloyee,
        address _company,
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
        weekPayment = _weekPayment;
        frizzing = -100;
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

    function deposit() public payable {
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
        require(msg.value >= weekPayment);
        require(frizzing == -1);
        frizzing = int(((now - startDate) / 1 days + 1 days) % 7);
    }

    function disputeStatusOn() public onlyEmployeeOrCompany {
        disputeStatus = true;
    }

    function solveDispute(address winner) public onlyOwner {
        require(winner == employee || winner == company);
        require(disputeStatus);

        frizzing = -500;

        if (winner == address(employee))
            employee.transfer(weekPayment);

        company.transfer(this.balance);
        /* selfdestruct(company); */
    }

    function start() public payable onlyOwnerOrCompany () {
        require(frizzing == -100);
        require(msg.value >= weekPayment);
        /* frizzing = int(((now - startDate) / 1 days + 1 days) % 7); */
        startDate = now;
        frizzing = 0;
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
            address,
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

    function getContractStatus() public view returns(int) {
        return frizzing;
    }

}
