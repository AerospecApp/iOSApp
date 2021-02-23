# iOSApp

## Overview:
![alt text](https://raw.githubusercontent.com/AerospecApp/iOSApp/main/misc/Pictures/readme/progress1.png)

An iOS app that can communicate with the user's sensor through ESP32. Capable of pulling data from DynamoDB using Amplify and CocoaPod. Currently working on data visualization. 

## Installation:
1. Compile and upload code in ESP32 to ESP32.
2. Download nRF from the AppStore.
3. Scan for your device.
![alt text](https://raw.githubusercontent.com/AerospecApp/iOSApp/main/misc/Pictures/readme/nRF-1.png?token=AKSLPNJML5JJTP5YS4KJIXLADS7JA)

4. Get your device's UUID
![alt text](https://raw.githubusercontent.com/AerospecApp/iOSApp/main/misc/Pictures/readme/nRF-2.png?token=AKSLPNPS65RBVGV5WXK6VNLADS7LY)
5. Run XCode with xed .
5. Now paste it to the xCode and compile it to your iPhone.
![alt text](https://raw.githubusercontent.com/AerospecApp/iOSApp/main/misc/Pictures/readme/UUID.png?token=AKSLPNLJB6DP7KRTNIY3HKTADS7NA)
6. To connect to your ESP32:
  open the app -> open Arduino -> open Serial Monitor -> tap the *ESP32* device and start sending messages.
