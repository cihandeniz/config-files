# Crop Video Into Another

## Prerequisites

- Install `v4l2loopback` to create a virtual video device

  ```bash
  git clone https://github.com/umlaeute/v4l2loopback
  cd v4l2loopback
  make
  sudo make install
  ```

  > [!NOTE]
  >
  > regular install didn't work for me, this is manual install

- Load module

  ```bash
  sudo modprobe v4l2loopback video_nr=1 # creates /dev/video1
  ```

## The Crop

Crop original video (at `/dev/video0`) into widescreen;

```bash
ffmpeg -i /dev/video0 -vf "crop=640:360:0:60" -f v4l2 /dev/video1
```

For more filters visit https://ffmpeg.org/ffmpeg-filters.html#Video-Filters
