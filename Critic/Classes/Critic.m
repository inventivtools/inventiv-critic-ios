#import <Foundation/Foundation.h>
#import "Critic.h"
#import "CriticReportData.h"

@implementation Critic

+ (Critic *)instance{
    static Critic *_fella = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fella = [[self alloc] init];
    });
    return _fella;
}

@end
