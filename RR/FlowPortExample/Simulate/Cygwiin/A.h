/*********************************************************************
	Rhapsody	: 7.5.3 
	Login		: Administrator
	Component	: Simulate 
	Configuration 	: Cygwiin
	Model Element	: A
//!	Generated Date	: Thu, 26, May 2011  
	File Path	: Simulate/Cygwiin/A.h
*********************************************************************/

#ifndef A_H
#define A_H

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
//## class a1_SP_C
#include "intFlowInterface.h"
//## link itsB
class B;

//## package Default

//## class A
class A : public OMReactive {
public :

//#[ ignore
    //## package Default
    class a1_SP_C : public intFlowInterface {
        ////    Constructors and destructors    ////
        
    public :
    
        //## auto_generated
        a1_SP_C();
        
        //## auto_generated
        virtual ~a1_SP_C();
        
        ////    Operations    ////
        
        //## auto_generated
        void SetValue(int data, void * pCaller = NULL);
        
        //## auto_generated
        intFlowInterface* getItsIntFlowInterface();
        
        //## auto_generated
        intFlowInterface* getOutBound();
        
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
    friend class OMAnimatedA;
#endif // _OMINSTRUMENT

    ////    Constructors and destructors    ////
    
    //## auto_generated
    A(IOxfActive* theActiveContext = 0);
    
    //## auto_generated
    ~A();
    
    ////    Operations    ////
    
//#[ ignore
    void setA1(int p_a1);
//#]

    ////    Additional operations    ////
    
    //## auto_generated
    a1_SP_C* getA1_SP() const;
    
    //## auto_generated
    a1_SP_C* get_a1_SP() const;
    
    //## auto_generated
    a1_SP_C* newA1_SP();
    
    //## auto_generated
    void deleteA1_SP();
    
    //## auto_generated
    int getA1() const;
    
    //## auto_generated
    B* getItsB() const;
    
    //## auto_generated
    void setItsB(B* p_B);
    
    //## auto_generated
    virtual bool startBehavior();

protected :

    //## auto_generated
    void initRelations();
    
    //## auto_generated
    void initStatechart();
    
    //## auto_generated
    void cleanUpRelations();
    
    ////    Attributes    ////
    
    int a1;		//## attribute a1
    
    ////    Relations and components    ////
    
    B* itsB;		//## link itsB
    
//#[ ignore
    a1_SP_C* a1_SP;
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
    
    // state_0:
    //## statechart_method
    inline bool state_0_IN() const;
    
    ////    Framework    ////

protected :

//#[ ignore
    enum A_Enum {
        OMNonState = 0,
        state_0 = 1
    };
    
    int rootState_subState;
    
    int rootState_active;
//#]
};

#ifdef _OMINSTRUMENT
//#[ ignore
class OMAnimatedA : virtual public AOMInstance {
    DECLARE_REACTIVE_META(A, OMAnimatedA)
    
    ////    Framework operations    ////
    
public :

    virtual void serializeAttributes(AOMSAttributes* aomsAttributes) const;
    
    virtual void serializeRelations(AOMSRelations* aomsRelations) const;
    
    //## statechart_method
    void rootState_serializeStates(AOMSState* aomsState) const;
    
    //## statechart_method
    void state_0_serializeStates(AOMSState* aomsState) const;
};
//#]
#endif // _OMINSTRUMENT

inline bool A::rootState_IN() const {
    return true;
}

inline bool A::state_0_IN() const {
    return rootState_subState == state_0;
}

#endif
/*********************************************************************
	File Path	: Simulate/Cygwiin/A.h
*********************************************************************/
