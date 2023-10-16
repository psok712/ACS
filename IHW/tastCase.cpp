#include <iostream>
#include <vector>
#include <string>
#include <fstream>

const std::string pathRars = R"(C:\Users\pavel\IHW1\rars1_6.jar)";
const std::string pathAssemb = R"(C:\Users\pavel\IHW1\main.asm)";

int main() {
    std::vector<std::string> vector;

    for (int i = 0; i < 6; ++i) {
        std::string str = "java -jar " + pathRars + " " + pathAssemb + " < "
                + R"(C:\Users\pavel\IHW1\test_case)"
                + std::to_string(i + 1) + ".txt";
        vector.push_back(str);
    }

    for (int i = 0; i < vector.size(); ++i) {
        std::string pathTestCase = R"(C:\Users\pavel\IHW1\test_case)"
                + std::to_string(i + 1) + ".txt";
        std::ifstream fin(pathTestCase);
        std::cout << i + 1 << ". Test content: ";
        int numb;
        while (!fin.eof()) {
            fin >> numb;
            std::cout << numb << " ";
        }
        std::cout << std::endl;
        const char* command = vector[i].c_str();
        system(command);
        std::cout << "\n-------------------------------------------------------------------------------------------\n";
    }
    return 0;
}
