var JCR = artifacts.require("./JCR.sol");
var Work = artifacts.require("./Work.sol");

module.exports = function(deployer) {
  const tokenAmount = 1400000;
  deployer.deploy(JCR, tokenAmount);

  var position = "programmer";
  var startDate = 1516827609;
  var endDate = 1516924800;
  var employee = "0x79af3df25d2923929bc023f5bb9e618d314dfc57";
  var company = "0xe1dc59294a9ab37483fcefca969693fd166b236a";
  var weekPayment = 10**17;

  deployer.deploy(Work, position, startDate, endDate, employee, company, weekPayment, {value: 10**18});
};
