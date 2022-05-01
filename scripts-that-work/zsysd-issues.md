# Zsysd hangs and consumes CPU

At some point my laptop started to make CPU intense work, even before starting
any applications.

I didn't know where to look, after some digging, now I have `htop` to monitor
processes.

```
sudo apt install htop
```

Then I saw that `zsysd` is making all that noise. Restarting that service
helped a bit.

```
sudo systemctl restart zsysd
```

It made below status check to return `OK`;

```
zsysctl service status
```

But after a while I saw this error;

```
ERROR couldn't save system state: Minimum free space to take a snapshot and
preserve ZFS performance is 20%.

Free space on pool "bpool" is 15%.
```

So I digged more and found this;

```
sudo -i
zfs list -H -o name -t snapshot | xargs -n1 zfs destroy
```

Now I got rid of that error, but `zsysd` still hangs every time I restart 🤷.
So I restart `zsysd` after every reboot and clean snapshots occasionally.

## Links thant helped

- https://gist.github.com/alexjj/4de71ddfae05e974c829#file-zfs-snapshot-deletion
- https://github.com/ubuntu/zsys/issues/208
- https://github.com/ubuntu/zsys/issues/172
