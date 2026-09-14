class_name NumberFormatter
extends RefCounted


enum FormatMode {
	SHORT_SCALE,
	SCIENTIFIC
}


static var format_mode: FormatMode = FormatMode.SHORT_SCALE


## Short-scale abbreviations.
##
## Index represents the power group:
##
## 1 = 10^3
## 2 = 10^6
## 3 = 10^9
## etc.


const SHORT_SUFFIXES := [
	"K",   # 10^3
	"M",   # 10^6
	"B",   # 10^9
	"T",   # 10^12
	"Qa",  # 10^15
	"Qi",  # 10^18
	"Sx",  # 10^21
	"Sp",  # 10^24
	"Oc",  # 10^27
	"No",  # 10^30
	"Dc",  # 10^33
	"Ud",  # 10^36
	"Dd",  # 10^39
	"Td",  # 10^42
	"Qad", # 10^45
	"Qid", # 10^48
	"Sxd", # 10^51
	"Spd", # 10^54
	"Ocd", # 10^57
	"Nod", # 10^60
	"Vg"   # 10^63
]


## Full short-scale names for the early tiers.
##
## These are useful for tooltips, accessibility, and future
## settings where the player may want full number names.


const FULL_NAMES := [
	"thousand",
	"million",
	"billion",
	"trillion",
	"quadrillion",
	"quintillion",
	"sextillion",
	"septillion",
	"octillion",
	"nonillion",
	"decillion",
	"undecillion",
	"duodecillion",
	"tredecillion",
	"quattuordecillion",
	"quindecillion",
	"sexdecillion",
	"septendecillion",
	"octodecillion",
	"novemdecillion",
	"vigintillion"
]


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

	var tier := absolute_number.exponent / 3

	if tier <= FULL_NAMES.size():
		var scaled := absolute_number.mantissa * pow(
			10.0,
			absolute_number.exponent - (tier * 3)
		)

		return "%s%.2f %s" % [
			sign,
			scaled,
			FULL_NAMES[tier - 1]
		]

	return "%s%s" % [
		sign,
		_format_large_full_name(absolute_number)
	]


static func _format_short_scale(number: BigNumber) -> String:
	var absolute_number := number.abs()

	if absolute_number.exponent < 3:
		return "%.0f" % number.to_float()

	var tier := int(floori(absolute_number.exponent / 3))

	var scaled_exponent := number.exponent - (tier * 3)
	var scaled := number.mantissa * pow(10.0, scaled_exponent)

	var sign := "-" if number.is_negative() else ""

	# We still have a named suffix.
	if tier <= SHORT_SUFFIXES.size():
		return "%s%.2f%s" % [
			sign,
			scaled,
			SHORT_SUFFIXES[tier - 1]
		]

	# Beyond the initial abbreviation table, generate
	# an "illions" style name rather than switching
	# to scientific notation.
	var generated_suffix := _generate_short_suffix(tier)

	return "%s%.2f%s" % [
		sign,
		scaled,
		generated_suffix
	]


static func _format_scientific(number: BigNumber) -> String:
	if number.is_zero():
		return "0"

	return "%.2fe%d" % [
		number.mantissa,
		number.exponent
	]


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


static func _generate_short_suffix(tier: int) -> String:
	# tier:
	#
	# 1  = K
	# 2  = M
	# 3  = B
	# 4  = T
	# 5  = Qa
	# ...
	#
	# For now, use generated "illions" abbreviations after
	# the explicitly defined early tiers.
	#
	# This keeps the formatter safe while the full naming
	# system is expanded.

	if tier <= SHORT_SUFFIXES.size():
		return SHORT_SUFFIXES[tier - 1]

	var illion_index := tier - 1

	return _generate_illion_abbreviation(illion_index)


static func _generate_illion_abbreviation(index: int) -> String:
	# This covers the common idle-game naming pattern.
	#
	# Examples:
	#
	# 11 -> Dc
	# 12 -> Ud
	# 13 -> Dd
	# 14 -> Td
	#
	# Beyond this point, use a generated prefix.

	if index == 11:
		return "Dc"

	if index == 12:
		return "Ud"

	if index == 13:
		return "Dd"

	if index == 14:
		return "Td"

	if index == 15:
		return "Qad"

	if index == 16:
		return "Qid"

	if index == 17:
		return "Sxd"

	if index == 18:
		return "Spd"

	if index == 19:
		return "Ocd"

	if index == 20:
		return "Nod"

	# Generic fallback.
	#
	# We deliberately DO NOT fall back to scientific notation.
	# The game can continue displaying named tiers while we
	# expand the naming table.

	return "e%d" % (index * 3)


static func _generate_short_full_name(tier: int) -> String:
	if tier <= FULL_NAMES.size():
		return FULL_NAMES[tier - 1]

	return "10^%d" % (tier * 3)


static func _format_large_full_name(number: BigNumber) -> String:
	var tier := int(floori(number.exponent / 3))

	return "%.2f %s" % [
		number.mantissa,
		_generate_short_full_name(tier)
	]
