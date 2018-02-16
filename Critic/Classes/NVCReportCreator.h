#import <Foundation/Foundation.h>

@interface NVCReportCreator : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSMutableArray *attachmentFilePaths;
@property (nonatomic, strong) NSMutableDictionary *metadata;

- (void)create:(void (^)(BOOL success, NSError *))completionBlock;

@end
