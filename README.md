# Weapon Carry Script

#### ⭐ Check out our other resources on [Tebex](https://gamzky-scripts.tebex.io/) or in our [Discord](https://discord.com/invite/sjFP3HrWc3).
#### 📼 Preview video: [Youtube](https://www.youtube.com/watch?v=guhRcpf_r-Q)

There are already quite some 'weapon-carry' scripts available, but I often found them to be either, buggy, lacking in features or badly optimized. So I decided to create a version of my own.

## Features
-   Tested on the esx-framework, but should also work on qb-core and with ox-inventory.
-   Configure the weapons that should be displayed on a players body, if the player has the weapon in his loadout/inventory.
-   The weapons are attached to a configured position and ped-bone.
-   A debug-mode enables a command which can be used to easily determine the right weapon positions (see the end of the preview video).
-   It is also possible to add clothes-dependend positions, as of now this only works with [skinchanger](https://github.com/mitlight/skinchanger).
-   The spawned weapon props are tracked on the server, which handles the attached props on a player disconnect.