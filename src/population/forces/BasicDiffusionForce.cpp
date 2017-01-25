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

#include "BasicDiffusionForce.hpp"
#include "AttachedCellMutationState.hpp"
#include "RVCellMutationState.hpp"
#include "WildTypeCellMutationState.hpp"

BasicDiffusionForce::BasicDiffusionForce(double strength=1.0)
    : AbstractForce<2>(),
      mStrength(strength)
{
    assert(mStrength > 0.0);
}

void BasicDiffusionForce::AddForceContribution(AbstractCellPopulation<2>& rCellPopulation)
{
    double dt = SimulationTime::Instance()->GetTimeStep();
    double mAbsoluteTemperature = 296.0;
    double mViscosity = 3.204e-6;
    double msBoltzmannConstant = 4.97033568e-7;
    
    //for (unsigned node_index = 0; node_index < rCellPopulation.GetNumNodes(); node_index++)
    for (typename AbstractMesh<2, 2>::NodeIterator node_iter = rCellPopulation.rGetMesh().GetNodeIteratorBegin(); 
        node_iter != rCellPopulation.rGetMesh().GetNodeIteratorEnd();
        ++node_iter)
    {
        unsigned node_index = node_iter->GetIndex();
        CellPtr p_cell = rCellPopulation.GetCellUsingLocationIndex(node_index);
        double node_radius = node_iter->GetRadius();
        
        if (node_radius == 0)
        {
            EXCEPTION("SetRadius() must be called on each Node before calling DiffusionForce::AddForceContribution() to avoid a division by zero error");
        }
        
        double nu = dynamic_cast<AbstractOffLatticeCellPopulation<2>*>(&rCellPopulation)->GetDampingConstant(node_index);
        double diffusion_const_scaling = msBoltzmannConstant*mAbsoluteTemperature/(6.0*mViscosity*M_PI);
        double diffusion_constant = diffusion_const_scaling/node_radius;
        
        
        c_vector<double, 2> force = zero_vector<double>(2);
        
        if (!(p_cell->GetMutationState()->IsType<AttachedCellMutationState>()))
        {
            for (unsigned i=0; i<2; i++)
            {
                double xi = RandomNumberGenerator::Instance()->StandardNormalRandomDeviate();
                force[i] = mStrength*(nu*sqrt(2.0*diffusion_constant*dt)/dt)*xi;
            }
        }
        
        node_iter->AddAppliedForceContribution(force);
    }
}

double BasicDiffusionForce::GetStrength()
{
    return mStrength;
}

void BasicDiffusionForce::OutputForceParameters(out_stream& rParamsFile)
{
    *rParamsFile << "\t\t\t<Strength>" << mStrength << "</Strength>\n";
    AbstractForce<2>::OutputForceParameters(rParamsFile);
}

#include "SerializationExportWrapperForCpp.hpp"
CHASTE_CLASS_EXPORT(BasicDiffusionForce)



    


    
