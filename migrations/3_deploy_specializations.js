// var Contract = artifacts.require("./Contract.sol");
var Specializations = artifacts.require("./Specializations.sol");

module.exports = function(deployer) {

    deployer.deploy(Specializations);

};
