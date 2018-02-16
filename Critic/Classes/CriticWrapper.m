#import <Foundation/Foundation.h>
#import "CriticWrapper.h"
#import "Critic.h"

@implementation CriticWrapper

+ (Critic *)instance{
    return [Critic instance];
}

@end

