# rabbitears-live-bandscan
Docker image for contributors to rabbitears.info live scans of OTA signals

rabbitears.info provides information for OTA TV in North America. The live bandscan feature collects signal information
from volunteers across the continent. See https://rabbitears.info/tvdx/all_tuners for current data and
https://rabbitears.info/static.php?name=join_live_bandscan for joining. This image is to help those who have joined
by making it easier to implement with Docker.

An HDHomeRun brand of TV tuner is required for this image.

There is a volume `/data` that stores the results per month locally.

```yaml
version: "3.4"

volumes:
  rabbitears:

services:
  rabbitears:
    image: ghcr.io/double16/rabbitears-live-bandscan:latest
    restart: unless-stopped
    volumes:
      - rabbitears:/data
    environment:
      TUNER_ID: "FFFFFFFF"
      TUNER_ADDR: "192.168.1.33"
      TUNER: "tuner1"
      DATA_DIR: "/data"
```

The following environment variables are supported:
- TUNER_ID (required): Unique ID of the tuner, should be labeled on the tuner hardware
- TUNER_ADDR: IP address of the tuner, required unless you use host networking
- TUNER (defaults to tuner0): Which tuner on the hardware to use. Can be tuner0, tuner1, tuner2, etc.
- DATA_DIR: Data directory
- DEBUG: Set to non-empty to output debugging information in the container log
- URL: URL for posting the results, usually do not specify
