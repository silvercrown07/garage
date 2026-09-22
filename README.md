# garage

A minimal, auto-updating Docker image for [Garage](https://garagehq.deuxfleurs.fr/), an S3-compatible object storage server, pre-configured to run as a single node without needing to mount a `garage.toml`.

## Usage

Run the container with the required environment variables set:

```sh
docker run -d \
  --name garage \
  -p 3900:3900 -p 3901:3901 -p 3902:3902 -p 3903:3903 \
  -v garage-meta:/var/lib/garage/meta \
  -v garage-data:/var/lib/garage/data \
  -e GARAGE_RPC_SECRET="$(openssl rand -hex 32)" \
  -e GARAGE_DEFAULT_ACCESS_KEY="GK$(openssl rand -hex 16)" \
  -e GARAGE_DEFAULT_SECRET_KEY="$(openssl rand -hex 32)" \
  -e GARAGE_DEFAULT_BUCKET="default-bucket" \
  ghcr.io/<owner>/garage:latest
```

### Environment variables

| Variable | Required | Purpose |
| --- | --- | --- |
| `GARAGE_RPC_SECRET` | yes | Shared secret Garage uses to identify itself internally. |
| `GARAGE_DEFAULT_ACCESS_KEY` | yes | Access key ID created on startup (used with `--default-bucket`). |
| `GARAGE_DEFAULT_SECRET_KEY` | yes | Secret key created on startup. |
| `GARAGE_DEFAULT_BUCKET` | yes | Name of the bucket created on startup. |
| `GARAGE_ADMIN_TOKEN` | no | Enables the admin API on port 3903. |
| `GARAGE_METRICS_TOKEN` | no | Protects the Prometheus metrics endpoint. |

`garage.toml` in this repo only holds non-secret defaults (ports, region, data/metadata paths); everything sensitive is supplied at runtime via the variables above.

## Ports

| Port | Purpose |
| --- | --- |
| 3900 | S3 API |
| 3901 | RPC (inter-node) |
| 3902 | Web endpoint |
| 3903 | Admin API / metrics |

## Auto-build pipeline

- [Dependabot](.github/dependabot.yaml) watches the `FROM dxflrs/garage:...` line in the [Dockerfile](Dockerfile) and opens a PR whenever a new upstream version is released.
- Once that PR is merged into `main`, the [image workflow](.github/workflows/image.yaml) builds and pushes a new multi-arch image to `ghcr.io/<owner>/garage`, tagged with the upstream version from the `FROM` line and `latest`.

The `FROM` line in the Dockerfile is the single source of truth for which upstream Garage version is built.
