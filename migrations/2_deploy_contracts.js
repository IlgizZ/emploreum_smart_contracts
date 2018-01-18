var JCR = artifacts.require("./JCR.sol");

module.exports = function(deployer) {
  const tokenAmount = 1400000;
  deployer.deploy(JCR, tokenAmount);
};
