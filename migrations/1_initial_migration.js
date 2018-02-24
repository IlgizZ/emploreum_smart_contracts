var Migrations = artifacts.require("./Migrations.sol");
var Store = artifacts.require("./Store.sol");

module.exports = function(deployer) {
  // var main = web3.eth.accounts[0];
  // var balance = web3.eth.getBalance(main);
  // console.log("asd");
  // deployer.deploy(Main).then(function(data) {
  //   console.log(data);
  // });
  deployer.deploy(Migrations);
};

// Deploy A, then deploy B, passing in A's newly deployed address

// deployer.deploy(A).then(function() {
//   return deployer.deploy(B, A.address);
// })
