# SMCKit
This is a fork of [SMCKit by beltex](https://github.com/beltex/SMCKit). It was forked to update the code for Swift 5 and build the smcutil binary. It appears that beltext hasn't been accepting pull requests and the original code hasn't been touched in ~3+ years.

I just wanted an opensource and schwifty way to swiftly ramp up my fan speed so that my laptop would stop burning my legs.

### Build smcutil
Please follow these steps to build the smcutil binary:
1. Clone this project `git clone --recursive https://github.com/bryanheinz/SMCKit.git`
2. Open the project in Xcode 11
3. Change the target to smcutil
4. Click **Product** in the menu bar
5. Click **Archive**
6. This should open **Window** --> **Organizer** to the **Archives** tab
7. Click **Distribute Content**
8. Select **Built Products** and click **Next**
9. Export
10. Copy the exported smcutil binary to `/usr/local/bin` or wherever you like to store your binaries

### Setting fan speed
Use this tool to adjust your fan speeds at your own risk. Using the following commands will set the minimum fan speed. If set too low, this could cause permanent damage to your Mac.

Running `smcutil -f` will list your fan info. Note the fan IDs and their minimum RPM value. 

Per-fan that you'd like to set, run `smcutil -s $RPM -n $FAN_ID`.

E.g. `smcutil -s 4000 -n 0`
