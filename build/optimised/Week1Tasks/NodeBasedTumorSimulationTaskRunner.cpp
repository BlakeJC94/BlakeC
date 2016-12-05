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
#include "projects/BlakeC/test/Week1Tasks/NodeBasedTumorSimulationTask.hpp"

static NodeBasedTumorSimulation suite_NodeBasedTumorSimulation;

static CxxTest::List Tests_NodeBasedTumorSimulation = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_NodeBasedTumorSimulation( "projects/BlakeC/test/Week1Tasks/NodeBasedTumorSimulationTask.hpp", 66, "NodeBasedTumorSimulation", suite_NodeBasedTumorSimulation, Tests_NodeBasedTumorSimulation );

static class TestDescription_NodeBasedTumorSimulation_TestNodeBasedTumorSimulation : public CxxTest::RealTestDescription {
public:
 TestDescription_NodeBasedTumorSimulation_TestNodeBasedTumorSimulation() : CxxTest::RealTestDescription( Tests_NodeBasedTumorSimulation, suiteDescription_NodeBasedTumorSimulation, 70, "TestNodeBasedTumorSimulation" ) {}
 void runTest() { suite_NodeBasedTumorSimulation.TestNodeBasedTumorSimulation(); }
} testDescription_NodeBasedTumorSimulation_TestNodeBasedTumorSimulation;

#include <cxxtest/Root.cpp>
