#include <iostream>
#include <cmath>
#include <vector>

int main() {
    double num;
    std::cin >> num;
    const double eps = 0.0005;
    double res = 0;
    double prev_res
    double square = 1;
    do {
        prev_res = res;
        res += square;
        square *= num;
    } while (std::abs(res - prev_res) > eps);
    std::cout << res << std::endl;
    return 0;
}
