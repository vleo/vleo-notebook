/*********************************************************************
	Rhapsody in C	: 7.5.3 
	Login		: Administrator
	Component	: DefaultBuild 
	Configuration 	: DefaultConfig
	Model Element	: BSDServer
//!	Generated Date	: Sun, 22, May 2011  
	File Path	: DefaultBuild/DefaultConfig/BSDServer.h
*********************************************************************/

#ifndef BSDServer_H
#define BSDServer_H

/*## auto_generated */
#include <oxf/Ric.h>
/*## auto_generated */
#include "stdio.h"
/*## auto_generated */
#include "winsock.h"
/*## auto_generated */
#include "Default.h"
/*## auto_generated */
#include <oxf/RiCReactive.h>
/*## auto_generated */
#include <oxf/RiCEvent.h>
/*## package Default */

/*## class TopLevel::BSDServer */
/*#[ ignore */
/* <sys/types.h>, <sys/socket.h>, <netinet/in.h>, <arpa/inet.h>, <stdio.h>, <stdlib.h>, <string.h>, <unistd.h> */
/*#]*/
/*#[ ignore */
struct BSDServer_t {
    RiCReactive ric_reactive;
    int rootState_subState;
    int rootState_active;
};
/*#]*/

/*## attribute ConnectFD */
extern int ConnectFD;

/*## attribute SocketFD */
extern int SocketFD;

/*## attribute stSockAddr */
extern struct sockaddr_in stSockAddr;

/*## classInstance BSDServer.BSDServer */
extern struct BSDServer_t BSDServer;

/***    User implicit entries    ***/


/* Constructors and destructors:*/

/*## auto_generated */
void BSDServer_Init(RiCTask * p_task);

/*## auto_generated */
void BSDServer_Cleanup(void);

/***    User explicit entries    ***/


/* Operations */

/*## operation function000(int) */
int function000(int n);

/*## auto_generated */
void BSDServer_initRelations(void);

/*## auto_generated */
RiCBoolean BSDServer_startBehavior(void);

/***    User explicit entries    ***/

/***    User implicit entries    ***/

/***    Framework entries    ***/

/* rootState: */
/*## statechart_method */
int BSDServer_rootState_IN(const struct BSDServer_t* const me);

/* initial: */
/*## statechart_method */
int BSDServer_initial_IN(const struct BSDServer_t* const me);

/*#[ ignore */
enum BSDServer_Enum {
    BSDServer_RiCNonState = 0,
    BSDServer_initial = 1
};
/*#]*/

#endif
/*********************************************************************
	File Path	: DefaultBuild/DefaultConfig/BSDServer.h
*********************************************************************/
