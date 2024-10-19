# AppLauncher for an AppImage

Original post;

https://askubuntu.com/questions/1328196/how-can-i-create-a-desktop-entry-for-an-appimage

I followed below steps;

- Move it to an appropriate path, like `~/Applications/Example`.
- Make it executable, run: `chmod +x example.AppImage`.
- Extract the AppImage, run `example.AppImage --appimage-extract`
  - a directory will be created called `squashfs-root` in the current working
    directory.
- Enter the directory `squashfs-root` and copy the desktop launcher
  `Example.desktop` to `~/.local/share/applications`
- Edit the desktop launcher to point to the path of the AppImage followed by
  `%F` or `%U` or `%u`, i.e.
  ```
  Exec=/home/username/Application/Example/example.AppImage %U
  ```
- Find icon in the folder `squashfs-root` or from the internet and place it
  under `~/Applications/Example/icon.png`
- Set icon path in `.desktop` file
  ```
  Icon=/home/username/Applications/Example/icon.png
  ```
- Give the `.desktop` file executable permissions:
  ```bash
  chmod +x ~/.local/share/applications/org.inkscape.Inkscape.desktop
  ```
- Remove the directory `rm -rdf squashfs-root`.
