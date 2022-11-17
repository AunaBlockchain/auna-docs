@ECHO OFF
docker image rm registry.bcs.cl/baas/baas-docs:nginx
docker build --no-cache -t registry.bcs.cl/baas/baas-docs:nginx .