# `glmark2` on NVIDIA

This guide provides the steps to run `glmark2` using the NVIDIA GPU temporarily
by setting environment variables.

## Prerequisites

1. Ensure you have the NVIDIA drivers installed on your system.

   ```bash
   sudo apt update
   sudo apt install nvidia-driver-###  # replace ### with your driver version number, e.g., nvidia-driver-470
   ```

2. Install glmark2 if it's not already installed.

  ```bash
  sudo apt update
  sudo apt install glmark2
  ```

## Running `glmark2` on NVIDIA GPU

Use the following command to run glmark2 using the NVIDIA GPU temporarily:

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glmark2
```

By following these steps, you can run glmark2 using the NVIDIA GPU without
needing to reboot or permanently change your GPU settings.
