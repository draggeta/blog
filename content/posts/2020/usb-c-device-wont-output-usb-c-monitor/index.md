---
title: USB-C device won't output to a USB-C monitor
author:
type: post
date: 2020-01-08T21:51:58+01:00
subtitle: Not all DisplayPort Alt Modes are created equally
image:
series: []
categories: [troubleshooting]
tags: [usb, usb-c, Alt Mode, displayport, thunderbolt, power delivery, standards]
draft: true
---

Last holiday I helped my sister find a new setup for her home office. I wanted her setup to be as simple as possible, while still being reasonably priced. Her choice fell on the Lenovo 13S-IWL laptop and Dell U2719DC monitor. 

Both the monitor support USB Type-C (USB-C) DisplayPort (DP) Alternate Mode (Alt Mode) which allows for output/input of a DP signal over USB-C. The monitor is also capable of supplying up to 100W of power via de USB-C cable, but the laptop sadly doesn't support receiving power over the port. 

The idea was that she could hook up all her USB devices such as a keyboard and mouse to the monitor and use one USB-C cable to connect the laptop to everthing. The only other cable she would need to plug in, would be the AC adapter.

After setting up the devices, the laptop could not output to the Dell monitor. Her peripherals attached to the monitor however, were connected to the laptop and could be used. Every time the cable was connected, this error notification popped up: 

{{< figure 
  src="./media/billboard-displayport-warning.png"
  width="1000"
  caption="DisplayPort warning" 
  caption-position="bottom"
  caption-effect="fade"
  alt="Display connection might be limited. Make sure the DisplayPort device you're connecting to is supported by your PC. Select this message for more troubleshooting information." 
  attr=""
>}}

The monitor wasn't recognized as a normal monitor either, but as a 'Billboard Device' that didn't seem to do anything.

## USB protocols and standards

To find out why it wasn't working, I had to read quite a bit about how the USB standards are defined and work. Below are the parts that are relevant for the problem.

### Data

The protocol itself has change quite a bit from when it first launched in 1996. The original release of 1.0 through the 2.0 release were half-duplex connections. Since USB 3.0, the actual protocol fundamentally changed, where it is now a full-duplex connection just like all Ethernet standards since gigabit ethernet.

Next, USB 3.1 got introduced. The new standard didn't exist side-by-side with USB 3.0, but superseded the 3.0 standard. What was 3.0 then became know as 3.1 Gen 1. The new standard also introduced a new variant which supports up to 10 Gbit/s.

| Name | Previous Standard | Speed | Notes |
| --- | --- | --- | --- |
| USB 3.1 Gen 1 | USB 3.0 | 5 Gbit/s | Uses one lane to achieve its throughput. |
| USB 3.1 Gen 2 | N/A | 10 Gbit/s | Uses two lanes to achieve its throughput. |

The subsequently introduced USB 3.2 standard again supersedes all previous 3.x standards. The new names and capabilities are:

| Name | Previous Standard | Speed | Notes |
| --- | --- | --- | --- |
| USB 3.2 Gen 1x1 | USB 3.0, USB 3.1 Gen 1 | 5 Gbit/s | Uses one lane to achieve its throughput. |
| USB 3.2 Gen 1x2 | USB 3.1 Gen 2 | 10 Gbit/s | Uses two lanes to achieve its throughput. |
| USB 3.2 Gen 2x1 | N/A | 10 Gbit/s | Uses one lane with a more efficient encoding to achieve its throughput. Uses the same branding as USB 3.2 Gen 1x2. |
| USB 3.2 Gen 2x2 | N/A | 20 Gbit/s | Uses two lanes with a more efficient encoding to achieve its throughput. |

Lastly, in 2019, the USB 4.0 standard got announced, which ups the transfer rate to 40 Gbit/s. This is a new standard and co-exists with the USB 3.2 standard. USB 4.0 is based on Thunderbolt 3.

### Power

Initially, the USB standard supplied only enough power to run the attached devices. However as time went on, the USB standard got used to provide power to more and more devices, official standards got created for supplying more power. This culminated in 2012 into what is now the USB Power Delivery standard. 

There are different revisions of the PD standard. All the Power Delivery specs allow the devices to negotiate the amount of power delivered. The standard allows for up to 20V and 5A of power (100 Watts) and is supported from both the host to device and vice versa. This, in combination with USB Type-C can lead to interesting situations where your phone charges your laptop and gets depeleted in minutes. 

### Others

There are other specifications as well, such as ways to transfer audio. These are not covered here as they are irrelevant to the problem.

## USB connectors

### Type-A and Type-B

The first thing to know is that the connector form factors are basically separate from the protocol standards. There are some differences between generations though. A Type-A cable or port that supports USB 3.0 has more pins in the connector than the cables supporting only USB 2.0. 

