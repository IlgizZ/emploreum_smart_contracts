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
      return deployer.deploy(Work, skillCodes, duration, employee, company, weekPayment);
  }).then(() => {
    var employeeInstance, companyInstance, workInstance;

    return Employee.deployed().then(function(instance) {
      employeeInstance = instance;
      return Company.deployed();
    }).then(function(instance) {
      companyInstance = instance;
      return Work.deployed();
    }).then(function(instance) {
      workInstance = instance;
      var promises = [companyInstance.addWork(workInstance.address), employeeInstance.addWork(workInstance.address, companyInstance.address)];
      return Promise.all(promises);
    }).then(function(instance) {
      return employeeInstance.getWorks();
    }).then(function(data) {
      console.log(data);
      console.log('asdasdasdasd');
    });
  });











  // var main = web3.eth.accounts[0];
  // var balance = web3.eth.getBalance(main);
  // deployer.deploy(Store).then(function(data) {
  //   console.log("----------------------------------------------");
  //   console.log("-------------------GAAAS----------------------");
  //   console.log(balance.minus(web3.eth.getBalance(main)).div(1000000000).toString() );
  //   console.log("----------------------------------------------");
  // });
  // deployer.then(function() {
  //   return Main.new();
  // })
  // .then(function(instance) {
  //
  //   contract = instance;
  //   console.log(contract.address);
  //   console.log(web3.fromWei(web3.eth.getBalance(main), 'ether').toString());
  //   console.log(web3.toWei('1', 'ether'));
  //
  //   web3.eth.sendTransaction({from: main, to:contract.address, value: web3.toWei('1', 'ether'), gas: 2300}, function callback(data) {
  //
  //     console.log('sending ether:');
  //     console.log(web3.fromWei(web3.eth.getBalance(main), 'ether').toString());
  //     console.log(web3.fromWei(web3.eth.getBalance(contract.address), 'ether').toString());
  //     console.log('sent');
  //   });

  //   return contract.newEmployee("_firstName", "_lastName", "_email", 1, '0x002c7E60484a0B65034C5D70b887Eee4A2C0FFbb', [], [], []);
  // }).then(function(data) {
  //   console.log('employee created');


  // })
};
