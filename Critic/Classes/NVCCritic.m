#import <Foundation/Foundation.h>
#import "NVCCritic.h"

@implementation NVCCritic

+ (NVCCritic *)instance{
    static NVCCritic *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)start:(NSString *)productAccessToken{
    [self setProductAccessToken:productAccessToken];
}

@end

