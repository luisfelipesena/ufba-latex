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

    int left = 0, right = 0;
    int currentSum = 0;
    int maxScore = 0;
    
    while (right < numberOfFigthers) {
        currentSum += healthPointsPerFight[right];
        
        while (currentSum > initialHealthValue && left <= right) {
            currentSum -= healthPointsPerFight[left];
            left++;
        }
        
        if (currentSum <= initialHealthValue) {
            maxScore = max(maxScore, right - left + 1);
        }
        
        right++;
    }


    cout << maxScore << endl;
    return 0;
}

