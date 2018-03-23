var Specializations = artifacts.require("./Specializations.sol");

var skills = ['javascript', 'postresql', 'android']
var specializations = ['web', 'mobile']

var specialization = 'mobile';
var code = 4098;
var skill = 'android';

contract('Specializations', function(accounts) {
  it("should return generated code for init specializations correctly", function() {
    var contract;
    return Specializations.deployed().then(function(instance) {
      contract = instance;
      var promises = [];

      skills.forEach(skill => promises.push(contract.addSkill(skill)));
      specializations.forEach(specialization => promises.push(contract.addSpecialization(specialization)));
      return Promise.all(promises);
    }).then(function() {
      return contract.generateCode(specialization, skill);
    }).then(function(data) {
      assert.equal(data.toString(), code, "'mobile' and 'android' code wasn't get correct");
    });
  });

  it("should return specialization and skill by given code correctly", function() {

    return Specializations.deployed().then(function(instance) {
      return instance.getSpecializationByCode(code);
    }).then(function(data) {
      assert.equal(data[0], specialization, `specialization ${specialization} wasn't get correct by code ${code}`);
      assert.equal(data[1], skill, `skill ${skill} wasn't get correct by code ${code}`);
    });
  });
});
