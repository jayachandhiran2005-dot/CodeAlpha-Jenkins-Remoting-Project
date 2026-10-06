# Architecture

```
                 +-----------------------------+
                 |   Jenkins Controller        |
                 |   (0 executors, HTTPS)      |
                 +--------------+--------------+
                                | Remoting over WebSocket (agent connects out)
          +---------------------+---------------------+
          |                     |                     |
  +-------v------+      +-------v------+      +-------v------+
  | linux/amd64  |      | linux/arm64  |      |   windows    |
  | label: amd64 |      | label: arm64 |      | label: win   |
  +--------------+      +--------------+      +--------------+
```

- Agents initiate the connection, so only the controller's HTTP(S) port must be reachable.
- Labels decide where each pipeline stage runs.
- The controller runs no builds, which keeps build code away from controller data.
