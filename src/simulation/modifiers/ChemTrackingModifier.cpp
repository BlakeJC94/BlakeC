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

#include "ChemTrackingModifier.hpp"
#include "MeshBasedCellPopulation.hpp"
#include "Debug.hpp"

template<unsigned DIM>
ChemTrackingModifier<DIM>::ChemTrackingModifier()
    : AbstractCellBasedSimulationModifier<DIM>(),
    mConcBModel(2),
    mConcBParameter(0.7)
{
}

template<unsigned DIM>
ChemTrackingModifier<DIM>::~ChemTrackingModifier()
{
}

template<unsigned DIM>
void ChemTrackingModifier<DIM>::UpdateAtEndOfTimeStep(AbstractCellPopulation<DIM,DIM>& rCellPopulation)
{
    UpdateCellData(rCellPopulation);
}

template<unsigned DIM>
void ChemTrackingModifier<DIM>::SetupSolve(AbstractCellPopulation<DIM,DIM>& rCellPopulation, std::string outputDirectory)
{
    UpdateCellData(rCellPopulation);
}

template<unsigned DIM>
void ChemTrackingModifier<DIM>::UpdateCellData(AbstractCellPopulation<DIM,DIM>& rCellPopulation)
{
    rCellPopulation.Update();
    
    for (typename AbstractCellPopulation<DIM>::Iterator cell_iter = rCellPopulation.Begin();
         cell_iter != rCellPopulation.End();
         ++cell_iter)
    {
        double cell_x = rCellPopulation.GetLocationOfCellCentre(*cell_iter)[0];
        double cell_y = rCellPopulation.GetLocationOfCellCentre(*cell_iter)[1];
        
        double conc_a = 0.0;
        if (cell_y < 10.0)
        {
            conc_a = 1 - cell_y/10.0;
        }
        
        
        double conc_b;
        
        if (mConcBModel == 1) // Constant
        {
            conc_b = mConcBParameter;
        }        
        else if (mConcBModel == 2) // Ramp
        {
            conc_b = 0.0;
            if (cell_x < 10.0)
            {
                conc_b = 1 - cell_x/10.0;
            }
        }
        else if (mConcBModel == 3) // Linear
        {
            conc_b = mConcBParameter * (1 - cell_x/20);
        }
        else if (mConcBModel == 4) // Smooth curve
        {
            conc_b = exp(-pow(cell_x,2)/(2*pow(5.5,2)));
        }
        else 
        {
            NEVER_REACHED;
        }



        cell_iter->GetCellData()->SetItem("concentrationA", conc_a);
        cell_iter->GetCellData()->SetItem("concentrationB", conc_b);
    }
}

template<unsigned DIM>
void ChemTrackingModifier<DIM>::SetConcBModel(double concBModel)
{
    mConcBModel = concBModel;
}

template<unsigned DIM>
double ChemTrackingModifier<DIM>::GetConcBModel()
{
    return mConcBModel;
}

template<unsigned DIM>
void ChemTrackingModifier<DIM>::SetConcBParameter(double concBParamter)
{
    mConcBParameter = concBParamter;
}

template<unsigned DIM>
double ChemTrackingModifier<DIM>::GetConcBParameter()
{
    return mConcBParameter;
}

template<unsigned DIM>
void ChemTrackingModifier<DIM>::OutputSimulationModifierParameters(out_stream& rParamsFile)
{
    // No parameters to output, so just call method on direct parent class
    AbstractCellBasedSimulationModifier<DIM>::OutputSimulationModifierParameters(rParamsFile);
}

// Explicit instantiation
template class ChemTrackingModifier<1>;
template class ChemTrackingModifier<2>;
template class ChemTrackingModifier<3>;

// Serialization for Boost >= 1.36
#include "SerializationExportWrapperForCpp.hpp"
EXPORT_TEMPLATE_CLASS_SAME_DIMS(ChemTrackingModifier)


