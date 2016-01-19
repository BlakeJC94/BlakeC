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

#include "TCellTumorSpringForce.hpp"
#include "IsNan.hpp"
#include "TCellProperty.hpp"
#include "TumorCellProperty.hpp"
#include "ImmortalCellProperty.hpp"

template<unsigned DIM>
TCellTumorSpringForce<DIM>::TCellTumorSpringForce()
   : GeneralisedLinearSpringForce<DIM>()
{
}

template<unsigned DIM>
void TCellTumorSpringForce<DIM>::AddForceContribution(AbstractCellPopulation<DIM>& rCellPopulation)
{
    // Throw an exception message if not using a NodeBasedCellPopulation
    if (dynamic_cast<NodeBasedCellPopulation<DIM>*>(&rCellPopulation) == NULL)
    {
        EXCEPTION("TCellTumorSpringForce is to be used with a NodeBasedCellPopulation only");
    }

    std::vector< std::pair<Node<DIM>*, Node<DIM>* > >& r_node_pairs = (static_cast<NodeBasedCellPopulation<DIM>*>(&rCellPopulation))->rGetNodePairs();

    for (typename std::vector< std::pair<Node<DIM>*, Node<DIM>* > >::iterator iter = r_node_pairs.begin();
        iter != r_node_pairs.end();
        iter++)
    {
        std::pair<Node<DIM>*, Node<DIM>* > pair = *iter;

        Node<DIM>* p_node_a = pair.first;
        Node<DIM>* p_node_b = pair.second;

        // Get the node locations
        c_vector<double, DIM> node_a_location = p_node_a->rGetLocation();
        c_vector<double, DIM> node_b_location =  p_node_b->rGetLocation();

        // Get the node radii
        double node_a_radius = p_node_a->GetRadius();
        double node_b_radius = p_node_b->GetRadius();
        
        // Get the node indices
        unsigned node_a_index = p_node_a->GetIndex();
        unsigned node_b_index = p_node_b->GetIndex();
        
        // Get the cells associated with these indices
        CellPtr p_cell_a = rCellPopulation.GetCellUsingLocationIndex(node_a_index);
        CellPtr p_cell_b = rCellPopulation.GetCellUsingLocationIndex(node_b_index);
        
        // Applies RepulsionForce to T-Cells
        if ((p_cell_a->template HasCellProperty<TCellProperty>()) && (p_cell_b->template HasCellProperty<TCellProperty>()))
        {
        
            // Get the unit vector parallel to the line joining the two nodes
            c_vector<double, DIM> unit_difference;

            unit_difference = (static_cast<NodeBasedCellPopulation<DIM>*>(&rCellPopulation))->rGetMesh().GetVectorFromAtoB(node_a_location, node_b_location);

            // Calculate the value of the rest length
            double rest_length = node_a_radius+node_b_radius;

            if (norm_2(unit_difference) < rest_length)
            {
                // Calculate the force between nodes
                c_vector<double, DIM> force = this->CalculateForceBetweenNodes(p_node_a->GetIndex(), p_node_b->GetIndex(), rCellPopulation);
                c_vector<double, DIM> negative_force = -1.0 * force;
                for (unsigned j=0; j<DIM; j++)
                {
                    assert(!std::isnan(force[j]));
                }
                // Add the force contribution to each node
                p_node_a->AddAppliedForceContribution(force);
                p_node_b->AddAppliedForceContribution(negative_force);
                
            }
        }
        // Applies GeneralisedLinearSpringForce to Tumor cells
        else if ((p_cell_a->template HasCellProperty<TumorCellProperty>()) && (p_cell_b->template HasCellProperty<TumorCellProperty>())) 
        //   The above code does not apply force to Tumor cells for reasons unknown..?
        //else if (  ( !(p_cell_a->template HasCellProperty<TCellProperty>()) && !(p_cell_a->template HasCellProperty<ImmortalCellProperty>()) ) &&
        //            ( !(p_cell_b->template HasCellProperty<TCellProperty>()) && !(p_cell_b->template HasCellProperty<ImmortalCellProperty>()) )  )
        {   
            // Calculate the force between nodes
            c_vector<double, DIM> force = this->CalculateForceBetweenNodes(p_node_a->GetIndex(), p_node_b->GetIndex(), rCellPopulation);
            c_vector<double, DIM> negative_force = -1.0 * force;
            for (unsigned j=0; j<DIM; j++)
            {
                assert(!std::isnan(force[j]));
            }
            // Add the force contribution to each node
            p_node_a->AddAppliedForceContribution(force);
            p_node_b->AddAppliedForceContribution(negative_force);
            
        }
    }
}

template<unsigned DIM>
void TCellTumorSpringForce<DIM>::OutputForceParameters(out_stream& rParamsFile)
{
    // Call direct parent class
    GeneralisedLinearSpringForce<DIM>::OutputForceParameters(rParamsFile);
}

// Explicit instantiation
template class TCellTumorSpringForce<1>;
template class TCellTumorSpringForce<2>;
template class TCellTumorSpringForce<3>;

// Serialization for Boost >= 1.36
#include "SerializationExportWrapperForCpp.hpp"
EXPORT_TEMPLATE_CLASS_SAME_DIMS(TCellTumorSpringForce)
