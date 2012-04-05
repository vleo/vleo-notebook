/*********************************************************************
	Rhapsody	: 7.5.3 
	Login		: Administrator
	Component	: Simulate 
	Configuration 	: Cygwiin
	Model Element	: intFlowInterface
//!	Generated Date	: Thu, 26, May 2011  
	File Path	: Simulate/Cygwiin/intFlowInterface.h
*********************************************************************/

#ifndef intFlowInterface_H
#define intFlowInterface_H

//## auto_generated
#include <oxf/oxf.h>
//## auto_generated
#include <../Profiles/SysML/SIDefinitions.h>
//## auto_generated
#include <aom/aom.h>
//## auto_generated
#include "stdio.h"
//## auto_generated
#include "FlowPortInterfaces.h"
//#[ ignore
//## package FlowPortInterfaces

//## ignore
class intFlowInterface {
    ////    Constructors and destructors    ////
    
public :

    //## auto_generated
    intFlowInterface();
    
    //## auto_generated
    virtual ~intFlowInterface() = 0;
    
    ////    Operations    ////
    
    //## operation SetValue(int,void *)
    virtual void SetValue(int data, void * pCaller = NULL) = 0;
};
//#]

#endif
/*********************************************************************
	File Path	: Simulate/Cygwiin/intFlowInterface.h
*********************************************************************/
