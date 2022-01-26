/**
=== Brief Intro to AC Power and Power Factor===

AC Power is represented as a vector with three components:
	- Real Power (P): Power that is actually doing some work, measured in W.

	- Reactive Power (Q): Measured in VAR. Losses due to current either leading or lagging behind voltage, causing useless power that is released
		and reabsorbed each cycle. As inductors cause lag, and capacitors lead, it'll be positive or negative depending on whether you've got too
		many inductors or capacitors.

	- Distorted Power (D): Measured in VAD. Losses caused by distortions in the sinewave, usually caused by non-linear loads, eg: a computer's
		PSU, and most other DC-to-AC converters.

The vector's norm gives us the Apparent Power (S): Measured in VA. How much power actually has to travel through the grid to meet demand.

There are some properties of this vector that are of interest, in order of popularity:
	- Power Factor (PF):
			PF = P / S = DPF * DF
		A measure of how efficiently power is being transferred. Industry tends to consider PF 0.8 as good enough. (see below for DPF and DF)

	- Displacement Power Factor (DPF):
			DPF = P / (P^2 + Q^2)
		Power factor if ignoring D. Also known as "cosphi" due to being equivalent to the cosine of the angle between P and Q. IEEE convention has
		 DPF caused by inductors marked with a minus sign, and DPF caused by capacitors marked with a plus sign. See https://www.se.com/ww/en/faqs/FA212521/

	- Total Harmonic Distortion (THD), or Distortion Ratio:
			THD = D / P
		How much VAD per W you're getting. Usually expressed as a percentage, though it can go past 100%. Calculated measuring
		 the sine wave's odd harmonics, hence the name, but that formula won't be relevant here.

	- Distortion Factor (DF):
			DF = P / (P^2 + D^2)
		Power factor if ignoring Q. The D equivalent of DPF

	- Reactive Ratio (QR):
			QR = Q / P
		How much VAR per W you're getting. Reactive equivalent to THD.

** TL;DR: For maximum efficiency, keep a balance of capacitors and inductors to keep DPF close to 1, and correct any distortions
 to the sinewave to keep THD close to 0. **
*/

#define POWER_FACTOR_RATING_BAD 0
#define POWER_FACTOR_RATING_AVERAGE 1
#define POWER_FACTOR_RATING_GOOD 2

#define POWER_FACTOR_THRESHOLD_AVERAGE 0.7
#define POWER_FACTOR_THRESHOLD_GOOD 0.9

#define DISPLACEMENT_POWER_FACTOR_THRESHOLD_AVERAGE 0.7
#define DISPLACEMENT_POWER_FACTOR_THRESHOLD_GOOD 0.9

#define TOTAL_HARMONIC_DISTORTION_THRESHOLD_AVERAGE 0.08
#define TOTAL_HARMONIC_DISTORTION_THRESHOLD_GOOD 0.05

/datum/power_vector

	var/P = 0	// Real power, measured in W
	var/Q = 0	// Reactive power, measured in VAR (+inductors, -capacitors)
	var/D = 0	// Distorted power, measured in VAD
	//  S = |v|	// Apparent power, measured in VA

/*
 * 'ratios' set to TRUE switches the meaning of 'reactive' and 'distorted' from power to ratios
 * eg: power: 2.0, reactive: 0.5, ratios: TRUE  -> 2.0 W, 1.0 VAR
 *     power: 2.0, reactive: 0.5, ratios: FALSE -> 2.0 W, 0.5 VAR */
/datum/power_vector/New(power=0, reactive=0, distorted=0, ratios=TRUE)
	P = power
	if (ratios)
		Q = P * reactive
		D = P * distorted
	else
		Q = reactive
		D = distorted

/datum/power_vector/proc/duplicate()
	return new /datum/power_vector(P, Q, D, FALSE)

/datum/power_vector/proc/reset()
	P = 0
	Q = 0
	D = 0


// -- Vector Operations --
// Addition
/datum/power_vector/proc/operator+(datum/power_vector/v)
	return new /datum/power_vector(P + v.P, Q + v.Q, D + v.D, FALSE)
/datum/power_vector/proc/operator+=(datum/power_vector/v)
	P += v.P
	Q += v.Q
	D += v.D

/datum/power_vector/proc/operator-(datum/power_vector/v)
	return new /datum/power_vector(P - v.P, Q - v.Q, D - v.D, FALSE)
/datum/power_vector/proc/operator-=(datum/power_vector/v)
	P -= v.P
	Q -= v.Q
	D -= v.D

// Product
/datum/power_vector/proc/dot_product(datum/power_vector/v)
	return P * v.P + Q * v.Q + D * v.D

/datum/power_vector/proc/operator*(x)
	return new /datum/power_vector(P * x, Q * x, D * x, FALSE)
/datum/power_vector/proc/operator*=(x)
	P *= x
	Q *= x
	D *= x

/datum/power_vector/proc/operator/(k)
	return new /datum/power_vector(P / k, Q / k, D / k, FALSE)

// Cross Product
/datum/power_vector/proc/cross(datum/power_vector/v)
	return new /datum/power_vector(Q * v.D - D * v.Q, D * v.P - P * v.D, P * v.Q - Q * v.P, FALSE)

// Norm
/datum/power_vector/proc/norm() //aka "Apparent power", or "S"
	return sqrt(P**2 + Q**2 + D**2)

/datum/power_vector/proc/normalized()
	return src / norm()

/datum/power_vector/proc/unit()
	return src / P

