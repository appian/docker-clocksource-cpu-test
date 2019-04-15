## Intro

This is a sample Java application in docker designed to demonstrate a high throughput of calls to System.currentTimeMillis() for the Appian Engineering blog post [Yet another reason your Docker containers may be slow on EC2](https://medium.com/appian-engineering/yet-another-reason-your-docker-containers-may-be-slow-on-ec2-clock-gettime-gettimeofday-and-9d92f6892048).

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
