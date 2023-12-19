#include "main.h"

int getRandomNumb(int left, int right) {
    std::random_device rd;
    std::uniform_int_distribution<int> dist(left, right);
    return dist(rd);
}

int getRandomNumb(int right) {
    return getRandomNumb(1, right);
}
