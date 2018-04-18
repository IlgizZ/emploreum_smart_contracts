pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Work.sol";
import "./Company.sol";
import "./Math.sol";


contract Employee is Ownable {

    using Math for uint256;

    struct EmployeeWork {
        Work work;
        Company company;
        bool isFinish;
    }

    struct Skill {
        uint skillCode;
        uint rating;
        uint bonusRating;
    }

    struct TestRating {
        uint testCode;
        uint skillCode;
        uint rating;
    }

    EmployeeWork[] public workHistory;
    Skill[] public skills;
    TestRating[] public passedTests;

    string private firstName;
    string private lastName;
    string private email;
    address private employeeAddress;

    // code 0 - desput status was set
    // code 1 - work not found
    event TurnOnDisputeStatuse(address work, int code);

    modifier onlyOwnerOrEmployee() {
        require(msg.sender == owner || msg.sender == employeeAddress);
        _;
    }

    modifier onlyWork() {
        Work work = Work(msg.sender);
        //check in store
        bool isInStore = true;
        require(work.getEmployee() == address(this) && isInStore);
        _;
    }

    function Employee(string _firstName, string _lastName, string _email, address _employee) public {
        firstName = _firstName;
        lastName = _lastName;
        email = _email;
        employeeAddress = _employee;
    }

    function () public payable {

    }

    function changeEmployeeAddress(address _employeeAddress) public onlyOwnerOrEmployee {
        employeeAddress = _employeeAddress;
    }

    function addWork(Work work, Company company) public onlyWork {
        for (uint i = 0; i < workHistory.length; i++) {
            if (work == workHistory[i].work) {
                revert();
            }
        }
        workHistory.push(EmployeeWork(work, company, false));
    }

    function getWorks() public view returns (Work[]) {
        Work[] memory  works = new Work[](workHistory.length);
        for (uint i = 0; i < workHistory.length; i++) {
            works[i] = workHistory[i].work;
        }
        return works;
    }

    function finishWork(Work work) public onlyOwner {
        for (uint i = 0; i < workHistory.length; i++) {
            if (work == workHistory[i].work) {
                workHistory[i].isFinish = true;
                return;
            }
        }
    }

    function dispute(Work work) public onlyOwnerOrEmployee {
        int code = 1;
        for (uint i = 0; i < workHistory.length; i++) {
            if (work == workHistory[i].work) {
                work.disputeStatusOn();
                workHistory[i].isFinish = true;
                code = 0;
                break;
            }
        }
        TurnOnDisputeStatuse(work, code);
    }

    function changeBonusRating(uint skillCode, uint addRating) public onlyOwner {
        for (uint index = 0; index < skills.length; index++) {
            if (skills[index].skillCode == skillCode) {
                break;
            }
        }
        assert(index == skills.length);
        skills[index].bonusRating += addRating;
    }

    //assume the skillCode is correct skill code
    function changeTestRating(uint testCode, uint addRating, uint skillCode) public onlyOwner {
        for (uint index = 0; index < passedTests.length; index++) {
            if (passedTests[index].testCode == testCode && passedTests[index].skillCode == skillCode) {
                passedTests[index].rating += addRating;
                return;
            }
        }

        passedTests.push(TestRating(testCode, addRating, skillCode));
    }

    function getSkills() public view returns (uint[] result) {
        result = new uint[](skills.length);
        for (uint i = 0; i < skills.length; i++) {
            result[i] = skills[i].skillCode;
        }
    }

    function getSkillHistory(uint skillCode) public view returns(address[]) {
        address[] memory result = new address[](workHistory.length);
        for (uint i = 0; i < workHistory.length; i++) {
            if (workHistory[i].work.hasSkill(skillCode)) {
                result[i] = (workHistory[i].work);
            }
        }
        return result;
    }

    function getSkillRatingBySkillCode(uint skillCode) public view returns (uint) {
        uint result;

        for (uint skillIndex = 0; skillIndex < skills.length; skillIndex++) {
            if (skills[skillIndex].skillCode == skillCode) {
                result = skills[skillIndex].rating;
                result += skills[skillIndex].bonusRating;
                break;
            }
        }

        for (uint testIndex = 0; testIndex < passedTests.length; testIndex++) {
            if (passedTests[testIndex].skillCode == skillCode) {
                result += passedTests[testIndex].rating;
                break;
            }
        }

        if (skillIndex == skills.length && testIndex == passedTests.length)
            revert();

        return result;
    }

    function addSkillRatingForWork(Work work, uint hoursWorked, uint skillCode) public onlyWork {
        bool found;
        for (uint i = 0; i < workHistory.length; i++) {
            if (work == workHistory[i].work && !workHistory[i].isFinish) {
                found = true;
                break;
            }
        }

        if (!found)
            revert();


        uint skillIndex;
        while (skillIndex < skills.length && skills[skillIndex].skillCode != skillCode) {
            skillIndex++;
        }

        bool isNewSkill = skillIndex == skills.length;

        uint currentSkillRating = isNewSkill ? 0 : skills[skillIndex].rating;
        uint newRating = calculateRatingToAdd(
            Company(work.getCompanyContractAddress()), hoursWorked, currentSkillRating
        );

        if (isNewSkill) {
            skills.push(Skill(skillCode, newRating, 0));
        } else {
            skills[skillIndex].rating = newRating;
        }
    }

    function calculateRatingToAdd(Company company,
                                    uint hoursWorked,
                                    uint currentSkillRating
    ) private view returns (uint result) {
        uint n = 1000000;
        int companyRating = company.getRating();

        if (companyRating < 0)
            revert();

        //new income expiriance
        result = uint(companyRating).sqrt() * hoursWorked / 80; // 40 * 2

        //find current expiriance
        uint currentExp = currentSkillRating / 256;
        currentExp = currentExp.exp();

        currentExp *= 80342147;
        currentExp /= n;
        currentExp -= 80 * n;

        result += currentExp;
        result = result / 4 + 20 * n;
        result = result.log();
        result = (result - 3 * n) * 256;
    }
}
