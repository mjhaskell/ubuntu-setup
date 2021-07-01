# Set up eduroam WiFi connection

In settings GUI go to Wi-Fi and then eduroam.
These are the settings you need:
- Security: WPA & WPA2 Enterprise
- Authentication: Protected EAP (PEAP)
- Anonymous identity:
- Domain: 
- CA certificate: (None)
  - check box that says no CA certificate is required
- PEAP version: Automatic
- Inner authentication: MSCHAPv2
- Username: <netid>@byu.edu
- Password:
  - click on icon and switch to ask for password every time

The config file is stored at
/etc/NetworkManager/system-connections/eduroam.nmconnection

