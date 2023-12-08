#include <iostream>
#include <iomanip>
#include <limits>
#include <ctime>
#include <thread>

const unsigned int SIZE = 100000000;

double *A ;
double *B;

// Number of threads
//const int THREAD_NUMBER = 1;
const int THREAD_NUMBER = 4;

// start function for child threads
void mutVec(int iThread, int iTN, double *arr1, double *arr2, int size, double *sum) {
    *sum = 0;
    for(int i = iThread; i < size; i+=iTN) {
        *sum += arr1[i] * arr2[i];
    }
}

int main() {
    // filling array A and B
    A = new double[SIZE];
    B = new double[SIZE];

    if(A == nullptr || B == nullptr) {
        std::cout << "Incorrect size of vector = " << SIZE << "\n";
        return 1;
    }

    for(int i = 0; i < SIZE; ++i) {
        A[i] = double(i);
        B[i] = double(SIZE - i);
    }

    std::thread *thr[THREAD_NUMBER];
    double sum[THREAD_NUMBER];

    clock_t start_time =  clock(); // start time

    // Creating Threads
    for (int i=0 ; i < THREAD_NUMBER ; i++) {
        thr[i] = new std::thread{mutVec, i, THREAD_NUMBER, A, B, SIZE, (sum + i)};
    }

    double rez = 0.0 ; // to record the final result

    // Terminating Threads
    for (int i=0 ; i < THREAD_NUMBER ; i++) {
        thr[i]->join();
        rez += sum[i];
        delete thr[i];
    }

    clock_t end_time = clock(); // end time

    std::cout << "Vector result = " << rez << "\n" ;
    std::cout << "Counting and assembly time = " << end_time - start_time << "\n";

    delete[] A;
    delete[] B;
    return 0;
}
