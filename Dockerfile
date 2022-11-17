# Build Image
FROM registry.bcs.cl/library/mkdocs:latest as build

WORKDIR /docs

COPY . .

RUN mkdocs build

# Output Image
FROM nginx:1.19.5-alpine

COPY --from=build /docs/site /usr/share/nginx/html