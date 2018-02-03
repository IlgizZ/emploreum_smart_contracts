var Contract = artifacts.require("./Contract.sol");
var Main = artifacts.require("./Main.sol");

module.exports = function(deployer) {

  var position = "programmer";
  var startDate = 1716827609;
  var endDate = 1716924800;
  var employee = web3.eth.accounts[2];
  var main = web3.eth.accounts[0];
  var company = web3.eth.accounts[3];
  var weekPayment = Math.pow(10, 12);
  var initPayment = Math.pow(10, 13);

  deployer.deploy(Contract, position, startDate, endDate, employee, company, weekPayment, {value: initPayment});
  deployer.deploy(Main);
};
