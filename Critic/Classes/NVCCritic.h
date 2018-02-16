#import <Foundation/Foundation.h>

@interface NVCCritic : NSObject

@property (nonatomic, strong) NSString *productAccessToken;

+ (NVCCritic *)instance;
- (void)start:(NSString *)productAccessToken;

@end

