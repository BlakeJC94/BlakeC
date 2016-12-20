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

#include "ChemConcentration.hpp"

template<unsigned DIM>
ChemConcentration<DIM>* ChemConcentration<DIM>::mpInstance = NULL;

template<unsigned DIM>
ChemConcentration<DIM>* ChemConcentration<DIM>::Instance()
{
    if (mpInstance == NULL)
    {
        mpInstance = new ChemConcentration;
    }
    return mpInstance;
}

template<unsigned DIM>
ChemConcentration<DIM>::ChemConcentration()
    : mpCellPopulation(NULL)
{
    assert(mpInstance == NULL);
}

template<unsigned DIM>
ChemConcentration<DIM>::~ChemConcentration()
{
}

template<unsigned DIM>
void ChemConcentration<DIM>::Destroy()
{
    if (mpInstance)
    {
        delete mpInstance;
        mpInstance = NULL;
    }
}

template<unsigned DIM>
double ChemConcentration<DIM>::GetChemALevel(CellPtr pCell)
{
    assert(mpCellPopulation!=NULL);
    
    double height;
    height = mpCellPopulation->GetLocationOfCellCentre(pCell)[1];
    
    return GetChemALevel(height);
}

template<unsigned DIM>
void ChemConcentration<DIM>::SetCellPopulation(AbstractCellPopulation<DIM>& rCellPopulation)
{
    mpCellPopulation = &rCellPopulation;
}

template<unsigned DIM>
AbstractCellPopulation<DIM>& ChemConcentration<DIM>::rGetCellPopulation()
{
    return *mpCellPopulation;
}

template<unsigned DIM>
double ChemConcentration<DIM>::GetChemALevel(double height)
{
    double conc_a = 0.0;
    if (height < 5.0)
    {
        conc_a = 1.0 - (height/5.0);
    }
    
    return conc_a;
}

/*
template<unsigned DIM>
bool ChemConcentration<DIM>::IsChemSetUp();
{
    bool result = false;
    if (mpCellPopulation!=NULL)
    {
        result = true;
    }
    return result;
}
*/

template class ChemConcentration<1>;
template class ChemConcentration<2>;
template class ChemConcentration<3>;
    
    
    
