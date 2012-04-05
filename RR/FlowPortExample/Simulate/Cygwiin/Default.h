/*********************************************************************
	Rhapsody	: 7.5.3 
	Login		: Administrator
	Component	: Simulate 
	Configuration 	: Cygwiin
	Model Element	: Default
//!	Generated Date	: Thu, 26, May 2011  
	File Path	: Simulate/Cygwiin/Default.h
*********************************************************************/

#ifndef Default_H
#define Default_H

//## auto_generated
#include <oxf/oxf.h>
//## auto_generated
#include <../Profiles/SysML/SIDefinitions.h>
//## auto_generated
#include <aom/aom.h>
//## auto_generated
#include "stdio.h"
//## auto_generated
#include <oxf/event.h>
//## classInstance itsA
class A;

//## classInstance itsB
class B;

//#[ ignore
#define printB1_Default_id 18601
//#]

//## package Default


//## classInstance itsA
extern A itsA;

//## classInstance itsB
extern B itsB;

//## auto_generated
void Default_initRelations();

//## auto_generated
bool Default_startBehavior();

//#[ ignore
class Default_OMInitializer {
    ////    Constructors and destructors    ////
    
public :

    //## auto_generated
    Default_OMInitializer();
    
    //## auto_generated
    ~Default_OMInitializer();
};
//#]

//## event printB1()
class printB1 : public OMEvent {
    ////    Friends    ////
    
public :

#ifdef _OMINSTRUMENT
    friend class OMAnimatedprintB1;
#endif // _OMINSTRUMENT

    ////    Constructors and destructors    ////
    
    //## auto_generated
    printB1();
    
    ////    Framework operations    ////
    
    //## statechart_method
    bool isTypeOf(short id) const;
};

#ifdef _OMINSTRUMENT
//#[ ignore
class OMAnimatedprintB1 : virtual public AOMEvent {
    DECLARE_META_EVENT(printB1)
};
//#]
#endif // _OMINSTRUMENT

#endif
/*********************************************************************
	File Path	: Simulate/Cygwiin/Default.h
*********************************************************************/
