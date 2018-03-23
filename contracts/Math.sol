pragma solidity ^0.4.11;


library Math {

    function log(uint x) internal pure returns (uint result) {
        uint N = 1000000;

        x *= N;
        while (x >= 1500000) {
            result = result + 405465;
            x = x * 2 / 3;
        }

        x = x - N;
        uint y = x;
        uint i = 1;

        while (i < 10) {
            result = result + (y / i);
            i = i + 1;
            y = y * x / N;
            result = result - (y / i);
            i = i + 1;
            y = y * x / N;
        }

        result /= 1000;
    }

    function sqrt(uint x) internal pure returns (uint result) {
        uint N = 1000000;
        uint tmp = x;
        tmp *= N * N;

        assert(x == 0 || tmp / (N * N) == x);
        x = tmp;

        result = (x + 1) / 2;
        tmp = x;

        while (result < tmp) {
            tmp = result;
            result = (x / result + result) / 2;
        }

        result /= 1000;
    }
}
