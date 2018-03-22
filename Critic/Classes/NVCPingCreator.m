#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SystemServices.h"
#import "NVCPingCreator.h"
#import "Critic.h"

@implementation NVCPingCreator

- (void)create:(void (^)(BOOL success, NSError *))completionBlock{
    
    NSURL *url = [NSURL URLWithString:@"https://critic.inventiv.io/api/v2/ping"];
    NSMutableURLRequest *request = nil;
    @try {
        request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField: @"Accept"];
        NSData *httpBody = [NSJSONSerialization dataWithJSONObject:[self generateParams] options:0 error:nil];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error){
                NSLog(@"Critic - Failed to send ping: %@", error);
                completionBlock(NO, error);
            }
            else{
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                long code = (long)[httpResponse statusCode];
                if(code == 200){
                    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"Critic - Ping has been sent successfully: %@", result);
                    
                    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
                    [[Critic instance] setAppInstallId:[[responseData valueForKey:@"app_install"] valueForKey:@"id"]];
                    NSLog(@"Critic - Ping response app_install.id: %@", [[Critic instance] appInstallId]);
                    
                    completionBlock(YES, error);
                }
                else{
                    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"Critic - Ping request failed. Server returned response code[%ld]. Result: %@", code, result);
                    completionBlock(NO, error);
                }
            }
        }];
        [task resume];
    }
    @catch (NSError *error) {
        NSLog(@"Critic - Error encountered forming ping request: %@", error);
        completionBlock(NO, error);
    }
}

- (NSDictionary *)generateParams{
    SystemServices* systemServices = [SystemServices sharedServices];
    
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    
    NSString* batteryStateString = nil;
    switch([myDevice batteryState]) {
        case UIDeviceBatteryStateUnknown:
            batteryStateString = @"Unknown";
            break;
        case UIDeviceBatteryStateFull:
            batteryStateString = @"Full";
            break;
        case UIDeviceBatteryStateCharging:
            batteryStateString = @"Charging";
            break;
        case UIDeviceBatteryStateUnplugged:
            batteryStateString = @"Unplugged";
        default:
            batteryStateString = @"Unknown";
            break;
    }
    
    NSMutableDictionary *app = [NSMutableDictionary new];
    NSBundle *bundle = [NSBundle mainBundle];
    [app setObject:[bundle objectForInfoDictionaryKey:@"CFBundleName"] forKey:@"name"];
    [app setObject:[bundle bundleIdentifier] forKey:@"package"];
    [app setObject:@"iOS" forKey:@"platform"];
    NSMutableDictionary *version = [NSMutableDictionary new];
    [version setObject:[bundle objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] forKey:@"code"];
    [version setObject:[bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"name"];
    [app setObject:version forKey:@"version"];
    
    NSMutableDictionary *device = [NSMutableDictionary new];
    [device setObject:[[myDevice identifierForVendor] UUIDString] forKey:@"identifier"];
    [device setObject:@"Apple" forKey:@"manufacturer"];
    [device setObject:[systemServices deviceModel] forKey:@"model"];
    NSString* carrierName = [systemServices carrierName];
    if(carrierName){
        [device setObject:carrierName forKey:@"network_carrier" ];
    } else {
        [device setObject:@"N/A" forKey:@"network_carrier" ];
    }
    [device setObject:@"iOS" forKey:@"platform"];
    [device setObject:[systemServices systemsVersion] forKey:@"platform_version"];
    
    NSMutableDictionary *deviceStatus = [NSMutableDictionary new];
    [deviceStatus setObject:@([SSHardwareInfo pluggedIn]) forKey:@"battery_charging"];
    [deviceStatus setObject:[NSNumber numberWithFloat:[systemServices batteryLevel]] forKey:@"battery_level"];
    [deviceStatus setObject:batteryStateString forKey:@"battery_health"];
    [deviceStatus setObject:[NSNumber numberWithLongLong:[systemServices longFreeDiskSpace]] forKey:@"disk_free" ];
    [deviceStatus setObject:[NSNumber numberWithLongLong:[systemServices longDiskSpace]] forKey:@"disk_total" ];
    [deviceStatus setObject:[NSNumber numberWithDouble:[systemServices activeMemoryinRaw]] forKey:@"memory_active" ];
    [deviceStatus setObject:[NSNumber numberWithDouble:[systemServices freeMemoryinRaw]] forKey:@"memory_free" ];
    [deviceStatus setObject:[NSNumber numberWithDouble:[systemServices inactiveMemoryinRaw]] forKey:@"memory_inactive" ];
    [deviceStatus setObject:[NSNumber numberWithDouble:[systemServices purgableMemoryinRaw]] forKey:@"memory_purgable" ];
    [deviceStatus setObject:[NSNumber numberWithDouble:[systemServices totalMemory]] forKey:@"memory_total" ];
    [deviceStatus setObject:[NSNumber numberWithDouble:[systemServices wiredMemoryinRaw]] forKey:@"memory_wired" ];
    [deviceStatus setObject:@([systemServices connectedToCellNetwork]) forKey:@"network_cell_connected" ];
    [deviceStatus setObject:@([systemServices connectedToWiFi]) forKey:@"network_wifi_connected" ];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[[Critic instance] productAccessToken] forKey:@"api_token"];
    [params setObject:app forKey:@"app"];
    [params setObject:device forKey:@"device"];
    [params setObject:deviceStatus forKey:@"device_status"];
    
    return params;
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary parameters:(NSDictionary *)parameters {
    NSMutableData *httpBody = [NSMutableData data];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}

- (NSString *)mimeTypeForPath:(NSString *)path {
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    CFRelease(UTI);
    return mimetype;
}
@end
