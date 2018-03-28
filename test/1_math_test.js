let MathTester = artifacts.require("./MathTester.sol");

let numbers = [4430, 12, 1, 10, 1111, 1230, 85000, 1423, 20.194911];

let checker = function (instanceF, mathF, errorMsg, accurancy) {
    let promises = numbers.map(number => {
        return instanceF(number * 1000000);
    })
    return Promise.all(promises).then(results => {
        for (let i = 0; i < results.length; i++) {
            let expected = Math.trunc(mathF(numbers[i]) * (10 ** accurancy));
            let result = Math.trunc(results[i].div(10 ** (6 - accurancy)));
            assert.equal(result, expected, `${errorMsg} ${numbers[i]}`);
        }
    })
}

contract('MathTester', function(accounts) {
  it("should correct calculate logarithm", function() {
    return MathTester.deployed().then(instance => checker(instance.log, Math.log, 'logarithm function doesn\'t work correct for:', 3) )
  });

  it("should correct calculate sqrt", function() {
    return MathTester.deployed().then(instance => checker(instance.sqrt, Math.sqrt, 'sqrt function doesn\'t work correct for:', 6))
  });

  it("should correct calculate exp", function() {
    let numbers = [0, 1, 10, 100, 1000, 2000, 199, 450];
    return MathTester.deployed().then(instance => {
      let promises = numbers.map(number => {
          return instance.exp(number * 1000000 / 256);
      })
      return Promise.all(promises);
    }).then(results => {
      numbers.forEach((number, i) => {
          let expected = Math.trunc(Math.exp(number / 256) * 10000);
          let result = Math.trunc(results[i].div(100));

          assert.equal(result, expected, `Exp function doesn\'t work correct for: ${i} / 256`);
      });
    })
  });
});
