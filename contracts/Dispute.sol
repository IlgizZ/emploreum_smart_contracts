pragma solidity ^0.4.11;
import "./Work.sol";


contract Dispute {

    address private employee;
    address private company;
    address private owner;
    Work private work;
    uint private employeeVotes;
    uint private companyVotes;
    mapping(address => bool) private voters;

    function Dispute (
        address _employee,
        address _company,
        address _owner
    )
        public
        payable
    {
        employee = _employee;
        company = _company;
        owner = _owner;
        work = Work(msg.sender);
    }

    function () public payable {

    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function vote(address winner, address sender) public onlyOwner {
        require(!voters[sender] && (employee == winner || company == winner));
        require(employeeVotes + companyVotes <= 100);
        voters[sender] = true;
        if (winner == employee) {
            employeeVotes++;
        } else {
            companyVotes++;
        }
        if (employeeVotes + companyVotes == 101) {
            solveDispute();
        }
    }

    function solveDispute() private {
        require(winner == employee || winner == company);
        address winner = employee;
        if (employeeVotes < companyVotes) {
            winner = company;
        }
        require(work.solveDispute(winner));
    }
}
