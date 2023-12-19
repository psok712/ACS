#include <iostream>
#include <pthread.h>
#include <unistd.h>
#include <cstdlib>
#include <random>
#include <semaphore.h>
#include <fstream>

const int SPECTATORS_PAINTING = 10;
const int COUNT_PAINTINGS = 5;
int visitors;
const int MAX_WAITING_TIME = 7;
const int MAX_VISITORS = 50;

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
std::vector<std::string> outputProgram;
int countVisitors = 0;
std::vector<int> countSpectators(COUNT_PAINTINGS, 0);
