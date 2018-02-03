var Work = artifacts.require("./Contract.sol");

var position = "programmer";
var endDate = 1716924800;
var main = web3.eth.accounts[0];
var employee = web3.eth.accounts[2];
var company = web3.eth.accounts[3]
var anotherAccount = web3.eth.accounts[4];
var startDate = 1716827609;
var weekPayment = Math.pow(10, 12);
var initPayment = Math.pow(10, 13);

contract('Work', function(accounts) {
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

  it("should send week paymnet to employee", function() {
    var employeeInitBalance = web3.eth.getBalance(employee);
    var contract;

    return Work.deployed().then(function(instance) {

      contract = instance;
      return contract.sendWeekSalary({from: company});
    }).then(function(data) {

      assert.equal(data.logs[0].args.code, 0, "sendWeekSalary return " + data.logs[0].args.code + " code.");

      var employeeEndBalance = web3.eth.getBalance(employee);

      assert(employeeEndBalance.eq(employeeInitBalance.plus(weekPayment)), "sendWeekSalary wasn't send correct payment to employee.");
    })
  });

  it("should throw an exception on send week payment if contract status is disput", function() {
    var contract;

    return Work.deployed().then(function(instance) {

      contract = instance;
      return contract.disputeStatusOn({from: employee});
    }).then(function(data) {

      return contract.sendWeekSalary({from: company});
    }).then(function(data) {

      assert(false, "sendWeekSalary was supposed to throw but didn't.");
    }).catch(function(error) {

      if(error.toString().indexOf("VM Exception while") == -1) {
        assert(false, error.toString());
      }
    });
  });

  it("should throw an exception on solve disput if winner neither employee neither company", function() {
    var contract;

    return Work.deployed().then(function(instance) {

      contract = instance;
      return contract.disputeStatusOn({from: employee});

    }).then(function(data) {

      return contract.solveDisput(anotherAccount, {from: company});

    }).then(function(data) {

      assert(false, "solveDisput was supposed to throw but didn't.");

    }).catch(function(error) {

      if(error.toString().indexOf("VM Exception while") == -1) {
        assert(false, error.toString());
      }

    });
  });

  it("should solve disput with employee winner", function() {
    var contract, contractBalance, employeeInitBalance, companyInitBalance;

    return Work.deployed().then(function(instance) {

      contract = instance;
      contractBalance = web3.eth.getBalance(contract.address);
      return contract.disputeStatusOn({from: employee});
    }).then(function(data) {

      employeeInitBalance = web3.eth.getBalance(employee);
      companyInitBalance = web3.eth.getBalance(company);

      return contract.solveDisput(employee, {from: main});
    }).then(function(data) {

      var employeeEndBalance = web3.eth.getBalance(employee);
      var companyEndBalance = web3.eth.getBalance(company);

      assert(employeeEndBalance.eq(employeeInitBalance.plus(weekPayment)), "solveDisput wasn't send correct payment to employee");
      assert(companyEndBalance.eq(companyInitBalance.plus(contractBalance).minus(weekPayment)), "solveDisput wasn't send correct payment to company");
    })
  });
});
