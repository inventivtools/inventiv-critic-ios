#import <Foundation/Foundation.h>
#import "Critic.h"

@implementation Critic

+ (Critic *)instance{
    static Critic *_instance = nil;
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

