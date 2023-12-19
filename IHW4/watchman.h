#include "visitor.h"

void *watchmanPth(void *arg) {
    int countVis = (*static_cast<int *>(arg));

    if (countVis > 0 && countVis <= MAX_VISITORS) { // NOLINT
        pthread_mutex_lock(&mutex);
        outputProgram.emplace_back("Checking paintings by a guard:");

        for (int i = 0; i < COUNT_PAINTINGS; ++i) {
            if (countSpectators[i] <= SPECTATORS_PAINTING) {
                continue;
            }

            outputProgram.emplace_back(
                    "To the picture numbered " + std::to_string(i + 1) + " 10 people are watching. You need to wait.");
            pthread_cond_wait(&cond, &mutex);
        }

        pthread_mutex_unlock(&mutex);
        sleep(1);
    }

    return nullptr;
}
