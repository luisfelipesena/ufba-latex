#include <iostream>
#include <fstream>
#include <random>
using namespace std;

int main() {
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<long long> distA(1000, 8000);
    uniform_int_distribution<long long> distBC(100, 75000000);

    for (int i = 1; i <= 21; i++) {
        ofstream fout;
        char filename[20];
        snprintf(filename, sizeof(filename), "tests/main/%03d.in", i);
        fout.open(filename);

        long long A, B, C;

        if (i == 1) {
            A = 1000; B = 100; C = 100;
        } else if (i == 2) {
            A = 8000; B = 75000000; C = 75000000;
        } else if (i == 3) {
            A = 1234; B = 567; C = 89;
        } else {
            A = distA(gen);
            B = distBC(gen);
            C = distBC(gen);
        }

        fout << A << " " << B << " " << C << endl;
        fout.close();
    }

    return 0;
}
