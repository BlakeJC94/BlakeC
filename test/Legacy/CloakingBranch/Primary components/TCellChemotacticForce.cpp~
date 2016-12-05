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

#include "TCellChemotacticForce.hpp"
#include "CellwiseDataGradient.hpp"

#include "TCellMutationState.hpp"

template<unsigned DIM>
TCellChemotacticForce<DIM>::TCellChemotacticForce()
    : AbstractForce<DIM>(),
      mStrengthParameter(1.0),
      mVariableName("variable"),
      mMoveLabeledCells("true")
{
}

template<unsigned DIM>
TCellChemotacticForce<DIM>::~TCellChemotacticForce()
{
}


template<unsigned DIM>
double TCellChemotacticForce<DIM>::GetStrengthParameter()
{
    return mStrengthParameter;
}

template<unsigned DIM>
void TCellChemotacticForce<DIM>::SetStrengthParameter(double strengthParameter)
{
    mStrengthParameter = strengthParameter;
}

template<unsigned DIM>
std::string TCellChemotacticForce<DIM>::GetVariableName()
{
    return mVariableName;
}

template<unsigned DIM>
void TCellChemotacticForce<DIM>::SetVariableName(std::string variableName)
{
    mVariableName = variableName;
}

/*
template<unsigned DIM>
bool TCellChemotacticForce<DIM>::GetMoveLabeledCells()
{
    return mMoveLabeledCells;
}*/
/*
template<unsigned DIM>
void TCellChemotacticForce<DIM>::SetMoveLabeledCells(bool moveLabeledCells)
{
    mMoveLabeledCells = moveLabeledCells;
}*/

template<unsigned DIM>
double TCellChemotacticForce<DIM>::GetTCellChemotacticForceMagnitude(const double concentration, const double concentrationGradientMagnitude)
{
    return mStrengthParameter; // temporary force law - can be changed to something realistic
                          // without tests failing
}

template<unsigned DIM>
void TCellChemotacticForce<DIM>::AddForceContribution(AbstractCellPopulation<DIM>& rCellPopulation)
{
    
    double dt = SimulationTime::Instance()->GetTimeStep();
    
    for (typename AbstractCellPopulation<DIM>::Iterator cell_iter = rCellPopulation.Begin();
         cell_iter != rCellPopulation.End();
         ++cell_iter)
    {
        if (cell_iter->GetMutationState()->template IsType<TCellMutationState>())
        {
            unsigned node_global_index = rCellPopulation.GetLocationIndexUsingCell(*cell_iter);

            c_vector<double,DIM> gradient;

            switch (DIM)
            {
                case 2:
                    gradient(0) = cell_iter->GetCellData()->GetItem(mVariableName+"_grad_x");
                    gradient(1) = cell_iter->GetCellData()->GetItem(mVariableName+"_grad_y");
                    break;
                default:
                    NEVER_REACHED;
            }
            
            double nutrient_concentration = cell_iter->GetCellData()->GetItem(mVariableName);
            double magnitude_of_gradient = norm_2(gradient);

            double force_magnitude = GetTCellChemotacticForceMagnitude(nutrient_concentration, magnitude_of_gradient);

            
            // force += chi * gradC/|gradC|
            if (magnitude_of_gradient > 0)
            {
                c_vector<double,DIM> force = (force_magnitude)*gradient/magnitude_of_gradient;
                rCellPopulation.GetNode(node_global_index)->AddAppliedForceContribution(force);
            }
            // else Fc=0
            
            
            
            /* --- new code start ---
            // Calculate chemotactic force
            c_vector<double,DIM> chem_force = (force_magnitude)*gradient/magnitude_of_gradient; 
            
            // Calculate diffusion force 
            c_vector<double, DIM> diff_force;
            /* Compute the diffusion coefficient D as D = k*T/(6*pi*eta*r), where
             *
             * k = Boltzmann's constant (4.97033568e-7),
             * T = absolute temperature (296.0, room temp),
             * eta = dynamic viscosity (3.204e-6, viscosity of water at room temperature),
             * r = cell radius. 
            double diffusion_constant = 2.43604/0.5; // ( k*T/(6*pi*eta)) / r )
            for (unsigned i=0; i<DIM; i++)
            {
            
                /* The force on this cell is scaled with the timestep such that when it is
                 * used in the discretised equation of motion for the cell, we obtain the
                 * correct formula
                 *
                 * x_new = x_old + sqrt(2*D*dt)*W
                 *
                 * where W is a standard normal random variable. 
                //RandomNumberGenerator* p_gen = RandomNumberGenerator::Instance();
                
                double xi = RandomNumberGenerator::Instance()->StandardNormalRandomDeviate();
                diff_force[i] = mStrengthParameter * ((sqrt(2.0*diffusion_constant*dt)/dt)*xi);
            }
            
            
            c_vector<double,DIM> force = chem_force + diff_force;
            rCellPopulation.GetNode(node_global_index)->AddAppliedForceContribution(force);
            // --- new code end --- */
        }
    }
}

template<unsigned DIM>
void TCellChemotacticForce<DIM>::OutputForceParameters(out_stream& rParamsFile)
{
    // No parameters to include

    // Call method on direct parent class
    AbstractForce<DIM>::OutputForceParameters(rParamsFile);
}

// Explicit instantiation
template class TCellChemotacticForce<1>;
template class TCellChemotacticForce<2>;
template class TCellChemotacticForce<3>;

// Serialization for Boost >= 1.36
#include "SerializationExportWrapperForCpp.hpp"
EXPORT_TEMPLATE_CLASS_SAME_DIMS(TCellChemotacticForce)
