var Main = artifacts.require("./Main.sol");
var Employee = artifacts.require("./Employee.sol");
var main = web3.eth.accounts[0];
var employee = web3.eth.accounts[2];
var company = web3.eth.accounts[3]
var anotherAccount = web3.eth.accounts[4];


contract('Main', function(accounts) {
  it("should return init data correctly", function() {
    var contract, gasFromContract, balance, siparate;

    var balance = web3.eth.getBalance(main);
    // return JCR.new(100, {from: main}).then(function(data) {
    //   console.log(web3.fromWei(balance - web3.eth.getBalance(main)));
    //
    //   console.log(data.transactionHash);
    // });
    // return Employee.new("_firstName", "_lastName", "_email", 1, employee, {from: main}).then(function(data) {
    //   console.log(web3.fromWei(balance - web3.eth.getBalance(main)));
    //
    //   console.log(data.transactionHash);
    // });

    return Main.deployed().then(function(instance) {

      contract = instance;
      return contract.newEmployee("_firstName", "_lastName", "_email", 1, employee);
    }).then(function(data) {

      // console.log(data);
    });
  });
});
