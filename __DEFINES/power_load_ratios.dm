/* == Reactive load ratios ==
 * Measured in Q/R (reactive load per real load)
 * Positive values indicate inductive loads, eg: magnetic coils, electric motors, transformers, fluorescent lamps.
 * Negative values indicate capacitive loads, eg: capacitors, buried wires. These tend to be weaker than inductive loads.
 *
 * For reference: A ratio of 0.75 or -0.75 will result in a power factor of 0.8, which the industry tends to consider "good enough"
*/
//define POWER_RATIO_Q_foo

#define POWER_RATIO_Q_SINGULARITY_BEACON 0.9 // How do you attract a singularity? MAGNETS
#define POWER_RATIO_Q_SHIELD_GENERATOR 0.8 // Anything that forms some sort of shield or barrier


/* == Deformed load ratios ==
 * Measured in D/R (deformed load per real load)
 * Deformed loads are caused by non-linear loads, eg: AC to DC rectifiers as found in most computers, lightning arcs, connecting a capacitor bank
 *
 * For reference: This value corresponds to the "THD" (Total Harmonic Distortion), of which IEEE 519 considers 5% THD good for computers and the like
*/

#define POWER_RATIO_D_CELL_CHARGER 0.03
#define POWER_RATIO_D_COMPUTER 0.05
#define POWER_RATIO_D_COMPUTER_EMAGGED 0.15

//P.A.C.M.A.N.
#define POWER_RATIO_D_PORTABLE_GENERATOR_MIN 0.10  //Normal portable generators are usually within this range
#define POWER_RATIO_D_PORTABLE_GENERATOR_MAX 0.25
#define POWER_RATIO_D_PORTABLE_GENERATOR_SUPER_MIN 0.065 //Halfway between normal and MRS
#define POWER_RATIO_D_PORTABLE_GENERATOR_SUPER_MAX 0.15
#define POWER_RATIO_D_PORTABLE_GENERATOR_MRS_MIN 0.03 //Inverter generators are usually within this range
#define POWER_RATIO_D_PORTABLE_GENERATOR_MRS_MAX 0.05

#define POWER_RATIO_D_MOB_ELECTROCUTION 0.5


#define POWER_RATIO_D_POWER_SINK 0.1
