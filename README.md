# PaintsChainer-Docker

Docker container for [PaintsChainer](https://github.com/taizan/PaintsChainer)

# How to use this image

## Processing via CUDA on GPU

Ensure you have [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) installed for GPU passthrough to containers. To run with the default GPU:

```console
$ nvidia-docker run -p 8000:8000 liamjones/paintschainer
```

If you have multiple GPUs and want to specify an alternate one you can specify GPU number via an environment variable:

```console
$ nvidia-docker run -p 8000:8000 -e PAINTCHAINER_GPU=1 liamjones/paintschainer
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
$ docker run -p 8000:8000 -e PAINTCHAINER_GPU=-1 liamjones/paintschainer
```

## Access the web interface

After bringing up the container, the web interface should be available at [http://localhost:8000/static/](http://localhost:8000/static/)

# Notes

This image is currently only recommended for local use for a couple of reasons:

* Directory browsing is available with the python server so all uploaded images are essentially public
* No image cleanup is performed while the container is running so eventually space will be exhausted
