#include "random.h"

void *visitorPth(void *arg) {
    int visitorId = *(static_cast<int *>(arg));
    delete static_cast<int *>(arg);

    for (int i = 0; i < COUNT_PAINTINGS; ++i) {
        pthread_mutex_lock(&mutex);

        while (countSpectators[i] >= SPECTATORS_PAINTING) {
            outputProgram.emplace_back("Painting " + std::to_string(i + 1) + " crowded.");
            pthread_cond_wait(&cond, &mutex);
        }

        ++countSpectators[i];
        ++countVisitors;
        outputProgram.emplace_back(
                "To the picture " + std::to_string(i + 1) + " are watching " + std::to_string(countSpectators[i]) +
                ".");
        pthread_mutex_unlock(&mutex);

        sleep(getRandomNumb(MAX_WAITING_TIME));

        pthread_mutex_lock(&mutex);

        --countVisitors;
        --countSpectators[i];
        outputProgram.emplace_back(
                "To the picture " + std::to_string(i + 1) + " the visitor " + std::to_string(visitorId) +
                " is no longer looking.");

        pthread_cond_signal(&cond);
        pthread_mutex_unlock(&mutex);
    }

    outputProgram.emplace_back(
            "Visitor " + std::to_string(visitorId) + " looked through all the paintings and left the gallery.");

    return nullptr;
}
