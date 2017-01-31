# PaintsChainer-Docker

Docker container for [PaintsChainer](https://github.com/taizan/PaintsChainer)

# How to use this image

If you want to run this on Windows and have no familiarity with Docker, etc you can find [Complete setup instructions for Windows (including Docker)](https://github.com/liamjones/PaintsChainer-Docker/wiki/Complete-setup-instructions-for-Windows-(including-Docker)) on the wiki.

## Processing via CUDA on GPU

Ensure you have [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) installed for GPU passthrough to containers. To run with the default GPU:

```console
$ nvidia-docker run -p 8000:8000 liamjones/paintschainer
```

If you have multiple GPUs and want to specify an alternate one you can specify GPU number via an environment variable:

```console
$ nvidia-docker run -p 8000:8000 -e PAINTSCHAINER_GPU=1 liamjones/paintschainer
```

GPU numbers can be verified by running:

```console
$ docker run liamjones/paintschainer nvidia-smi
```

## Processing via CPU

This will be slower than GPU processing but has some advantages;

* Doesn't require an NVIDIA card
* Doesn't require nvidia-docker
* Can potentially process larger images (assuming you have more RAM than VRAM)

```console
$ docker run -p 8000:8000 -e PAINTSCHAINER_GPU=-1 liamjones/paintschainer
```

## Access the web interface

After bringing up the container, the web interface should be available at [http://localhost:8000/static/](http://localhost:8000/static/)

# Notes

This image is currently only recommended for local use because directory browsing is available with the python server so all uploaded images are essentially public
