/*

Copyright (c) 2005-2016, University of Oxford.
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

#include <cxxtest/TestSuite.h>
#include "CheckpointArchiveTypes.hpp"
#include "AbstractCellBasedTestSuite.hpp"

#include "UniformCellCycleModel.hpp"
#include "FixedG1GenerationalCellCycleModel.hpp"
#include "HoneycombMeshGenerator.hpp"
#include "CylindricalHoneycombMeshGenerator.hpp"
#include "HoneycombVertexMeshGenerator.hpp"
#include "CellsGenerator.hpp"
#include "MeshBasedCellPopulationWithGhostNodes.hpp"
#include "NodeBasedCellPopulation.hpp"
#include "VertexBasedCellPopulation.hpp"
#include "GeneralisedLinearSpringForce.hpp"
#include "NagaiHondaForce.hpp"
#include "SimpleTargetAreaModifier.hpp"
#include "OffLatticeSimulation.hpp"
#include "TransitCellProliferativeType.hpp"
#include "SmartPointers.hpp"
#include "VoronoiDataWriter.hpp"

#include "PlaneBoundaryCondition.hpp"
#include "PlaneBasedCellKiller.hpp"
#include "GravityForce.hpp"

#include "FakePetscSetup.hpp"

class UtericBudSimulation : public AbstractCellBasedTestSuite
{
public:
    void TestUtericBudSimulation() throw (Exception)
    {
        /* Simulation Options */
        unsigned num_cm_cells = 10; // Default = 10
        unsigned spawn_region_x = 2; // Default = 7, Max = 10
        unsigned spawn_region_y = 2; // Default = 3.5, Max = 5;
        unsigned simulation_time = 10; 
        
        /* 
        double sim_index = 0;
	    RandomNumberGenerator::Instance()->Reseed(100.0*sim_index);        

	    std::stringstream out;
	    out << sim_index;
	    std::string output_directory = "ThyroidTumorSimulation" + out.str();
	    */
        
        /* Generate Nodes */ 
        std::vector<Node<2>*> nodes;
        RandomNumberGenerator* p_gen_x = RandomNumberGenerator::Instance();
        RandomNumberGenerator* p_gen_y = RandomNumberGenerator::Instance();
        
        for (unsigned index = 0; index < num_cm_cells; index++)
        {
            double x_coord = spawn_region_x * p_gen_x->ranf();
            double y_coord = spawn_region_y * p_gen_y->ranf();
            nodes.push_back(new Node<2>(index, false, x_coord, y_coord+3));
        }
        
        /* Generate Mesh */ 
        NodesOnlyMesh<2> mesh;
        mesh.ConstructNodesWithoutMesh(nodes, 1.5);
        
        /* Generate Cells */
        std::vector<CellPtr> cells;
        MAKE_PTR(TransitCellProliferativeType, p_transit_type);
        CellsGenerator<UniformCellCycleModel, 2> cells_generator;
        cells_generator.GenerateBasicRandom(cells, mesh.GetNumNodes());
        
        /* Generate CellPopulation*/
        NodeBasedCellPopulation<2> cell_population(mesh, cells);
        
        /* Begin OffLatticeSimulation */ 
        OffLatticeSimulation<2> simulator(cell_population);
        simulator.SetOutputDirectory("TestUtericBudSimulation");
        simulator.SetEndTime(simulation_time);
        
        /* Add Boundary Conditions */
        c_vector<double, 2> bc_point = zero_vector<double>(2);
        c_vector<double, 2> bc_normal_1 = zero_vector<double>(2);
        bc_normal_1(1) = -1.0;
        c_vector<double, 2> bc_normal_2 = zero_vector<double>(2);
        bc_normal_2(0) = -1.0;
        
        MAKE_PTR_ARGS(PlaneBoundaryCondition<2>, p_bc1, (&cell_population, bc_point, bc_normal_1));
        simulator.AddCellPopulationBoundaryCondition(p_bc1);
        
        MAKE_PTR_ARGS(PlaneBoundaryCondition<2>, p_bc2, (&cell_population, bc_point, bc_normal_2));
        simulator.AddCellPopulationBoundaryCondition(p_bc2);
        
        
        /* Add Cell Killers */
        c_vector<double, 2> ck_point = zero_vector<double>(2);
        ck_point(1) = 20.0;
        
        c_vector<double, 2> ck_normal = zero_vector<double>(2);
        ck_normal(1) = 1.0;
        
        MAKE_PTR_ARGS(PlaneBasedCellKiller<2>, p_killer, (&cell_population, ck_point, ck_normal));
        simulator.AddCellKiller(p_killer);
        
        
        /* Add Cell Forces */ 
        MAKE_PTR(GeneralisedLinearSpringForce<2>, p_linear_force);
        p_linear_force->SetCutOffLength(1.5);
        simulator.AddForce(p_linear_force);
        
        MAKE_PTR_ARGS(GravityForce, p_force, (10.0));
        simulator.AddForce(p_force);
        

        simulator.Solve();

    }
};
