#import "MNAUtil.h"

@implementation MNAUtil
+ (NSString *)localizedItem:(NSString *)key {
  NSBundle *tweakBundle = [NSBundle bundleWithPath:@PREF_BUNDLE_PATH];
  return [tweakBundle localizedStringForKey:key value:@"" table:@"Root"] ?: @"";
}

+ (UIColor *)colorFromHex:(NSString *)hexString {
  unsigned rgbValue = 0;
  if ([hexString hasPrefix:@"#"]) hexString = [hexString substringFromIndex:1];
  if (hexString) {
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner setScanLocation:0]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
  }
  else return [UIColor grayColor];
}

+ (void)showAlertMessage:(NSString *)message title:(NSString *)title viewController:(UIViewController *)vc {
  __block UIWindow* topWindow;
  if (!vc) {
    topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
  }
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:title ?: @"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    if (!vc) {
      topWindow.hidden = YES;
      topWindow = nil;
    }
  }]];
  if (!vc) {
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
  } else {
    [vc presentViewController:alert animated:YES completion:nil];
  }
}

+ (void)showRequireRestartAlert:(UIViewController *)vc {
  __block UIWindow* topWindow;
  if (!vc) {
    topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
  }
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:[MNAUtil localizedItem:@"APP_RESTART_REQUIRED"] message:[MNAUtil localizedItem:@"DO_YOU_REALLY_WANT_TO_KILL_MESSENGER"] preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:[MNAUtil localizedItem:@"CONFIRM"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    if (!vc) {
      topWindow.hidden = YES;
      topWindow = nil;
    }
    exit(0);
  }]];

  [alert addAction:[UIAlertAction actionWithTitle:[MNAUtil localizedItem:@"CANCEL"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    if (!vc) {
      topWindow.hidden = YES;
      topWindow = nil;
    }
  }]];

  if (!vc) {
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
  } else {
    [vc presentViewController:alert animated:YES completion:nil];
  }
}

+ (BOOL)isDarkMode {
  if (@available(iOS 12.0, *)) {
    if(UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
      return TRUE;
    }else{
      return FALSE;
    }
  }
  return FALSE;
}

+ (BOOL)isiPad {
  return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}
@end