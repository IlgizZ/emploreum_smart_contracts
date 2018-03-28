pragma solidity ^0.4.11;

/**
    *
    *FOR input apply uint x * 10^6
    *
*/

library Math {
    function log(uint x) internal pure returns (uint result) {
        uint N = 1000000;

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
    }

    function sqrt(uint x) internal pure returns (uint result) {
        uint N = 1000000;
        uint tmp = x;
        tmp *= N;

        assert(x == 0 || tmp / (N) == x);
        x = tmp;

        result = (x + 1) / 2;
        tmp = x;

        while (result < tmp) {
            tmp = result;
            result = (x / result + result) / 2;
        }
    }

    function exp(uint x) internal pure returns (uint result) {
        uint fact = 1;
        uint accurancy = 1000000;
        uint iteration = 0;

        while (accurancy > 1) {
            result += accurancy;
            accurancy = x;
            for (uint i = 0; i < iteration; i++) {
                accurancy *= x;
                accurancy /= 1000000;
            }
            iteration++;
            fact *= iteration;
            accurancy /= fact;
        }
    }
}
