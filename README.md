# superspread
A Monte Carlo based simulation of disease spread, derived from an SIR model.

After all initialization parameters have been set (population size, % vaccinated, spread rate, recovery time), the simulation begins and runs until no further infections occur, or there is an exit due to max iterations being exceeded (5000). 

Interactions are parametrized by a random walk, and this movement is visualized in a dynamic graph. 

There are four active states for the simulated population's individuals:

"Healthy" represents an individual who is not and has never been infected.

"Infected" represents an individual who has become infected.

"Immunized" represents an individual who was either vaccinated at the start of the simulation, or who reached immunization by outlasting the recovery time.

"Dead" represents an individual who is deceased. This is a bit reductionist; more realistically, it might also represent an individual who recovered later with complications.

Enclosed in the "simulations" folder is a set of four outputs in both video and photo form. Each output corresponds to a different spread rate: 10%, 25%, 50%, and 75%. 
