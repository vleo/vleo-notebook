/********************************************************************
	Rhapsody	: 7.5.3 
	Login		: Administrator
	Component	: Simulate 
	Configuration 	: Cygwiin
	Model Element	: Cygwiin
//!	Generated Date	: Thu, 26, May 2011  
	File Path	: Simulate/Cygwiin/MainSimulate.cpp
*********************************************************************/

//## auto_generated
#include "MainSimulate.h"
//## auto_generated
#include "Default.h"
Simulate::Simulate() {
    Default_initRelations();
    Default_startBehavior();
}

int main(int argc, char* argv[]) {
    int status = 0;
    if(OXF::initialize(argc, argv, 6423, "v-613f52755eb04"))
        {
            Simulate initializer_Simulate;
            //#[ configuration Simulate::Cygwiin 
            //#]
            OXF::start();
            status = 0;
        }
    else
        {
            status = 1;
        }
    return status;
}

/*********************************************************************
	File Path	: Simulate/Cygwiin/MainSimulate.cpp
*********************************************************************/
