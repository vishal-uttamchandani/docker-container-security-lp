# Notes

- toos/healthcheck is a program written in golang. It does a http GET on the url and returns a non-zero exit code if an error condition is encountered. The tools makes '5' retries using exponential backoff logic to reach the endpoint
  
- tools/healthcheck is utilized within Dockerfile for HEALTCHECK instruction
