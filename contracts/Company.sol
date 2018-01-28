pragma solidity ^0.4.11;


contract Company {

    struct Employee {
        address empl_address;
        bool hired;
    }

    Employee[] private employees;
    uint16 private employee_count;
    string public name;
    uint public raiting;

    function Company() public {
    }

}
