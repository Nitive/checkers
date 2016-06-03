build:
	@ mkdir -p static && \
	  elm-make src/Main.elm --output static/build.js

start:
	@ elm reactor

clean:
	@ rm -rf static/ && \
	  rm -rf elm-stuff/
