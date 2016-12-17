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
#include "Exception.hpp"
#include "StemCellProliferativeType.hpp"
#include "TransitCellProliferativeType.hpp"
#include "DifferentiatedCellProliferativeType.hpp"
#include "CellLabel.hpp"
#include "WildTypeCellMutationState.hpp"

CMCellCycleModel::CMCellCycleModel()
{
}

CMCellCycleModel::CMCellCycleModel(const CMCellCycleModel& rModel)
   : AbstractSimpleGenerationalCellCycleModel(rModel)
{
    /*
     * The member variables mGeneration and mMaxTransitGeneration are
     * initialized in the AbstractSimpleGenerationalCellCycleModel
     * constructor.
     *
     * The member variables mCurrentCellCyclePhase, mG1Duration,
     * mMinimumGapDuration, mStemCellG1Duration, mTransitCellG1Duration,
     * mSDuration, mG2Duration and mMDuration are initialized in the
     * AbstractPhaseBasedCellCycleModel constructor.
     *
     * The member variables mBirthTime, mReadyToDivide and mDimension
     * are initialized in the AbstractCellCycleModel constructor.
     *
     * Note that mG1Duration is (re)set as soon as InitialiseDaughterCell()
     * is called on the new cell-cycle model.
     */
}

void CMCellCycleModel::SetSpawnRate(double newValue)
{
    mSpawnRate = newValue;
}

void CMCellCycleModel::SetDivThreshold(double newValue)
{
    mDivThreshold = newValue;
}

AbstractCellCycleModel* CMCellCycleModel::CreateCellCycleModel()
{
    return new CMCellCycleModel(*this);
}

void CMCellCycleModel::SetG1Duration()
{
    assert(mpCell != NULL);
    RandomNumberGenerator* p_gen = RandomNumberGenerator::Instance();
    
    //double lambda = mSpawnRate; // To be re-implemented when needed

    if (mpCell->GetCellProliferativeType()->IsType<StemCellProliferativeType>())
    {
        NEVER_REACHED;
        //mG1Duration = GetStemCellG1Duration() + 4*p_gen->ranf(); // U[14,18] 
    }
    else if (mpCell->GetCellProliferativeType()->IsType<TransitCellProliferativeType>())
    {
        /*
        mMDuration = mSpawnRate/4;
        mG1Duration = mSpawnRate/4;
        mSDuration = mSpawnRate/4;
        mG2Duration = mSpawnRate/4;
        */
        /*
        mMDuration = 0.01;
        mG1Duration = 0.01;
        mSDuration = 0.01;
        mG1Duration = 0.01; // U[4,6] 
        */
        //mG1Duration = (-log(p_gen->ranf()))/mSpawnRate; // E[mSpawnRate]
        //mG1Duration = GetTransitCellG1Duration() + 2*p_gen->ranf(); // U[4,6] 
        mG1Duration = p_gen->NormalRandomDeviate(10,1.5); // U[4,6]
    }
    else if (mpCell->GetCellProliferativeType()->IsType<DifferentiatedCellProliferativeType>())
    {
        mG1Duration = DBL_MAX;
    }
    else
    {
        NEVER_REACHED;
    }
    
    if (mG1Duration < mMinimumGapDuration)
    {
        mG1Duration = mMinimumGapDuration;
    }
}

void CMCellCycleModel::UpdateCellCyclePhase()
{
    // Prolif region = region where A and B is greater than div_threshold
    //double div_threshold = 0.4; //0.6
    double div_threshold = mDivThreshold;
    
    /* Insert set up for specifying specific div thresholds here 
     * (To be implemented when attachment procedure is written)
    if (mpCell->GetMutationState()->IsType<WildTypeCellMutationState>())
    {
        div_threshold = 0.5;
    }
    else
    {
        NEVER_REACHED;
    }
    
    if (mpCell->HasCellProperty<CellLabel>())
    {
        div_threshold = 0.7;
    }
    */
    
    double conc_a = mpCell->GetCellData()->GetItem("concentrationA");
    double conc_b = mpCell->GetCellData()->GetItem("concentrationB");
    
    //double chem_level = conc_a + conc_b;
    
    // If A transit cell is outside prolif region, become differentiated.
    if (mpCell->GetCellProliferativeType()->IsType<TransitCellProliferativeType>())
    {
        if (conc_a < div_threshold || conc_b < div_threshold)
        {
            boost::shared_ptr<AbstractCellProperty> p_diff_type =
            mpCell->rGetCellPropertyCollection().GetCellPropertyRegistry()->Get<DifferentiatedCellProliferativeType>();
            mpCell->SetCellProliferativeType(p_diff_type);
        }
    }
    
    AbstractSimplePhaseBasedCellCycleModel::UpdateCellCyclePhase();
}

void CMCellCycleModel::InitialiseDaughterCell()
{


    boost::shared_ptr<AbstractCellProperty> p_transit_type =
            mpCell->rGetCellPropertyCollection().GetCellPropertyRegistry()->Get<TransitCellProliferativeType>();
    mpCell->SetCellProliferativeType(p_transit_type);

    AbstractSimplePhaseBasedCellCycleModel::InitialiseDaughterCell();
}

void CMCellCycleModel::OutputCellCycleModelParameters(out_stream& rParamsFile)
{
    // No new parameters to output, so just call method on direct parent class
    AbstractSimpleGenerationalCellCycleModel::OutputCellCycleModelParameters(rParamsFile);
}

// Serialization for Boost >= 1.36
#include "SerializationExportWrapperForCpp.hpp"
CHASTE_CLASS_EXPORT(CMCellCycleModel)
