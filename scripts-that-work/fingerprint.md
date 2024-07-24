# Fingerprint

To make fingerprint work in Ubuntu, follow these steps;

1. Install required packages

   ```bash
   sudo apt update
   sudo apt install fprintd libpam-fprintd
   ```

2. Enroll fingerprints

   ```bash
   fprintd-enroll
   ```

   Follow the on-screen instructions to scan your fingerprints.

3. Enable fingerprint authentication

   ```bash
   sudo pam-auth-update --enable fprintd
   ```

4. Reboot the system

   ```bash
   sudo reboot
   ```
