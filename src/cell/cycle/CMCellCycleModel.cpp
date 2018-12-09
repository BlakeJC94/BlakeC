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
      mTDProbability(0.55),
      mRVProbability(0.1),
      mCritVolume(0.58),
      mDiffModel(4),
      mDiffModelParam(0.6),
      mTDYThreshold(0.0),
      mAverageDivisionAge(10.0), 
      mStdDivisionAge(1.0)
{
}

CMCellCycleModel::CMCellCycleModel(const CMCellCycleModel& rModel)
   : AbstractCellCycleModel(rModel),
     mTDProbability(rModel.mTDProbability),
     mRVProbability(rModel.mRVProbability),
     mCritVolume(rModel.mCritVolume),
     mDiffModel(rModel.mDiffModel),
     mDiffModelParam(rModel.mDiffModelParam),
     mTDYThreshold(rModel.mTDYThreshold),
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
    mpCell->GetCellData()->SetItem("DivisionDelay", 0);
}

void CMCellCycleModel::InitialiseDaughterCell()
{
    double RandomDivisionAge = GenerateDivisionAge();
    mpCell->GetCellData()->SetItem("DivAge", RandomDivisionAge);
    mpCell->GetCellData()->SetItem("DivisionDelay", 0);
}

bool CMCellCycleModel::ReadyToDivide()
{
    assert(mpCell != NULL);
    RandomNumberGenerator* p_gen = RandomNumberGenerator::Instance();
    
    MAKE_PTR(RVCellMutationState, p_rv_state);   
    
    //if (  (!mReadyToDivide) && (!mpCell->GetMutationState()->IsType<RVCellMutationState>())  )
    // Changed to allow RV cells to divide (same rate)
    if (!mReadyToDivide)
    {
        MAKE_PTR(TransitCellProliferativeType, p_transit_type);
        MAKE_PTR(DifferentiatedCellProliferativeType, p_diff_type);
    
        double dt = SimulationTime::Instance()->GetTimeStep();
        
        //double conc_a = mpCell->GetCellData()->GetItem("concentrationA");
        //double conc_b = mpCell->GetCellData()->GetItem("concentrationB");
        
        
        /* Apply the RV mutation state with random chance to 
         * differntiated cells. 
        double RVProbability = 1-conc_b;
        
        if (  (mpCell->GetCellProliferativeType()->IsType<DifferentiatedCellProliferativeType>()) && (p_gen->ranf() < RVProbability * dt)  )
        {
            mpCell->SetMutationState(p_rv_state);
            mReadyToDivide = false;
            mpCell->GetCellData()->SetItem("DivAge", 0);
        }
        */ // SIMPLIFY MODEL: Remove intermediate DiffCMcells.
        if (mpCell->GetCellProliferativeType()->IsType<DifferentiatedCellProliferativeType>()) 
        {
            mpCell->SetMutationState(p_rv_state);
            // Changed to allow RV cells to divide (same rate)
            //mReadyToDivide = false;
            //mpCell->GetCellData()->SetItem("DivAge", 0);
        }
        
        
        /* If volume of the cell is below threshold, delay division */
        double cell_volume = mpCell->GetCellData()->GetItem("volume");
        double crit_vol = mCritVolume; 
        double RandomDivisionAge = mpCell->GetCellData()->GetItem("DivAge");
        
        if (cell_volume < crit_vol)
        {
            RandomDivisionAge += dt;
            mpCell->GetCellData()->SetItem("DivAge", RandomDivisionAge);
            
            double smoof = mpCell->GetCellData()->GetItem("DivisionDelay");
            smoof += dt;
            mpCell->GetCellData()->SetItem("DivisionDelay", smoof);
            
            mReadyToDivide = false;
        }
            
        
        /* If a transit cell reaches age larger than the RandomDivisionAge, 
         * then set mReadyToDivide to true */
        //if (  (GetAge() > RandomDivisionAge) && (mpCell->GetCellProliferativeType()->IsType<TransitCellProliferativeType>())  )
        // Changed to allow RV cells to divide (same rate)
        if (GetAge() > RandomDivisionAge)
        {
            mReadyToDivide = true;
            mpCell->GetCellData()->SetItem("DivisionDelay", 0);
            
            /* Dividing transit cells have a chance (constant) to 
             * become non-proliferative differentiated cells and produce a 
             * non-proliferative differentiated daughter cell. 
             * 
             * If it doesnt differentiate and divide, then remain as transit and divide.
             * Draw a new division age as well (Daughter will get new div age in
             * InitialiseDaughterCell(). */
            //double DiffProbability = 1-conc_b;
            double DiffProbability = 0;
            int DiffModel = mDiffModel;
            double DiffModelParam = mDiffModelParam;
            
            double cell_x = mpCell->GetCellData()->GetItem("cellHorizPosition");
            
            if (DiffModel == 0) // Constant
            {
                DiffProbability = DiffModelParam;
            }
            else if (DiffModel == 1) // Step
            {
                DiffProbability = 1.0;
                if (cell_x < 20.0*mDiffModelParam)
                {
                    DiffProbability = 0.0;
                }
            }
            else if (DiffModel == 2) // Linear
            {
                DiffProbability = 1 - mDiffModelParam * (1 - cell_x/20);
            }        
            else if (DiffModel == 3) // Ramp
            {
                DiffProbability = 1.0;
                if (cell_x < 20.0*DiffModelParam)
                {
                    DiffProbability = cell_x/(20.0*DiffModelParam);
                }
            }
            else if (DiffModel == 4) // Smooth curve
            {
                DiffProbability = 1 - exp(-pow(cell_x,2)/(2*pow(5.5,2)));
            }
            else 
            {
                NEVER_REACHED;
            }
            
            
            
            
            double DiffYThreshold = mTDYThreshold;
            
            //if ( (p_gen->ranf() < DiffProbability) && (conc_a < DiffYThreshold) ) // conc_a < or >?
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


void CMCellCycleModel::SetTDProbability(double tdProbability)
{
    mTDProbability = tdProbability;
}

double CMCellCycleModel::GetTDProbability()
{
    return mTDProbability;
}


void CMCellCycleModel::SetRVProbability(double rvProbability)
{
    mRVProbability = rvProbability;
}

double CMCellCycleModel::GetRVProbability()
{
    return mRVProbability;
}


void CMCellCycleModel::SetCritVolume(double critVolume)
{
    mCritVolume = critVolume;
}

double CMCellCycleModel::GetCritVolume()
{
    return mCritVolume;
}


void CMCellCycleModel::SetDiffModel(int diffModel)
{
    mDiffModel = diffModel;
}

int CMCellCycleModel::GetDiffModel()
{
    return mDiffModel;
}


void CMCellCycleModel::SetDiffModelParam(double diffModelParam)
{
    mDiffModelParam = diffModelParam;
}

double CMCellCycleModel::GetDiffModelParam()
{
    return mDiffModelParam;
}


void CMCellCycleModel::SetTDYThreshold(double tdYThreshold)
{
    mTDYThreshold = tdYThreshold;
}

double CMCellCycleModel::GetTDYThreshold()
{
    return mTDYThreshold;
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
    *rParamsFile << "\t\t\t<TDProbability>" << mTDProbability << "</TDProbability>\n";
    *rParamsFile << "\t\t\t<DRvProbability>" << mRVProbability << "</DRvProbability>\n";
    *rParamsFile << "\t\t\t<AverageDivisionAge>" << mAverageDivisionAge << "</AverageDivisionAge>\n";
    *rParamsFile << "\t\t\t<StandardDeviationDivisionAge>" << mStdDivisionAge << "</StandardDeviationDivisionAge>\n";

    // Call method on direct parent class
    AbstractCellCycleModel::OutputCellCycleModelParameters(rParamsFile);
}

// Serialization for Boost >= 1.36
#include "SerializationExportWrapperForCpp.hpp"
CHASTE_CLASS_EXPORT(CMCellCycleModel)
