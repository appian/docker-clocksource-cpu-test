## Intro

This is a sample Java application in docker designed to demonstrate a high throughput of calls to System.currentTimeMillis()

The Docker image also contains Java debugging symbols and some tools to generate FlameGraphs for profiling the app.

## Building

```
docker build -t docker-clocksource-cpu-test .
```

## Running

```
docker run -d docker-clocksource-cpu-test
```

This container will saturate one CPU, you may want to kill it when done with the demo.