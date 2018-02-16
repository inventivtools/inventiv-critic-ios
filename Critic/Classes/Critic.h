#import <Foundation/Foundation.h>
#import "CriticReportData.h"

@interface Critic : NSObject

@property (nonatomic, strong) NSString *productAccessToken;

+ (instancetype)instanceCritic;

@end
