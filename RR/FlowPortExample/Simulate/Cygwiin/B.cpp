/********************************************************************
	Rhapsody	: 7.5.3 
	Login		: Administrator
	Component	: Simulate 
	Configuration 	: Cygwiin
	Model Element	: B
//!	Generated Date	: Thu, 26, May 2011  
	File Path	: Simulate/Cygwiin/B.cpp
*********************************************************************/

//#[ ignore
#define NAMESPACE_PREFIX

#define _OMSTATECHART_ANIMATED
//#]

//## auto_generated
#include "B.h"
//#[ ignore
#define Default_B_B_SERIALIZE OM_NO_OP
//#]

//## package Default

//## class B
//#[ ignore
B::b1_SP_C::b1_SP_C() {
    itsIntFlowInterface = NULL;
}

B::b1_SP_C::~b1_SP_C() {
    cleanUpRelations();
}

void B::b1_SP_C::SetValue(int data, void * pCaller) {
    
    if (itsIntFlowInterface != NULL) {
        itsIntFlowInterface->SetValue(data,this);
    }
    
}

void B::b1_SP_C::connectB(B* part) {
    setItsIntFlowInterface(part);
    
}

intFlowInterface* B::b1_SP_C::getItsIntFlowInterface() {
    return this;
}

void B::b1_SP_C::setItsIntFlowInterface(intFlowInterface* p_intFlowInterface) {
    itsIntFlowInterface = p_intFlowInterface;
}

void B::b1_SP_C::cleanUpRelations() {
    if(itsIntFlowInterface != NULL)
        {
            itsIntFlowInterface = NULL;
        }
}
//#]

B::B(IOxfActive* theActiveContext) {
    NOTIFY_REACTIVE_CONSTRUCTOR(B, B(), 0, Default_B_B_SERIALIZE);
    setActiveContext(theActiveContext, false);
    initRelations();
    initStatechart();
    //#[ operation B()
    b1=123;
    //#]
}

B::~B() {
    NOTIFY_DESTRUCTOR(~B, true);
    cleanUpRelations();
    cancelTimeouts();
}

//#[ ignore
void B::SetValue(int data, void * pCaller) {
    if (pCaller == (void *)get_b1_SP()) {
    	setB1(data);
    }
}

void B::setB1(int p_b1) {
    if (b1 != p_b1) {
    	b1 = p_b1;
    	FLOW_DATA_RECEIVE("b1", b1, x2String);
    }
    
}
//#]

B::b1_SP_C* B::getB1_SP() const {
    return b1_SP;
}

B::b1_SP_C* B::get_b1_SP() const {
    return b1_SP;
}

B::b1_SP_C* B::newB1_SP() {
    b1_SP = new B::b1_SP_C;
    return b1_SP;
}

void B::deleteB1_SP() {
    delete b1_SP;
    b1_SP = NULL;
}

int B::getB1() const {
    return b1;
}

bool B::startBehavior() {
    bool done = false;
    done = OMReactive::startBehavior();
    return done;
}

void B::initRelations() {
    b1_SP = newB1_SP();
    if (get_b1_SP() != NULL) {
    	get_b1_SP()->connectB(this);
    }
}

void B::initStatechart() {
    rootState_subState = OMNonState;
    rootState_active = OMNonState;
    rootState_timeout = NULL;
}

void B::cleanUpRelations() {
    {
        deleteB1_SP();
    }
}

void B::cancelTimeouts() {
    if(rootState_timeout != NULL)
        {
            rootState_timeout->cancel();
            rootState_timeout = NULL;
        }
}

bool B::cancelTimeout(const IOxfTimeout* arg) {
    bool res = false;
    if(rootState_timeout == arg)
        {
            rootState_timeout = NULL;
            res = true;
        }
    return res;
}

void B::rootState_entDef() {
    {
        NOTIFY_STATE_ENTERED("ROOT");
        NOTIFY_TRANSITION_STARTED("0");
        NOTIFY_STATE_ENTERED("ROOT.state_0");
        rootState_subState = state_0;
        rootState_active = state_0;
        rootState_timeout = scheduleTimeout(100, "ROOT.state_0");
        NOTIFY_TRANSITION_TERMINATED("0");
    }
}

IOxfReactive::TakeEventStatus B::rootState_processEvent() {
    IOxfReactive::TakeEventStatus res = eventNotConsumed;
    if(rootState_active == state_0)
        {
            if(IS_EVENT_TYPE_OF(OMTimeoutEventId))
                {
                    if(getCurrentEvent() == rootState_timeout)
                        {
                            NOTIFY_TRANSITION_STARTED("1");
                            if(rootState_timeout != NULL)
                                {
                                    rootState_timeout->cancel();
                                    rootState_timeout = NULL;
                                }
                            NOTIFY_STATE_EXITED("ROOT.state_0");
                            NOTIFY_STATE_ENTERED("ROOT.state_1");
                            rootState_subState = state_1;
                            rootState_active = state_1;
                            //#[ state ROOT.state_1.(Entry) 
                            printf("B::b1= %d\n",getB1());
                            //#]
                            NOTIFY_TRANSITION_TERMINATED("1");
                            res = eventConsumed;
                        }
                }
            
        }
    return res;
}

#ifdef _OMINSTRUMENT
//#[ ignore
void OMAnimatedB::serializeAttributes(AOMSAttributes* aomsAttributes) const {
    aomsAttributes->addAttribute("b1", x2String(myReal->b1));
}

void OMAnimatedB::serializeRelations(AOMSRelations* aomsRelations) const {
}

void OMAnimatedB::rootState_serializeStates(AOMSState* aomsState) const {
    aomsState->addState("ROOT");
    switch (myReal->rootState_subState) {
        case B::state_0:
        {
            state_0_serializeStates(aomsState);
        }
        break;
        case B::state_1:
        {
            state_1_serializeStates(aomsState);
        }
        break;
        default:
            break;
    }
}

void OMAnimatedB::state_1_serializeStates(AOMSState* aomsState) const {
    aomsState->addState("ROOT.state_1");
}

void OMAnimatedB::state_0_serializeStates(AOMSState* aomsState) const {
    aomsState->addState("ROOT.state_0");
}
//#]

IMPLEMENT_REACTIVE_META_P(B, Default, Default, false, OMAnimatedB)
#endif // _OMINSTRUMENT

/*********************************************************************
	File Path	: Simulate/Cygwiin/B.cpp
*********************************************************************/
