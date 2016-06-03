build:
	@ mkdir -p static && \
	  elm-make src/Main.elm --output static/build.js

start:
	@ elm reactor
