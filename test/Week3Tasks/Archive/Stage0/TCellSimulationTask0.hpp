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


/* After Week 2, we have a basic, but working first iteration of the simulation we are
 * working towards. This week, we wish to add more foundations for more adding more
 * complexity in later revisions. This will require rewriting some components to be 
 * more flexiblew with cell counts and a more sophisticted CellCycleModel for T Cells
 * as well as a new label to protect the primary T Cell spawner. */

/* Task 0. Re-write components to act on CellLabels rather than cell counts */ 


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

#include "TCellBoundaryCondition.hpp"
#include "TCellDiffusionForce.hpp"
#include "TCellTumorCellCycleModel.hpp"
#include "TCellTumorCellKiller.hpp"
#include "TCellTumorSpringForce.hpp"


class TCellSimulation : public AbstractCellBasedTestSuite
{
public:

    void TestTCellSimulation() throw(Exception)
    {
    
        // T Cell simulation intial state options
        unsigned num_t_cells = 5;
        unsigned num_tumor_cells = 4;
        double initial_domain_radius = 5;


        // Generate T Cell nodes (random loactions in annular domain 2<r<5)
        //     Possible issue: stop T cells spawning in the middle of a tumor?
        std::vector<Node<2>*> nodes;

        RandomNumberGenerator* p_gen_r = RandomNumberGenerator::Instance();
        RandomNumberGenerator* p_gen_theta = RandomNumberGenerator::Instance();
        for (unsigned index = 0; index < num_t_cells; index++)
        {            
            double radial_coord = (initial_domain_radius - 2)*p_gen_r->ranf() + 2;
            double angular_coord = p_gen_theta->ranf() * 6.283185307;
            
            nodes.push_back(new Node<2>(index, false, 
                radial_coord * cos(angular_coord) ,  
                radial_coord * sin(angular_coord)));
        }
        
        // Generate Tumor Cell nodes (random loactions in circular domain r<2)
        for (unsigned index = 0; index < num_tumor_cells; index++)
        {
            //nodes.push_back(new Node<2>(index, false, 
            //    2.0*initial_domain_length*p_gen->ranf() - initial_domain_length ,  
            //    2.0*initial_domain_length*p_gen->ranf() - initial_domain_length));
            
            double radial_coord = 2*p_gen_r->ranf();
            double angular_coord = p_gen_theta->ranf() * 6.283185307;
            
            nodes.push_back(new Node<2>(index, false, 
                radial_coord * cos(angular_coord) ,  
                radial_coord * sin(angular_coord)));
        }
        
        /*
        // Manually create nodes for Tumor Cells near origin
        nodes.push_back(new Node<2>(1 + num_t_cells, false, 0.5, 0.5));
        nodes.push_back(new Node<2>(2 + num_t_cells, false, 0.5, -0.5));
        nodes.push_back(new Node<2>(3 + num_t_cells, false, -0.5, 0.5));
        nodes.push_back(new Node<2>(4 + num_t_cells, false, -0.5, -0.5));
        */
        
        // Generate mesh
        NodesOnlyMesh<2> mesh;
        mesh.ConstructNodesWithoutMesh(nodes, 1.5);
        
        
        // Generate cells
        std::vector<CellPtr> cells;
        MAKE_PTR(TransitCellProliferativeType, p_transit_type);
        MAKE_PTR(CellLabel, p_label); 
        MAKE_PTR(WildTypeCellMutationState, p_state);
        
        for (unsigned i=0; i<mesh.GetNumNodes(); i++)
        {
        
            // Cell cycle model for all cells
            //   Labelled (T Cells) do not divide
            //   Unlabelled (Tumor Cells) divide according to a U[0,2] distribution
            TCellTumorCellCycleModel* p_model = new TCellTumorCellCycleModel();
            CellPropertyCollection collection;
            
            if (i < num_t_cells) // Label T Cells
            {
                collection.AddProperty(p_label);
            }
            
            CellPtr p_cell(new Cell(p_state, p_model, NULL, false, collection));
            p_cell->SetCellProliferativeType(p_transit_type);
            
            double birth_time = - RandomNumberGenerator::Instance()->ranf() *
                (p_model->GetStemCellG1Duration()
                    + p_model->GetSG2MDuration());
            
            p_cell->SetBirthTime(birth_time);
            
            cells.push_back(p_cell);
        }
        
        
        // Generate Cell Population
        NodeBasedCellPopulation<2> cell_population(mesh, cells);
        
        
        // Begin OffLatticeSimulation
        OffLatticeSimulation<2> simulator(cell_population);
        simulator.SetOutputDirectory("TestTCellSimulation");
        simulator.SetSamplingTimestepMultiple(6);
        simulator.SetEndTime(45.0);


        // Add generalised linear spring forces between cells
        //   Tumor Cell & Tumor Cell --> Attraction and Repulsion
        //   T Cell & T Cell --> Repulsion only
        MAKE_PTR(TCellTumorSpringForce<2>, p_spring_force);
        simulator.AddForce(p_spring_force);
        
        // Add diffusion force component and constant left-facing force componet to T Cells
        MAKE_PTR(TCellDiffusionForce<2>, p_diffusion_force);
        simulator.AddForce(p_diffusion_force);
        
        // Add "portal" boundary condition on edges of square region
        MAKE_PTR_ARGS(TCellBoundaryCondition, p_bc, (&cell_population));
        simulator.AddCellPopulationBoundaryCondition(p_bc);
        
        // Add cell killer (kills tumor cells instantly when a T Cell is nearby)
        MAKE_PTR_ARGS(TCellTumorCellKiller, p_cell_killer, (&cell_population));
        simulator.AddCellKiller(p_cell_killer);
        

        simulator.Solve();
        
    }
};

// Pass
