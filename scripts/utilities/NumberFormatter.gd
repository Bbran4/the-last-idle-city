class_name NumberFormatter
extends RefCounted


static func format_number(value: float) -> String:
	if is_zero_approx(value):
		return "0"

	var absolute_value : float = abs(value)

	if absolute_value < 1_000.0:
		return "%.0f" % value

	var suffixes := [
		"K",
		"M",
		"B",
		"T",
		"Qa",
		"Qi",
		"Sx",
		"Sp",
		"Oc",
		"No",
		"Dc"
	]

	var tier := 0
	var scaled := absolute_value

	while scaled >= 1_000.0 and tier < suffixes.size():
		scaled /= 1_000.0
		tier += 1

	if tier == suffixes.size() and scaled >= 1_000.0:
		return "%.2e" % value

	if tier == 0:
		return "%.0f" % value

	var sign := "-" if value < 0 else ""

	return "%s%.2f%s" % [sign, scaled, suffixes[tier - 1]]
