/*********************************************************************
	Rhapsody in C	: 7.5.3 
	Login		: Administrator
	Component	: DefaultBuild 
	Configuration 	: DefaultConfig
	Model Element	: DefaultConfig
//!	Generated Date	: Sun, 22, May 2011  
	File Path	: DefaultBuild/DefaultConfig/MainDefaultBuild.c
*********************************************************************/

/*## auto_generated */
#include "MainDefaultBuild.h"
/*## auto_generated */
#include "Default.h"
void DefaultBuild_Init(void) {
    Default_initRelations();
    Default_startBehavior();
}

void DefaultBuild_Cleanup(void) {
    Default_OMInitializer_Cleanup();
}

int main(int argc, char* argv[]) {
    int status = 0;
    if(RiCOXFInit(argc, argv, 6423, "v-613f52755eb04", 0, 0, RiCTRUE))
        {
            DefaultBuild_Init();
            /*#[ configuration DefaultBuild::DefaultConfig */
            /*#]*/
            RiCOXFStart(FALSE);
            DefaultBuild_Cleanup();
            status = 0;
        }
    else
        {
            status = 1;
        }
    return status;
}

/*********************************************************************
	File Path	: DefaultBuild/DefaultConfig/MainDefaultBuild.c
*********************************************************************/
