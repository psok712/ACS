#include <cmath>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

const std::string rarsPath = R"(C:\Users\pavel\IHW3\rars1_6.jar)";
const std::string mainPath = R"(C:\Users\pavel\IHW3\main.asm)";

int main() {
    std::string testPath = R"(C:\Users\pavel\IHW3\tests.txt)";
    std::ifstream fin(testPath);
    std::string filePath;
    std::string ansPath;
    std::string repeatAnswer;
    std::vector<std::string> data{"", "!Hello.Words", ":D ;) !?", "OneDriveCloudMail"};
    int i = 1;
    for (auto& el : data) {
        filePath = R"(C:\Users\pavel\IHW3\file)" + std::to_string(i++) + ".txt";
        std::ofstream fout(filePath);
        fout << el;
    }

    // Generating of separate test files
    i = 1;
    while (fin >> filePath) {
        fin >> ansPath;
        fin >> repeatAnswer;
        std::string separateTestFilePath = R"(C:\Users\pavel\IHW3\test)" + std::to_string(i++) + ".txt";
        std::ofstream fout(separateTestFilePath);
        filePath = R"(C:\Users\pavel\IHW3\)" + filePath; // NOLINT
        ansPath = R"(C:\Users\pavel\IHW3\)" + ansPath; // NOLINT
        fout << filePath << '\n';
        fout << ansPath << '\n';
        fout << repeatAnswer << '\n';
    }

    // Calling our program with generated test files
    for (auto j = 1; j < i; ++j) {
        std::string command = "java -jar " + rarsPath + " "
                              + mainPath + " < " + R"(C:\Users\pavel\IHW3\test)"
                              + std::to_string(j) + ".txt";
        system(command.c_str());
        std::cout << "\n------------------------------------\n";
    }

    return 0;
}
