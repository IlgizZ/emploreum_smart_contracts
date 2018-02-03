pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Employee.sol";
import "./Company.sol";
import "./Contract.sol";


contract Main is Ownable {

    Employee[] private employees;
    Company[] private companies;
    Contract[] private contracts;

    function () public payable {
        owner.transfer(msg.value);
    }

    function newEmployee(string _firstName, string _lastName, string _email,
        uint _raiting, address _address) public onlyOwner {
        Employee employee = new Employee(_firstName, _lastName, _email, _raiting, _address);
        employees.push(employee);
    }

    function newCompany(string _name, uint _raiting, address _address) public onlyOwner {
        Company company = new Company(_name, _raiting, _address);
        companies.push(company);
    }

    function newContract(string _position, uint _startDate, uint _endDate, Employee _empoloyee, Company _company,
      uint _weekPayment) public onlyOwner {
        Contract _contract = new Contract(_position, _startDate, _endDate, _empoloyee, _company, _weekPayment);
        contracts.push(_contract);
    }

    function getBalance() public view returns (uint) {
        return this.balance;
    }

    function getEmployee(uint index) public view returns (Employee) {
        return employees[index];
    }

    function kill() public {
        selfdestruct(owner);
    }

}
