pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Work.sol";


contract Employee is Ownable {

    struct EmployeeWork {
        address work;
        address company;
        bool isFinish;
    }

    struct Skill {
        uint skillCode;
        uint rating;
    }

    struct TestRaiting {
        uint testCode;
        uint rating;
    }

    EmployeeWork[] public workHistory;
    uint public bonusRating;
    Skill[] public skills;
    TestRaiting[] public passedTests;

    string private firstName;
    string private lastName;
    string private email;
    address private employeeAddress;

    modifier onlyOwnerOrEmployee() {
        require(msg.sender == owner || msg.sender == employeeAddress);
        _;
    }

    function Employee(string _firstName, string _lastName, string _email, address _employee) public {
        firstName = _firstName;
        lastName = _lastName;
        email = _email;
        employeeAddress = _employee;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function getSenderWorkCount() public view returns (uint result) {
        for (uint i = 0; i < workHistory.length; i++) {
            if (msg.sender == address(workHistory[i].company))
                result++;
        }
        return result;
    }

    function getFirstWorkFrom(uint from) public view returns (int, address company) {

        for (uint i = from; i < workHistory.length; i++) {
            if (msg.sender == address(workHistory[i].company))
                return (int(i), company);
        }
        return (-1, company);
    }

    function addWork(address work, address company) public onlyOwner {
        for (uint i = 0; i < workHistory.length; i++) {
            if (work == workHistory[i].work) {
                revert();
            }
        }
        workHistory.push(EmployeeWork(work, company, false));
    }

    function finishWork(address work) public onlyOwner {
        for (uint i = 0; i < workHistory.length; i++) {
            if (work == workHistory[i].work) {
                workHistory[i].isFinish = true;
                return;
            }
        }
    }

    function changeEmployeeAddress(address _employeeAddress) public onlyOwnerOrEmployee {
        employeeAddress = _employeeAddress;
    }

    function changeBonusRaiting(uint newRaiting) public onlyOwner {
        bonusRating = newRaiting;
    }

    //assume the skillCode is correct skill code
    function changeSkillRaiting(uint skillCode, uint newRaiting) public onlyOwner {
        for (uint index = 0; index < skills.length; index++) {
            if (skills[index].skillCode == skillCode) {
                skills[index].rating = newRaiting;
                return;
            }
        }

        skills.push(Skill(skillCode, newRaiting));
    }

    //assume the skillCode is correct skill code
    function changeTestRaiting(uint testCode, uint newRaiting) public onlyOwner {
        for (uint index = 0; index < passedTests.length; index++) {
            if (passedTests[index].testCode == testCode) {
                passedTests[index].rating = newRaiting;
                return;
            }
        }

        skills.push(Skill(testCode, newRaiting));
    }

    function calculateRaiting() public view returns (uint result) {
        for (uint i = 0; i < skills.length; i++) {
            result += skills[i].rating;
        }

        for (i = 0; i < passedTests.length; i++) {
            result += passedTests[i].rating;
        }

        result += bonusRating;
    }

    function dispute(Work work) public onlyOwnerOrEmployee {
        for (uint i = 0; i < workHistory.length; i++) {
            if (address(work) == workHistory[i].work) {
                work.disputeStatusOn();
                workHistory[i].isFinish = true;
                return;
            }
        }
    }
}
