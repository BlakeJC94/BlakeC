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

CMCellCycleModel::CMCellCycleModel()
    : AbstractCellCycleModel(),
      mDivisionThreshold(0.5),
      mMinimumDivisionAge(10.0)
{
}

CMCellCycleModel::CMCellCycleModel(const CMCellCycleModel& rModel)
   : AbstractCellCycleModel(rModel),
     mDivisionThreshold(rModel.mDivisionThreshold),
     mMinimumDivisionAge(rModel.mMinimumDivisionAge)
{
    /*
     * Initialize only those member variables defined in this class.
     *
     * The member variables mBirthTime, mReadyToDivide and mDimension
     * are initialized in the AbstractCellCycleModel constructor.
     */
}

bool CMCellCycleModel::ReadyToDivide()
{
    assert(mpCell != NULL);
    RandomNumberGenerator* p_gen = RandomNumberGenerator::Instance();
    
    if (!mReadyToDivide)
    {
        double conc_a = mpCell->GetCellData()->GetItem("concentrationA");
        double conc_b = mpCell->GetCellData()->GetItem("concentrationB");
        double div_threshold = mDivisionThreshold;
        
        if (conc_a < div_threshold || conc_b < div_threshold)
        {
            boost::shared_ptr<AbstractCellProperty> p_diff_type =
            mpCell->rGetCellPropertyCollection().GetCellPropertyRegistry()->Get<DifferentiatedCellProliferativeType>();
            mpCell->SetCellProliferativeType(p_diff_type);
            mReadyToDivide = false;
        }
        
        double RandomDivisionAge = p_gen->NormalRandomDeviate(mMinimumDivisionAge, 1.0);
        if (RandomDivisionAge < 7.0)
        {
            RandomDivisionAge = mMinimumDivisionAge;
        }
        
        if (  (GetAge() > RandomDivisionAge) && (mpCell->GetCellProliferativeType()->IsType<TransitCellProliferativeType>())  )
        {
            mReadyToDivide = true;
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

void CMCellCycleModel::SetMinimumDivisionAge(double minimumDivisionAge)
{
    mMinimumDivisionAge = minimumDivisionAge;
}

double CMCellCycleModel::GetMinimumDivisionAge()
{
    return mMinimumDivisionAge;
}

double CMCellCycleModel::GetAverageTransitCellCycleTime()
{
    return mMinimumDivisionAge;
}

double CMCellCycleModel::GetAverageStemCellCycleTime()
{
    return mMinimumDivisionAge;
}

void CMCellCycleModel::OutputCellCycleModelParameters(out_stream& rParamsFile)
{
    *rParamsFile << "\t\t\t<DivisionProbability>" << mDivisionThreshold << "</DivisionProbability>\n";
    *rParamsFile << "\t\t\t<MinimumDivisionAge>" << mMinimumDivisionAge << "</MinimumDivisionAge>\n";

    // Call method on direct parent class
    AbstractCellCycleModel::OutputCellCycleModelParameters(rParamsFile);
}

// Serialization for Boost >= 1.36
#include "SerializationExportWrapperForCpp.hpp"
CHASTE_CLASS_EXPORT(CMCellCycleModel)
