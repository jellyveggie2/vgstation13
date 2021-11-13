/datum/powernet_load
	var/real_load = 0			// the current useful load on the powernet, increased by each machine at processing
	var/reactive_load = 0		// the reactive load on the powernet, increased by inductive machines, decreased by capacitive machines. Can be negative.
	var/deformed_load = 0		// the distortion load on the powernet, increased by AC-to-DC converters (eg: computers), faulty equipment, and others.

/datum/powernet_load/New(apparent_load=0, reactive_ratio=0, deformed_ratio=0)
	add_apparent_load(apparent_load, reactive_ratio, deformed_ratio)

//--- load management ---
/datum/powernet_load/proc/reset()
	real_load = 0
	reactive_load = 0
	deformed_load = 0

/datum/powernet_load/proc/add_load(datum/powernet_load/load)
	add_loads(load.real_load, load.reactive_load, load.deformed_load)
	return load.real_load

/datum/powernet_load/proc/add_loads(real_load, reactive_load, deformed_load)
	add_real_load(real_load)
	add_reactive_load(reactive_load)
	add_deformed_load(deformed_load)

/datum/powernet_load/proc/add_real_load(real_load)
	src.real_load = max(0, src.real_load + real_load)

/datum/powernet_load/proc/add_reactive_load(reactive_load)
	src.reactive_load += reactive_load

/datum/powernet_load/proc/add_deformed_load(deformed_load)
	src.deformed_load = max(0, src.deformed_load + deformed_load)

/* Ratios are measured in Q/P and D/P
 * So, if real power is 100W, a reactive ratio of 1/2 will result in 50var, and a deformed ratio of 1/5 in 20VAD
 * Returns he real load that was added, for cells and other chargers
 */
/datum/powernet_load/proc/add_apparent_load(apparent_load, reactive_ratio, deformed_ratio)
	deformed_ratio = max(deformed_ratio, 0)
	var/real_load = abs(apparent_load) / sqrt(1 + reactive_ratio ** 2 + deformed_ratio ** 2)
	add_loads(real_load, real_load * reactive_ratio, real_load * deformed_ratio)
	return real_load

//--- helpers ---
/datum/powernet_load/proc/apparent_load()
	return sqrt(real_load ** 2 + reactive_load ** 2 + deformed_load ** 2)

/datum/powernet_load/proc/power_factor()
	return real_load / apparent_load()
