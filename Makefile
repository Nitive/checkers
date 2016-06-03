build:
	@ mkdir -p static && \
	  elm-make src/Main.elm --output static/build.js

start:
	@ elm reactor -a 0.0.0.0 -p 3000

clean:
	@ rm -rf static/ && \
	  rm -rf elm-stuff/
