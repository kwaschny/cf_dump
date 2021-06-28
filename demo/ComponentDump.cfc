component {

	VARIABLES["privateNumeric"] = 123 * 1;
	VARIABLES["privateNull"]    = javaCast("null", "");
	VARIABLES["privateString"]  = "STRING";
	VARIABLES["privateBoolean"] = (1 eq 1);

	THIS["PublicNumeric"] = 123 * 1;
	THIS["PublicNull"]    = javaCast("null", "");
	THIS["PublicString"]  = "STRING";
	THIS["PublicBoolean"] = (1 eq 1);

	public struct function dump() {

		return VARIABLES;
	}

}
