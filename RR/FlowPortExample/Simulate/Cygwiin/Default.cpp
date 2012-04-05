/********************************************************************
	Rhapsody	: 7.5.3 
	Login		: Administrator
	Component	: Simulate 
	Configuration 	: Cygwiin
	Model Element	: Default
//!	Generated Date	: Thu, 26, May 2011  
	File Path	: Simulate/Cygwiin/Default.cpp
*********************************************************************/

//#[ ignore
#define NAMESPACE_PREFIX
//#]

//## auto_generated
#include "Default.h"
//## classInstance itsA
#include "A.h"
//## classInstance itsB
#include "B.h"
//#[ ignore
#define printB1_SERIALIZE OM_NO_OP

#define printB1_UNSERIALIZE OM_NO_OP

#define printB1_CONSTRUCTOR printB1()
//#]

//## package Default


//## classInstance itsA
A itsA;

//## classInstance itsB
B itsB;

#ifdef _OMINSTRUMENT
static void serializeGlobalVars(AOMSAttributes* aomsAttributes);

static void RenameGlobalInstances();

IMPLEMENT_META_PACKAGE(Default, Default)
#endif // _OMINSTRUMENT

void Default_initRelations() {
    {
        {
            itsA.setShouldDelete(false);
        }
        {
            itsB.setShouldDelete(false);
        }
    }
    {
    	
    	itsA.get_a1_SP()->setItsIntFlowInterface(itsB.get_b1_SP()->getItsIntFlowInterface());
    	
    }
    
    #ifdef _OMINSTRUMENT
    RenameGlobalInstances();
    #endif // _OMINSTRUMENT
}

bool Default_startBehavior() {
    bool done = true;
    done &= itsA.startBehavior();
    done &= itsB.startBehavior();
    return done;
}

#ifdef _OMINSTRUMENT
static void serializeGlobalVars(AOMSAttributes* aomsAttributes) {
}

static void RenameGlobalInstances() {
    OM_SET_INSTANCE_NAME(&itsA, A, "itsA", AOMNoMultiplicity);
    OM_SET_INSTANCE_NAME(&itsB, B, "itsB", AOMNoMultiplicity);
}
#endif // _OMINSTRUMENT

//#[ ignore
Default_OMInitializer::Default_OMInitializer() {
    Default_initRelations();
    Default_startBehavior();
}

Default_OMInitializer::~Default_OMInitializer() {
}
//#]

//## event printB1()
printB1::printB1() {
    NOTIFY_EVENT_CONSTRUCTOR(printB1)
    setId(printB1_Default_id);
}

bool printB1::isTypeOf(short id) const {
    return (printB1_Default_id==id);
}

IMPLEMENT_META_EVENT_P(printB1, Default, Default, printB1())

/*********************************************************************
	File Path	: Simulate/Cygwiin/Default.cpp
*********************************************************************/
