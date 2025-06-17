# Quake 3 Arena Server Docker Image

This repository contains a Docker setup for running a dedicated Quake 3 Arena server using the open-source ioquake3 engine.

## Features

- Based on Ubuntu 24.04
- Uses the latest ioquake3 engine compiled from source
- Fully configurable through environment variables
- Multi-platform support (amd64)
- Secure execution with a dedicated non-root user
- Volume support for game files
- GitHub Actions workflow for automatic builds

## Prerequisites

- Docker and Docker Compose installed on your system
- Original Quake 3 Arena game files (pak0.pk3, etc.)

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/dmitry-osin/quake3server.git
   cd quake3server
   ```

2. Create a directory for your game files and copy the required files:
   ```bash
   mkdir -p q3data
   # Copy pak0.pk3, pak1.pk3, etc. to the q3data directory
   ```

3. Start the server using Docker Compose:
   ```bash
   docker-compose -f _bootstrap.yml up -d
   ```

4. Connect to your server from the Quake 3 Arena client using your server's IP address.

## Configuration

### Environment Variables

You can customize your server by setting the following environment variables in the `.env` file or directly in the `_bootstrap.yml` file:

| Variable         | Default             | Description                                              |
| ---------------- | ------------------- | -------------------------------------------------------- |
| SV_HOSTNAME      | "My Quake 3 Server" | Name of the server as displayed in the server browser    |
| G_GAMETYPE       | 1                   | Game type (0=FFA, 1=Tournament, 2=FFA, 3=Team DM, 4=CTF) |
| FRAG_LIMIT       | 20                  | Number of frags to end the match                         |
| TIME_LIMIT       | 10                  | Time limit in minutes                                    |
| SV_MAXCLIENTS    | 16                  | Maximum number of players                                |
| NET_PORT         | 27960               | UDP port for the server                                  |
| RCON_PASSWORD    | qwerty              | Remote console password (change this!)                   |
| SV_DEDICATED     | 2                   | Server dedicated mode (2=LAN)                            |
| G_QUADFACTOR     | 3                   | Quad damage multiplier                                   |
| G_INACTIVITY     | 120                 | Inactivity timeout in seconds                            |
| SV_ALLOWDOWNLOAD | 1                   | Allow clients to download missing files                  |
| G_ALLOWVOTE      | 1                   | Allow voting                                             |
| COM_HUNKMEGS     | 256                 | Memory allocation for the server                         |
| SV_PURE          | 1                   | Pure server setting                                      |
| MAP              | bloodrun            | Initial map to load                                      |

### Docker Compose

The `_bootstrap.yml` file contains the Docker Compose configuration for running the server. You can modify it to suit your needs.

## Building the Docker Image

### Local Build

To build the Docker image locally:

```bash
docker build -t quake3server .
```

### Using GitHub Packages

This repository includes a GitHub Actions workflow that automatically builds and publishes the Docker image to GitHub Packages when you push to the main branch or create a tag.

To use the pre-built image:

```bash
docker pull ghcr.io/dmitry-osin/quake3server:latest
```

Or update your Docker Compose file to use the pre-built image:

```yaml
services:
  quake3server:
    image: ghcr.io/dmitry-osin/quake3server:latest
    # rest of configuration...
```

## File Structure

- `Dockerfile` - Contains the Docker image definition
- `_bootstrap.yml` - Docker Compose configuration file
- `.github/workflows/docker-image.yml` - GitHub Actions workflow for building and publishing the image
- `q3data/` - Directory for game files (pak0.pk3, etc.)

## Important Notes

- You must provide your own Quake 3 Arena game files (pak0.pk3, etc.) as they are protected by copyright and cannot be distributed with this image.
- The server runs as a non-root user (`ioq3srv`) for improved security.
- Remember to change the default RCON password for production use.

## Advanced Configuration

For advanced configuration, you can modify the server.cfg file directly. Mount a custom server.cfg file to override the default configuration:

```yaml
volumes:
  - ./custom-server.cfg:/home/ioq3srv/server/baseq3/server.cfg
```

## Troubleshooting

### Server Not Starting

- Check if you've provided all required game files in the q3data directory
- Verify that the server port is not in use by another application
- Check the logs: `docker-compose -f _bootstrap.yml logs -f`

### Can't Connect to Server

- Make sure your firewall allows traffic on the server port (default: 27960/UDP)
- Verify that the server is running: `docker ps`
- Check if the server is listening on the correct port: `netstat -tuln`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Note about Quake 3 Arena game files

This project requires original Quake 3 Arena game files (pak0.pk3, etc.) which are **not** included and must be provided by the user. These files are copyrighted by id Software and are subject to their own licensing terms.

### Third-party software

This project uses the following third-party software:

- [ioquake3](https://github.com/ioquake/ioq3) - GPLv2 license
- Various Ubuntu packages - Various licenses

Each third-party software component is subject to its own license terms.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.