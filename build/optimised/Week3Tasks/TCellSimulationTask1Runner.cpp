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
#include "projects/BlakeC/test/Week3Tasks/TCellSimulationTask1.hpp"

static TCellSimulation suite_TCellSimulation;

static CxxTest::List Tests_TCellSimulation = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_TCellSimulation( "projects/BlakeC/test/Week3Tasks/TCellSimulationTask1.hpp", 70, "TCellSimulation", suite_TCellSimulation, Tests_TCellSimulation );

static class TestDescription_TCellSimulation_TestTCellSimulation : public CxxTest::RealTestDescription {
public:
 TestDescription_TCellSimulation_TestTCellSimulation() : CxxTest::RealTestDescription( Tests_TCellSimulation, suiteDescription_TCellSimulation, 74, "TestTCellSimulation" ) {}
 void runTest() { suite_TCellSimulation.TestTCellSimulation(); }
} testDescription_TCellSimulation_TestTCellSimulation;

#include <cxxtest/Root.cpp>
