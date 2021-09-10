# dosparkles
Flutter 2.2.0-10.3.pre • channel beta


flutter clean
flutter packages pub upgrade

keytool -keystore android/app/key.jks -list -v
B0:5D:BA:3B:25:57:AE:0D:EA:37:B5:30:0E:71:A1:83:66:85:23:9A
keytool -genkey -v -keystore android/app/key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key

      
keytool -exportcert -alias key -keystore android/app/key.jks | openssl sha1 -binary | openssl base64
sF26OyVXrg3qN7UwDnGhg2aFI5o=


keytool -list -v \
-alias key -keystore android/app/key.jks

# Screenshots

<div style="float: right">
      <img src='https://github.com/sysintellects/cmx-mobile/blob/master/assets/img/Preview.png' width='250'>
      <img src='https://github.com/sysintellects/cmx-mobile/blob/master/assets/img/Preview.png' width='250'>
      <img src='https://github.com/sysintellects/cmx-mobile/blob/master/assets/img/Preview.png' width='250'>
</div>

# Update translations:

flutter pub run intl*translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/main.dart lib/l10n/intl*\*.arb

# build apk:

flutter build apk --release

flutter build apk --no-sound-null-safety
flutter build apk --split-per-abi --no-sound-null-safety
# update repos:

cd ios
pod cache clean --all
pod repo update
pod update
cd ..
flutter clean
flutter build ios
grep -r IUWebView ios/Pods

android emulator with local backend

ipconfig
// 192.168.43.136

{
"graphQLHttpLink": "http://192.168.43.136:1337/graphql",
"baseApiHost": "http://192.168.43.136:1337"
}

{
"graphQLHttpLink": "https://backend.dosparkles.com/graphql",
"baseApiHost": "https://backend.dosparkles.com"
}
