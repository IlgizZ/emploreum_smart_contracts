pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Company is Ownable {

    struct Worker {
        address employeeAddress;
        bool hired;
    }

    string public name;
    uint public rating;
    Worker[] private employees;
    address private companyAddress;

    modifier onlyOwnerOrCompany() {
        require(msg.sender == owner || msg.sender == companyAddress);
        _;
    }

    function Company(string _name, uint _rating, address _companyAddress) public {
        name = _name;
        rating = _rating;
        companyAddress = _companyAddress;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function changeRating(uint newRaiting) public onlyOwner {
        rating = newRaiting;
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

    function getEmployees() public view onlyOwnerOrCompany returns(address[] result) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].hired)
              result.push(employees[i].employeeAddress);
        }
    }
}
