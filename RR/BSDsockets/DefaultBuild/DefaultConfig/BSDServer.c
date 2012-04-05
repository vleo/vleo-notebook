/*********************************************************************
	Rhapsody in C	: 7.5.3 
	Login		: Administrator
	Component	: DefaultBuild 
	Configuration 	: DefaultConfig
	Model Element	: BSDServer
//!	Generated Date	: Sun, 22, May 2011  
	File Path	: DefaultBuild/DefaultConfig/BSDServer.c
*********************************************************************/

/*## auto_generated */
#include <oxf/RiCTask.h>
/*## auto_generated */
#include <stdio.h>
/*## auto_generated */
#include "BSDServer.h"
/*## package Default */

/*## class TopLevel::BSDServer */
/*## attribute ConnectFD */
int ConnectFD;

/*## attribute SocketFD */
int SocketFD;

/*## attribute stSockAddr */
struct sockaddr_in stSockAddr;

/*## classInstance BSDServer.BSDServer */
struct BSDServer_t BSDServer;

/*## auto_generated */
static void BSDServer_initStatechart(void);

/*## statechart_method */
static void BSDServer_rootState_entDef(void * const void_me);

/*## statechart_method */
static RiCTakeEventStatus BSDServer_rootState_dispatchEvent(void * const void_me, short id);

void BSDServer_Init(RiCTask * p_task) {
    /* Virtual tables Initialization */
    static const RiCReactive_Vtbl BSDServer_reactiveVtbl = {
        BSDServer_rootState_dispatchEvent,
        BSDServer_rootState_entDef,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
    };
    RiCReactive_init(&(BSDServer.ric_reactive), (void*)&BSDServer, p_task, &BSDServer_reactiveVtbl);
    RiCReactive_setActive(&(BSDServer.ric_reactive), RiCFALSE);
    BSDServer_initStatechart();
}

void BSDServer_Cleanup(void) {
    RiCReactive_cleanup(&(BSDServer.ric_reactive));
}

/*## operation function000(int) */
int function000(int n) {
    /*#[ operation function000(int) */
    WSADATA ws;
    WSAStartup(0x0101,&ws);
    
        SocketFD = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
     
        if(SocketFD<0)
        {
          perror("can not create socket");
          printf("SocketFD= %d WSAGetLastError= %d\n",SocketFD,WSAGetLastError());
          exit(EXIT_FAILURE);                
        }
     
        memset(&stSockAddr, 0, sizeof(stSockAddr));
     
        stSockAddr.sin_family = AF_INET;
        stSockAddr.sin_port = htons(1100);
        stSockAddr.sin_addr.s_addr = INADDR_ANY;
     
        if(-1 == bind(SocketFD,(struct sockaddr *)&stSockAddr, sizeof(stSockAddr)))
        {
          perror("bind failed");
          close(SocketFD);
          exit(EXIT_FAILURE);
        }
     
        if(-1 == listen(SocketFD, 10))
        {
          perror("error listen failed");
          close(SocketFD);
          exit(EXIT_FAILURE);
        }
     
        for(;;)
        {
          ConnectFD = accept(SocketFD, NULL, NULL);
     
          if(0 > ConnectFD)
          {
            perror("error accept failed");
            close(SocketFD);
            exit(EXIT_FAILURE);
          }
     
         /* perform read write operations ... 
         read(sockfd,buff,size)*/
     
          shutdown(ConnectFD, 2);
     
          close(ConnectFD);
        }
     
        close(SocketFD);
        return 0;
    /*#]*/
}

void BSDServer_initRelations(void) {
    BSDServer_Init(RiCMainTask());
}

RiCBoolean BSDServer_startBehavior(void) {
    RiCBoolean done = RiCFALSE;
    done = RiCReactive_startBehavior(&(BSDServer.ric_reactive));
    return done;
}

static void BSDServer_initStatechart(void) {
    BSDServer.rootState_subState = BSDServer_RiCNonState;
    BSDServer.rootState_active = BSDServer_RiCNonState;
}

int BSDServer_rootState_IN(const struct BSDServer_t* const me) {
    return 1;
}

int BSDServer_initial_IN(const struct BSDServer_t* const me) {
    return BSDServer.rootState_subState == BSDServer_initial;
}

static void BSDServer_rootState_entDef(void * const void_me) {
    {
        BSDServer.rootState_subState = BSDServer_initial;
        BSDServer.rootState_active = BSDServer_initial;
        {
            /*#[ state ROOT.initial.(Entry) */
            function000(123);
            /*#]*/
        }
    }
}

static RiCTakeEventStatus BSDServer_rootState_dispatchEvent(void * const void_me, short id) {
    RiCTakeEventStatus res = eventNotConsumed;
    return res;
}

/*********************************************************************
	File Path	: DefaultBuild/DefaultConfig/BSDServer.c
*********************************************************************/
