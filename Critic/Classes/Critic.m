#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Critic.h"
#import "CriticReportData.h"


@implementation Critic

+ (instancetype)instanceCritic{
    static Critic *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
