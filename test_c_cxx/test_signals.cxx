// This sample demonstrates how try {} block disables handler set by signal()
// on MinGW-w64 with GCC SJLJ build
#include <signal.h>
#include <iostream>

int izero = 0;

static void SIGWntHandler (int signum)//sub_code)
{
  std::cout << "In signal handler, signum = " << signum << std::endl;
  std::cout << "Now exiting..." << std::endl;
  std::exit(1);
}

int main (void)
{
  std::cout << "Entered main(), arming signal handler..." << std::endl;
  if (signal (SIGSEGV, (void(*)(int))SIGWntHandler) == SIG_ERR)
    std::cout << "signal(OSD::SetSignal) error\n";
  if (signal (SIGFPE, (void(*)(int))SIGWntHandler) == SIG_ERR)
    std::cout << "signal(OSD::SetSignal) error\n";
  if (signal (SIGILL, (void(*)(int))SIGWntHandler) == SIG_ERR)
    std::cout << "signal(OSD::SetSignal) error\n";

  // this try block disables signal handler...
  try { std::cout << "In try block" << std::endl; } catch(char*) {}

  std::cout << "Doing bad things to cause signal..." << std::endl;
  izero = 1 / izero; // cause integer division by zero
  char* ptrnull = 0;
  ptrnull[0] = '\0'; // cause access violation

  std::cout << "We are too lucky..." << std::endl;
  return 0;
}
