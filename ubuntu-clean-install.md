## Ubuntu Clean Install

> [!NOTE]
>
> To install on a mac with M chip, follow instructions in below post
> :point_down:
>
> https://techblog.shippio.io/how-to-run-an-ubuntu-22-04-vm-on-m1-m2-apple-silicon-9554adf4fda1
>

> [!TIP]
>
> During shared folder setup, it asks to change emulated display card to
> `virtuo-ramfb`, make it `virtuo-ramfb-gl` to enable animations in ubuntu

- linux basics
  - install sudo pro attach
  - configure hibernation
    - https://ubuntuhandbook.org/index.php/2021/08/enable-hibernate-ubuntu-21-10/
    - https://www.youtube.com/watch?v=qJDJHOaM6FE
    - https://www.reddit.com/r/Ubuntu/comments/zkcro6/hibernate_with_secured_boot/
    - also, might need to remove nvidia dependencies from hibernate and suspend
      services
      - https://gist.github.com/bmcbm/375f14eaa17f88756b4bdbbebbcfd029
      - https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1933880/comments/9
  - configure power management
    - open extension manager and install Power Profile Switcher
    - configure to get to power saving when below 20% battery
  - authentication
    - install fprintd for fingerprint login, see `scripts-that-work`
    - (optional) howdy for face login
  - install hack nerd font mono regular
    - from nerdfonts.com
  - install psensor
    - add it to startup applications in tweaks
    - configure sensor threashold to 40%
  - pulse audio
    - install pulseaudio from sudo apt install (probably already installed)
    - install volume control from ubuntu software
  - htop
  - install droidcam to use webcam from linux
    - https://www.dev47apps.com/droidcam/linux/
    - read `config-files/crop-video-into-another` to create a video stream with
      proper aspect ratio
- personalizations
  - capslock as escape
    - https://askubuntu.com/questions/363346/how-to-permanently-switch-caps-lock-and-esc
  - compare and move `.bashrc` to home folder
  - keyboard shortcuts
    - copy all of them one by one (as well as custom shortcuts at the bottom)
  - enable touchpad gestures
    - https://ubuntuhandbook.org/index.php/2021/06/multi-touch-gestures-ubuntu-20-04/
  - appearance layout
  - switch from wayland to x
  - regional settings format canada
- apps
  - brave
  - element, beeper
  - zoom, anydesk
  - pandoc, transmission (torrent)
    - pandoc pdflatex support -> https://gist.github.com/yspkm/f33d59181b7f6f5c8701360995c07418
- development
  - terminal
    - font and background
  - git, gh
    - `git config --global credential.helper store` to remember credentials
    - `git config --global pull.rebase true` to rebase on pull
    - `git config --global user.email [github-email]`
    - `git config --global user.name [github-username]`
    - `git config --global core.autocrlf input`
  - dotnet v9, node v22.13.1
    - install dotnet using https://launchpad.net/~dotnet/+archive/ubuntu/backports
      ```bash
      sudo add-apt-repository ppa:dotnet/backports
      sudo apt update
      ```
    - install node using `sudo apt install nodejs`
      - add node version manager
        - `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash`
      - switch to 22 via `nvm install 22`
  - vim
    - install with x11: `sudo apt install vim-gtk3`
    - `ln -s ~/Repositories/cihandeniz/config-files/vim/vimrc
      ~/.vimrc`
    - `ln -s ~/Repositories/cihandeniz/config-files/vim/omnisharp.json
      ~/.omnisharp/omnisharp.json`
    - install js, ts, json, html, css, eslint, volar (vue) support for coc
      - list of coc plugins are in vimrc
      - https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim#install-extensions-for-programming-languages-you-use-daily
  - repos
    - clone all repos
    - add precommit hooks to certain projects
    - build, test and run all tests
  - docker, azure cli, kubectl
    - install docker from engine cli
      - https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
    - create a docker group and add user to docker group
      - https://phoenixnap.com/kb/docker-permission-denied
  - dbeaver, figma, postman
    - for dbeaver try to install from snap `sudo snap install dbeaver-ce`, if
      not from apt, last stop is local deb package
  - virtualbox
    - import vm-windows-10 from vm-windows-10.ova in backup
- music & creativitiy
  - ardour or audacity
  - musescore
  - blender, godot, unreal
  - kdenlive
