/*

Copyright (c) 2005-2015, University of Oxford.
All rights reserved.

University of Oxford means the Chancellor, Masters and Scholars of the
University of Oxford, having an administrative office at Wellington
Square, Oxford OX1 2JD, UK.
1. Apply a proper Parabollic PDE which only uses Labelled T Cells as sources.

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


/* Continuing from where we left off with the Vacation Scholars project, we met with Fede and 
 * discussed the next steps foward to making this project worthy of publication. We don't want to 
 * replicate what fede has done with his original model, but we want to add to it.
 * 
 * We want to write a detailed study of different methods of comutation and modelling. This will 
 * involve branching off the model currently and scaling up to the order of 500 cells instead of
 * 20 or so. The first branch will be incorperating a 'cloaking' behaviour of the tumor cells by 
 * modifying the existing PDE to make the attacked tumor cells act as 'sinks'. The second branch 
 * will be adding a recrietment process for the attacking T Cells by modifying the CellCycleModel.  */

/* Task 01. Modify the PDE to get the attacked tumor cells to 'mop up' cytokines (cloaking model) */


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

/* Load Primary components */
#include "TCellDiffusionForce.hpp"
#include "TCellTumorCellKiller.hpp" 
#include "TCellTumorSpringForce.hpp"
#include "TCellTumorCellCycleModel.hpp"
#include "TCellChemotacticForce.hpp"
#include "AveragedSourceParabolicPde.hpp"

/* Load Secondary components */
#include "TCellMutationState.hpp"
#include "TumorCellMutationState.hpp"
#include "TCellTumorMutationStatesCountWriter.hpp"

/* Load PDE Resources */
#include "ParabolicBoxDomainPdeModifier.hpp"
#include "ParabolicPdeAndBoundaryConditions.hpp"

#include "CommandLineArguments.hpp"


class TCellSimulation : public AbstractCellBasedTestSuite
{
public:

