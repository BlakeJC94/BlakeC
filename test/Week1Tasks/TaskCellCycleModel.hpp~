/*
 * = An example showing how to create a new cell-cycle model and use it in a cell-based simulation =
 *
 * == Introduction ==
 *
 * In the previous cell-based Chaste tutorials, we used existing cell-cycle models to define how cells
 * proliferate. In this tutorial, we show how to create a new cell-cycle model class, and how this
 * can be used in a cell-based simulation.
 *
 * == Including header files ==
 *
 * We begin by including the necessary header files. */
#include <cxxtest/TestSuite.h>
#include "CheckpointArchiveTypes.hpp"
#include "AbstractCellBasedTestSuite.hpp"

/* The next header includes the Boost shared_ptr smart pointer, and defines some useful
 * macros to save typing when using it. */
#include "SmartPointers.hpp"
/* The next header includes the NEVER_REACHED macro, used in one of the methods below. */
#include "Exception.hpp"

/* The next header defines a base class for simple generation-based cell-cycle models.
 * A cell-cycle model is defined as ''simple'' if the duration of each phase of the cell
 * cycle is determined when the cell-cycle model is created, rather than
 * evaluated on the fly (e.g. by solving a system of ordinary differential
 * equations for the concentrations of key cell cycle proteins), and may
 * depend on the cell type. A simple cell-cycle model is defined as ''generation-based'' if it keeps track of the
 * generation of the corresponding cell, and sets the cell type according
 * to this. Our new cell-cycle model will inherit from this abstract class. */
#include "AbstractSimpleGenerationBasedCellCycleModel.hpp"

/* The remaining header files define classes that will be used in the cell-based
 * simulation test. We have encountered each of these header files in previous cell-based Chaste
 * tutorials, except for {{{CheckReadyToDivideAndPhaseIsUpdated}}}, which defines a helper
 * class for testing a cell-cycle model. */
#include "CheckReadyToDivideAndPhaseIsUpdated.hpp"
#include "WildTypeCellMutationState.hpp"
#include "GeneralisedLinearSpringForce.hpp"
#include "OffLatticeSimulation.hpp"
#include "StemCellProliferativeType.hpp"
#include "TransitCellProliferativeType.hpp"
#include "DifferentiatedCellProliferativeType.hpp"
//This test is always run sequentially (never in parallel)
#include "FakePetscSetup.hpp"

/*
 * == Defining the cell-cycle model class ==
 *
 * As an example, let us consider a cell-cycle model in which the durations
 * of S, G2 and M phases are fixed, but the duration of G1 phase is an exponential
 * random variable with rate parameter λ. This rate parameter is a constant, dependent on cell type, whose value is
 * chosen such that the mean of the distribution, 1/λ, equals the mean
 * G1 duration as defined in the {{{AbstractCellCycleModel}}} class. We will also assume that
 * cells divide a certain number of generations before becoming differentiated. To implement this model we define a new cell-cycle model, {{{TaskCellCycleModel}}},
 * which inherits from {{{AbstractSimpleGenerationBasedCellCycleModel}}} and
 * overrides the {{{SetG1Duration()}}} method.
 *
 * Note that usually this code would be separated out into a separate declaration in
 * a .hpp file and definition in a .cpp file.
 */
