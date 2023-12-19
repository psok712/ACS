#include "watchman.h"

int main() {
    for (int k = 1; k < 6; ++k) {
        std::string answerOutputFile;
        std::ofstream out;
        std::ifstream in("input" + std::to_string(k) + ".txt");
        std::cout << "Enter the number of visitors to the gallery:" << std::endl;
        in >> visitors;

        std::vector<pthread_t> vecVisitor(visitors);
        pthread_t watchmanPtr;

        pthread_create(&watchmanPtr, nullptr, watchmanPth, static_cast<void *>(new int(0)));
        outputProgram.emplace_back("The gallery is open! The watchman begins to let visitors in.");

        for (int i = 0; i < visitors; ++i) {
            pthread_create(&vecVisitor[i], nullptr, visitorPth, static_cast<void *>(new int(i + 1)));
            if (i > MAX_VISITORS) {
                outputProgram.emplace_back("Visitor " + std::to_string(i + 1) + " comes to the gallery and waits.");
            } else {
                outputProgram.emplace_back("Visitor " + std::to_string(i + 1) + " came to the gallery.");
            }
        }

        for (int i = 0; i < visitors; ++i) {
            pthread_join(vecVisitor[i], nullptr);
        }

        pthread_cancel(watchmanPtr);
        pthread_join(watchmanPtr, nullptr);
        outputProgram.emplace_back("The gallery is closed! We look forward to seeing you all next time.");



        std::cout << "Do you want to save the answer to a file? Enter Y/N:" << std::endl;
        in >> answerOutputFile;

        if (answerOutputFile == "Y") {
            std::string nameFile;
            std::cout << "Enter name file:" << std::endl;
            in >> nameFile;
            out.open(nameFile + ".txt");

            for (auto &el: outputProgram) {
                out << el << std::endl;
            }

            out.close();
        }


        std::cout << "Do you want to print the response to the console? Enter Y/N: " << std::endl;
        in >> answerOutputFile;

        if (answerOutputFile == "Y") {
            for (auto &el: outputProgram) {
                std::cout << el << std::endl;
            }
        }

        outputProgram.clear();
    }

    return 0;
}
