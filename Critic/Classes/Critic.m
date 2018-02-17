#import <Foundation/Foundation.h>
#import "Critic.h"
#import "NVCFeedbackViewController.h"

@implementation Critic

+ (Critic *)instance{
    static Critic *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        // default to writing to a log file if there is no debugger attached.
        [_instance setShouldLogToFile:(!isatty(STDERR_FILENO) && !isatty(STDOUT_FILENO))];
    });
    return _instance;
}

- (void)start:(NSString *)productAccessToken{
    [self setProductAccessToken:productAccessToken];

    if([self shouldLogToFile]){
        NSString *logFilePath = [self getLogFilePath];
        freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
        freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    }
}

- (NSString *)getLogFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"log01.txt"];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)showDefaultFeedbackScreen:(UIViewController *)viewController{
    NSBundle *podBundle = [NSBundle bundleForClass:Critic.self];
    NSURL *bundleURL = [podBundle URLForResource:@"Critic" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FeedbackScreen" bundle: bundle];
    UIViewController *feedbackViewController = [storyboard instantiateViewControllerWithIdentifier:@"FeedbackScreen"];
    [viewController presentViewController:feedbackViewController animated:true completion:nil];
}

@end

