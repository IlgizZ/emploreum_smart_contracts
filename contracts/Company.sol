pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Employee.sol";
import "./Contract.sol";


contract Company is Ownable {

    struct Worker {
        address employeeAddress;
        bool hired;
    }

    Worker[] private employees;
    string public name;
    uint public raiting;
    address private companyAddress;

    modifier onlyOwnerOrCompany() {
        require(msg.sender == owner || msg.sender == companyAddress);
        _;
    }

    function Company(string _name, uint _raiting, address _companyAddress) public {
        name = _name;
        raiting = _raiting;
        companyAddress = _companyAddress;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function changeRaiting(uint newRaiting) public onlyOwner {
        raiting = newRaiting;
    }

    function addEmployee(address _employee) public onlyOwnerOrCompany {
        uint index = findEmployee(_employee);

        if (index < 0) {
            Worker memory employee = Worker(_employee, true);
            employees.push(employee);
        } else {
            employees[index].hired = true;
            employees.length++;
        }
    }

    function removeEmployee(address _employee) public onlyOwnerOrCompany {
        uint index = findEmployee(_employee);
        require(index >= 0);

        employees[index].hired = false;
        employees.length--;
    }

    function dispute(address worker) public onlyOwnerOrCompany {
        Employee employee = Employee(worker);
        Contract work = Contract(employee.getSenderContract());
        work.disputeStatusOn();
    }

    function sendWeekSalary(Contract work) public payable {
        work.sendWeekSalary.value(msg.value)();
    }

    function findEmployee(address employee) private view returns (uint index) {
        uint employeeNumber = 0;

        while (employeeNumber < employees.length) {
            if (employees[index].employeeAddress == employee)
                return index;
            if (employees[index].hired)
                employeeNumber++;
            index++;
        }
        return index;
    }


}
