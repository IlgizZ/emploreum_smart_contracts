// var Contract = artifacts.require("./Contract.sol");
var Employee = artifacts.require("./Employee.sol");
var firstName = "John"
var lastName = "Shpohen"
var email  = "123@mail.com"
var employee = web3.eth.accounts[2];

module.exports = function(deployer) {

    deployer.deploy(Employee, firstName, lastName, email, employee);

};
