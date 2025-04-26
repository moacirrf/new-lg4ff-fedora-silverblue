# new-lg4ff-fedora-silverblue
***

A simple way to build new-lg4ff module on Fedora Silverblue flavours (Fedora kinoite).

This script will download automatically the last version of new-lg4ff from
[https://github.com/berarma/new-lg4ff](https://github.com/berarma/new-lg4ff).  

### Dependencies
1. **Podman**, check podman instalation with the command:
 
        podman version
    
    The output is something like
    
        Client:       Podman Engine
        Version:      5.0.0-rc2
        API Version:  5.0.0-rc2
        Go Version:   go1.22.0
        Built:        Mon Feb 19 06:50:31 2024
        OS/Arch:      linux/amd64

## Express build and installation
If you just want build and run, lets go!:

1. Edit **Dockerfile** to configure your Fedora Version, default is **42**

   > ARG FEDORA_VERSION=**YOUR_VERSION**
   
3. Build
        
         sh podman_build.sh --no-cache

4. Install the module as a systemd service

        sudo sh install.sh

5. Check if all is ok

        sudo dmesg

    Output will be:
        
        [   15.412246] input: Logitech G29 Driving Force Racing Wheel as /devices/pci0000:00/0000:00:08.1/0000:09:00.3/usb3/3-1/3-1:1.0/0003:046D:C24F.0001/input/input23
        [   15.412313] logitech 0003:046D:C24F.0001: input,hidraw3: USB HID v1.11 Joystick [Logitech G29 Driving Force Racing Wheel] on usb-0000:09:00.3-1/input0
        [   15.412369] logitech 0003:046D:C24F.0001: Force feedback support for Logitech Gaming Wheels (0.4.1)
        [   15.412370] logitech 0003:046D:C24F.0001: Hires timer: period = 2 ms


If module stop works just repeat all steps again.

## Detailed Build

***

### Preparing build to your Fedora Version
1. Checkout or download all this files on a directory, after download you must have this files:

        new-lg4ff-fedora-silverblue/
        ├── Dockerfile
        ├── install.sh
        ├── load-hid-logitech-new.sh
        ├── podman_build.sh
        ├── README.md
        └── uninstall.sh


2. Verify your Fedora version with the command
    
    > uname -r
    
    The output is something like
    
        6.14.3-300.fc42.x86_64

    The **fc42** says that we are using **Fedora 42**

   Edit file **Dockerfile**  and change the first line to your version:

        ARG FEDORA_VERSION=42


### Building

1.  Open a terminal inside folder that you dowload an excecute the file **podman_build.sh**

        sh podman_build.sh

    A folder called **build** will be created and the module **hid-logitech-new.ko** will be generated:

        ├── build
        │   └── new-lg4ff
        │       └── hid-logitech-new.ko
        ├── Dockerfile
        ├── install.sh
        ├── load-hid-logitech-new.sh
        ├── podman_build.sh
        ├── README.md
        └── uninstall.sh

2.  Load module:

        sudo sh load-hid-logitech-new.sh

3   Great! your module must be loaded and working.

4.  Check with command:

        sudo dmesg

    Output will be:
        
        [   15.412246] input: Logitech G29 Driving Force Racing Wheel as /devices/pci0000:00/0000:00:08.1/0000:09:00.3/usb3/3-1/3-1:1.0/0003:046D:C24F.0001/input/input23
        [   15.412313] logitech 0003:046D:C24F.0001: input,hidraw3: USB HID v1.11 Joystick [Logitech G29 Driving Force Racing Wheel] on usb-0000:09:00.3-1/input0
        [   15.412369] logitech 0003:046D:C24F.0001: Force feedback support for Logitech Gaming Wheels (0.4.1)
        [   15.412370] logitech 0003:046D:C24F.0001: Hires timer: period = 2 ms


### Possible or Inevitable Problems

1.  You will have to repeat step 2 every time you restart your computer ( solution in the end of this document)
       
        sudo sh load-hid-logitech-new.sh
    
2. Must repeat all building step if you update your kernel.

        sh podman_build.sh
        sudo sh load-hid-logitech-new.sh

### Load this module when system starts.

Certainly there are many ways to do that, but a simple way is creating a service, lets do that!

1.  Execute the file **install.sh**

        sudo sh install.sh

    Output will be something like
    
        Creating a service on /etc/systemd/system/ ...
        Disabling original module hid-logitech
        Creating a black list file  /etc/modprobe.d/hid-logitech-blacklist.conf
        Enable service...
        Created symlink /etc/systemd/system/multi-user.target.wants/hid-logitech-new.service → /etc/systemd/system/hid-logitech-new.service.
        Starting service
        OK.Bye bye

2. Now the module will load before the user session starts, you can change **install.sh** script to adapt to your necessities.

3. To remove this service execute:

        sudo sh uninstall.sh

    output will be:

        Removing service...
        Removed "/etc/systemd/system/multi-user.target.wants/hid-logitech-new.service".
        Unloading module hid-logitech-new
        Enabling original module hid-logitech
        Ok.Bye bye

### Build diretory is empty.
Execute the following command
    
        sh podman_build.sh --no-cache
        
### Can i use this in other distribution?
Sure you can! just adapt the dockerfile to your distribution.

https://github.com/moacirrf/new-lg4ff-fedora-silverblue/blob/main/Dockerfile

You can ask CHATGPT to convert dockerfile content to work with Ubuntu.

### Next features
- Automatically rebuild the module if module refuse to load.
- Or a graphical notification when module refuse to load (hard to do).
