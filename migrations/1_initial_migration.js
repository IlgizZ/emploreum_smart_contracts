var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};

// Deploy A, then deploy B, passing in A's newly deployed address

// deployer.deploy(A).then(function() {
//   return deployer.deploy(B, A.address);
// })
