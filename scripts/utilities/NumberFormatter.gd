class_name NumberFormatter
extends RefCounted


enum FormatMode {
	SHORT_SCALE,
	SCIENTIFIC
}


static var format_mode: FormatMode = FormatMode.SHORT_SCALE


## Short-scale abbreviations for the first 21 named tiers
## (thousand through vigintillion). Index = tier group:
##
## 0 = 10^3  (K)
## 1 = 10^6  (M)
## ...
## 20 = 10^63 (Vg)
##
## Beyond this table, names/abbreviations are generated indefinitely
## using the standard ones/tens/hundreds "-illion" naming convention
## (the same system behind names like "Unvigintillion" or
## "Centillion"), so growth never silently falls back to scientific
## notation just because it outgrew a hardcoded list.
const SHORT_SUFFIXES := [
	"K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No",
	"Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod",
	"Vg"
]

const FULL_NAMES := [
	"thousand", "million", "billion", "trillion", "quadrillion",
	"quintillion", "sextillion", "septillion", "octillion", "nonillion",
	"decillion", "undecillion", "duodecillion", "tredecillion",
	"quattuordecillion", "quindecillion", "sexdecillion", "septendecillion",
	"octodecillion", "novemdecillion", "vigintillion"
]

## Combining-form tables used to generate names/abbreviations for
## tier groups beyond vigintillion (group >= 21). Index 0 is
## unused (digit 0 contributes nothing to the name).
const ONES_COMBINED := ["", "Un", "Duo", "Tres", "Quattuor", "Quin", "Ses", "Septem", "Octo", "Novem"]
const ONES_ABBR := ["", "U", "D", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No"]

const TENS_COMBINED := ["", "Dec", "Vigint", "Trigint", "Quadragint", "Quinquagint", "Sexagint", "Septuagint", "Octogint", "Nonagint"]
const TENS_ABBR := ["", "d", "Vg", "Tg", "Qg", "Qq", "Sg", "Sn", "Og", "Ng"]

const HUNDREDS_COMBINED := ["", "Cent", "Ducent", "Trecent", "Quadringent", "Quingent", "Sescent", "Septingent", "Octingent", "Nongent"]
const HUNDREDS_ABBR := ["", "C", "DC", "TC", "QC", "QqC", "SC", "SnC", "OC", "NC"]

## Highest tier group we'll generate a name for. Group 999 is roughly
## 10^3002 — already far beyond anything a save file will reach, so
## the fallback below this is effectively dead code in practice.
const MAX_GENERATED_TIER := 999


static func set_format_mode(mode: FormatMode) -> void:
	format_mode = mode


static func get_format_mode() -> FormatMode:
	return format_mode


static func format_number(value: Variant) -> String:
	var number := _to_big_number(value)

	if number.is_zero():
		return "0"

	match format_mode:
		FormatMode.SCIENTIFIC:
			return _format_scientific(number)

		FormatMode.SHORT_SCALE:
			return _format_short_scale(number)

	return "0"


static func format_rate(value: Variant) -> String:
	var number := _to_big_number(value)

	if number.is_zero():
		return "0.00"

	var absolute_number := number.abs()

	# Small rates are shown with normal decimal precision.
	if absolute_number.exponent < 0:
		var small_value := number.to_float()

		if absf(small_value) < 0.01:
			return "%.3f" % small_value

		return "%.2f" % small_value

	return format_number(number)


static func format_full_name(value: Variant) -> String:
	var number := _to_big_number(value)

	if number.is_zero():
		return "zero"

	var sign := "negative " if number.is_negative() else ""
	var absolute_number := number.abs()

	if absolute_number.exponent < 3:
		return "%s%s" % [
			sign,
			_format_small_integer(absolute_number.to_float())
		]

	var grouped := _tier_and_scaled(number)

	return "%s%.2f %s" % [
		sign,
		grouped.scaled,
		_illion_name(grouped.tier - 1)
	]


static func _format_short_scale(number: BigNumber) -> String:
	var absolute_number := number.abs()

	if absolute_number.exponent < 3:
		return "%.0f" % number.to_float()

	var grouped := _tier_and_scaled(number)
	var sign := "-" if number.is_negative() else ""

	return "%s%.2f%s" % [
		sign,
		grouped.scaled,
		_illion_abbreviation(grouped.tier - 1)
	]


static func _format_scientific(number: BigNumber) -> String:
	if number.is_zero():
		return "0"

	return "%.2fe%d" % [
		number.mantissa,
		number.exponent
	]


## Groups a BigNumber into its tier (1 = K/thousand, 2 = M/million, ...)
## and the mantissa scaled to that tier (e.g. 1234.0 -> tier 1,
## scaled 1.23). Shared by the abbreviation and full-name paths so
## they always agree on the number shown before the suffix — the old
## full-name path skipped this step, which is why it showed the wrong
## value whenever the exponent wasn't a multiple of 3.
static func _tier_and_scaled(number: BigNumber) -> Dictionary:
	var absolute_number := number.abs()
	var tier := int(floor(float(absolute_number.exponent) / 3.0))
	var scaled_exponent := absolute_number.exponent - (tier * 3)
	var scaled := absolute_number.mantissa * pow(10.0, scaled_exponent)

	return {"tier": tier, "scaled": scaled}


static func _to_big_number(value: Variant) -> BigNumber:
	if value is BigNumber:
		return value

	if value is int:
		return BigNumber.from_int(value)

	if value is float:
		return BigNumber.from_float(value)

	return BigNumber.zero()


static func _format_small_integer(value: float) -> String:
	return "%.0f" % value


## Returns the abbreviation for tier group (0 = thousand, 1 = million,
## ..., 20 = vigintillion, 21 = unvigintillion, ...). Uses the
## hardcoded table while available, then generates indefinitely.
static func _illion_abbreviation(group: int) -> String:
	if group < SHORT_SUFFIXES.size():
		return SHORT_SUFFIXES[group]

	if group > MAX_GENERATED_TIER:
		return "e%d" % ((group + 1) * 3)

	var digits := _illion_digits(group)
	var abbr := ""

	if digits.o > 0:
		abbr += ONES_ABBR[digits.o]
	if digits.t > 0:
		abbr += TENS_ABBR[digits.t]
	if digits.h > 0:
		abbr += HUNDREDS_ABBR[digits.h]

	return abbr


## Returns the full name for tier group (0 = thousand, ...), same
## indefinite-generation behaviour as _illion_abbreviation above.
static func _illion_name(group: int) -> String:
	if group < FULL_NAMES.size():
		return FULL_NAMES[group]

	if group > MAX_GENERATED_TIER:
		return "10^%d" % ((group + 1) * 3)

	var digits := _illion_digits(group)
	var name := ""

	if digits.o > 0:
		name += ONES_COMBINED[digits.o]
	if digits.t > 0:
		name += TENS_COMBINED[digits.t]
		if digits.h > 0:
			name += "a" # linking vowel, e.g. "viginti" + "a" + "cent"
	if digits.h > 0:
		name += HUNDREDS_COMBINED[digits.h]

	return (name + "illion").to_lower()


## Decomposes a tier group into hundreds/tens/ones digits. Group
## also doubles as the classical "-illion" index (million = 1,
## billion = 2, ..., vigintillion = 20, unvigintillion = 21, ...).
static func _illion_digits(group: int) -> Dictionary:
	return {
		"h": int(group / 100),
		"t": int(group / 10) % 10,
		"o": group % 10
	}
