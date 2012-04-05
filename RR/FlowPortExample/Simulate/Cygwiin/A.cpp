/********************************************************************
	Rhapsody	: 7.5.3 
	Login		: Administrator
	Component	: Simulate 
	Configuration 	: Cygwiin
	Model Element	: A
//!	Generated Date	: Thu, 26, May 2011  
	File Path	: Simulate/Cygwiin/A.cpp
*********************************************************************/

//#[ ignore
#define NAMESPACE_PREFIX

#define _OMSTATECHART_ANIMATED
//#]

//## auto_generated
#include "A.h"
//## link itsB
#include "B.h"
//#[ ignore
#define Default_A_A_SERIALIZE OM_NO_OP
//#]

//## package Default

//## class A
//#[ ignore
A::a1_SP_C::a1_SP_C() {
    itsIntFlowInterface = NULL;
}

A::a1_SP_C::~a1_SP_C() {
    cleanUpRelations();
}

void A::a1_SP_C::SetValue(int data, void * pCaller) {
    
    if (itsIntFlowInterface != NULL) {
        itsIntFlowInterface->SetValue(data,pCaller);
    }
    
}

intFlowInterface* A::a1_SP_C::getItsIntFlowInterface() {
    return this;
}

intFlowInterface* A::a1_SP_C::getOutBound() {
    return this;
}

void A::a1_SP_C::setItsIntFlowInterface(intFlowInterface* p_intFlowInterface) {
    itsIntFlowInterface = p_intFlowInterface;
}

void A::a1_SP_C::cleanUpRelations() {
    if(itsIntFlowInterface != NULL)
        {
            itsIntFlowInterface = NULL;
        }
}
//#]

A::A(IOxfActive* theActiveContext) {
    NOTIFY_REACTIVE_CONSTRUCTOR(A, A(), 0, Default_A_A_SERIALIZE);
    setActiveContext(theActiveContext, false);
    itsB = NULL;
    initRelations();
    initStatechart();
}

A::~A() {
    NOTIFY_DESTRUCTOR(~A, true);
    cleanUpRelations();
}

//#[ ignore
void A::setA1(int p_a1) {
    if (a1 != p_a1)  {
    	a1 = p_a1;
    	FLOW_DATA_SEND(a1, a1_SP, SetValue, x2String);
    }
}
//#]

A::a1_SP_C* A::getA1_SP() const {
    return a1_SP;
}

A::a1_SP_C* A::get_a1_SP() const {
    return a1_SP;
}

A::a1_SP_C* A::newA1_SP() {
    a1_SP = new A::a1_SP_C;
    return a1_SP;
}

void A::deleteA1_SP() {
    delete a1_SP;
    a1_SP = NULL;
}

int A::getA1() const {
    return a1;
}

B* A::getItsB() const {
    return itsB;
}

void A::setItsB(B* p_B) {
    itsB = p_B;
    if(p_B != NULL)
        {
            NOTIFY_RELATION_ITEM_ADDED("itsB", p_B, false, true);
        }
    else
        {
            NOTIFY_RELATION_CLEARED("itsB");
        }
}

bool A::startBehavior() {
    bool done = false;
    done = OMReactive::startBehavior();
    return done;
}

void A::initRelations() {
    a1_SP = newA1_SP();
}

void A::initStatechart() {
    rootState_subState = OMNonState;
    rootState_active = OMNonState;
}

void A::cleanUpRelations() {
    {
        deleteA1_SP();
    }
    if(itsB != NULL)
        {
            NOTIFY_RELATION_CLEARED("itsB");
            itsB = NULL;
        }
}

void A::rootState_entDef() {
    {
        NOTIFY_STATE_ENTERED("ROOT");
        NOTIFY_TRANSITION_STARTED("0");
        NOTIFY_STATE_ENTERED("ROOT.state_0");
        rootState_subState = state_0;
        rootState_active = state_0;
        //#[ state ROOT.state_0.(Entry) 
        setA1(666);
        //#]
        NOTIFY_TRANSITION_TERMINATED("0");
    }
}

IOxfReactive::TakeEventStatus A::rootState_processEvent() {
    IOxfReactive::TakeEventStatus res = eventNotConsumed;
    return res;
}

#ifdef _OMINSTRUMENT
//#[ ignore
void OMAnimatedA::serializeAttributes(AOMSAttributes* aomsAttributes) const {
    aomsAttributes->addAttribute("a1", x2String(myReal->a1));
}

void OMAnimatedA::serializeRelations(AOMSRelations* aomsRelations) const {
    aomsRelations->addRelation("itsB", false, true);
    if(myReal->itsB)
        {
            aomsRelations->ADD_ITEM(myReal->itsB);
        }
}

void OMAnimatedA::rootState_serializeStates(AOMSState* aomsState) const {
    aomsState->addState("ROOT");
    if(myReal->rootState_subState == A::state_0)
        {
            state_0_serializeStates(aomsState);
        }
}

void OMAnimatedA::state_0_serializeStates(AOMSState* aomsState) const {
    aomsState->addState("ROOT.state_0");
}
//#]

IMPLEMENT_REACTIVE_META_P(A, Default, Default, false, OMAnimatedA)
#endif // _OMINSTRUMENT

/*********************************************************************
	File Path	: Simulate/Cygwiin/A.cpp
*********************************************************************/
