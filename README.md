# Icon Validator Shim


### Purpose:
* Translates bad calls to xdg-desktop-portal-validate-icon into good calls


### How to install:
* Copy the script somewhere (recommend /usr/local/bin/xdg-desktop-portal-validate-icon.bash)
* Move /usr/libexec/xdg-desktop-portal-validate-icon to /usr/libexec/xdg-desktop-portal-validate-icon.orig
* Symlink /usr/libexec/xdg-desktop-portal-validate-icon to the script
* Package updates that overwrite /usr/libexec/xdg-desktop-portal-validate-icon will require that you move the new version to *.orig (overwriting the previous version) and then recreate the symlink to the script.


### How to uninstall
* Remove the /usr/libexec/xdg-desktop-portal-validate-icon symlink (ONLY IF IT IS THE SYMLINK!)
* Move /usr/libexec/xdg-desktop-portal-validate-icon.orig to /usr/libexec/xdg-desktop-portal-validate-icon
* Delete the script, wherever it is you put it


### Shout out
* FuriLabs for making the FLX1s, the first mobile Linux phone I've ever been able to comfortably (enjoyably even!) daily drive.


### License
* For now, this project adopts Alaraajavamma's ["Feel free to do what ever you want with this but no guarantees - this will probably explode your phone xD"](https://gitlab.com/Alaraajavamma/fastflx1/) license.
* but I reserve the sole right to change it at any point for any reason and without any notice.
