extends ARVROrigin

var test_order = [ "OpenVR", "Oculus" ]

func _ready():
	print("Available ARVR Interfaces:")
	
	for vrInterface in ARVRServer.get_interfaces():
		print(vrInterface["name"])
	
	var found = false
	for test in test_order:
		var vr := ARVRServer.find_interface(test)
		if vr and vr.initialize():
			print("VR Drivers " + test + " found and initialised!")
			get_viewport().arvr = true
			get_viewport().hdr = false
			found = true
			break
		
	if not found:
		print("No VR Drivers found")
