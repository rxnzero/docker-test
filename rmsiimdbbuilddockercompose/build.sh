if cd elink-root
then 
	git pull
	git submodule foreach git pull origin sgi
else
	git clone https://git.eactive.synology.me:8090/elink/v3.6/elink-root 
	cd elink-root
	git checkout sgi

	# submodule sync
	git submodule sync --recursive
	git submodule update --init --recursive

	# submodule branch change to sgi
	git submodule foreach git checkout sgi
	git submodule foreach git pull origin sgi
fi
./gradlew RMSWeb:build
./gradlew IIMWeb:build
