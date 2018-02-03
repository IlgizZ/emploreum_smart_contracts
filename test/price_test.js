var Main = artifacts.require("./Main.sol");
var Employee = artifacts.require("./Employee.sol");

var position = "programmer";
var endDate = 1516924800;
var main = web3.eth.accounts[0];
var employee = web3.eth.accounts[2];
var company = web3.eth.accounts[3]
var anotherAccount = web3.eth.accounts[4];
var startDate = 1516827609;
var weekPayment = Math.pow(10, 17);
var initPayment = Math.pow(10, 18);

//change 1 symbol 64

//additional call 2 * 10 ^ -3

//int256 is cheapest

contract('Main', function(accounts) {
  // it("should return init data correctly", function() {
  //   var contract, gasFromContract, balance, siparate;
  //   var accRange = [...Array(10).keys()];
  //
  //   return Main.deployed().then(function(instance) {
  //
  //     contract = instance;
  //
  //     var contracts = [];
  //
  //     contracts.push(contract.changei8(Math.pow(10, 30)));
  //     contracts.push(contract.changei16(Math.pow(10, 30)));
  //     contracts.push(contract.changei32(Math.pow(10, 30)));
  //     contracts.push(contract.changei64(Math.pow(10, 30)));
  //     contracts.push(contract.changei128(Math.pow(10, 30)));
  //     contracts.push(contract.changei256(Math.pow(10, 30)));
  //
  //     return Promise.all(contracts);
  //   }).then(function(results) {
  //     results.map(data => {
  //       console.log(data.receipt.gasUsed);
  //     })
  //     // return contract.getContract(0);
  //   }).then(function(address) {
  //
  //     // console.log(address);
  //   });
  // });
  //
  // it("should return init data correctly", function() {
  //   var contract, gasFromContract, balance, siparate;
  //   var accRange = [...Array(10).keys()];
  //
  //   return Main.deployed().then(function(instance) {
  //
  //     contract = instance;
  //
  //     var contracts = accRange.map(index => {
  //       return contract.createContract("_firstName" + index, "_lastName" + index, "_email" + index)
  //     })
  //
  //     return Promise.all(contracts);
  //   }).then(function(data) {
  //
  //     var calls = accRange.map(index => {
  //       return contract.getEmployeeAddress(index);
  //     })
  //
  //     return Promise.all(calls);
  //   }).then(function(addresses) {
  //
  //     balance = web3.eth.getBalance(main);
  //
  //     var promises = addresses.map((address, index) => {
  //       return Employee.at(address).changeState(index + 1, {from: main});
  //     })
  //
  //     return Promise.all(promises);
  //   }).then(function(data) {
  //
  //     siparate = balance - web3.eth.getBalance(main);
  //
  //     balance = web3.eth.getBalance(main);
  //
  //     return contract.changeState();
  //   }).then(function(data) {
  //
  //     var fromContract = balance - web3.eth.getBalance(main);
  //     console.log(fromContract, siparate);
  //     console.log(web3.fromWei(siparate - fromContract));
  //
  //     assert.notEqual(fromContract, siparate, "gas used should be same");
  //   });
  // });
});
