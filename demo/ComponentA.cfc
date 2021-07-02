component implements="InterfaceX,InterfaceY" {

	THIS.publicVarA = THIS;
	THIS.publicVarB = [ "" ];

	VARIABLES.privateVarA = "";
	VARIABLES.privateVarB = "";

	public string function foo(required i, n) {
	}

	private function bar() {
	}

	public function init(x) {

		if (structKeyExists(ARGUMENTS, "x")) {

			THIS.reference = ARGUMENTS.x;
		}
	}

}
