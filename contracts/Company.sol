pragma solidity ^0.4.11;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Work.sol";


contract Company is Ownable {

    struct Review {
        address employeeAddress;
        int rating;
    }

    string public name;
    Work[] private works;
    Review[] private reviews;
    address private companyAddress;

    modifier onlyOwnerOrCompany() {
        require(msg.sender == owner || msg.sender == companyAddress);
        _;
    }

    function Company(string _name, address _companyAddress) public {
        name = _name;
        companyAddress = _companyAddress;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function addReview(address employee, int rating) public onlyOwnerOrCompany {
        reviews.push(Review(employee, rating));
    }

    function addWork(Work work) public onlyOwnerOrCompany {
        works.push(work);
    }

    function getWorks() public view onlyOwnerOrCompany returns(Work[]) {
        return works;
    }

    function getReviewRating() public view returns(int result) {
        for (uint i = 0; i < reviews.length; i++) {
            result += reviews[i].rating;
        }
    }

    function getRating() public view returns(int result) {
        uint totalHours = 0;
        uint totalWeekPayment = 0;
        for (uint i = 0; i < works.length; i++) {
            Work work = works[i];
            if (work.getContractStatus() < 0) {
                continue;
            }

            result += int(work.getCompanyWorkRating());
            totalHours += work.getWorkedHours();
            totalWeekPayment += work.getWeekPayment();
        }

        result *= int(works.length);
        result /= int(totalHours);

        result += getReviewRating() * 1000000;
        result += int(totalWeekPayment) * 25000; // 1000000 / 40
    }
}
