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

template<unsigned ELEMENT_DIM, unsigned SPACE_DIM>
SelectivePlaneBoundaryCondition<ELEMENT_DIM,SPACE_DIM>::SelectivePlaneBoundaryCondition(AbstractCellPopulation<ELEMENT_DIM,SPACE_DIM>* pCellPopulation,
                                                    c_vector<double, SPACE_DIM> point,
                                                    c_vector<double, SPACE_DIM> normal)
        : AbstractCellPopulationBoundaryCondition<ELEMENT_DIM,SPACE_DIM>(pCellPopulation),
          mPointOnPlane(point),
          mUseJiggledNodesOnPlane(false)
{
    assert(norm_2(normal) > 0.0);
    mNormalToPlane = normal/norm_2(normal);
}

template<unsigned ELEMENT_DIM, unsigned SPACE_DIM>
const c_vector<double, SPACE_DIM>& SelectivePlaneBoundaryCondition<ELEMENT_DIM,SPACE_DIM>::rGetPointOnPlane() const
{
    return mPointOnPlane;
}

template<unsigned ELEMENT_DIM, unsigned SPACE_DIM>
const c_vector<double, SPACE_DIM>& SelectivePlaneBoundaryCondition<ELEMENT_DIM,SPACE_DIM>::rGetNormalToPlane() const
{
    return mNormalToPlane;
}


template<unsigned ELEMENT_DIM, unsigned SPACE_DIM>
void SelectivePlaneBoundaryCondition<ELEMENT_DIM,SPACE_DIM>::SetUseJiggledNodesOnPlane(bool useJiggledNodesOnPlane)
{
    mUseJiggledNodesOnPlane = useJiggledNodesOnPlane;
}

template<unsigned ELEMENT_DIM, unsigned SPACE_DIM>
bool SelectivePlaneBoundaryCondition<ELEMENT_DIM,SPACE_DIM>::GetUseJiggledNodesOnPlane()
{
    return mUseJiggledNodesOnPlane;
}

template<unsigned ELEMENT_DIM, unsigned SPACE_DIM>
void SelectivePlaneBoundaryCondition<ELEMENT_DIM,SPACE_DIM>::ImposeBoundaryCondition(const std::map<Node<SPACE_DIM>*, c_vector<double, SPACE_DIM> >& rOldLocations)
{
    for (typename AbstractCellPopulation<ELEMENT_DIM,SPACE_DIM>::Iterator cell_iter = this->mpCellPopulation->Begin();
         cell_iter != this->mpCellPopulation->End();
         ++cell_iter)
    {
        unsigned node_index = this->mpCellPopulation->GetLocationIndexUsingCell(*cell_iter);
        CellPtr p_cell = this->mpCellPopulation->GetCellUsingLocationIndex(node_index);
        
        if (!p_cell->GetMutationState()->IsType<RVCellMutationState>())
        {
            Node<SPACE_DIM>* p_node = this->mpCellPopulation->GetNode(node_index);
            c_vector<double, SPACE_DIM> node_location = p_node->rGetLocation();
            
            double signed_distance = inner_prod(node_location - mPointOnPlane, mNormalToPlane);
            if (signed_distance > 0.0)
            {
                c_vector<double, SPACE_DIM> nearest_point;
                //wumbo = 10;
                //PRINT_VARIABLE(wumbo);
                //wumbo = 0;
                
                
                if (mUseJiggledNodesOnPlane)
                {
                    double max_jiggle = 1e-4;
                    nearest_point = node_location - (signed_distance+max_jiggle*RandomNumberGenerator::Instance()->ranf())*mNormalToPlane;
                }
                else
                {
                    nearest_point = node_location - signed_distance*mNormalToPlane;
                }
                p_node->rGetModifiableLocation() = nearest_point;
            }
        }
    }
}
    



template<unsigned ELEMENT_DIM, unsigned SPACE_DIM>
bool SelectivePlaneBoundaryCondition<ELEMENT_DIM,SPACE_DIM>::VerifyBoundaryCondition()
{
    bool condition_satisfied = true;

    if (SPACE_DIM == 1)
    {
        EXCEPTION("SelectivePlaneBoundaryCondition is not implemented in 1D");
    }
    else
    {
        for (typename AbstractCellPopulation<ELEMENT_DIM, SPACE_DIM>::Iterator cell_iter = this->mpCellPopulation->Begin();
             cell_iter != this->mpCellPopulation->End();
             ++cell_iter)
        {
            unsigned node_index = this->mpCellPopulation->GetLocationIndexUsingCell(*cell_iter);
            CellPtr p_cell = this->mpCellPopulation->GetCellUsingLocationIndex(node_index);
            
            c_vector<double, SPACE_DIM> cell_location = this->mpCellPopulation->GetLocationOfCellCentre(*cell_iter);
            
            if (!p_cell->GetMutationState()->IsType<RVCellMutationState>())
            {
                if (inner_prod(cell_location - mPointOnPlane, mNormalToPlane) > 0.0)
                {
                   condition_satisfied = false;
                   break;
                }
            }
        }
    }

    return condition_satisfied;
}

template<unsigned ELEMENT_DIM, unsigned SPACE_DIM>
void SelectivePlaneBoundaryCondition<ELEMENT_DIM,SPACE_DIM>::OutputCellPopulationBoundaryConditionParameters(out_stream& rParamsFile)
{
    *rParamsFile << "\t\t\t<PointOnPlane>";
    for (unsigned index=0; index != SPACE_DIM-1U; index++) // Note: inequality avoids testing index < 0U when DIM=1
    {
        *rParamsFile << mPointOnPlane[index] << ",";
    }
    *rParamsFile << mPointOnPlane[SPACE_DIM-1] << "</PointOnPlane>\n";

    *rParamsFile << "\t\t\t<NormalToPlane>";
    for (unsigned index=0; index != SPACE_DIM-1U; index++) // Note: inequality avoids testing index < 0U when DIM=1
    {
        *rParamsFile << mNormalToPlane[index] << ",";
    }
    *rParamsFile << mNormalToPlane[SPACE_DIM-1] << "</NormalToPlane>\n";
    *rParamsFile << "\t\t\t<UseJiggledNodesOnPlane>" << mUseJiggledNodesOnPlane << "</UseJiggledNodesOnPlane>\n";

    // Call method on direct parent class
    AbstractCellPopulationBoundaryCondition<ELEMENT_DIM,SPACE_DIM>::OutputCellPopulationBoundaryConditionParameters(rParamsFile);
}

// Explicit instantiation
template class SelectivePlaneBoundaryCondition<1,1>;
template class SelectivePlaneBoundaryCondition<1,2>;
template class SelectivePlaneBoundaryCondition<2,2>;
template class SelectivePlaneBoundaryCondition<1,3>;
template class SelectivePlaneBoundaryCondition<2,3>;
template class SelectivePlaneBoundaryCondition<3,3>;

// Serialization for Boost >= 1.36
#include "SerializationExportWrapperForCpp.hpp"
EXPORT_TEMPLATE_CLASS_ALL_DIMS(SelectivePlaneBoundaryCondition)