Below is a subset of the connectors. The A connectors are plugged into the host, while the B connectors are used on the device side. Ports and cables always have a host and device side, making them unidirectional (in the master/slave sense, not that data could be transfered in one direction).


{{< figure 
  src="./media/usb-connectors.png"
  width="1000"
  caption="Some variants of connectors supporting up to USB 2.0, as well as the USB Type-C connector " 
  caption-position="bottom"
  alt="Some variants of connectors supporting up to USB 2.0, as the USB Type-C connector. The form factor of the Type-A connector is the same between generations, but the USB 3.0 supporting cables and connectors contain more pins." 
  attr="©original:Bruno Duyé/mod:Darx~commonswiki/mod:me CC-BY-SA-3.0" 
>}}
  <!-- caption-effect="fade" -->


### Type-C

In 2014 the USB-C plug got introduced. This brought some 'radical' changes and benefits. The USB-C plug can be used for both host and device operations. It also has quite a few more pins, allowing it to transfer more data and data types, new audio standards as well as more power. The best feature however, is that it is reversible. No longer will people have to turn their USB cable three times to get it plugged in.

While USB-C was introduced just after USB 3.1, they are not linked. USB-C, like the A and B connectors, is 'just' a form factor. Type-C cables and ports that for example carry only USB 2.0 or only supply power do exist. This is similar to the Type-A connector. Type-A cables and ports exist that carry only USB 1.1 signals all the way up to and including USB 3.2 Gen 2x2.

However, the USB Type-C receptacle and port is not designed to carry only USB protocols. It can carry a lot of protocols via Alternate Modes. The confusing part is that it isn't required to carry any of the protocols it can carry. Be they USB or Alternate Modes.

There are some limitations to the cables. To reach 10 or 20 Gbit/s, the cables cannot be longer than 1 meter in length. 5 Gbit/s is supported on USB-C cables up to 2 meters.

The Type-C ports and cables are also the only supported USB 4.0 form factor.

### Type-C Alternate Modes

USB-C supports carrying other signals in conjunction with USB signals. Right now, five Alt modes exist and they are negotiated by the host and device sides. How the negotiation happens depends on each separate mode and there can be multiple negotiation types per mode. All the signals in the Alternative Modes are native signals and are not carried over/encapsulated in USB. The modes often still have enough bandwidth to carry USB signals as well as power. 

Below is a list of the more interesting Alternative Modes and the signals they carry natively and over USB standards.

* DisplayPort
    * Native DisplayPort 1.4
    * Native USB 3.2 or 2.0*
    * Native USB Power Delivery over USB-C PD standard**
    * HDMI 2.0a over DisplayPort
* Thunderbolt 3
    * Native Thunderbolt 3
    * Native USB Power Delivery over USB-C PD standard
    * DisplayPort 1.2 over TB
    * PCI-E 3.0 over TB
    * USB 3.2 over TB 
* HDMI
    * Native HDMI 1.4
    * Native USB 2.0
    * Native USB Power Delivery over USB-C PD standard

>*Depending on the amount of lanes used, more throughput is available for the Alt Mode and less for USB. e.g. if 4 lanes are used in DP Alt Mode, only USB 2.0 speeds are available for data transfer.  
>**Optional if the devices doesn't have the DisplayPort logo next to the port.

It looks a bit confusing, but it isn't. Each of the Alternate Modes is capabable of delivering what it can natively do. DisplayPort has always been able to carry HDMI and Thunderbolt is capable of carrying USB and DisplayPort.

## DisplayPort Alternate Mode woes

Back to the problem. I have a laptop and monitor that both support DisplayPort Alternative Mode over their USB-C ports. However, when both are connected, no image is displayed and an error pops up. This behaviour is actually completely according to the specifications of the DisplayPort Alt Mode standard. 

As mentioned before, my laptop doesn't support USB Power Delivery over its USB Type-C port. The DisplayPort Alternate Mode standard however, requires that if two devices are connected via USB-C, power delivery is negotiated before the Alternative Mode negotiations can happen. If no PD is negotiated, DisplayPort Alt Mode fails. The display device then falls back to offering a 'Billboard Device' so at the very least a generic USB 2.0 hub and all connected devices are provided to the host.

If like me, you do have a laptop that doesn't support USB PD but does output DP Alt Mode, you'll need to use a USB-C adapter/dock that can provide you with a separate DisplayPort connector (male of female). The negotiation for this type of connection doesn't require Power Delivery. If PD isn't supported on one side, it gets disabled skips to the DP Alt Mode negotiation. Such an adapter or cable allows the laptop to output DP 1.4 to the monitor via the monitors DisplayPort input.

## Conclusion

In short. If you want to use a USB-C cable to connect two devices so one can output DisplayPort to a display, make sure that both support USB Power Delivery. Otherwise you'll need to use an adapter to convert the USB-C signal/plug into a DisplayPort connector.
