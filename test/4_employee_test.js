var Employee = artifacts.require("./Employee.sol");
var Work = artifacts.require("./Work.sol");
var Company = artifacts.require("./Company.sol");


contract('Employee', function(accounts) {
  var company, work;
  it("should correct calculate logarithm", function() {

    return Work.deployed().then(function(instance) {
      work = instance;
      return Company.deployed().then(function(instance) {
        company = instance
        return Employee.deployed().then(function(instance) {
          return instance.addWork(work.address, company.address);
        }).then(function(data) {
          return instance.getWorks();
        }).then(function(data) {
          console.log(data);
        });
      });
    });
  });
});
