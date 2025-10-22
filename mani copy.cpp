// C++ Template
#include <iostream>
#include <vector>
using namespace std;

int main() {
    int numberOfFigthers, initialHealthValue;
    cin >> numberOfFigthers >> initialHealthValue;
    int healthPointsPerFight[numberOfFigthers];

    for (int i = 0; i < numberOfFigthers; i++) {
        cin >> healthPointsPerFight[i];
    }

    int maxScore = 0;
    for (int i = 0; i < numberOfFigthers; i++) {
      int accPoints = 0;
      int fightsNumber = 0;

      while (i + fightsNumber < numberOfFigthers && accPoints <= initialHealthValue) {
        int possibleResult = accPoints + healthPointsPerFight[i + fightsNumber];
        if (possibleResult > initialHealthValue) {
          break;
        }

        accPoints = possibleResult;
        fightsNumber++;
      }

      if (fightsNumber > maxScore) {
        maxScore = fightsNumber;
      }
    }


    cout << maxScore << endl;
    return 0;
}

