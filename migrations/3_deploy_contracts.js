// var Contract = artifacts.require("./Contract.sol");
var Work = artifacts.require("./Work.sol");
var Employee = artifacts.require("./Employee.sol");
var Company = artifacts.require("./Company.sol");

module.exports = function(deployer) {
  var firstName = "John"
  var lastName = "Shpohen"
  var email  = "123@mail.com"
  var employee = web3.eth.accounts[2];

  var name = "Company one"
  var company = web3.eth.accounts[3];

  var skillCodes = [4098];
  var duration = 2;
  var weekPayment = Math.pow(10, 12);

  return deployer.deploy(Employee, firstName, lastName, email, employee).then(() => {
      return deployer.deploy(Company, name, company);
  }).then(() => {
    var employeeInstance, companyInstance, workInstance;

    return Employee.deployed().then(instance => {
      employeeInstance = instance;
      return Company.deployed();
    }).then(function(instance) {
      companyInstance = instance;
      return deployer.deploy(Work, skillCodes, duration, employee, employeeInstance.address, company, companyInstance.address, weekPayment);
    })
    // .then(() => {
    //   return Work.deployed();
    // }).then(function(instance) {
    //   workInstance = instance;
    //   var promises = [companyInstance.addWork(workInstance.address), employeeInstance.addWork(workInstance.address, companyInstance.address)];
    //   return Promise.all(promises);
    // })
  });

};
