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

#include "SelectivePlaneBoundaryCondition.hpp"
#include "AbstractCentreBasedCellPopulation.hpp"
#include "VertexBasedCellPopulation.hpp"
#include "RandomNumberGenerator.hpp"
#include "RVCellMutationState.hpp"

#include "Debug.hpp"

SelectivePlaneBoundaryCondition::SelectivePlaneBoundaryCondition(AbstractCellPopulation<2>* pCellPopulation)
    : AbstractCellPopulationBoundaryCondition<2>
{
}

void SelectivePlaneBoundaryCondition::ImposeBoundaryCondition(const std::map<Node<2>*, c_vector<double, 2> >& rOldLocations)
{
    for (typename AbstractCellPopulation<2>::Iterator cell_iter = this->mpCellPopulation->Begin();
         cell_iter != this->mpCellPopulation->End();
         ++cell_iter)
    {
        unsigned node_index = this->mpCellPopulation->GetLocationIndexUsingCell(*cell_iter);
        CellPtr p_cell = this->mpCellPopulation->GetCellUsingLocationIndex(node_index);
        
        if (!p_cell->GetMutationState()->IsType<RVCellMutationState>())
        {
            Node<2>* p_node = this->mpCellPopulation->GetNode(node_index);
            double x_coord = p_node->rGetLocation()[0];
            
            if (x_coord > 18.0)
            {
                p_node->rGetModifiableLocation()[0] = 18.0;
            }
        }
    }
}

bool SelectivePlaneBoundaryCondition::VerifyBoundaryCondition()
{
    bool condition_satisfied = true;
    
    for (typename AbstractCellPopulation<2>::Iterator cell_iter = this->mpCellPopulation->Begin();
        cell_iter != this->mpCellPopulation->End();
        ++cell_iter)
    {
        unsigned node_index = this->mpCellPopulation->GetLocationIndexUsingCell(*cell_iter);
        CellPtr p_cell = this->mpCellPopulation->GetCellUsingLocationIndex(node_index);
        
        if (!p_cell->GetMutationState()->IsType<RVCellMutationState>())
        {
            c_vector<double, 2> cell_location - this->mpCellPopulation->GetLocationOfCellCentre(*cell_iter);
            x_coord = cell_location(0);
            
            if (x_coord > 18.0)
            {
                condition_satisfied = false;
                break;
            }
        }
    }
}

void SelectivePlaneBoundaryCondition::OutputCellPopulationBoundaryConditionParameters(out_stream& rParamsFile)
{
    AbstractCellPopulationBoundaryCondition<2>::OutputCellPopulationBoundaryConditionParameters(rParamsFile);
}

#include "SerializationExportWrapperForCpp.hpp"
CHASTE_CLASS_EXPORT(SelectivePlaneBoundaryCondition)





