pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Contract.sol";
import "./Company.sol";


contract Employee is Ownable {

    struct Work {
        Contract work;
        Company company;
    }

    struct Specializations {
      string profile;
      Skill[] skills;
    }

    struct Skill {
        string skill;
        uint raiting;
    }

    Contract[] public workHistory;
    Work[] public currentWorks;
    /* Specializations[] public skills; */

    uint public raiting;
    string private firstName;
    string private lastName;
    string private email;
    address private employeeAddress;

    modifier onlyOwnerOrEmployee() {
        require(msg.sender == owner || msg.sender == employeeAddress);
        _;
    }

    function Employee(string _firstName, string _lastName, string _email, uint _raiting, address _employee) public {
        firstName = _firstName;
        lastName = _lastName;
        email = _email;
        raiting = _raiting;
        employeeAddress = _employee;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function getSenderContract() public view returns (address) {
        for (uint i = 0; i < currentWorks.length; i++) {
            if (msg.sender == address(currentWorks[i].company))
                return address(currentWorks[i].work);
        }
        return 0;
    }

    function addWork(Contract work, Company company) public onlyOwner {
        workHistory.push(work);
        currentWorks.push(Work(work, company));
    }

    /* function getSpecializations() public view returns(Specializations[]) {
        return skills;
    } */

    function changeRaiting(uint newRaiting) public onlyOwner {
        raiting = newRaiting;
    }

    function dispute(address work) public onlyOwnerOrEmployee {
        for (uint i = 0; i < currentWorks.length; i++) {
            if (work == address(currentWorks[i].work)) {
                currentWorks[i].work.disputeStatusOn();
                return;
            }
        }
    }

    /* function fillSkils(string[] profiles, string[] skillNames, uint[] skillRaitings, uint[] counts) public onlyOwner {
        uint counter = 0;

        for (uint i = 0; i < currentWorks.length; i++) {
            Skill[] memory _skills = new Skill[](counts[i]);
            for (uint j = 0; j < counts[i]; j++) {
                _skills[j] = Skill(skillNames[j + counter], skillRaitings[j + counter]);
                counter++;
            }
             skills.push(Specializations(profiles[i], _skills)); 
        }
    } */
}
