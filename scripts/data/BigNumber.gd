class_name BigNumber
extends RefCounted


## A large number represented as:
##
##     mantissa × 10^exponent
##
## Example:
##
##     1.25e123
##
## is stored as:
##
##     mantissa = 1.25
##     exponent = 123
##
## The mantissa is always normalized to:
##
##     1.0 <= abs(mantissa) < 10.0
##
## except for zero.


var mantissa: float = 0.0
var exponent: int = 0


func _init(p_mantissa: float = 0.0, p_exponent: int = 0) -> void:
	mantissa = p_mantissa
	exponent = p_exponent
	_normalize()


static func zero() -> BigNumber:
	return BigNumber.new(0.0, 0)


static func one() -> BigNumber:
	return BigNumber.new(1.0, 0)


static func from_float(value: float) -> BigNumber:
	return BigNumber.new(value, 0)


static func from_int(value: int) -> BigNumber:
	return BigNumber.new(float(value), 0)


func duplicate_number() -> BigNumber:
	return BigNumber.new(mantissa, exponent)


func is_zero() -> bool:
	return is_zero_approx(mantissa)


func is_positive() -> bool:
	return mantissa > 0.0


func is_negative() -> bool:
	return mantissa < 0.0


func abs() -> BigNumber:
	return BigNumber.new(absf(mantissa), exponent)


func negated() -> BigNumber:
	return BigNumber.new(-mantissa, exponent)


func _normalize() -> void:
	if is_zero_approx(mantissa):
		mantissa = 0.0
		exponent = 0
		return

	var absolute_mantissa := absf(mantissa)

	while absolute_mantissa >= 10.0:
		mantissa /= 10.0
		exponent += 1
		absolute_mantissa /= 10.0

	while absolute_mantissa < 1.0:
		mantissa *= 10.0
		exponent -= 1
		absolute_mantissa *= 10.0


func add(other: BigNumber) -> BigNumber:
	if is_zero():
		return other.duplicate_number()

	if other.is_zero():
		return duplicate_number()

	# If the exponents are too far apart, the smaller number
	# has no meaningful effect at float precision.
	var exponent_difference := exponent - other.exponent

	if exponent_difference >= 16:
		return duplicate_number()

	if exponent_difference <= -16:
		return other.duplicate_number()

	if exponent_difference >= 0:
		var scaled_other := other.mantissa * pow(10.0, -exponent_difference)
		return BigNumber.new(mantissa + scaled_other, exponent)

	var scaled_self := mantissa * pow(10.0, exponent_difference)
	return BigNumber.new(scaled_self + other.mantissa, other.exponent)


func subtract(other: BigNumber) -> BigNumber:
	return add(other.negated())


func multiply(other: BigNumber) -> BigNumber:
	if is_zero() or other.is_zero():
		return BigNumber.zero()

	return BigNumber.new(
		mantissa * other.mantissa,
		exponent + other.exponent
	)


func multiply_float(value: float) -> BigNumber:
	if is_zero() or is_zero_approx(value):
		return BigNumber.zero()

	return BigNumber.new(
		mantissa * value,
		exponent
	)


func divide(other: BigNumber) -> BigNumber:
	if other.is_zero():
		push_error("BigNumber division by zero.")
		return BigNumber.zero()

	if is_zero():
		return BigNumber.zero()

	return BigNumber.new(
		mantissa / other.mantissa,
		exponent - other.exponent
	)


func divide_float(value: float) -> BigNumber:
	if is_zero_approx(value):
		push_error("BigNumber division by zero.")
		return BigNumber.zero()

	return BigNumber.new(
		mantissa / value,
		exponent
	)


func pow_int(power: int) -> BigNumber:
	if power == 0:
		return BigNumber.one()

	if is_zero():
		return BigNumber.zero()

	var result := BigNumber.one()
	var base := duplicate_number()
	var remaining : int = abs(power)

	while remaining > 0:
		if remaining % 2 == 1:
			result = result.multiply(base)

		base = base.multiply(base)
		remaining /= 2

	if power < 0:
		return BigNumber.one().divide(result)

	return result


func compare(other: BigNumber) -> int:
	# Returns:
	# -1 if this < other
	#  0 if this == other
	#  1 if this > other

	if is_zero() and other.is_zero():
		return 0

	if is_zero():
		return -1 if other.is_positive() else 1

	if other.is_zero():
		return 1 if is_positive() else -1

	if mantissa < 0.0 and other.mantissa >= 0.0:
		return -1

	if mantissa >= 0.0 and other.mantissa < 0.0:
		return 1

	if exponent != other.exponent:
		if mantissa > 0.0:
			return 1 if exponent > other.exponent else -1

		return 1 if exponent < other.exponent else -1

	if is_equal_approx(mantissa, other.mantissa):
		return 0

	return 1 if mantissa > other.mantissa else -1


func is_equal_to(other: BigNumber) -> bool:
	return compare(other) == 0


func is_greater_than(other: BigNumber) -> bool:
	return compare(other) > 0


func is_less_than(other: BigNumber) -> bool:
	return compare(other) < 0


func is_greater_or_equal(other: BigNumber) -> bool:
	return compare(other) >= 0


func is_less_or_equal(other: BigNumber) -> bool:
	return compare(other) <= 0


func to_float() -> float:
	if exponent > 308:
		return INF

	if exponent < -308:
		return 0.0

	return mantissa * pow(10.0, exponent)


func to_dict() -> Dictionary:
	return {
		"mantissa": mantissa,
		"exponent": exponent
	}


static func from_dict(data: Dictionary) -> BigNumber:
	return BigNumber.new(
		float(data.get("mantissa", 0.0)),
		int(data.get("exponent", 0))
	)


func to_display_string() -> String:
	if is_zero():
		return "0"

	return "%s × 10^%d" % [
		str(mantissa),
		exponent
	]
