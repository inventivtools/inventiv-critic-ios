#import <Foundation/Foundation.h>

@interface Critic : NSObject

@property (nonatomic) Boolean shouldLogToFile;
@property (nonatomic, strong) NSString *productAccessToken;

+ (Critic *)instance;
- (void)start:(NSString *)productAccessToken;
- (NSString *)getLogFilePath;

@end

