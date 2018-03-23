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
    int private rating;

    modifier onlyOwnerOrCompany() {
        require(msg.sender == owner || msg.sender == companyAddress);
        _;
    }

    function Company(string _name, address _companyAddress) public {
        name = _name;
        companyAddress = _companyAddress;
        rating = 1000;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function addReview(address employee, int _rating) public onlyOwnerOrCompany {
        reviews.push(Review(employee, _rating));
    }

    function addWork(Work work) public onlyOwnerOrCompany {
        works.push(work);
    }

    function getWorks() public view onlyOwnerOrCompany returns(Work[]) {
        return works;
    }

    function getRating() public view returns(int) {
        return rating;
    }

    function getReviewRating() public view returns(int result) {
        for (uint i = 0; i < reviews.length; i++) {
            result += reviews[i].rating;
        }
    }

    function dispute(Work work) public onlyOwnerOrCompany returns(bool) {
        for (uint i = 0; i < works.length; i++) {
            if (work == works[i]) {
                work.disputeStatusOn();
                return true;
            }
        }
        return false;
    }


    function calculateRating() public onlyOwnerOrCompany {
        int result = 0;
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

        result += getReviewRating() * 1000;
        result += int(totalWeekPayment) * 25; // 1000 / 40
        rating = result;
    }
}
