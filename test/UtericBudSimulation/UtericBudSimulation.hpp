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
#include "FakePetscSetup.hpp"
#include "SmartPointers.hpp"
//#include "Debug.hpp"

#include "NodeBasedCellPopulation.hpp"
#include "OffLatticeSimulation.hpp"
#include "GeneralisedLinearSpringForce.hpp"
#include "TransitCellProliferativeType.hpp"
#include "DifferentiatedCellProliferativeType.hpp"
#include "WildTypeCellMutationState.hpp"
#include "CellLabel.hpp"
#include "CellProliferativeTypesCountWriter.hpp"
#include "CellAgesWriter.hpp"
//#include "RepulsionForce.hpp"

#include "PlaneBoundaryCondition.hpp"
#include "PlaneBasedCellKiller.hpp"
#include "GravityForce.hpp"
#include "BasicDiffusionForce.hpp"
#include "CMCellCycleModel.hpp"
#include "ChemTrackingModifier.hpp"
#include "AttachedCellMutationState.hpp"
#include "AttachmentModifier.hpp"
//#include "AttachedCellMutationStatesCountWriter.hpp"
#include "RVCellMutationState.hpp"
#include "UtericBudMutationStateWriter.hpp"
#include "SelectivePlaneBoundaryCondition.hpp"
#include "BasicLinearSpringForce.hpp"
#include "UtericBudCellTypesCountWriter.hpp"




class UtericBudSimulation : public AbstractCellBasedTestSuite
{
private:

