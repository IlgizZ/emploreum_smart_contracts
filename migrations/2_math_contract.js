// var Contract = artifacts.require("./Contract.sol");
var MathTester = artifacts.require("./MathTester.sol");

module.exports = function(deployer) {


  deployer.deploy(MathTester);

};
