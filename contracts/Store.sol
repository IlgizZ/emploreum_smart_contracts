pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Store is Ownable {

    address[] public employees;
    address[] public companies;
    address[] public contracts;
    address public specializations;

    function Store() public payable {}

    function () public payable {}

    function addEmployee(address employee) public onlyOwner {
        employees.push(employee);
    }

    function addCompany(address company) public onlyOwner {
        companies.push(company);
    }

    function addWork(address _contract) public onlyOwner {
        contracts.push(_contract);
    }

    function setSpecializations(address _specializations) public onlyOwner {
        specializations = _specializations;
    }

    function getAccountSizes() public view returns (uint, uint, uint) {
        return (employees.length, companies.length, contracts.length);
    }

    function kill() public {
        selfdestruct(owner);
    }

}
