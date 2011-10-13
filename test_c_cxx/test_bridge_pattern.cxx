/*
 * Sample Code describing usage of bridge Design Pattern
  */
#include <iostream>
//#include <iomanip>
#include <string.h>

using namespace std;

class CTimeImp {
public:
    CTimeImp(int hr, int min) {
        m_nHr = hr;
        m_nMin = min;
    }
    virtual void tell() {
        cout << "time is " << m_nHr << m_nMin << endl;
    }
protected:
    int m_nHr, m_nMin;
};

class CCivilianCTimeImp: public CTimeImp {
public:
    CCivilianCTimeImp(int hr, int min, int pm): CTimeImp(hr, min) {
        if (pm) {
            strcpy(m_cWhichM, " PM");
        }
        else {
            strcpy(m_cWhichM, " AM");
        }
    }
    /*
          * virtual
                */
    void tell() {
        cout << "time is " << m_nHr << ":" << m_nMin << m_cWhichM << endl;
    }
protected:
    char m_cWhichM[4];
};

class CZuluCTimeImp: public CTimeImp {
public:
    CZuluCTimeImp(int hr, int min, int zone): CTimeImp(hr, min) {
        if (zone == 5) {
            strcpy(m_cZone, " Eastern Standard Time");
        }
        else if (zone == 6) {
            strcpy(m_cZone, " Central Standard Time");
        }
    }
    /*
                * virtual
                            */
    void tell() {
        cout << "time is " << m_nHr << m_nMin << m_cZone << endl;
    }
protected:
    char m_cZone[30];
};

class CTime {
public:
    CTime() {
    }
    CTime(int hr, int min) {
        imp_ = new CTimeImp(hr, min);
    }
    virtual void tell() {
        imp_->tell();
    }
protected:
    CTimeImp *imp_;
};

class CCivilianTime: public CTime {
public:
    CCivilianTime(int hr, int min, int pm) {
        imp_ = new CCivilianCTimeImp(hr, min, pm);
    }
};

class CZuluTime: public CTime {
public:
    CZuluTime(int hr, int min, int zone) {
        imp_ = new CZuluCTimeImp(hr, min, zone);
    }
};

int main() {    // main begins
    CTime *times[3];
    times[0] = new CTime(14, 30);
    times[1] = new CCivilianTime(2, 30, 1);
    times[2] = new CZuluTime(14, 30, 6);
    for (int i = 0; i < 3; i++) {
        times[i]->tell();
    }
    return 0;
}    //main ends
