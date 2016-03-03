make: 
	rm -rf .build && swift build --configuration release && .build/release/App

