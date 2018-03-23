var Employee = artifacts.require("./Employee.sol");
var Work = artifacts.require("./Work.sol");
var Company = artifacts.require("./Company.sol");


contract('Employee', function(accounts) {
  var company, work;
  it("should correct calculate logarithm", function() {

    return Work.deployed().then(instance => {
      work = instance;
      return Company.deployed().then(instance => {
        company = instance
        return Employee.deployed().then(instance => instance.addWork(work.address, company.address))
        .then(data => {
        
        });
      });
    });
  });
});
