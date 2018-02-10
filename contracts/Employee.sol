pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Contract.sol";
import "./Company.sol";


contract Employee is Ownable {

    struct Work {
        Contract work;
        Company company;
    }

    struct Skill {
        uint specializationId;
        bytes32[] skill;
        uint raiting;
    }

    Contract[] public workHistory;
    Work[] public currentWorks;
    uint public raiting;
    uint[] public positionCodes;
    uint[] public skillCodes;
    mapping (uint => uint) private skillToPosition;

    string private firstName;
    string private lastName;
    string private email;
    address private employeeAddress;

    modifier onlyOwnerOrEmployee() {
        require(msg.sender == owner || msg.sender == employeeAddress);
        _;
    }

    function Employee(string _firstName, string _lastName, string _email, uint _raiting, address _employee,
      uint[] _positionCodes, uint[] _skillCodes, uint[] _skillToPosition) public {
        firstName = _firstName;
        lastName = _lastName;
        email = _email;
        raiting = _raiting;
        employeeAddress = _employee;
        positionCodes = _positionCodes;
        skillCodes = _skillCodes;

        for (uint i = 0; i < _skillToPosition.length; i++) {
            skillToPosition[skillCodes[i]] = _skillToPosition[i];
        }
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


}
