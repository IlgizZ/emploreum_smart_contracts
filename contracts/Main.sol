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

    }

    function Main() public payable {}

    function newEmployee(string _firstName, string _lastName, string _email,
                            uint _raiting, address _address, uint[] _positionCodes,
                            uint[] _skillCodes, uint[] _skillToPosition) public onlyOwner {

        Employee employee = new Employee(_firstName, _lastName, _email, _raiting,
                                            _address, _positionCodes, _skillCodes, _skillToPosition);
        employees.push(employee);

    }

    function newCompany(string _name, uint _raiting, address _address) public onlyOwner {
        Company company = new Company(_name, _raiting, _address);
        companies.push(company);
    }

    function newContract(uint[] _skillCodes, uint[] _skillToPosition,
                            uint _startDate, uint _endDate, Employee _empoloyee,
                            Company _company, uint _weekPayment) public onlyOwner {

        Contract _contract = new Contract(_skillCodes, _skillToPosition,
                                            _startDate, _endDate, _empoloyee, _company, _weekPayment);
        contracts.push(_contract);
    }

    function getBalance() public view returns (uint) {
        return this.balance;
    }

    function getEmployee(uint index) public view returns (Employee) {
        return employees[index];
    }

    function getCompany(uint index) public view returns (Company) {
        return companies[index];
    }

    function getContract(uint index) public view returns (Contract) {
        return contracts[index];
    }

    function kill() public {
        selfdestruct(owner);
    }

    function test(uint index, uint count) public view returns (int) {
        return employees[index].test(index, count);
    }

}
