var Work = artifacts.require("./Work.sol");

var position = "programmer";
var endDate = 1516924800;
var employee = web3.eth.accounts[2];
var company = web3.eth.accounts[3]
var anotherAccount = web3.eth.accounts[4];
var weekPayment = 10**17;
var startDate = 1516827609;

contract('Work', function(accounts) {

  it("should throw an exception if employee confirm week payment", function() {
    return Work.deployed().then(function(instance) {
      return instance.sendWeekSalary({from: employee});
    }).then(function(data) {
      assert(false, "sendWeekSalary was supposed to throw but didn't.");
    }).catch(function(error) {
      if(error.toString().indexOf("VM Exception while") == -1) {
        assert(false, error.toString());
      }
    });
  });

  it("should throw an exception if week payment comfirmed not by company", function() {
    return Work.deployed().then(function(instance) {
      return instance.sendWeekSalary({from: anotherAccount});
    }).then(function(data) {
      assert(false, "sendWeekSalary was supposed to throw but didn't.");
    }).catch(function(error) {
      if(error.toString().indexOf("VM Exception while") == -1) {
        assert(false, error.toString());
      }
    });
  });

  it("should throw an exception if send payment", function() {
    return Work.deployed().then(function(instance) {
      return instance.sendWeekSalary({from: employee});
    }).then(function(data) {
      assert(false, "sendWeekSalary was supposed to throw but didn't.");
    }).catch(function(error) {
      if(error.toString().indexOf("VM Exception while") == -1) {
        assert(false, error.toString());
      }
    });
  });

  it("should return init data correctly", function() {
    return Work.deployed().then(function(instance) {
      return instance.getWorkData.call();
    }).then(function(data) {
      assert.equal(data[0], position, "position field initialization wasn't correct");
      assert.equal(data[1], startDate, "startDate field initialization wasn't correct");
      assert.equal(data[2], endDate, "endDate field initialization wasn't correct");
      assert.equal(data[3], employee, "employee field initialization wasn't correct");
      assert.equal(data[4], company, "company field initialization wasn't correct");
      assert.equal(data[5], weekPayment, "weekPayment field initialization wasn't correct");
      assert.equal(data[6], accounts[0], "weekPayment field initialization wasn't correct");
      assert.equal(data[7], false, "weekPayment field initialization wasn't correct");
      assert.equal(data[8], 0, "weekPayment field initialization wasn't correct");
    });
  });

});
