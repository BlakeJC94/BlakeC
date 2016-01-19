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



/* The purpose of this exercise was to begin the foundation of T-cell simulation for later integration
 * into the final model. Only the labelled T-cells will be focussed on here, no tumor growth. We 
 * assert that these cells dont divide, dont die and experience repulsion forces between each other. 
 * We treat the simulation area as a square box with side length 10 centered at the origin. */

/* Task 0: Get a working base that randomly spawns the T cells throughout the box */


#include <cxxtest/TestSuite.h>
#include "CheckpointArchiveTypes.hpp"

#include "AbstractCellBasedTestSuite.hpp"
#include "PetscSetupAndFinalize.hpp"
#include "CellsGenerator.hpp"
#include "DifferentiatedCellProliferativeType.hpp"
#include "OffLatticeSimulation.hpp"
#include "SmartPointers.hpp"
#include "NodesOnlyMesh.hpp"
#include "NodeBasedCellPopulation.hpp"
#include "RepulsionForce.hpp"

#include "StochasticDurationCellCycleModel.hpp"

class TCellSimulation : public AbstractCellBasedTestSuite
{
public:

    void TestTCellSimulation() throw(Exception)
    {
        unsigned num_cells = 100;
        double initial_domain_length = 10;

        std::vector<Node<2>*> nodes;
        RandomNumberGenerator* p_gen = RandomNumberGenerator::Instance();

        for (unsigned index = 0; index < num_cells; index++)
        {
            nodes.push_back(new Node<2>(index, false, 
                2.0*initial_domain_length*p_gen->ranf() - initial_domain_length ,  
                2.0*initial_domain_length*p_gen->ranf() - initial_domain_length));
        }

        NodesOnlyMesh<2> mesh;
        mesh.ConstructNodesWithoutMesh(nodes, 1.5);
        
        std::vector<CellPtr> cells;
        MAKE_PTR(DifferentiatedCellProliferativeType, p_transit_type);
        CellsGenerator<StochasticDurationCellCycleModel, 2> cells_generator;
        cells_generator.GenerateBasicRandom(cells, mesh.GetNumNodes(), p_transit_type);
        
        NodeBasedCellPopulation<2> cell_population(mesh, cells);
        
        OffLatticeSimulation<2> simulator(cell_population);
        simulator.SetOutputDirectory("TestTCellSimulation");
        simulator.SetSamplingTimestepMultiple(6);
        simulator.SetEndTime(45.0);
        
        MAKE_PTR(RepulsionForce<2>, p_force);
        simulator.AddForce(p_force);
        

        simulator.Solve();
        
    }
};


// Pass