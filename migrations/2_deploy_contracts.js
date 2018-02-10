var Contract = artifacts.require("./Contract.sol");
var Main = artifacts.require("./Main.sol");

module.exports = function(deployer) {

  var position = "programmer";
  var startDate = 1519827609;
  var endDate = 1716924800;
  var employee = web3.eth.accounts[2];
  var main = web3.eth.accounts[0];
  var company = web3.eth.accounts[3];
  var weekPayment = Math.pow(10, 12);
  var initPayment = Math.pow(10, 13);
  var contract;
  // deployer.deploy(Contract, [], [], startDate, endDate, '0x002c7E60484a0B65034C5D70b887Eee4A2C0FFbb', '0x004120f424F83417C68109Cc8522594c22528d3c',
                      // weekPayment, {value: initPayment});

  deployer.then(function() {
    return Main.new();
  }).then(function(instance) {

    contract = instance;
    console.log(contract.address);
    console.log(web3.fromWei(web3.eth.getBalance(main), 'ether').toString());
    console.log(web3.toWei('1', 'ether'));

    web3.eth.sendTransaction({from: main, to:contract.address, value: web3.toWei('1', 'ether'), gas: 2300}, function callback(data) {

      console.log('sending ether:');
      console.log(web3.fromWei(web3.eth.getBalance(main), 'ether').toString());
      console.log(web3.fromWei(web3.eth.getBalance(contract.address), 'ether').toString());
      console.log('sent');
    });

  //   return contract.newEmployee("_firstName", "_lastName", "_email", 1, '0x002c7E60484a0B65034C5D70b887Eee4A2C0FFbb', [], [], []);
  // }).then(function(data) {
  //   console.log('employee created');


  })
};
