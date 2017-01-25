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

#include "CMCellCycleModel.hpp"
#include "RandomNumberGenerator.hpp"
#include "StemCellProliferativeType.hpp"
#include "TransitCellProliferativeType.hpp"
#include "DifferentiatedCellProliferativeType.hpp"
#include "CellLabel.hpp"
#include "WildTypeCellMutationState.hpp"
#include "RVCellMutationState.hpp"
#include "SmartPointers.hpp"

#include "Debug.hpp"

CMCellCycleModel::CMCellCycleModel()
    : AbstractCellCycleModel(),
      mDivisionThreshold(0.5),
      mAverageDivisionAge(10.0), 
      mStdDivisionAge(1.0)
{
}

CMCellCycleModel::CMCellCycleModel(const CMCellCycleModel& rModel)
   : AbstractCellCycleModel(rModel),
     mDivisionThreshold(rModel.mDivisionThreshold),
     mAverageDivisionAge(rModel.mAverageDivisionAge),
     mStdDivisionAge(rModel.mStdDivisionAge)
{
    /*
     * Initialize only those member variables defined in this class.
     *
     * The member variables mBirthTime, mReadyToDivide and mDimension
     * are initialized in the AbstractCellCycleModel constructor.
     */
}

void CMCellCycleModel::Initialise()
{
    double RandomDivisionAge = GenerateDivisionAge();
    mpCell->GetCellData()->SetItem("DivAge", RandomDivisionAge);
}

void CMCellCycleModel::InitialiseDaughterCell()
{
    double RandomDivisionAge = GenerateDivisionAge();
    mpCell->GetCellData()->SetItem("DivAge", RandomDivisionAge);
}


bool CMCellCycleModel::ReadyToDivide()
{
    assert(mpCell != NULL);
    RandomNumberGenerator* p_gen = RandomNumberGenerator::Instance();
    MAKE_PTR(RVCellMutationState, p_rv_state);
    
    MAKE_PTR(TransitCellProliferativeType, p_transit_type);
    MAKE_PTR(DifferentiatedCellProliferativeType, p_diff_type);
    
    double rv_threshold = 0.1;
    double dt = SimulationTime::Instance()->GetTimeStep();
    double RVProbability = 0.01;
    
    if (  (!mReadyToDivide) && (!mpCell->GetMutationState()->IsType<RVCellMutationState>())  )
    {
        double conc_a = mpCell->GetCellData()->GetItem("concentrationA");
        double conc_b = mpCell->GetCellData()->GetItem("concentrationB");
        double div_threshold = mDivisionThreshold;
        
        
        /* I know this segment looks dumb, but trust me on this. We had issues with
         * Transit cells being recorded in celltypes.dat and rapid divisions, this
         * appeared to fix the issue. 
         * ... At least it used to. Celltypes no longer seems to be counting properly */
        /*
        if (mpCell->GetCellProliferativeType()->IsType<TransitCellProliferativeType>())
        {
            mpCell->SetCellProliferativeType(p_transit_type);
        }
        */
        
        
        /* If a differentiated cell has B > 0.9 then apply the RV mutation 
         * state with random chance (first try deterministic). */
        if (  (mpCell->GetCellProliferativeType()->IsType<DifferentiatedCellProliferativeType>()) && (conc_b > 0.9) && (p_gen->ranf() < RVProbability * dt)  )
        {
            mpCell->SetMutationState(p_rv_state);
            mReadyToDivide = false;
            mpCell->GetCellData()->SetItem("DivAge", 0);
        }
        
        
        double RandomDivisionAge = mpCell->GetCellData()->GetItem("DivAge");
        /* If a transit cell reaches age larger than the RandomDivisionAge, then set
         * mReadyToDivide to true */
        if (  (GetAge() > RandomDivisionAge) && (mpCell->GetCellProliferativeType()->IsType<TransitCellProliferativeType>())  )
        {
            mReadyToDivide = true;
            
            /* Dividing transit cells have a chance (proportional to conc_b) to 
             * become non-proliferative differentiated cells and produce a 
             * non-proliferative differentiated daughter cell. 
             * 
             * If it doesnt differentiate and divide, then remain as transit and divide.
             * Draw a new division age as well (Daughter will get new div age in
             * InitialiseDaughterCell(). */
            double DiffProbability = conc_b;
            if (p_gen->ranf() < DiffProbability)
            {
                mpCell->SetCellProliferativeType(p_diff_type);
            }
            else 
            {
                double RandomDivisionAge = GenerateDivisionAge();
                mpCell->GetCellData()->SetItem("DivAge", RandomDivisionAge);
            }
        }
    }
    
    return mReadyToDivide;
}

AbstractCellCycleModel* CMCellCycleModel::CreateCellCycleModel()
{
    return new CMCellCycleModel(*this);
}

void CMCellCycleModel::SetDivisionThreshold(double divisionThreshold)
{
    mDivisionThreshold = divisionThreshold;
}

double CMCellCycleModel::GetDivisionThreshold()
{
    return mDivisionThreshold;
}

void CMCellCycleModel::SetAverageDivisionAge(double AverageDivisionAge)
{
    mAverageDivisionAge = AverageDivisionAge;
}

double CMCellCycleModel::GetAverageDivisionAge()
{
    return mAverageDivisionAge;
}

void CMCellCycleModel::SetStdDivisionAge(double StdDivisionAge)
{
    mStdDivisionAge = StdDivisionAge;
}

double CMCellCycleModel::GetStdDivisionAge()
{
    return mStdDivisionAge;
}

double CMCellCycleModel::GetAverageTransitCellCycleTime()
{
    return mAverageDivisionAge;
}

double CMCellCycleModel::GetAverageStemCellCycleTime()
{
    return mAverageDivisionAge;
}

double CMCellCycleModel::GenerateDivisionAge()
{
    RandomNumberGenerator* p_gen = RandomNumberGenerator::Instance();
    
    double RandomDivisionAge = p_gen->NormalRandomDeviate(mAverageDivisionAge, mStdDivisionAge);
    // If a negative number is generated, set it to the mean.
    if (RandomDivisionAge < 0)
    {
        RandomDivisionAge = mAverageDivisionAge;
        PRINT_VARIABLE(RandomDivisionAge);
    }
}

void CMCellCycleModel::OutputCellCycleModelParameters(out_stream& rParamsFile)
{
    *rParamsFile << "\t\t\t<DivisionThreshold>" << mDivisionThreshold << "</DivisionThreshold>\n";
    *rParamsFile << "\t\t\t<AverageDivisionAge>" << mAverageDivisionAge << "</AverageDivisionAge>\n";
    *rParamsFile << "\t\t\t<StandardDeviationDivisionAge>" << mStdDivisionAge << "</StandardDeviationDivisionAge>\n";

    // Call method on direct parent class
    AbstractCellCycleModel::OutputCellCycleModelParameters(rParamsFile);
}

// Serialization for Boost >= 1.36
#include "SerializationExportWrapperForCpp.hpp"
CHASTE_CLASS_EXPORT(CMCellCycleModel)
