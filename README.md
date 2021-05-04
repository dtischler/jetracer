# JetRacer
This repo contains a JetRacer build running in a container, designed to be deployed onto a Jetson Nano running balenaOS.  With the combination of the public endpoint feature in balenaCloud that opens a connection to the device, and then combined with the Jupyter server, you can login and begin controlling JetRacer no matter where it is located.  This makes for the ability to drive the car from anywhere.  For training though, it probabaly makes more sense to be physically present and located with the car and the track.  It's certainly less time consuming that way.  :-)

## Background Info
The Balena workflow is significantly different than the typical Jetpack Ubuntu distribution that Jetson users are likely accustomed to, so we'll cover it briefly here to give a basic understanding of the overall design.  Balena builds a small, command-line only operating system based on Yocto linux, designed for embedded devices and IoT endpoints.  This operating system is minimal by design, and the intention is to run all applications and workloads in a container, which can then be deployed, updated, and used no matter where the device is physically located (so long as it has internet connectivity of some sort).  Further, there is a web-based control plane for the balena devices, called balenaCloud, that lets you interact with the devices.  Thus, instead of flashing an SD Card card with the Jetpack Ubuntu and attaching a monitor, keyboard and mouse like usual, you instead flash an SD Card with balenaOS, which then registers itself with balenaCloud and waits for containers to be built and pushed to the device.  There is no need for a monitor, keyboard, or mouse, and you instead interact with the device via the cloud terminal.  You can read more about balena and the workflow here:  [https://balena.io](https://balena.io)

## Installation

With that overall conceptual understanding, the basic process to follow for this GitHub repo consists of:

- Sign up for a balena account, login.
![Alt text](/img/image1.png?raw=true)
- Create an Application, name it anything you want.  Choose the **Nvidia Jetson Nano (SD Card)** as the "default" device type for the Application.
![Alt text](/img/image2.png?raw=true)
- Next, Add a Device.  There are a few options here, but it might be useful to select a "Development" image on this menu so that you can more easily troubleshoot any issues.  Also, be sure to add WiFi credentials, so the Nano can attach to WiFi upon first boot.  At the bottom, click "Download balenaOS", and an operating system is literally created and downloaded to your laptop or desktop PC.
![Alt text](/img/image3.png?raw=true)
![Alt text](/img/image4.png?raw=true)
- Flash that downloaded OS image to an SD Card, insert into the JetRacer Nano, and boot it up.
![Alt text](/img/image5.png?raw=true)
- After a few moments, the Nano will show up in the balenaCloud dashboard, and it is ready for containers at this point.
- Click this button, to start the build of this repo on the balena hosted builders:

[![balena deploy button](https://www.balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/dtischler/jetracer)

- This will take a long time to build, perhaps multiple hours, and result in a very large container of about 30gb.  Once it is done building, the Nano will automatically download it.  This means you have a 30gb download to perform, also quite time consuming as you can imagine.  Make some tea.  
- Finally, once the download finishes and the container starts, the Jupyter server will start and you can connect to it from a browser.  You can find your Nano's IP address in the balenaCloud dashboard.  And over on the right hand side, in the Logs streaming from the Nano, you will see the Token that is generated.  Browse to that IP address of the Nano, enter your token, and you are ready to use JetRacer!
![Alt text](/img/image7.png?raw=true)
![Alt text](/img/image8.png?raw=true)

## Usage

Running through the Jupyter notebooks and using JetRacer is the same as the Nvidia provided version, which is well [documented in their repo](https://github.com/NVIDIA-AI-IOT/jetracer), so I won't repeat those instructions here.  
![Alt text](/img/image9.png?raw=true)

However, the added bits and pieces from this containerized methodolgy are the following:

A.) We added one JetRacer in the Installation instructions above, but, that process is repeatable and you can continue flashing that same balenaOS image to more SD Cards and pop them into more JetRacers, building out a whole fleet of them.  This is useful for instructors teaching a class, or developers with more than one JetRacer.  Up to 10 devices are free in balenaCloud, then paid plans exist beyond 10 units.

B.) There is a feature called "Public Device URL" in balenaCloud that exposes whatever is running on port 80 to a device endpoint URL of the syntax https://device-UUID.balena-devices.com/ (it is turned off by default). With that setting enabled though, the Jupyter server becomes available on the external, public internet.  You would still need the token to access the notebook, but, this gets interesting...  With the Public URL enabled, you can login to JetRacer, and essentially drive the vehicle from anywhere!

![Alt text](/img/image10.png?raw=true)
![Alt text](/img/image11.png?raw=true)

C.) As you train your JetRacer, the images and the model are of course inside the running container.  If the container is restarted, you lose that information if you don't save the model to a volume that is mapped back to the host OS.  If you examine the docker-compose file in the top level directory of this repo, you will see there is a volume named `data`, so that is probably a good place to put it.  Another option is think about the ramifications of a fleet of JetRacers, and students competing.  If teams wanted to share their models, what could be done is to setup a local-network fileserver, and have the teams upload their models to it.  I personally tested this with a NextCloud instance running on the same network, which is nice because it allows direct CLI uploading of files via it's WebDav syntax.  You can [read about that here](https://docs.nextcloud.com/server/10/user_manual/files/access_webdav.html#accessing-nextcloud-files-using-webdav), but, it worked great to share the model across JetRacers.






