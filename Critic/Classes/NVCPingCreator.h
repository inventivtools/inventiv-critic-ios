#import <Foundation/Foundation.h>

@interface NVCPingCreator : NSObject

- (void)create:(void (^)(BOOL success, NSError *))completionBlock;

@end
