#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Critic.h"
#import "CriticReportData.h"

static __weak Critic *instance;
Critic *strongInstance;

@implementation Critic

+ (instancetype)instanceCritic{
    
    strongInstance = instance;
    @synchronized(self) {
        if (strongInstance == nil) {
            strongInstance = [[Critic alloc] init];
            instance = strongInstance;
        }
    }
    return strongInstance;
}

@end
