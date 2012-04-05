/*********************************************************************
	Rhapsody	: 7.5.3 
	Login		: Administrator
	Component	: Simulate 
	Configuration 	: Cygwiin
	Model Element	: B
//!	Generated Date	: Thu, 26, May 2011  
	File Path	: Simulate/Cygwiin/B.h
*********************************************************************/

#ifndef B_H
#define B_H

//## auto_generated
#include <oxf/oxf.h>
//## auto_generated
#include <../Profiles/SysML/SIDefinitions.h>
//## auto_generated
#include <aom/aom.h>
//## auto_generated
#include "stdio.h"
//## auto_generated
#include "Default.h"
//## auto_generated
#include <oxf/omthread.h>
//## auto_generated
#include <oxf/omreactive.h>
//## auto_generated
#include <oxf/state.h>
//## auto_generated
#include <oxf/event.h>
//## class B
#include "intFlowInterface.h"
//## package Default

//## class B
class B : public OMReactive, public intFlowInterface {
public :

//#[ ignore
    //## package Default
    class b1_SP_C : public intFlowInterface {
        ////    Constructors and destructors    ////
        
    public :
    
        //## auto_generated
        b1_SP_C();
        
        //## auto_generated
        virtual ~b1_SP_C();
        
        ////    Operations    ////
        
        //## auto_generated
        void SetValue(int data, void * pCaller = NULL);
        
        //## auto_generated
        void connectB(B* part);
        
        //## auto_generated
        intFlowInterface* getItsIntFlowInterface();
        
        ////    Additional operations    ////
        
        //## auto_generated
        void setItsIntFlowInterface(intFlowInterface* p_intFlowInterface);
    
    protected :
    
        //## auto_generated
        void cleanUpRelations();
        
        ////    Attributes    ////
        
        int _p_;		//## attribute _p_
        
        ////    Relations and components    ////
        
        intFlowInterface* itsIntFlowInterface;		//## link itsIntFlowInterface
    };
//#]

    ////    Friends    ////
    
#ifdef _OMINSTRUMENT
    friend class OMAnimatedB;
#endif // _OMINSTRUMENT

    ////    Constructors and destructors    ////
    
    //## operation B()
    B(IOxfActive* theActiveContext = 0);
    
    //## auto_generated
    ~B();
    
    ////    Operations    ////
    
//#[ ignore
    void SetValue(int data, void * pCaller = NULL);
    
    void setB1(int p_b1);
//#]

    ////    Additional operations    ////
    
    //## auto_generated
    b1_SP_C* getB1_SP() const;
    
    //## auto_generated
    b1_SP_C* get_b1_SP() const;
    
    //## auto_generated
    b1_SP_C* newB1_SP();
    
    //## auto_generated
    void deleteB1_SP();
    
    //## auto_generated
    int getB1() const;
    
    //## auto_generated
    virtual bool startBehavior();

protected :

    //## auto_generated
    void initRelations();
    
    //## auto_generated
    void initStatechart();
    
    //## auto_generated
    void cleanUpRelations();
    
    //## auto_generated
    void cancelTimeouts();
    
    //## auto_generated
    bool cancelTimeout(const IOxfTimeout* arg);
    
    ////    Attributes    ////
    
    int b1;		//## attribute b1
    
    ////    Relations and components    ////
    
//#[ ignore
    b1_SP_C* b1_SP;
//#]

    ////    Framework operations    ////

public :

    // rootState:
    //## statechart_method
    inline bool rootState_IN() const;
    
    //## statechart_method
    virtual void rootState_entDef();
    
    //## statechart_method
    virtual IOxfReactive::TakeEventStatus rootState_processEvent();
    
    // state_1:
    //## statechart_method
    inline bool state_1_IN() const;
    
    // state_0:
    //## statechart_method
    inline bool state_0_IN() const;
    
    ////    Framework    ////

protected :

//#[ ignore
    enum B_Enum {
        OMNonState = 0,
        state_1 = 1,
        state_0 = 2
    };
    
    int rootState_subState;
    
    int rootState_active;
    
    IOxfTimeout* rootState_timeout;
//#]
};

#ifdef _OMINSTRUMENT
//#[ ignore
class OMAnimatedB : virtual public AOMInstance {
    DECLARE_REACTIVE_META(B, OMAnimatedB)
    
    ////    Framework operations    ////
    
public :

    virtual void serializeAttributes(AOMSAttributes* aomsAttributes) const;
    
    virtual void serializeRelations(AOMSRelations* aomsRelations) const;
    
    //## statechart_method
    void rootState_serializeStates(AOMSState* aomsState) const;
    
    //## statechart_method
    void state_1_serializeStates(AOMSState* aomsState) const;
    
    //## statechart_method
    void state_0_serializeStates(AOMSState* aomsState) const;
};
//#]
#endif // _OMINSTRUMENT

inline bool B::rootState_IN() const {
    return true;
}

inline bool B::state_1_IN() const {
    return rootState_subState == state_1;
}

inline bool B::state_0_IN() const {
    return rootState_subState == state_0;
}

#endif
/*********************************************************************
	File Path	: Simulate/Cygwiin/B.h
*********************************************************************/
