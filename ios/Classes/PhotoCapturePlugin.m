#import "PhotoCapturePlugin.h"
#import <photo_capture_plugin/photo_capture_plugin-Swift.h>

@implementation PhotoCapturePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPhotoCapturePlugin registerWithRegistrar:registrar];
}
@end
