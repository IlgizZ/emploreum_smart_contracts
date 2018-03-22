pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Work.sol";
import "./Company.sol";


contract Employee is Ownable {

    using Math for uint256;

    struct EmployeeWork {
        address work;
        address company;
        bool isFinish;
    }

    struct Skill {
        uint skillCode;
        uint rating;
    }

    struct TestRating {
        uint testCode;
        uint rating;
    }

    EmployeeWork[] public workHistory;
    uint public bonusRating;
    Skill[] public skills;
    TestRating[] public passedTests;

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

    function changeBonusRating(uint addRating) public onlyOwner {
        bonusRating += addRating;
    }

    //assume the skillCode is correct skill code
    function changeTestRating(uint testCode, uint addRating) public onlyOwner {
        for (uint index = 0; index < passedTests.length; index++) {
            if (passedTests[index].testCode == testCode) {
                passedTests[index].rating += addRating;
                return;
            }
        }

        passedTests.push(TestRating(testCode, addRating));
    }

    function calculateRating() public view returns (uint result) {
        for (uint i = 0; i < skills.length; i++) {
            result += skills[i].rating;
        }

        for (i = 0; i < passedTests.length; i++) {
            result += passedTests[i].rating;
        }

        result += bonusRating;
    }

    function getSkills() public view returns (Skill[]) {
        return skills;
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

    function addSkillRatingForWork(address work, uint hoursWorked, uint skillCode) public onlyOwner {
        bool found;
        for (uint i = 0; i < workHistory.length; i++) {
            if (work == workHistory[i].work && !workHistory[i].isFinish) {
                found = true;
                break;
            }
        }

        if (!found)
            revert();

        uint skillIndex = skills.length;
        while (skillIndex < skills.length && skills[skillIndex].skillCode != skillCode) {
            skillIndex++;
        }
        if (skillIndex == skills.length) {
            skills.push(Skill(skillCode, 0));
        }

        uint rating = calculateRatingToAdd(company, hoursWorked, skills[skillIndex].rating);
        changeSkillRating(skillCode, rating);
    }

    function calculateRatingToAdd(Company company,
                                    uint hoursWorked,
                                    uint currentSkillRating
    ) private pure returns (uint result) {
        uint e =  2718281;
        uint n = 1000000;
        uint currentExp = n;
        result = company.getRaiting().sqrt() * hoursWorked / 40 / 4;

        //find current expiriance
        uint root = 8;
        while (currentSkillRating % 2 == 0 && root > 0) {
            currentSkillRating /= 2;
            root--;
        }

        for (uint i = 0; i < currentSkillRating; i++) {
            currentExp *= e;
            currentExp /= n;
        }

        currentExp *= n;

        while (root > 0) {
            currentExp *= n;
            currentExp = currentExp.sqrt();
            root--;
        }

        currentExp *= 80372147;
        currentExp /= n;
        currentExp -= 80 * n;

        result += currentExp;
        result = result / 4 + 20;
        result = result.log();
        result = (result - 3) * 256;

    }

    //assume the skillCode is correct skill code
    function changeSkillRating(uint skillCode, uint addRating) private {
        for (uint index = 0; index < skills.length; index++) {
            if (skills[index].skillCode == skillCode) {
                skills[index].rating += addRating;
                return;
            }
        }

        skills.push(Skill(skillCode, addRating));
    }
}