// Equals
/datum/power_vector/proc/equals(datum/power_vector/v)
	return (P == v.P && Q == v.Q && D == v.D)


// --- Power operations ---
// General
/datum/power_vector/proc/apparent_power()
	return norm()

// Power factor
/datum/power_vector/proc/power_factor()
	return P ? P / norm() : 1

// Reactive ratio/factor
/datum/power_vector/proc/reactive_ratio()
	return P ? Q / P : 0
/datum/power_vector/proc/qr()
	return reactive_ratio()

/datum/power_vector/proc/set_reactive_ratio(qr)
	Q = P * qr

/datum/power_vector/proc/reactive_factor() // aka. cosphi, or Displacement Power Factor (DPF)
	var/sign = Q > 0 ? -1 : 1 //Positive VAR -> negative DPF, negative VAR -> positive DPF. IEEE sez so. ...Or so Schneider Electrics claims: https://www.se.com/ww/en/faqs/FA212521/
	return P ? sign * (P / sqrt(P**2 + Q**2)) : 1

/datum/power_vector/proc/set_reactive_factor(qf)
	var/sign = qf >= 0 ? -1 : 1
	Q = sign * sqrt((P/qf)**2 - P**2)

// Distorted ratio/factor
/datum/power_vector/proc/distortion_ratio() // aka. Total Harmonic Distortion (THD)
	return P ? D / P : 0
/datum/power_vector/proc/dr()
	return distortion_ratio()

/datum/power_vector/proc/set_distortion_ratio(dr)
	D = P * dr

/datum/power_vector/proc/distortion_factor()
	return P ? P / sqrt(P**2 + D**2) : 1

/datum/power_vector/proc/set_distortion_factor(df)
	D = sqrt((P/df)**2 - P**2)

// Excess
/* Picture this:
 *  - We have a powernet with some load "load" and some available power "available"
 *  - We have a machine whose load will have a reactive ratio and distortion ratio of "qr" and "dr"
 * How big of a load could this machine put unto the powernet such that the resulting apparent load matches the available power? (aka: consumes all excess power)
 *
 * This function calculates that */
/proc/power_excess_calculator(available, datum/power_vector/load = new(), qr=0, dr=0)
	/* We have to solve P for:
	* 	A^2 = (L.P + P)^2 + (L.Q + P * QR)^2 + (L.D + P * DR)^2
	* Where:
	* 	A: Power available
	* 	L: load
	* 	P, QR, DR: Reactive Ratio and Distortion Ratio of a load which, if added to L, builds an Apparent Power equal to A
	*
	* And return the highest positive result */
	var/p = 0
	if (available)
		for (var/result in SolveQuadratic(1 + qr**2 + dr**2, 2*(load.P + qr * load.Q + dr * load.D), load.norm()**2 - available**2))
			if (result > p)
				p = result
	return p

// --- String conversions ---
// Powers

/datum/power_vector/proc/P_string()
	return "[format_units(P)]W"
/datum/power_vector/proc/Q_string()
	return "[format_units(Q)]VAR"
/datum/power_vector/proc/D_string()
	return "[format_units(D)]VAD"
/datum/power_vector/proc/S_string()
	return "[format_units(apparent_power())]VA"

// Factors/Ratios

/datum/power_vector/proc/PF_string(decimals=2)
	// The slightest deviation from 1PF matters, so 0.9999 should round to 0.99PF, not 1
	decimals = 10 ** decimals
	return "[round(power_factor()*decimals)/decimals] PF"

/datum/power_vector/proc/DPF_string(decimals=2)
	// The slightest deviation from 1DPF matters, so 0.9999 should round to 0.99DPF, not 1
	decimals = 10 ** decimals
	var/q_sign = (reactive_factor() == 1 ? "" : reactive_factor() > 0 ? "+" : "-")
	return "[q_sign][round(abs(reactive_factor())*decimals)/decimals] DPF"

/datum/power_vector/proc/THD_string(decimals=1)
	decimals = 1 / (10 ** decimals)
	return "[round(distortion_ratio() * 100, decimals)]% THD"

/datum/power_vector/proc/PF_full_string()
	return "[PF_string()] ([DPF_string()], [THD_string()])"

/datum/power_vector/proc/PF_rating()
	if (power_factor() > POWER_FACTOR_THRESHOLD_GOOD)
		return POWER_FACTOR_RATING_GOOD
	if (power_factor() > POWER_FACTOR_THRESHOLD_AVERAGE)
		return POWER_FACTOR_RATING_AVERAGE
	return POWER_FACTOR_RATING_BAD

/datum/power_vector/proc/DPF_rating()
	if (abs(reactive_factor()) > DISPLACEMENT_POWER_FACTOR_THRESHOLD_GOOD)
		return POWER_FACTOR_RATING_GOOD
	if (abs(reactive_factor()) > DISPLACEMENT_POWER_FACTOR_THRESHOLD_AVERAGE)
		return POWER_FACTOR_RATING_AVERAGE
	return POWER_FACTOR_RATING_BAD

/datum/power_vector/proc/THD_rating()
	if (distortion_ratio() < TOTAL_HARMONIC_DISTORTION_THRESHOLD_GOOD)
		return POWER_FACTOR_RATING_GOOD
	if (distortion_ratio() < TOTAL_HARMONIC_DISTORTION_THRESHOLD_AVERAGE)
		return POWER_FACTOR_RATING_AVERAGE
	return POWER_FACTOR_RATING_BAD
