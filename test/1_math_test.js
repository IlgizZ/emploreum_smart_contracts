var MathTester = artifacts.require("./MathTester.sol");

var numbers = [44300, 12, 1, 10, 11111111, 1230, 85000, 1423, 444];

var checker = function (instanceF, mathF, errorMsg) {
    var promises = numbers.map(number => {
        return instanceF(number);
    })
    return Promise.all(promises).then(results => {
        for (var i = 0; i < results.length; i++) {
            var expected = Math.trunc(mathF(numbers[i]) * 1000);
            var result = Math.trunc(results[i]);
            assert.equal(result, expected, `${errorMsg} ${numbers[i]}`);
        }
    })
}

contract('MathTester', function(accounts) {
  it("should correct calculate logarithm", function() {
    return MathTester.deployed().then(instance => checker(instance.log, Math.log, 'logarithm function doesn\'t work correct for:') )
  });

  it("should correct calculate sqrt", function() {
    return MathTester.deployed().then(instance => checker(instance.sqrt, Math.sqrt, 'sqrt function doesn\'t work correct for:'))
  });
});
