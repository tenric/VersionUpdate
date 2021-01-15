# VersionUpdate
Check and update  app's version for both AppStore &amp; Fir

### How to use

1. Add Channel in info.plist
Now we only support two channels "AppStore" or "Fir", no channel or other channel are ignored.
![demo1](https://raw.githubusercontent.com/tenric/VersionUpdate/master/VersionUpdateDemo/Demo1.png)

2. Include library use CocoaPods
    pod 'VersionUpdate', '~> 1.0.2'

3. Call this when app launch

    let versionUpdate = VersionUpdate()
    versionUpdate.addAppStoreChannelWithAppId("your app id on appstore")
    versionUpdate.addFirChannelWithAppId("your app id on fir", token: "your koken on fir", downloadUrl: "http://fir.im/xxxxxx")
    versionUpdate.checkUpdate()

4. If there has new version,just show alert which you can ignore or go to update.
![demo2](https://raw.githubusercontent.com/tenric/VersionUpdate/master/VersionUpdateDemo/Demo2.png)
