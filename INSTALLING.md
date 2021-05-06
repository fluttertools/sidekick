Installing Sidekick is super simple and should only take a few minutes! To start of, [download the latest release](https://github.com/leoafarias/sidekick/releases/latest) or build from source (Like any other flutter application).

# Windows
There are two ways to install Sidekick on Windows. Firstly, with an MSIX, named `Sidekick-windows-x.x.x.msix`, you should run this if you wish to install Sidekick on you PC, please check Installing with MSIX for instructions. Alternatively, you can just run `Sidekick.exe` to use Sidekick without having to install anything. This is done by downloading `windows-x.x.x.zip`

### Installing with MSIX (Recommended)
Unfortunately, it isn't as easy as opening the file and installing it as we do not have a signed certificate (yet).

To install Sidekick, first right-click and click on `Properties`.

Then, navigate to `Digital Signatures`. You will see only one signature called `Msix Testing`, you will need to add this to the windows key-store. To do this, please double-click on the signature and click on `View Certificate`. Next, click on `Install Certificate` and then on `Local System`. Finally you'll need to select they key-store called `Trusted Root Certification Authorities` under `Browse`.

After completing those steps you should now be able to install Sidekick using the MSIX package.

### Using the portable version
If you don't wish to install an untrusted certificate you can also simply save `Sidekick.exe` and all of the other files wherever you want and then create a desktop shortcut. Please note that the auto-update feature will not work!

# MacOS
In order to install Sidekick on MacOS we recommend downlading the file named `Sidekick-macos-x.x.x.dmg`, you should run this if you wish to install Sidekick on you Mac, please check Installing with DMG for instructions. Alternatively, you can just run `Sidekick` to use Sidekick without having to install anything by downloading `macos-x.x.x.zip`.

### Installing with DMG (Recommended)
To install Sidekick in your Mac simply open `Sidekick.dmg` and drag the Sidekick app to the `Applications` folder next to it. If you are updating the app you'll need to click `Replace`.

After doing this you should be able to see `Sidekick` in your Laucnhapd. However, if you try to open it you might get a message saying that `"Sidekick" can't be opened because Apple cannot check it for malicious software.` In order to fix this open `System Preferences` and click on `Security and Privacy`, where you'll see a message saying `"Sidekick" was blocked from use because it is not from an identified developer`, in order to complete the installation you will need to click `Open Anyway` and then `Open` in the popup.

Done! You should now be able to use Sidekick normally!

### Using the portable version
To use the portable version of Sidekick in your Mac simply locate `Sidekick` and drag the it wherever you want to store the app.

After doing this you should be able to open `Sidekick`. However, if you try to open it you might get a message saying that `"Sidekick" can't be opened because Apple cannot check it for malicious software.` In order to fix this open `System Preferences` and click on `Security and Privacy`, where you'll see a message saying `"Sidekick" was blocked from use because it is not from an identified developer`, in order to complete the installation you will need to click `Open Anyway` and then `Open` in the popup.

# Linux
Coming soon!