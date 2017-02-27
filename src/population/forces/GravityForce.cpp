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

#include "GravityForce.hpp"
#include "AttachedCellMutationState.hpp"
#include "RVCellMutationState.hpp"
#include "WildTypeCellMutationState.hpp"

GravityForce::GravityForce(double strength=1.0)
    : AbstractForce<2>(), 
      mStrength(strength),
      mRVRightStrength(1.0),
      mDampingConst(100.0),
      mRepulsionDistance(2.0),
      mRepulsionStrength(2.0),
      mAttachmentStrength(10.0)
{
}

void GravityForce::AddForceContribution(AbstractCellPopulation<2>& rCellPopulation)
{
    c_vector<double, 2> down_force = zero_vector<double>(2);
    c_vector<double, 2> bc_repulsion = zero_vector<double>(2);
    
    for (typename AbstractMesh<2, 2>::NodeIterator node_iter = rCellPopulation.rGetMesh().GetNodeIteratorBegin(); 
        node_iter != rCellPopulation.rGetMesh().GetNodeIteratorEnd();
        ++node_iter)
    {
        unsigned node_index = node_iter->GetIndex();
        CellPtr p_cell = rCellPopulation.GetCellUsingLocationIndex(node_index);
        
        
        if (!p_cell->GetMutationState()->IsType<AttachedCellMutationState>())
        {
            double conc_a = p_cell->GetCellData()->GetItem("concentrationA");
            
            down_force(0) = 0;
            down_force(1) = -((mStrength - 0.5) * conc_a + 0.5); //down_force(1) = -mStrength;
            
            if (p_cell->GetMutationState()->IsType<RVCellMutationState>())
            {
                down_force(0) = mRVRightStrength;
            }
            
            double cell_location_y = rCellPopulation.GetLocationOfCellCentre(p_cell)[1];
            if (cell_location_y < mRepulsionDistance)
            {
                //down_force(1) = mRepulsionStrength * mStrength * (mRepulsionDistance - cell_location_y)/mRepulsionDistance;
                down_force(1) = mRepulsionStrength;
            }
            
        }
        
        if (p_cell->GetMutationState()->IsType<AttachedCellMutationState>())
        {
            down_force(0) = 0;
            down_force(1) = -mAttachmentStrength * mDampingConst;
        }
        
        rCellPopulation.GetNode(node_index)->AddAppliedForceContribution(down_force);
    }
    
}

double GravityForce::GetStrength()
{
    return mStrength;
}


void GravityForce::SetRepulsionDistance(double repulsionDist)
{
    mRepulsionDistance = repulsionDist;
}

double GravityForce::GetRepulsionDistance()
{
    return mRepulsionDistance;
}


void GravityForce::SetRepulsionStrength(double repulsionStrength)
{
    mRepulsionStrength = repulsionStrength;
}

double GravityForce::GetRepulsionStrength()
{
    return mRepulsionStrength;
}


void GravityForce::SetAttachmentStrength(double attachStrength)
{
    mAttachmentStrength = attachStrength;
}

double GravityForce::GetAttachmentStrength()
{
    return mAttachmentStrength;
}


void GravityForce::SetRVRightStrength(double rvRightStrength)
{
    mRVRightStrength = rvRightStrength;
}

double GravityForce::GetRVRightStrength()
{
    return mRVRightStrength;
}


void GravityForce::SetDampingConst(double dampingConst)
{
    mDampingConst = dampingConst;
}
    
double GravityForce::GetDampingConst()
{
    return mDampingConst;
}
    

void GravityForce::OutputForceParameters(out_stream& rParamsFile)
{
    *rParamsFile << "\t\t\t<Strength>" << mStrength << "</Strength>\n";
    AbstractForce<2>::OutputForceParameters(rParamsFile);
}

#include "SerializationExportWrapperForCpp.hpp"
CHASTE_CLASS_EXPORT(GravityForce)

    
    
    
