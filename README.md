# dosparkles

# Update translations:
flutter pub run intl_translation:generate_from_arb     --output-dir=lib/l10n --no-use-deferred-loading     lib/main.dart lib/l10n/intl_*.arb

# build apk:
flutter build apk


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