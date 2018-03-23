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

    function getWorks() public view returns (Work) {
        return workHistory[0].work;
    }

    function getSenderWorkCount() public view returns (uint result) {
        for (uint i = 0; i < workHistory.length; i++) {
            if (msg.sender == address(workHistory[i].company))
                result++;
        }
        return result;
    }

    function getFirstWorkFrom(uint from) public view returns (int, Company company) {
        for (uint i = from; i < workHistory.length; i++) {
            if (msg.sender == address(workHistory[i].company))
                return (int(i), workHistory[i].company);
        }
        return (-1, company);
    }

    function addWork(Work work, Company company) public onlyOwner {
        for (uint i = 0; i < workHistory.length; i++) {
            if (work == workHistory[i].work) {
                revert();
            }
        }
        workHistory.push(EmployeeWork(work, company, false));
    }

    function finishWork(Work work) public onlyOwner {
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

    function changeBonusRating(uint skillCode, uint addRating) public onlyOwner {
        int index = getSkillBySkillCode(skillCode);
        assert(index > 0);
        skills[uint(index)].bonusRating += addRating;
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

    function getSkillRatingBySkillCode(uint skillCode) public view returns (uint ) {
        uint result = 9999999999;

        for (uint index = 0; index < skills.length; index++) {
            if (skills[index].skillCode == skillCode) {
                result = skills[index].rating;
                result += skills[index].bonusRating;
                break;
            }
        }

        assert(result != 9999999999);

        for (index = 0; index < skills.length; index++) {
            if (passedTests[index].skillCode == skillCode) {
                result += passedTests[index].rating;
                break;
            }
        }

        return result;
    }

    function getSkills() public view returns (Skill[]) {
        return skills;
    }

    function getTests() public view returns (TestRating[]) {
        return passedTests;
    }

    function dispute(Work work) public onlyOwnerOrEmployee returns(bool) {
        for (uint i = 0; i < workHistory.length; i++) {
            if (work == workHistory[i].work) {
                work.disputeStatusOn();
                workHistory[i].isFinish = true;
                return true;
            }
        }
        return false;
    }

    function addSkillRatingForWork(Work work, uint hoursWorked, uint skillCode) public onlyOwner {
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
            skills.push(Skill(skillCode, 0, 0));
        }

        uint rating = calculateRatingToAdd(Company(work.getCompany()), hoursWorked, skills[skillIndex].rating);
        changeSkillRating(skillCode, rating);
    }

    function calculateRatingToAdd(Company company,
                                    uint hoursWorked,
                                    uint currentSkillRating
    ) private view returns (uint result) {
        uint e =  2718281;
        uint n = 1000000;
        uint currentExp = n;
        int companyRating = company.getRating();

        if (companyRating < 0)
            revert();
        result = uint(companyRating).sqrt() * hoursWorked / 40 / 4;

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

    function getSkillBySkillCode(uint skillCode) private view returns (int) {
        for (uint index = 0; index < skills.length; index++) {
            if (skills[index].skillCode == skillCode) {
                return int(index);
            }
        }
        return -1;
    }

    //assume the skillCode is correct skill code
    function changeSkillRating(uint skillCode, uint addRating) private onlyOwner {
        int index = getSkillBySkillCode(skillCode);

        if (index > 0) {
            skills[uint(index)].rating += addRating;
        } else {
            skills.push(Skill(skillCode, addRating, 0));
        }
    }
}
