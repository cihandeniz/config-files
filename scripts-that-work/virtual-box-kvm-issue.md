# Virtual Box vs KVM

When running VirtualBox on Linux, you may run into this dreaded error:

```
VirtualBox can't operate in VMX root mode.
Please disable the KVM kernel extension, recompile your kernel and reboot
(VERR_VMX_IN_VMX_ROOT_MODE).
```

What this means: **another hypervisor (KVM) is already using your CPU's
virtualization features (VT-x/AMD-V).** VirtualBox can't share them.

---

## The Quick Fix: Unload KVM

On Ubuntu, KVM modules (`kvm_intel` or `kvm_amd`) are often loaded
automatically. To free up VT-x for VirtualBox:

For Intel CPUs:

``` bash
sudo modprobe -r kvm_intel kvm
```

For AMD CPUs:

``` bash
sudo modprobe -r kvm_amd kvm
```

That's it.

---

## Does This Break Docker?

No. Regular Docker containers don't need KVM. Only containers that explicitly
use `/dev/kvm` (for nested virtualization) will stop working until you reload
the modules.

You can bring KVM back anytime with:

``` bash
sudo modprobe kvm_intel kvm   # Intel
sudo modprobe kvm_amd kvm     # AMD
```
