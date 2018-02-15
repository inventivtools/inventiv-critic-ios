#import <Foundation/Foundation.h>
#import "CriticReportData.h"

@interface Critic : NSObject

+ (instancetype)instanceCritic;
- (void)setProductAccessToken:(NSString *)productAccessToken;
- (void)createReport:(CriticReportData *)report completion:(void (^)(BOOL success, NSError *))completionBlock;

@end
