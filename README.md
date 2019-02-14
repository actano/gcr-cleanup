# gcr-cleanup

Clean up images on the Google Container Registry.

Based on the [gist](https://gist.github.com/ahmetb/7ce6d741bd5baa194a3fac6b1fec8bb7) by [Ahmet Alp Balkan](https://gist.github.com/ahmetb)

## Prerequisites
authenticated `gcloud` session for the project.

## Usage
```
  gcrgc.sh REPOSITORY N
```
cleans up tagged or untagged images for a given `REPOSITORY` and keeps the `N` most recent images.
### EXAMPLE
```
gcrgc.sh gcr.io/ahmet/my-app 3
```
  would clean up everything under the `gcr.io/ahmet/my-app` repository
  and keep the 3 most recent images.
