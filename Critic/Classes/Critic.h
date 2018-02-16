#import <Foundation/Foundation.h>

@interface Critic : NSObject

@property (nonatomic, strong) NSString *productAccessToken;

+ (Critic *)instance;
- (void)start:(NSString *)productAccessToken;

@end

