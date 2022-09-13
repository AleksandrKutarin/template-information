#include <iostream>

using namespace std;


class Coordinates {
private:
    int first;
    int second;

public:

    Coordinates() {

        first = 5;
        second = 10;

    }

    Coordinates(int _first, int _second) {

        first = _first;
        second = _second;

    }

    Coordinates(const Coordinates& copy) {

        first = copy.first;
        second = copy.second;

    }

    void operator + (const Coordinates& copy) {
        first += copy.first;
        second += copy.second;
    }

    void operator = (const Coordinates& copy) {
        if (this != &copy) {
            first = copy.first;
            second = copy.second;
        }
    }

    void iPrint() {
        std::cout << "Coordinates: " << first << " ; "  << second << "\n";
    }

    friend std::ostream& operator << (std::ostream& cout, Coordinates& copy) {
        cout << "Coordinates: " << copy.first << " ; "  << copy.second << "\n";
        return cout;
    }
};

void exampl() {
    Coordinates XY = Coordinates();
    XY.iPrint();
}

void exampl2() {
    Coordinates XY = Coordinates(5, 10);
    XY.iPrint();
}

void exampl3() {
    Coordinates XY = Coordinates();
    std::cout << XY;
}


int main() {
    exampl();
    exampl2();
    exampl3();
    return 0;
}