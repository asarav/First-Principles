class_name SignalValue
extends RefCounted

## Typed simulation value. Starts with booleans; other kinds can be added later
## without rewriting the machine graph.

enum Kind { UNSET, BOOL }

var kind: Kind = Kind.UNSET
var bool_value: bool = false


static func unset() -> SignalValue:
	var v := SignalValue.new()
	v.kind = Kind.UNSET
	return v


static func from_bool(value: bool) -> SignalValue:
	var v := SignalValue.new()
	v.kind = Kind.BOOL
	v.bool_value = value
	return v


static func from_variant(value: Variant) -> SignalValue:
	if value == null:
		return unset()
	if value is bool:
		return from_bool(value)
	if value is SignalValue:
		return (value as SignalValue).duplicate_value()
	push_error("SignalValue.from_variant: unsupported value %s" % str(value))
	return unset()


func is_set() -> bool:
	return kind != Kind.UNSET


func duplicate_value() -> SignalValue:
	var v := SignalValue.new()
	v.kind = kind
	v.bool_value = bool_value
	return v


func equals(other: SignalValue) -> bool:
	if other == null:
		return false
	if kind != other.kind:
		return false
	if kind == Kind.BOOL:
		return bool_value == other.bool_value
	return true


func to_variant() -> Variant:
	match kind:
		Kind.BOOL:
			return bool_value
		_:
			return null


func to_debug_string() -> String:
	match kind:
		Kind.BOOL:
			return "true" if bool_value else "false"
		_:
			return "unset"
