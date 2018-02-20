#import <Foundation/Foundation.h>

@interface Critic : NSObject

@property (nonatomic, strong) NSString *defaultFeedbackScreenDescriptionPlaceholder;
@property (nonatomic, strong) NSString *defaultFeedbackScreenTitle;
@property (nonatomic, strong) NSString *defaultShakeNotificationMessage;
@property (nonatomic, strong) NSString *defaultShakeNotificationTitle;
@property (nonatomic) Boolean shouldLogToFile;
@property (nonatomic) Boolean shouldRespondToShake;
@property (nonatomic, strong) NSString *productAccessToken;

+ (Critic *)instance;

- (NSString *)getLogFilePath;
- (void)preventLogCapture;
- (void)preventShakeDetection;
- (void)showDefaultFeedbackScreen:(UIViewController *)viewController;
- (void)start:(NSString *)productAccessToken;
- (void)startLogCapture;


@end

