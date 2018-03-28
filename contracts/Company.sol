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

    modifier onlyWork() {
        Work work = Work(msg.sender);
        //check in store
        bool isInStore = true;
        require(work.getCompanyContractAddress() == address(this) && isInStore);
        _;
    }

    event CompanyTest(int data, uint index);

    function Company(string _name, address _companyAddress) public {
        name = _name;
        companyAddress = _companyAddress;
        rating = 1000000;
    }

    function () public payable {
        owner.transfer(msg.value);
    }

    function addReview(address employee, int _rating) public onlyOwnerOrCompany {
        reviews.push(Review(employee, _rating));
    }

    function addWork(Work work) public onlyWork {
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

    function changeRating() public onlyWork {
        int n = 1000000;
        int result = 0;
        int totalHours = 0;
        /* int totalWeekPayment = 0; */
        int workCount = 0;

        for (uint i = 0; i < works.length; i++) {
            Work work = works[i];
            if (work.getContractStatus() < 0) {
                continue;
            }
            result += work.getCompanyWorkRating(); //// R(empl) I
            totalHours += int(work.getWorkedHours()); // R(empl) II
            /* totalWeekPayment += int(work.getWeekPayment()); // R(salary) I */
            workCount++; // R(salary) II
        }
        CompanyTest(result, 0);
        CompanyTest(totalHours, 1);
        /* CompanyTest(totalWeekPayment, 2); */
        CompanyTest(workCount, 3);
        // R(empl) II
        result /= int(totalHours);
        CompanyTest(result, 4);
        /* result += totalWeekPayment * n / workCount; //R(salary) */
        CompanyTest(result, 5);
        result += getReviewRating() * n; // R(reviews)
        CompanyTest(result, 6);
        rating = result + n;
        CompanyTest(rating, 7);
        CompanyTest(rating, 7);
        CompanyTest(0, 0);
    }
}
