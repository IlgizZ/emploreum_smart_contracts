let Work = artifacts.require("./Work.sol");
let Company = artifacts.require("./Company.sol");
let Employee = artifacts.require("./Employee.sol");
let BigNumber = require('bignumber.js');
let main = web3.eth.accounts[0];
let anotherAccount = web3.eth.accounts[4];
let skillCodes = [new BigNumber(4098)];
let duration = 2;
let employee = web3.eth.accounts[2];
let employeeContract, companyContract;
let company = web3.eth.accounts[3];
let weekPayment = Math.pow(10, 12);

contract('Work', function(accounts) {
  before(function() {
    return Work.deployed().then(function(instance) {
        return Promise.all([instance.getEmployee(),instance.getCompanyContractAddress()]);
    }).then(data => {employeeContract = data[0]; companyContract = data[1]});
  });

  it("should return init data correctly", function() {
    return Work.deployed().then(function(instance) {
      return instance.getWorkData();
    }).then(function(data) {
      let startDate = 0;
      let owner = web3.eth.accounts[0];
      let disputeStatus = false;
      let frizzing = -100;

      let isEqual = true;
      for (let i = 0; i < skillCodes.length; i++) {
          if (!skillCodes[i].eq(data[0][i])) {
              isEqual = false;
              break;
          }
      }
      assert(isEqual, "skillCodes field initialization wasn't correct");
      assert.equal(data[1], startDate, "startDate field initialization wasn't correct");
      assert.equal(data[2], duration, "endDate field initialization wasn't correct");
      assert(data[3], employee, "employee field initialization wasn't correct");
      assert(data[4], company, "company field initialization wasn't correct");
      assert.equal(data[5], weekPayment, "weekPayment field initialization wasn't correct");
      assert.equal(data[6], owner, "owner field initialization wasn't correct");
      assert.equal(data[7], disputeStatus, "disputeStatus field initialization wasn't correct");
      assert.equal(data[8], frizzing, "frizzing field initialization wasn't correct");
    });
  });


  it("should change status after start", function() {
    let contract;

    return Work.deployed().then(instance => {
      contract = instance;
      return contract.start({from: main, value: weekPayment});
    }).then(() => {
      return contract.getWorkData();
    }).then(data => {
      let frizzing = 0;
      let startDate = 0;
      assert.notEqual(data[1], startDate, "startDate field wasn't changed");
      assert.equal(data[8], frizzing, "frizzing field wasn't changed");
    })

  });

  it("should add work to employee", function() {
    let contract, company;

    return Work.deployed().then(instance => {
      contract = instance;
      return instance.getEmployee();
    }).then(address => Employee.at(address))
    .then(instance => instance.getWorks())
    .then(console.log);
  });

  it("should throw an exception if start called twice", function() {
    let contract;

    return Work.deployed().then(function(instance) {
      contract = instance;
      return contract.start({from: company, value: weekPayment});
    }).then(function(data) {
      assert(false, "twice start call was supposed to throw but didn't.");
    }).catch(function(error) {
      if(error.toString().indexOf("VM Exception while") == -1) {
        assert(false, error.toString());
      }
    });
  });

  it("should throw an exception if employee confirm week payment", function() {
    let contract;

    return Work.deployed().then(function(instance) {
      contract = instance;
      return contract.sendWeekSalary(35, {from: employee});
    }).then(function(data) {

      assert(false, "sendWeekSalary was supposed to throw but didn't.");
    }).catch(function(error) {

      if(error.toString().indexOf("VM Exception while") == -1) {
        assert(false, error.toString());
      }
    });
  });

  it("should throw an exception if week payment comfirmed not by company", function() {
    let contract;

    return Work.deployed().then(function(instance) {
      contract = instance;
      return contract.sendWeekSalary(35, {from: anotherAccount});
    }).then(function(data) {
      assert(false, "sendWeekSalary was supposed to throw but didn't.");
    }).catch(function(error) {
      if(error.toString().indexOf("VM Exception while") == -1) {
        assert(false, error.toString());
      }
    });
  });

  it("should send week paymnet to employee with code 0", function() {
    let employeeInitBalance = web3.eth.getBalance(employeeContract);
    let contract, employeeInstance, companyInstance, events, companyEvents;
    let range = 52 * 5;

    let printEvent = (error, data) => {
        console.log(`${data.event}: ${data.args.data} index: ${data.args.index}`);
    };

    let printCompany = (error, data) => {
        console.log(`${data.event}: ${data.args.data} index: ${data.args.index}`);
    };

    return Work.deployed().then(instance => {
      contract = instance;
      return Employee.at(employeeContract);
    }).then(instance => {employeeInstance = instance;
        events = employeeInstance.allEvents();
        events.watch(printEvent);
        return Company.at(companyContract);
    }).then(instance => {companyInstance = instance;
        companyEvents = companyInstance.allEvents();
        companyEvents.watch(printCompany);
    })
    .then(data => {
      let promises = [];
      for (var i = 0; i < range; i++) {
        promises.push(contract.sendWeekSalary(35, {from: main, value: weekPayment}));
      }
      return Promise.all(promises);
    })
    .then(results => {
      assert.equal(results[0].logs[0].args.code, 0, "sendWeekSalary return " + results[0].logs[0].args.code + " code.");

      let employeeEndBalance = web3.eth.getBalance(employeeContract);

      assert(employeeEndBalance.eq(employeeInitBalance.plus(weekPayment * range)), "sendWeekSalary wasn't send correct payment to employee.");
    }).then(data => {
      return employeeInstance.test(0);
    }).then(data => {
      console.log(data[0].div(1000000).toString());
      console.log(data);
      events.stopWatching();
      companyEvents.stopWatching();
    //   return employeeInstance.getSkillHistory(4098);
    // }).then(data => {
    //   console.log(data);
    })
  });

  it("should throw an exception on send week payment if contract status is disput", function() {
    let contract;

    return Work.deployed().then(function(instance) {
      contract = instance;
      return contract.disputeStatusOn({from: company});
    }).then(function(data) {
      return contract.getDisputeStatus();
    }).then(data => {
      assert(data, 'Disput status is not changed');
      return contract.sendWeekSalary(35, {from: company});
    }).then(function(data) {

      assert(false, "sendWeekSalary was supposed to throw but didn't.");
    }).catch(function(error) {

      if(error.toString().indexOf("VM Exception while") == -1) {
        assert(false, error.toString());
      }
    });
  });

  it("should throw an exception on solve disput if winner neither employee neither company", function() {
    let contract;

    return Work.deployed().then(function(instance) {
      contract = instance;
      return contract.solveDispute(anotherAccount, {from: company});

    }).then(function(data) {

      assert(false, "solveDisput was supposed to throw but didn't.");

    }).catch(function(error) {

      if(error.toString().indexOf("VM Exception while") == -1) {
        assert(false, error.toString());
      }

    });
  });

  it("should solve disput with employee winner", function() {
    let contract, contractBalance, employeeInitBalance, companyInitBalance;

    return Work.deployed().then(instance => {
      contract = instance;

      contractBalance = web3.eth.getBalance(contract.address);

      employeeInitBalance = web3.eth.getBalance(employeeContract);
      companyInitBalance = web3.eth.getBalance(company);

      return contract.solveDispute(employeeContract, {from: main});
    }).then(function(data) {
      let employeeEndBalance = web3.eth.getBalance(employeeContract);
      let companyEndBalance = web3.eth.getBalance(company);

      assert(employeeEndBalance.eq(employeeInitBalance.plus(weekPayment)), "solveDisput wasn't send correct payment to employee");
      assert(companyEndBalance.eq(companyInitBalance.plus(contractBalance).minus(weekPayment)), "solveDisput wasn't send correct payment to company");
    })
  });
});
