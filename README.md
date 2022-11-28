# superspread
A Monte Carlo based simulation of disease spread, similar to an SIR model.

After all initialization parameters have been set (population size, % vaccinated, spread rate, recovery time), the simulation begins and runs until no further infections occur, or there is an exit due to max iterations being exceeded (5000). 

Interactions are parametrized by a random walk, and this movement is visualized in a dynamic graph. 

There are four active states for the simulated population's individuals. 

"Healthy" represents an individual who was never infected. 
"Infected" represents an individual who has been infected.
"Immunized" represents an individual who was either vaccinated at the start, who reached immunization by surviving the recovery time. 
"Dead" represents an individual who is deceased. 
