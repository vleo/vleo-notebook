/*********************************************************************
	Rhapsody in C	: 7.5.3 
	Login		: Administrator
	Component	: DefaultBuild 
	Configuration 	: DefaultConfig
	Model Element	: Default
//!	Generated Date	: Sun, 22, May 2011  
	File Path	: DefaultBuild/DefaultConfig/Default.c
*********************************************************************/

/*## auto_generated */
#include "Default.h"
/*## file BSDServer */
#include "BSDServer.h"
/*## package Default */


void Default_OMInitializer_Init(void) {
    Default_initRelations();
    Default_startBehavior();
}

void Default_OMInitializer_Cleanup(void) {
}

void Default_initRelations(void) {
    BSDServer_initRelations();
}

RiCBoolean Default_startBehavior(void) {
    RiCBoolean done = RiCTRUE;
    done &= BSDServer_startBehavior();
    return done;
}

/*********************************************************************
	File Path	: DefaultBuild/DefaultConfig/Default.c
*********************************************************************/
