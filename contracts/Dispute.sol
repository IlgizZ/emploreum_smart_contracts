pragma solidity ^0.4.11;
import "./Work.sol";


contract Dispute {

    address private employee;
    address private company;
    Work private work;
    uint private employeeVotes;
    uint private companyVotes;
    mapping(address => bool) private voters;

    function Dispute (
        address _employee,
        address _company
    )
        public
        payable
    {
        employee = _employee;
        company = _company;
        work = Work(msg.sender);
    }

    function () public payable {}

    function vote(address candidate, address sender) public {
        require(msg.sender == work.getOwner());
        require(!voters[sender] && (employee == candidate || company == candidate));
        require(employeeVotes + companyVotes <= 100);
        voters[sender] = true;

        if (candidate == employee) {
            employeeVotes++;
        } else {
            companyVotes++;
        }

        if (employeeVotes + companyVotes == 101) {
            solveDispute();
        }
    }

    function solveDispute() private {
        address winner = employee;
        if (employeeVotes < companyVotes) {
            winner = company;
        }
        require(work.solveDispute(winner));
    }
}
