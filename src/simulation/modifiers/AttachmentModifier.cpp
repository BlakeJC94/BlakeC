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

#include "AttachmentModifier.hpp"
#include "MeshBasedCellPopulation.hpp"
#include "RandomNumberGenerator.hpp"
#include "SmartPointers.hpp"

#include "WildTypeCellMutationState.hpp"
#include "AttachedCellMutationState.hpp"
#include "Debug.hpp"

template<unsigned DIM>
AttachmentModifier<DIM>::AttachmentModifier()
    : AbstractCellBasedSimulationModifier<DIM>()
{
}

template<unsigned DIM>
AttachmentModifier<DIM>::~AttachmentModifier()
{
}

template<unsigned DIM>
void AttachmentModifier<DIM>::UpdateAtEndOfTimeStep(AbstractCellPopulation<DIM,DIM>& rCellPopulation)
{
    UpdateCellStates(rCellPopulation);
}

template<unsigned DIM>
void AttachmentModifier<DIM>::SetupSolve(AbstractCellPopulation<DIM,DIM>& rCellPopulation, std::string outputDirectory)
{
    UpdateCellStates(rCellPopulation);
}

template<unsigned DIM>
void AttachmentModifier<DIM>::UpdateCellStates(AbstractCellPopulation<DIM,DIM>& rCellPopulation)
{
    //TRACE("smoof");
    rCellPopulation.Update();
    MAKE_PTR(AttachedCellMutationState, p_attached_state);
    MAKE_PTR(WildTypeCellMutationState, p_state);
    
    double AttachmentProbability = 0.1;
    double DetachmentProbability = 0.7;
    
    for (typename AbstractMesh<DIM, DIM>::NodeIterator node_iter = rCellPopulation.rGetMesh().GetNodeIteratorBegin();
         node_iter != rCellPopulation.rGetMesh().GetNodeIteratorEnd();
         ++node_iter)
    {
        unsigned node_index = node_iter->GetIndex();
        CellPtr p_cell = rCellPopulation.GetCellUsingLocationIndex(node_index);
        RandomNumberGenerator* p_gen = RandomNumberGenerator::Instance();
        double dt = SimulationTime::Instance()->GetTimeStep();
        
        if (!(p_cell->GetMutationState()->IsType<AttachedCellMutationState>()))
        {
            double cell_location_y = rCellPopulation.GetLocationOfCellCentre(p_cell)[1];
            if ((p_gen->ranf() < AttachmentProbability * dt) && (cell_location_y < 2.0))
            {
                p_cell->SetMutationState(p_attached_state);
            }
        }
        else
        {
            if (p_gen->ranf() < DetachmentProbability * dt)
            {
                p_cell->SetMutationState(p_state);
            }
        }
    }
}

template<unsigned DIM>
void AttachmentModifier<DIM>::OutputSimulationModifierParameters(out_stream& rParamsFile)
{
    AbstractCellBasedSimulationModifier<DIM>::OutputSimulationModifierParameters(rParamsFile);
}

// Explicit instantiation
template class AttachmentModifier<1>;
template class AttachmentModifier<2>;
template class AttachmentModifier<3>;

// Serialization for Boost >= 1.36
#include "SerializationExportWrapperForCpp.hpp"
EXPORT_TEMPLATE_CLASS_SAME_DIMS(AttachmentModifier)


