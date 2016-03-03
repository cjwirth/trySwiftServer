make: 
	rm -rf .build 
	swift build --configuration release
	.build/release/App --bind 0.0.0.0:8080

