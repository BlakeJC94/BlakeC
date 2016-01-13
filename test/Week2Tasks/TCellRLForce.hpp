/*

Copyright (c) 2005-2015, University of Oxford.
All rights reserved.

University of Oxford means the Chancellor, Masters and Scholars of the
University of Oxford, having an administrative office at Wellington
Square, Oxford OX1 2JD, UK.

This file is part of Chaste.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of the University of Oxford nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

/*
 * = An example showing how to create and use a new force =
 *
 * EMPTYLINE
 *
 * == Introduction ==
 *
 * EMPTYLINE
 *
 * In previous cell-based Chaste tutorials, we used existing force classes to define
 * how cells interact mechanically. In this tutorial we show
 * how to create a new force class, and how this can be used in a cell-based
 * simulation.
 *
 * EMPTYLINE
 *
 * == 1. Including header files ==
 *
 * EMPTYLINE
 *
 * As in previous cell-based Chaste tutorials, we begin by including the necessary header files.
 */
#include <cxxtest/TestSuite.h>
#include "CheckpointArchiveTypes.hpp"
#include "AbstractCellBasedTestSuite.hpp"

/* The next header defines a base class for forces, from which the new class will inherit. */
#include "AbstractForce.hpp"
/* The remaining header files define classes that will be used in the cell-based
 * simulation test. We have encountered each of these header files in previous cell-based
 * Chaste tutorials. */
#include "HoneycombMeshGenerator.hpp"
#include "FixedDurationGenerationBasedCellCycleModel.hpp"
#include "GeneralisedLinearSpringForce.hpp"
#include "OffLatticeSimulation.hpp"
#include "CellsGenerator.hpp"
#include "TransitCellProliferativeType.hpp"
#include "SmartPointers.hpp"

/* This header ensures that this test is only run on one process, since it doesn't support parallel execution. */
//#include "FakePetscSetup.hpp"

/*
 * EMPTYLINE
 *
 * == Defining the force class ==
 *
 * As an example, let us consider a force for a two-dimensional cell-based
 * simulation, that mimics gravity. To implement this we define a force
 * boundary condition class, {{{TCellRLForce}}}, which inherits from
 * {{{AbstractForce}}} and overrides the methods {{{AddForceContribution()}}} and
 * {{{OutputForceParameters()}}}.
 *
 * Note that usually this code would be separated out into a separate declaration
 * in a .hpp file and definition in a .cpp file.
 */
class TCellRLForce : public AbstractForce<2>
{
private:

    /* This force class includes a member variable, {{{mStrength}}}, which
     * defines the strength of the force. This member variable will be set
     * in the constructor.
     */
    double mStrength;

    /* We only need to include the next block of code if we wish to be able
     * to archive (save or load) the force model object in a cell-based simulation.
     * The code consists of a serialize method, in which we first archive the force
     * using the serialization code defined in the base class {{{AbstractForce}}},
     * then archive the member variable. */
    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & archive, const unsigned int version)
    {
        archive & boost::serialization::base_object<AbstractForce<2> >(*this);
        archive & mStrength;
    }

public:
    /* The first public method is a default constructor, which calls the base
     * constructor. There is a single input argument, which defines the strength
     * of the force. We provide a default value of 1.0 for this argument. Inside
     * the method, we add an assertion to make sure that the strength is strictly
     * positive.
     */
    TCellRLForce(double strength=1.0)
        : AbstractForce<2>(),
          mStrength(strength)
    {
        assert(mStrength > 0.0);
    }

    /* The second public method overrides {{{AddForceContribution()}}}.
     * This method takes in one arguments, a reference to the cell population itself.
     */
    void AddForceContribution(AbstractCellPopulation<2>& rCellPopulation)
    {
        /* Inside the method, we loop over nodes, and add a constant vector to
         * each node, in the negative ''y''-direction and of magnitude {{{mStrength}}}.
         */
        c_vector<double, 2> force = zero_vector<double>(2);
        force(0) = -mStrength;

        for (unsigned node_index=0; node_index<rCellPopulation.GetNumNodes(); node_index++)
        {
            rCellPopulation.GetNode(node_index)->AddAppliedForceContribution(force);
        }
    }

    /* We also add a get method for {{{mStrength}}}, to allow for testing. */
    double GetStrength()
    {
        return mStrength;
    }

    /* Just as we encountered in [wiki:UserTutorials/CreatingAndUsingANewCellKiller], here we must override
     * a method that outputs any member variables to a specified results file {{{rParamsFile}}}.
     * In our case, we output the member variable {{{mStrength}}}, then call the method on the base class.
     */
    void OutputForceParameters(out_stream& rParamsFile)
    {
        *rParamsFile << "\t\t\t<Strength>" << mStrength << "</Strength>\n";
        AbstractForce<2>::OutputForceParameters(rParamsFile);
    }
};

/* As mentioned in previous cell-based Chaste tutorials, we need to include the next block
 * of code to be able to archive the force object in a cell-based
 * simulation, and to obtain a unique identifier for our new force for writing
 * results to file.
 */
#include "SerializationExportWrapper.hpp"
CHASTE_CLASS_EXPORT(TCellRLForce)
#include "SerializationExportWrapperForCpp.hpp"
CHASTE_CLASS_EXPORT(TCellRLForce)

/*
 * This completes the code for {{{TCellRLForce}}}. Note that usually this code
 * would be separated out into a separate declaration in a .hpp file and definition
 * in a .cpp file.
 *
 * EMPTYLINE
 *
 * === The Tests ===
 *
 * EMPTYLINE
 *
 * We now define the test class, which inherits from {{{AbstractCellBasedTestSuite}}}.
 */
