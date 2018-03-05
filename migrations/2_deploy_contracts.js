// var Contract = artifacts.require("./Contract.sol");
var Work = artifacts.require("./Work.sol");

module.exports = function(deployer) {

  var skillCodes = [];
  var duration = 2;
  var employee = web3.eth.accounts[2];
  var company = web3.eth.accounts[3];
  var weekPayment = Math.pow(10, 12);

  deployer.deploy(Work, skillCodes, duration, employee, company, weekPayment);
  // deployer.deploy(Main);

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
