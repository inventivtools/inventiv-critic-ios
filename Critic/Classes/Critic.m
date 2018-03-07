#import <Foundation/Foundation.h>
#import "Critic.h"
#import "NVCFeedbackViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Critic

+ (Critic *)instance{
    static Critic *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
        // set defaults
        [_instance setDefaultFeedbackScreenDescriptionPlaceholder:@"What's happening?\n\nPlease describe your problem or suggestion in as much detail as possible. Thank you for helping us out! 🙂"];
        [_instance setDefaultFeedbackScreenTitle:@"Feedback"];
        [_instance setDefaultShakeNotificationMessage:@"Do you want to send us feedback?"];
        [_instance setDefaultShakeNotificationTitle:@"Easy, easy!"];
        [_instance setProductMetadata:[NSMutableDictionary new]];
        [_instance setShouldRespondToShake:true];
        
        // default to capturing console output to a log file if there is no debugger attached.
        [_instance setShouldLogToFile:(!isatty(STDERR_FILENO) && !isatty(STDOUT_FILENO))];
        
        // listen for shake events in UIWindow#motionEnded.
        __block IMP originalIMP = NVCReplaceMethodWithBlock([UIWindow class], @selector(motionEnded:withEvent:), ^(UIWindow *_self, UIEventSubtype motion, UIEvent *event) {
            if ([[Critic instance] shouldRespondToShake] && event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
                NSLog(@"Critic - Shake detected. Displaying notification dialog.");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[Critic instance] defaultShakeNotificationTitle] message:[[Critic instance] defaultShakeNotificationMessage] preferredStyle: UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    [[_self rootViewController] dismissViewControllerAnimated:false completion:nil];
                    [[Critic instance] showDefaultFeedbackScreen:[_self rootViewController]];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                    [[_self rootViewController] dismissViewControllerAnimated:false completion:nil];
                }]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[_self rootViewController] presentViewController:alert animated:true completion:nil];
                });
            }
            ((void ( *)(id, SEL, UIEventSubtype, UIEvent *))originalIMP)(_self, @selector(motionEnded:withEvent:), motion, event);
        });
    });
    
    return _instance;
}

- (void)start:(NSString *)productAccessToken{
    NSAssert(productAccessToken && [productAccessToken length] != 0, @"You need to provide a Product Access Token. See the Critic Getting Started Guide at https://inventiv.io/critic/critic-integration-getting-started/.");
    NSAssert(![productAccessToken isEqualToString:@"YOUR_PRODUCT_ACCESS_TOKEN"], @"Your Product Access Token is invalid. Please use a valid one. See the Critic Getting Started Guide at https://inventiv.io/critic/critic-integration-getting-started/.");
    
    [self setProductAccessToken:productAccessToken];
    if([self shouldLogToFile]){
        [self startLogCapture];
    }
}

- (NSString *)getLogFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"log01.txt"];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)preventLogCapture{
    [self setShouldLogToFile:false];
}

- (void)preventShakeDetection{
    [self setShouldRespondToShake:false];
}

- (void)showDefaultFeedbackScreen:(UIViewController *)viewController{
    NSBundle *podBundle = [NSBundle bundleForClass:Critic.self];
    NSURL *bundleURL = [podBundle URLForResource:@"Critic" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FeedbackScreen" bundle: bundle];
    UIViewController *feedbackViewController = [storyboard instantiateViewControllerWithIdentifier:@"FeedbackScreen"];
    [viewController presentViewController:feedbackViewController animated:true completion:nil];
}
- (void)startLogCapture{
    [self setShouldLogToFile:true];
    NSLog(@"Critic - Starting log file capture. If you wish to prevent this, call preventLogCapture() before start().");
    NSString *logFilePath = [self getLogFilePath];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
}

static IMP NVCReplaceMethodWithBlock(Class c, SEL origSEL, id block) {
    NSCParameterAssert(block);
    
    // get original method
    Method origMethod = class_getInstanceMethod(c, origSEL);
    NSCParameterAssert(origMethod);
    
    // convert block to IMP trampoline and replace method implementation
    IMP newIMP = imp_implementationWithBlock(block);
    
    // Try adding the method if not yet in the current class
    if (!class_addMethod(c, origSEL, newIMP, method_getTypeEncoding(origMethod))) {
        return method_setImplementation(origMethod, newIMP);
    }else {
        return method_getImplementation(origMethod);
    }
}

@end

