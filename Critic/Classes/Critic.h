#import <Foundation/Foundation.h>

@interface Critic : NSObject

@property (nonatomic) Boolean shouldLogToFile;
@property (nonatomic, strong) NSString *productAccessToken;

+ (Critic *)instance;

- (NSString *)getLogFilePath;
- (void)showDefaultFeedbackScreen:(UIViewController *)viewController;
- (void)start:(NSString *)productAccessToken;

@end

