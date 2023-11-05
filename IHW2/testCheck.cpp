#include <iostream>
#include <vector>
#include <string>
#include <fstream>

const std::string pathRars = R"(C:\Users\pavel\IHW2\rars1_6.jar)";
const std::string pathAssemb = R"(C:\Users\pavel\IHW2\main.asm)";

int main() {
    std::vector<double> nums;
    std::string testFilePath = R"(C:\Users\pavel\IHW2\tests.txt)";
    std::ifstream fin(testFilePath);
    std::cout << "File numbers: ";
    int i = 0;
    double x;
    while (fin >> x) {
        std::string new_test_file_path = R"(C:\Users\pavel\IHW2\test)" + std::to_string(i) + ".txt";
        std::ofstream fout;
        fout.open(new_test_file_path);
        fout << x;
        fout.close();
        nums.push_back(x);
        std::cout << x << " ";
        ++i;
    }
    std::cout << '\n';
    for (auto j = 1; j < i; ++j) {
        std::cout << "\n";
        std::cout << j << ". ";
        std::string command = "java -jar " + pathRars + " "
                              + pathAssemb + " < " + R"(C:\Users\pavel\IHW2\test)"
                              + std::to_string(j) + ".txt";
        system(command.c_str());
        if (nums[j] > -1 && nums[j] < 1) {
            std::cout << " (C++ math: " << 1. / (1 - nums[j]) << ")\n";
        }
    }
    return 0;
}
