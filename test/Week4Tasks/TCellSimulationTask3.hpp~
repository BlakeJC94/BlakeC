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

/* Task 3. Fix CellCycleModel to stop the new T Cells dividing once spawned */ 


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
#include "TCellTumorCellKiller.hpp"
#include "TCellTumorSpringForce.hpp"

#include "TCellProperty.hpp"
#include "TumorCellProperty.hpp"
#include "TCellTumorGenerationBasedCellCycleModel.hpp"


class TCellSimulation : public AbstractCellBasedTestSuite
{
public:

    void TestTCellSimulation() throw(Exception)
    {
    
        // T Cell simulation intial state options
        unsigned num_t_cells = 0; // To be phased out soon
        unsigned num_tumor_cells = 5;
        double initial_domain_radius = 5;
        
        std::vector<Node<2>*> nodes;
        
        
        // Generate node for "Immortal" Stem T Cell 
        //     node index = 0
        nodes.push_back(new Node<2>(0, false, 6 , 6));
        
        // Generate T Cell nodes (random loactions in annular domain 2<r<5)
        //     node index range = [1, num_t_cells]
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
        
        // Generate Tumor Cell nodes (random loactions in circular domain r<1)
        //     node index range = [num_t_cells + 1, num_t_cells + num_tumor_cells]
        for (unsigned index = 0; index < num_tumor_cells; index++)
        {
            double radial_coord = p_gen_r->ranf();
            double angular_coord = p_gen_theta->ranf() * 6.283185307;
            
            nodes.push_back(new Node<2>(index, false, 
                radial_coord * cos(angular_coord) ,  
                radial_coord * sin(angular_coord)));
        }
        
        
        // Generate mesh
        NodesOnlyMesh<2> mesh;
        mesh.ConstructNodesWithoutMesh(nodes, 1.5);
        
        
        // Generate cells
        std::vector<CellPtr> cells;
        
        MAKE_PTR(TransitCellProliferativeType, p_transit_type);
        MAKE_PTR(StemCellProliferativeType, p_stem_type);
        MAKE_PTR(WildTypeCellMutationState, p_state);
        
        MAKE_PTR(TCellProperty, p_t_cell_property); 
        
        MAKE_PTR(TumorCellProperty, p_tumor_cell_property);
        MAKE_PTR_ARGS(CellLabel, p_tumor_cell_label, (5));
        
        for (unsigned i=0; i<mesh.GetNumNodes(); i++) 
        {
            // Cell cycle model for all cells
            //   Labelled (Tumor Cells) divide according to a distribution specified in TCellTumorGenerationBasedCellCycleModel
            //   Unlabelled (T Cells) do not divide
            //   Stem cell at node 0 spawns new T Cells at random points on domain boundary at constant rate
            TCellTumorGenerationBasedCellCycleModel* p_model = new TCellTumorGenerationBasedCellCycleModel();
            CellPropertyCollection collection;
            
            if (  (i <= num_t_cells) && (i != 0)  )
            {
               collection.AddProperty(p_t_cell_property);
            }
            else if (i > num_t_cells)
            {
                collection.AddProperty(p_tumor_cell_label);
                collection.AddProperty(p_tumor_cell_property);
            }
            
            CellPtr p_cell(new Cell(p_state, p_model, NULL, false, collection));
            
            if (i == 0)
            {
                p_cell->SetCellProliferativeType(p_stem_type);
            }
            else
            {
                p_cell->SetCellProliferativeType(p_transit_type);
            }
            
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


        /* Add generalised linear spring forces between cells
         *   Tumor Cell & Tumor Cell --> Attraction and Repulsion
         *   T Cell & T Cell --> Repulsion only 
         * No interaction specified between Tumor Cell and T Cell 
         * Node 0 ignored */
        MAKE_PTR(TCellTumorSpringForce<2>, p_spring_force);
        simulator.AddForce(p_spring_force);
        
        /* Add diffusion force component to T Cells */
        MAKE_PTR(TCellDiffusionForce<2>, p_diffusion_force);
        simulator.AddForce(p_diffusion_force);
        
        /* Add cell killer component
         *   Kills T Cells that leave domain (Ignores T Cells near node 0) 
         *   Kills Tumor Cells instantly when a T Cell is nearby */
        MAKE_PTR_ARGS(TCellTumorCellKiller, p_cell_killer, (&cell_population));
        simulator.AddCellKiller(p_cell_killer);
        
        /* Add "portal" boundary condition outside domain
         *   Teleports new T Cells from node 0 neighbourhood onto 
         *   random points of domain boundary, ignores node 0 */
        MAKE_PTR_ARGS(TCellBoundaryCondition, p_bc, (&cell_population));
        simulator.AddCellPopulationBoundaryCondition(p_bc);
        
        
        simulator.Solve();
        
    }
};

// Pass