    void GenerateCells(unsigned num_cells, std::vector<CellPtr>& rCells, double div_age_mean, double div_age_std, double critconc, double diffprob)
    {
        MAKE_PTR(TransitCellProliferativeType, p_transit_type);
        MAKE_PTR(DifferentiatedCellProliferativeType, p_diff_type);
        MAKE_PTR(WildTypeCellMutationState, p_state);
        MAKE_PTR(AttachedCellMutationState, p_attached_state);
        MAKE_PTR(CellLabel, p_label);
        
        for (unsigned i = 0; i < num_cells; i++)
        {
            CMCellCycleModel* p_model = new CMCellCycleModel;
            p_model->SetAverageDivisionAge(div_age_mean);
            p_model->SetStdDivisionAge(div_age_std);
            p_model->SetRVThreshold(critconc);
            p_model->SetRVProbability(diffprob);
            
            
            CellPtr p_cell(new Cell(p_state, p_model));
            
            p_cell->InitialiseCellCycleModel();
            
            p_cell->SetCellProliferativeType(p_transit_type);
            /*
            if (RandomNumberGenerator::Instance()->ranf() < 0.2)
            {
                p_cell->SetCellProliferativeType(p_transit_type);
                //p_cell->AddCellProperty(p_label);
            }
            */
            
            double birth_time = - RandomNumberGenerator::Instance()->ranf() * 10.0;
            p_cell->SetBirthTime(birth_time);
            
            p_cell->GetCellData()->SetItem("concentrationA", 1.0); 
            p_cell->GetCellData()->SetItem("concentrationB", 1.0); 
            p_cell->GetCellData()->SetItem("AttachTime", 0);
            p_cell->GetCellData()->SetItem("DivAge", 0);
            
            rCells.push_back(p_cell);
        }
    }

public:
    void TestUtericBudSimulation() throw (Exception)
    {
        /* Simulation options */   
        double simulation_time = 200;
        double simulation_output_mult = 120;
        double simulation_dt = 1.0/200.0; // 1.0/180.0
        
        double simulation_region_x = 20; // 20
        double simulation_region_y = 10; // 10
        
        double initial_cm_cells = 15; 
        double permeable_barrier_x = 18; // 18
        double spawn_region_x = 10; // 10
        double spawn_region_y = 5; // 5
        
        
        double gforce_strength = 1.0; 
        double dforce_strength = 0.25; 
        
        double gforce_repulsion_distance = 2.0;
        double gforce_repulsion_multiplier = 2.0;
        double gforce_attachment_multiplier = 10.0;
        
        
        double div_age_mean = 10.0; 
        double div_age_std = 2.0; 
        
        double RV_diff_threshold = 0.9; 
        double RV_diff_probability = 0.5; 
        
        double attachment_probability = 0.5;
        double detachment_probability = 0.5;
        double attachment_height = 0.75;
        double attached_damping_constant = 100.0;
        
        
        
        
        /* Setup timer, output directory and RNG seed */
        clock_t t1, t2;
        t1 = clock();
        
	    double sim_index = 0;
	    if (CommandLineArguments::Instance()->OptionExists("-sim_index"))
	    {
	        sim_index = (double) atof(CommandLineArguments::Instance()->GetStringCorrespondingToOption("-sim_index").c_str());
        }
	    
	    std::stringstream out;
	    out << sim_index;
	    std::string output_directory = "UtericBudSimulation_" + out.str();
	    
	    RandomNumberGenerator::Instance()->Reseed(100.0 * sim_index);
        
        
        
        /* Generate Nodes */ 
        std::vector<Node<2>*> nodes;
        RandomNumberGenerator* p_gen_x = RandomNumberGenerator::Instance();
        RandomNumberGenerator* p_gen_y = RandomNumberGenerator::Instance();
        
        for (unsigned index = 0; index < initial_cm_cells; index++)
        {
            double x_coord = spawn_region_x * p_gen_x->ranf();
            double y_coord = spawn_region_y * p_gen_y->ranf();
            nodes.push_back(new Node<2>(index, false, x_coord, y_coord));
        }
        
        
        
        /* Generate Mesh */ 
        NodesOnlyMesh<2> mesh;
        mesh.ConstructNodesWithoutMesh(nodes, 1.5);
        
        
        
        /* Generate Cells */
        std::vector<CellPtr> cells;
        GenerateCells(mesh.GetNumNodes(), cells, div_age_mean, div_age_std, RV_diff_threshold, RV_diff_probability);
        
        
        
        /* Generate CellPopulation*/
        NodeBasedCellPopulation<2> cell_population(mesh, cells);
        
        
        
        /* Adjust damping constant for attached cells */
        cell_population.SetDampingConstantMutant(attached_damping_constant);
        
        
        
        /* Add CellWriters */
        //cell_population.AddCellPopulationCountWriter<CellProliferativeTypesCountWriter>();
        cell_population.AddCellPopulationCountWriter<UtericBudCellTypesCountWriter>();
        cell_population.AddCellWriter<CellAgesWriter>();
        cell_population.AddCellWriter<UtericBudMutationStateWriter>();
        
        
        
        /* Begin OffLatticeSimulation */ 
        OffLatticeSimulation<2> simulator(cell_population);
        simulator.SetOutputDirectory(output_directory);
        simulator.SetSamplingTimestepMultiple(simulation_output_mult);
        simulator.SetDt(simulation_dt);
        simulator.SetEndTime(simulation_time);
        simulator.SetOutputCellVelocities(true);
        simulator.SetOutputDivisionLocations(true);
        
        
        
        /* Add BoundaryConditions */
        c_vector<double, 2> bc_point_1 = zero_vector<double>(2);
        c_vector<double, 2> bc_normal_1 = zero_vector<double>(2);
        bc_normal_1(1) = -1.0;
        
        MAKE_PTR_ARGS(PlaneBoundaryCondition<2>, p_bc1, (&cell_population, bc_point_1, bc_normal_1));
        p_bc1->SetUseJiggledNodesOnPlane(true);
        simulator.AddCellPopulationBoundaryCondition(p_bc1);
        
        c_vector<double, 2> bc_point_2 = zero_vector<double>(2);
        c_vector<double, 2> bc_normal_2 = zero_vector<double>(2);
        bc_normal_2(0) = -1.0;
        
        MAKE_PTR_ARGS(PlaneBoundaryCondition<2>, p_bc2, (&cell_population, bc_point_2, bc_normal_2));
        p_bc2->SetUseJiggledNodesOnPlane(true);
        simulator.AddCellPopulationBoundaryCondition(p_bc2);
        
        c_vector<double, 2> bc_point_3 = zero_vector<double>(2);
        bc_point_3(0) = permeable_barrier_x;
        c_vector<double, 2> bc_normal_3 = zero_vector<double>(2);
        bc_normal_3(0) = 1.0;
        
        MAKE_PTR_ARGS(SelectivePlaneBoundaryCondition<2>, p_bc3, (&cell_population, bc_point_3, bc_normal_3));
        //p_bc3->SetUseJiggledNodesOnPlane(true);
        simulator.AddCellPopulationBoundaryCondition(p_bc3);
        
        
        
        /* Add CellKillers */
        c_vector<double, 2> ck_point_1 = zero_vector<double>(2);
        ck_point_1(0) = simulation_region_x;
        c_vector<double, 2> ck_normal_1 = zero_vector<double>(2);
        ck_normal_1(0) = 1.0;
        
        MAKE_PTR_ARGS(PlaneBasedCellKiller<2>, p_killer_x, (&cell_population, ck_point_1, ck_normal_1));
        simulator.AddCellKiller(p_killer_x);
        
        c_vector<double, 2> ck_point_2 = zero_vector<double>(2);
        ck_point_2(1) = simulation_region_y;
        c_vector<double, 2> ck_normal_2 = zero_vector<double>(2);
        ck_normal_2(1) = 1.0;
        
        MAKE_PTR_ARGS(PlaneBasedCellKiller<2>, p_killer_y, (&cell_population, ck_point_2, ck_normal_2));
        simulator.AddCellKiller(p_killer_y);
        
        
        
        /* Add CellForces */ 
        //MAKE_PTR(GeneralisedLinearSpringForce<2>, p_linear_force);
        MAKE_PTR(BasicLinearSpringForce<2>, p_linear_force);
        p_linear_force->SetCutOffLength(1.5);
        simulator.AddForce(p_linear_force);
        
        MAKE_PTR_ARGS(GravityForce, p_gforce, (gforce_strength));
        p_gforce->SetRepulsionDistance(gforce_repulsion_distance);
        p_gforce->SetRepulsionMultiplier(gforce_repulsion_multiplier);
        p_gforce->SetAttachmentMultiplier(gforce_attachment_multiplier);
        simulator.AddForce(p_gforce);
        
        MAKE_PTR_ARGS(BasicDiffusionForce, p_dforce, (dforce_strength));
        simulator.AddForce(p_dforce);
        
        
        
        /* Add SimulationModifiers */ 
        MAKE_PTR(ChemTrackingModifier<2>, p_chem_modifier);
        simulator.AddSimulationModifier(p_chem_modifier);
        
        MAKE_PTR(AttachmentModifier<2>, p_attach_modifier);
        p_attach_modifier->SetAttachmentProbability(attachment_probability);
        p_attach_modifier->SetDetachmentProbability(detachment_probability);
        p_attach_modifier->SetAttachmentHeight(attachment_height);
        p_attach_modifier->SetOutputAttachmentDurations(true); 
        simulator.AddSimulationModifier(p_attach_modifier);

        
        
        /* Run Simulation and output runtime */
        simulator.Solve();
        
        t2 = clock();
        float seconds = (((float)t2 - (float)t1) / CLOCKS_PER_SEC);
        if (seconds > 60)
        {
            float minutes = floor(seconds/60);
            seconds = seconds - 60 * minutes;
            if (minutes == 1)
            {
                cout << "Runtime : " << minutes << " minute and " << seconds << " seconds" << endl;
            }
            else
            {
                cout << "Runtime : " << minutes << " minutes and " << seconds << " seconds" << endl;
            }
        }
        else 
        {
            cout << "Runtime : " << seconds << " seconds" << endl;
        }
        
    }
};
