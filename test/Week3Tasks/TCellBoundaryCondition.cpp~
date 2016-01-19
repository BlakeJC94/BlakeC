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


#include "TCellBoundaryCondition.hpp"
#include "TCellProperty.hpp"
#include "TumorCellProperty.hpp"

TCellBoundaryCondition::TCellBoundaryCondition(AbstractCellPopulation<2>* pCellPopulation)
    : AbstractCellPopulationBoundaryCondition<2>(pCellPopulation)
{
}

void TCellBoundaryCondition::ImposeBoundaryCondition(const std::map<Node<2>*, c_vector<double, 2> >& rOldLocations)
{
    for (AbstractCellPopulation<2>::Iterator cell_iter = this->mpCellPopulation->Begin();
         cell_iter != this->mpCellPopulation->End();
         ++cell_iter)
    {
        unsigned node_index = this->mpCellPopulation->GetLocationIndexUsingCell(*cell_iter);
        Node<2>* p_node = this->mpCellPopulation->GetNode(node_index);
        double x_coordinate = p_node->rGetLocation()[0];
        double y_coordinate = p_node->rGetLocation()[1];
        
        double r_coordinate = sqrt(pow(x_coordinate, 2) + pow(y_coordinate, 2));
        RandomNumberGenerator* p_gen_theta = RandomNumberGenerator::Instance();
        double angular_coord = p_gen_theta->ranf() * 6.283185307;
        
        MAKE_PTR_ARGS(CellLabel, p_t_cell_label, (3));
        MAKE_PTR(TCellProperty, p_t_cell_property);
        
        CellPtr p_cell = this->mpCellPopulation->GetCellUsingLocationIndex(node_index);
        
        /* Boundary condition teleport all non-tumor cells with node_index > 0 outside disk with radius 6
         * onto a random point on the edge of disk with radius 4.9 (slightly under 5 to increase chance of 
         * survival for new cells moderately). */
        if (   ( !(cell_iter->template HasCellProperty<TumorCellProperty>()) && (r_coordinate > 6.0) ) &&
            (node_index != 0)   )
        {
            p_node->rGetModifiableLocation()[0] = 4.9 * cos(angular_coord); // Default value = 4.9
            p_node->rGetModifiableLocation()[1] = 4.9 * sin(angular_coord);
            
            // Adds TCellProperty to new cells from node 0
            if (!(cell_iter->template HasCellProperty<TCellProperty>()))
            {
                cell_iter->AddCellProperty(p_t_cell_property);
            }
        }  
    }
}

bool TCellBoundaryCondition::VerifyBoundaryCondition()
{
    bool condition_satisfied = true;
    
    /* ---- Disabled VerifyBoundaryCondition temporarily

    for (AbstractCellPopulation<2>::Iterator cell_iter = this->mpCellPopulation->Begin();
         cell_iter != this->mpCellPopulation->End();
         ++cell_iter)
    {
        
        c_vector<double, 2> cell_location = this->mpCellPopulation->GetLocationOfCellCentre(*cell_iter);
        double x_coordinate = cell_location(0);
        double y_coordinate = cell_location(1);

        if ((x_coordinate < -5.0) || (x_coordinate > 5.0))
        {
            condition_satisfied = false;
            break;
        }
    }
    */
    
    return condition_satisfied;
}

void TCellBoundaryCondition::OutputCellPopulationBoundaryConditionParameters(out_stream& rParamsFile)
{
    AbstractCellPopulationBoundaryCondition<2>::OutputCellPopulationBoundaryConditionParameters(rParamsFile);
}

#include "SerializationExportWrapperForCpp.hpp"
CHASTE_CLASS_EXPORT(TCellBoundaryCondition)