    void TestTCellSimulation() throw(Exception)
    {
        /* Initial cell count options */
        unsigned num_t_cells = 8; // Default = 0
        unsigned num_tumor_cells = 8; // Default = 5
        
        /* Simulation options */
        double domain_radius = 10; // Default = 5 
        unsigned simulation_time = 30; // Default = 45
        unsigned sampling_timestep_multiple = 6; //Default = 6
        double t_cell_spawn_rate = 10; // Default = 25 (units: cells/hour)
	    double diffusion_intensity = 0.25; // Default = 0.1
        double chemotactic_strength = 0.8; // Default = 1.0
        
        
        /* Parabolic PDE options */
        double dudt_coefficient = 10.0; // Default = 10.0
        double diffusion_constant = 5.0; // Default = 1.0
        double t_cell_source_coefficient = 8.0; // Default = 5.0
        double decay_coefficient = 5.0; // Default = 5.0
        double tumor_cell_sink_coefficient = 0.0; // Default = 0.0
        
        
        /* Simulation essential parameters (don't change unless required) */
        /*     node_0_coord: Top-right corner location for node 0 (node_0_coord, node_0_coord) 
         *     pde_boundary: Half side length of square domain for PDE 
         *     kill_radius_a and kill_radius_b: TCells in the range kill_radius_a < r < kill_radius_b will be killed 
         *     diffusion_intensity: intensity of the diffusion force contribution on T Cells */
        double node_0_coord = (domain_radius + 2.25)*cos(M_PI/4); // Default = (domain_radius + 1.5)*cos(M_PI/4)
        double pde_boundary = domain_radius + 1.5; // Default = domain_radius + 1.5
        double kill_radius_a = domain_radius + 0.15; // Default = domain_radius + 0.15
        double kill_radius_b = domain_radius + 1.0; // Default = domain_radius + 1.0
	    double t_cell_lifetime = 1/t_cell_spawn_rate;

	    //double sim_index = (double) atof(CommandLineArguments::Instance()->GetStringCorrespondingToOption("-sim_index").c_str());
	    double sim_index = 0;
	    RandomNumberGenerator::Instance()->Reseed(100.0*sim_index);        

	    std::stringstream out;
	    out << sim_index;
	    std::string output_directory = "ThyroidTumorSimulation" + out.str();
        
        
        /* Generate nodes */
        /* 01. Stem T Cell node index = 0 
         * 02. Initial T Cell nodes: 
         *         index range = [1, num_t_cells] 
         *         radial range = ((2 * domain_radius)/5, domain_radius)
         * 03. Initial Tumor Cell nodes: 
         *         index range = [num_t_cells + 1, num_t_cells + num_tumor_cells] 
         *         radial range = (0, domain_radius/5)) */
        std::vector<Node<2>*> nodes;
        RandomNumberGenerator* p_gen_r = RandomNumberGenerator::Instance();
        RandomNumberGenerator* p_gen_theta = RandomNumberGenerator::Instance();
        
        nodes.push_back(new Node<2>(0, false, node_0_coord , node_0_coord)); // 01.
        
        for (unsigned index = 0; index < num_t_cells; index++) // 02.
        {            
            double radial_coord = ((3 * domain_radius)/5) * p_gen_r->ranf() + (2 * domain_radius)/5;
            double angular_coord = p_gen_theta->ranf() * 2 * M_PI;
            
            nodes.push_back(new Node<2>(index, false, 
                radial_coord * cos(angular_coord) ,  
                radial_coord * sin(angular_coord)));
        }
        
        for (unsigned index = 0; index < num_tumor_cells; index++) // 03.
        {
            double radial_coord = (domain_radius/5) * p_gen_r->ranf();
            double angular_coord = p_gen_theta->ranf() * 2 * M_PI;
            
            nodes.push_back(new Node<2>(index, false, 
                radial_coord * cos(angular_coord) ,  
                radial_coord * sin(angular_coord)));
        }
        
        
        /* Generate mesh */
        NodesOnlyMesh<2> mesh;
        mesh.ConstructNodesWithoutMesh(nodes, 1.5);
        
        
        /* Generate cells */
        std::vector<CellPtr> cells;
        
        MAKE_PTR(StemCellProliferativeType, p_stem_type);
        MAKE_PTR(TransitCellProliferativeType, p_transit_type);
        MAKE_PTR(DifferentiatedCellProliferativeType, p_diff_type);

        MAKE_PTR(TCellMutationState, p_t_cell_state); 
        MAKE_PTR(TumorCellMutationState, p_tumor_cell_state);
        
        for (unsigned i=0; i<mesh.GetNumNodes(); i++) 
        {
            /* Add cell cycle model for all cells
             * 01. Tumor Cells: 
             *       Transit and Diff Cells with TumorCellMutationState divide according to specified distribution (default U[0, 2])
             * 02. T Cells:
             *       Stem Cells divide at constant rate into Transit Cells 
             *       Transit and Diff Cells do not divide */
            TCellTumorCellCycleModel* p_model = new TCellTumorCellCycleModel();
            p_model->SetSpawnRate(t_cell_lifetime);
            
            double birth_time = - RandomNumberGenerator::Instance()->ranf() *
                (p_model->GetStemCellG1Duration()
                    + p_model->GetSG2MDuration());
            
            CellPtr p_cell(new Cell(p_t_cell_state, p_model, NULL, false));

            p_cell->SetBirthTime(birth_time);
            p_cell->GetCellData()->SetItem("cytokines", 0.0); // PDE
            p_cell->GetCellData()->SetItem("cytokines_grad_x", 0.0);
            p_cell->GetCellData()->SetItem("cytokines_grad_y", 0.0);
            
            if (i == 0) // 01.
            {
                p_cell->SetCellProliferativeType(p_stem_type);
            }
            else if ( (i > 0) && (i <= num_t_cells)  ) // 02.
            {
               p_cell->SetCellProliferativeType(p_diff_type);   
            }
            else // 03.
            {
                p_model->SetMaxTransitGenerations(100000000);
                p_cell->SetMutationState(p_tumor_cell_state);
                p_cell->SetCellProliferativeType(p_transit_type);
            }
            cells.push_back(p_cell);
        }
        
        
        /* Generate Cell Population */
        NodeBasedCellPopulation<2> cell_population(mesh, cells);
        cell_population.AddCellPopulationCountWriter<TCellTumorMutationStatesCountWriter>();
        
        
        /* Begin OffLatticeSimulation */
        OffLatticeSimulation<2> simulator(cell_population);
        //simulator.SetOutputDirectory("TestTCellSimulation");
	    simulator.SetOutputDirectory(output_directory);
        simulator.SetSamplingTimestepMultiple(sampling_timestep_multiple);
        simulator.SetEndTime(simulation_time);

        
        /* Add cell killer component
         *   01: Teleports Transit T Cells in range r > (kill_radius_b) onto random points of domain boundary
         *   02: Kills Differentiated T Cells that leave domain (in range kill_radius_a < r < kill_radius_b)
         *   03: T Cells instantly Labelled when a Tumor Cell is nearby and labelled T Cells and Tumor Cells die in pairs randomly 
         *   04: Labelled T Cells are unlabelled if no Tumor Cell is near */
        MAKE_PTR_ARGS(TCellTumorCellKiller, p_cell_killer, (&cell_population));
        p_cell_killer->SetDomainRadius(domain_radius);
        p_cell_killer->SetKillRadiusA(kill_radius_a);
        p_cell_killer->SetKillRadiusB(kill_radius_b);
        simulator.AddCellKiller(p_cell_killer);
        
        
        /* Add generalised linear spring forces between cells
         *   01: T Cell + T Cell --> Repulsion
         *   02: Labelled T-Cells + Tumor Cells --> Attraction & Repulsion
         *   03: Tumor Cell + Tumor Cell --> Attraction and Repulsion */
        MAKE_PTR(TCellTumorSpringForce<2>, p_spring_force);
        simulator.AddForce(p_spring_force);
        
        /* Add diffusion force component to Unlabelled Differentiated T Cells */
        MAKE_PTR(TCellDiffusionForce<2>, p_diffusion_force);
        p_diffusion_force->SetDiffusionIntensity(diffusion_intensity);
        simulator.AddForce(p_diffusion_force);
        
        /* Add chemotactic force to Unlabelled Differentiated T Cells */
        MAKE_PTR(TCellChemotacticForce<2>, p_chemotactic_force_cytokines);
        p_chemotactic_force_cytokines->SetVariableName("cytokines");
        p_chemotactic_force_cytokines->SetStrengthParameter(chemotactic_strength);
        simulator.AddForce(p_chemotactic_force_cytokines);
        
        
        /* Make the PDE, BCs and PDE Domain */
        AveragedSourceParabolicPde<2> pde(cell_population, dudt_coefficient, diffusion_constant, t_cell_source_coefficient, decay_coefficient, tumor_cell_sink_coefficient);
        ConstBoundaryCondition<2> bc(0.0);
        ParabolicPdeAndBoundaryConditions<2> pde_and_bc(&pde, &bc, false);
        pde_and_bc.SetDependentVariableName("cytokines");
        ChastePoint<2> lower(-pde_boundary, -pde_boundary);
        ChastePoint<2> upper(pde_boundary, pde_boundary);
        ChasteCuboid<2> cuboid(lower, upper);

        /* Add PDE modifier component */
        MAKE_PTR_ARGS(ParabolicBoxDomainPdeModifier<2>, p_pde_modifier, (&pde_and_bc, cuboid));
        p_pde_modifier->SetOutputGradient(true);
        simulator.AddSimulationModifier(p_pde_modifier);

        
        /* Call solve */
        simulator.Solve();
        
    }
};

// Pass
