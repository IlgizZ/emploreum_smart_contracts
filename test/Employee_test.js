var Employee = artifacts.require("./Employee.sol");


contract('Employee', function(accounts) {

  it("should correct calcolate logarithm", function() {
    var number = 44300;

    return Employee.deployed().then(function(instance) {
      return instance.log(number);
    }).then(function(data) {
      var ln = Math.trunc(Math.log(number) * 10000);
      var result = Math.trunc(data.div(100));
      assert.equal(result, ln, "logarithm function doesn't work correct");
    });
  });
});
