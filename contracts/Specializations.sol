pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract Specializations is Ownable {

    string[] private specializations;
    string[] private skills;

    function () public payable {revert();}

    function addSpecialization(string specialization) public onlyOwner {
        specializations.push(specialization);
    }

    function addSkill(string skill) public onlyOwner {
        skills.push(skill);
    }

    function removeSpecialization(string specialization) public onlyOwner {
        uint index = 0;

        for (index; index < specializations.length; index++) {
            if (compareStrings(specializations[index], specialization))
                break;
        }

        if (index == specializations.length)
            revert();
        index++;

        for (index; index < specializations.length; index++) {
            specializations[index - 1] = specializations[index];
        }

        delete specializations[index];
        specializations.length--;
    }

    function removeSkill(string skill) public onlyOwner {
        uint index = 0;

        for (index; index < skills.length; index++) {
            if (compareStrings(skills[index], skill))
                break;
        }

        if (index == skills.length)
            revert();
        index++;

        for (index; index < skills.length; index++) {
            skills[index - 1] = skills[index];
        }

        delete skills[index];
        skills.length--;
    }

    function getSpecializationByCode(uint code) public view returns (string, string) {
        uint skill = code & (4096 - 1);
        uint specialization = code >> 12;
        require(skill < skills.length && specialization < specializations.length);

        return (specializations[specialization], skills[skill]);
    }

    function generateCode(string _specialization, string _skill) public view returns (uint result) {
        uint skill;
        uint specialization;

        while (skill < skills.length && !compareStrings(skills[skill], _skill))
            skill++;

        while (
            specialization < specializations.length
            &&
            !compareStrings(specializations[specialization], _specialization)
        )
            specialization++;

        require(skill < skills.length && specialization < specializations.length);

        result = (specialization << 12) + skill;
    }

    function kill() public {
        selfdestruct(owner);
    }

    function compareStrings (string a, string b) private pure returns (bool) {
        return keccak256(a) == keccak256(b);
    }

}
