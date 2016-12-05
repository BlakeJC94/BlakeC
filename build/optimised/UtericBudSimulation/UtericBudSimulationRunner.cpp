/* Generated file, do not edit */

#ifndef CXXTEST_RUNNING
#define CXXTEST_RUNNING
#endif

#define _CXXTEST_HAVE_STD
#define _CXXTEST_HAVE_EH
#include <cxxtest/TestListener.h>
#include <cxxtest/TestTracker.h>
#include <cxxtest/TestRunner.h>
#include <cxxtest/RealDescriptions.h>
#include <cxxtest/ErrorPrinter.h>

#include "CommandLineArguments.hpp"
int main( int argc, char *argv[] ) {
 CommandLineArguments::Instance()->p_argc = &argc;
 CommandLineArguments::Instance()->p_argv = &argv;
 return CxxTest::ErrorPrinter().run();
}
#include "projects/BlakeC/test/UtericBudSimulation/UtericBudSimulation.hpp"

static UtericBudSimulation suite_UtericBudSimulation;

static CxxTest::List Tests_UtericBudSimulation = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_UtericBudSimulation( "projects/BlakeC/test/UtericBudSimulation/UtericBudSimulation.hpp", 63, "UtericBudSimulation", suite_UtericBudSimulation, Tests_UtericBudSimulation );

static class TestDescription_UtericBudSimulation_TestUtericBudSimulation : public CxxTest::RealTestDescription {
public:
 TestDescription_UtericBudSimulation_TestUtericBudSimulation() : CxxTest::RealTestDescription( Tests_UtericBudSimulation, suiteDescription_UtericBudSimulation, 66, "TestUtericBudSimulation" ) {}
 void runTest() { suite_UtericBudSimulation.TestUtericBudSimulation(); }
} testDescription_UtericBudSimulation_TestUtericBudSimulation;

#include <cxxtest/Root.cpp>
