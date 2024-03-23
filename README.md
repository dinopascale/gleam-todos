# todos

Simple web application for managing todos list

## How to run

Run in docker container (so you don't have to install dependencies)

```bash
docker build -t gleam-todos .
docker run -p 8000:8000 --name gtodos gleam-todos:latest
```

And then you can visit `localhost:8000`