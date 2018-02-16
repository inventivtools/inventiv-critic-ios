#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Critic.h"
#import "CriticReportData.h"

static Critic *_instance = nil;

@implementation Critic

+ (instancetype)instanceCritic{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
