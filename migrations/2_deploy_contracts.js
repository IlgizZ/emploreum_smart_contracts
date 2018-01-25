var JCR = artifacts.require("./JCR.sol");
var Work = artifacts.require("./Work.sol");

module.exports = function(deployer) {
  const tokenAmount = 1400000;
  deployer.deploy(JCR, tokenAmount);

  var position = "programmer";
  var startDate = 1516827609;
  var endDate = 1516924800;
  var employee = web3.eth.accounts[2];
  var company = web3.eth.accounts[3];
  var weekPayment = 10**17;
  var initPayment = 10**18;

  deployer.deploy(Work, position, startDate, endDate, employee, company, weekPayment, {value: initPayment});
};
