#import <Foundation/Foundation.h>

@interface SampleClass:NSObject {
  int v;
}
/* method declaration */
- (id)initWithInt:(int)vv;
//- (int)max:(int)num1 andNum2:(int)num2;
- (int)max:(int)num1 :(int)num2;
- (int)getV;
@end

@implementation SampleClass

/* method returning the max between two numbers */
- (id)initWithInt:(int) vv {
    
    if( (self=[super init]) ) {
      printf("self=%p\n",self);
      v = vv;
    }
    return self;
  }
- (int)getV {
    return v;
  }
//- (int)max:(int)num1 andNum2:(int)num2{
- (int)max:(int)num1 :(int)num2 {
/* local variable declaration */
   int result;
 
   if (num1 > num2)
   {
      result = num1;
   }
   else
   {
      result = num2;
   }
 
   return result; 
}

@end

int main ()
{
   NSAutoreleasePool *pool = [NSAutoreleasePool new];

   /* local variable definition */
   int a = 100;
   int b = 200;
   int ret;
   
   SampleClass *sampleClass = [[SampleClass alloc] initWithInt:123];

   /* calling a method to get max value */
   ret = [sampleClass max:a :b];
   printf("Max value is: %d\n",ret);
 
   ret = [sampleClass getV];
   NSLog(@"sampleClass.v is : %d\n", ret );

   [pool drain];
 
   return 0;

}
