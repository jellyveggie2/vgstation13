/* ==== Reactive load ratios ====
 * Defined as Q/P (reactive load per real load)
 * Positive values indicate inductive loads, eg: magnetic coils, electric AC motors, transformers, fluorescent lamps.
 * Negative values indicate capacitive loads, eg: capacitors, buried wires. These tend to be weaker than inductive loads.
 *
 * For reference: A ratio of 0.75 or -0.75 will result in a displacement power factor of 0.8, which the industry tends to consider "good enough"
 *
 * For machines with no clear IRL equivalent or reactive load where you have to make ups a ratio, I base it on components as follows:
 * - Manipulators: Reactive, due to motors powering the manipulator
 * - Scanners: Slightly reactive, thinking of MRI scans as an extreme example
 * - Lasers: Slightly capacitive, like LEDs
 * - Capacitors: Slighlty distorted, rarely capacitive. Most capacitors are meant for DC and are behind an AC to DC rectifier, they're rarely connected directly to AC
 *
 * ==== Distorted load ratios ====
 * Defined as D/P (distorted load per real load)
 * Distorted loads are caused by non-linear loads, eg: AC to DC rectifiers as found in most computers, lightning arcs, connecting a capacitor bank
 *
 * For reference: IRL this value corresponds to the "THD" (Total Harmonic Distortion), of which IEEE 519 considers 5% THD good for computers and the like
 *
 * ==== Ratio to Power Factor Formula ====
 *  Use this formula if you ever find a PF but no ratio, are missing either the reactive (RQ) or deformation ratio (RD), need to check the
 *  PF resulting from two given ratios, etc.:
 *
 * 	(1/PF)^2 = 1 + RQ^2 + RD^2
*/

// --- Engines ---
// P.A.C.M.A.N.
#define POWER_RATIO_D_PORTABLE_GENERATOR_MIN 0.10  //Normal portable generators are usually within this range
#define POWER_RATIO_D_PORTABLE_GENERATOR_MAX 0.25
#define POWER_RATIO_D_PORTABLE_GENERATOR_SUPER_MIN 0.065 //Halfway between normal and MRS
#define POWER_RATIO_D_PORTABLE_GENERATOR_SUPER_MAX 0.15
#define POWER_RATIO_D_PORTABLE_GENERATOR_MRS_MIN 0.03 //Inverter generators are usually within this range
#define POWER_RATIO_D_PORTABLE_GENERATOR_MRS_MAX 0.05

// --- Power management ---
// Made up values
#define POWER_RATIO_Q_SMES 1.1
#define POWER_RATIO_D_CELL_CHARGER 0.03
#define POWER_RATIO_D_CAPACITOR_CHARGER 0.03

// --- Faults ---
// Fried assistants are bad for your grid's health
#define POWER_RATIO_D_MOB_ELECTROCUTION 0.5

// EMP. Figures completely made up
#define POWER_RATIO_D_EMP_LIGHT 0.8
#define POWER_RATIO_D_EMP_HEAVY 1.5

// --- Computers ---
// Regulations indicate a 3%-5% THD for computers
#define POWER_RATIO_D_COMPUTER 0.04
#define POWER_RATIO_D_SIMPLE_CONSOLE 0.03

// --- Motors ---
// Strong induction motors
// Neat reference here: "https://www.engineeringtoolbox.com/power-factor-electrical-motor-d_654.html"
#define POWER_RATIO_Q_MOTOR 0.6
#define POWER_RATIO_Q_MOTOR_LATHE 1.25 // Lathes and fabricators
#define POWER_RATIO_Q_MOTOR_PUMP 1.73 // Gas and heat pumps
#define POWER_RATIO_Q_MOTOR_MINING 0.95 // Sorters, conveyors, smelters, recyclers...
#define POWER_RATIO_Q_MOTOR_BIO_GRINDER 0.82

// Small precise motors, powered with DC
// Values entirely made up.
#define POWER_RATIO_D_MOTOR_SERVO 0.07
#define POWER_RATIO_D_MOTOR_TINY 0.06

// --- Medical ---
// Figures are all made up, couldn't find any info
#define POWER_RATIO_Q_MEDICAL_SCANNER 0.9

#define POWER_RATIO_Q_MEDICAL_CLONING -0.2
#define POWER_RATIO_D_MEDICAL_CLONING 0.05


// --- Lighting ---
// Good 'ol resistive lightbulbs, 1 DPF, 0% THD
#define POWER_RATIO_Q_LIGHTBULB 0
#define POWER_RATIO_D_LIGHTBULB 0

// CFL lightbulbs, 0.45 DPF, 7.5% THD.
#define POWER_RATIO_Q_LIGHTBULB_HE 1.8
#define POWER_RATIO_D_LIGHTBULB_HE 0.075

// LED lighbulbs, 0.85 DPF, 8% THD
#define POWER_RATIO_Q_LIGHTBULB_LED -0.61
#define POWER_RATIO_D_LIGHTBULB_LED 0.08

// --- Miscellaneous ---
#define POWER_RATIO_Q_FIELD_GENERATOR 1.2 // Fields that move, accelerate or affect stuff in some way
#define POWER_RATIO_Q_SHIELD_GENERATOR 1.4 // Anything that forms some sort of shield or barrier

#define POWER_RATIO_Q_SINGULARITY_BEACON 1.2 // How do you attract a singularity? MAGNETS

#define POWER_RATIO_D_POWER_SINK 0.12 // I doubt the syndicate cares much about the health of NT's powernet

#define POWER_RATIO_Q_ANTIQUE_SYNTH 0.7
#define POWER_RATIO_D_ANTIQUE_SYNTH 0.12 // It is an antique after all

#define POWER_RATIO_Q_LASER -0.61 // For turrets, weapons, emitters and other "strong" lasers
#define POWER_RATIO_D_LASER 0.08

#define POWER_RATIO_Q_PARTICLE 1.4 // Particle accelerators and such
#define POWER_RATIO_D_PARTICLE 0.08

#define POWER_RATIO_Q_MICROWAVE 0.3
#define POWER_RATIO_D_MICROWAVE 0.05

#define POWER_RATIO_Q_RADIO_TRANSMITTER  0.5
#define POWER_RATIO_Q_RADIO_FILTER  -0.25

#define POWER_RATIO_Q_ANALYZER 0.9