class TaskCellCycleModel : public AbstractSimpleCellCycleModel
{
    friend class TestSimpleCellCycleModels;
private:
    
    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & archive, const unsigned int version)
    {
        archive & boost::serialization::base_object<AbstractSimpleCellCycleModel>(*this);
        RandomNumberGenerator* p_gen = RandomNumberGenerator::Instance();
        archive & *p_gen;
        archive & p_gen;
    }

    /* Override the {{{SetG1Duration()}}} method. */
    void SetG1Duration()
    {
    
        /* As we will access the cell type of the cell associated with this cell
         * cycle model, we should assert that this cell exists. */
         assert(mpCell != NULL);

        /* Set the G1 duration based on cell type. */
        double uniform_random_number = RandomNumberGenerator::Instance()->ranf();
        
        if (mpCell->HasCellProperty<CellLabel>()) 
        {
            if (mpCell->GetCellProliferativeType()->IsType<StemCellProliferativeType>())
            {
                mG1Duration = GetStemCellG1Duration() + 2*uniform_random_number + 9; // U[11,13]
            }
            else if (mpCell->GetCellProliferativeType()->IsType<TransitCellProliferativeType>())
            {
                mG1Duration = GetTransitCellG1Duration() + 2*uniform_random_number + 9; // U[11,13]
            }
            else if (mpCell->GetCellProliferativeType()->IsType<DifferentiatedCellProliferativeType>())
            {
                mG1Duration = DBL_MAX;
            }
            else
            {
                NEVER_REACHED;
            }
        }
        else if (!(mpCell->HasCellProperty<CellLabel>()))
        {
            if (mpCell->GetCellProliferativeType()->IsType<StemCellProliferativeType>())
            {
                mG1Duration = -log(uniform_random_number)*GetStemCellG1Duration() * 12; // E[12]
            }
            else if (mpCell->GetCellProliferativeType()->IsType<TransitCellProliferativeType>())
            {
                mG1Duration = -log(uniform_random_number)*GetTransitCellG1Duration() * 12; // E[12]
            }
            else if (mpCell->GetCellProliferativeType()->IsType<DifferentiatedCellProliferativeType>())
            {
                mG1Duration = DBL_MAX;
            }
            else 
            {
                NEVER_REACHED;
            }
        }
    }   


/* The first public method is a default constructor, which just calls the base
 * constructor. */
public:

    TaskCellCycleModel()
    {}

    /* The second public method overrides {{{CreateCellCycleModel()}}}. This is a
     * builder method to create new copies of the cell-cycle model. We first create
     * a new cell-cycle model, then set each member variable of the new cell-cycle
     * model that inherits its value from the parent.
     *
     * There are a number of things to mention regarding the {{{CreateCellCycleModel()}}}
     * method: these are quite technical, but are worth stating here for the sake of
     * completeness. If we look at which member variables
     * {{{TaskCellCycleModel}}} inherits from its base class, we will find that some of
     * these member variables are not set here. This is for two main reasons. First, some
     * of the new cell-cycle model's member variables (namely {{{mBirthTime}}},
     * {{{mCurrentCellCyclePhase}}}, {{{mReadyToDivide}}}) will already have been
     * correctly initialized in the new cell-cycle model's constructor. Second, the
     * member variable {{{mDimension}}} remains unset, since this cell-cycle
     * model does not need to know the spatial dimension, so if we were to call
     * {{{SetDimension()}}} on the new cell-cycle model an exception would be triggered;
     * hence we do not set this member variable. It is also worth noting that in a simulation,
     * one or more of the new cell-cycle model's member variables
     * may be set/overwritten as soon as {{{InitialiseDaughterCell()}}} is called on
     * the new cell-cycle model; this occurs when the associated cell has called its
     * {{{Divide()}}} method.
     */
    AbstractCellCycleModel* CreateCellCycleModel()
    {
        TaskCellCycleModel* p_model = new TaskCellCycleModel();
        
        p_model->SetBirthTime(mBirthTime);
        p_model->SetMinimumGapDuration(mMinimumGapDuration);
        p_model->SetStemCellG1Duration(mStemCellG1Duration);
        p_model->SetTransitCellG1Duration(mTransitCellG1Duration);
        p_model->SetSDuration(mSDuration);
        p_model->SetG2Duration(mG2Duration);
        p_model->SetMDuration(mMDuration);
        
        return p_model;
    }
};

/* We need to include the next block of code if you want to be able to archive (save or load)
 * the cell-cycle model object in a cell-based simulation. It is also required for writing out
 * the parameters file describing the settings for a simulation - it provides the unique
 * identifier for our new cell-cycle model. Thus every cell-cycle model class must provide this,
 * or you'll get errors when running simulations. */
#include "SerializationExportWrapper.hpp"
CHASTE_CLASS_EXPORT(TaskCellCycleModel);

/* Since we're defining the new cell-cycle model within the test file, we need to include the
 * following stanza as well, to make the code work with newer versions of the Boost libraries.
 * Normally the above export declaration would occur in the cell-cycle model's .hpp file, and
 * the following lines would appear in the .cpp file.  See ChasteGuides/BoostSerialization for
 * more information.
 */
#include "SerializationExportWrapperForCpp.hpp"
CHASTE_CLASS_EXPORT(TaskCellCycleModel);
