#import <Foundation/Foundation.h>

@interface NVCReportCreator : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *attachmentFileName;
@property (nonatomic, strong) NSString *attachmentFilePath;
@property (nonatomic, strong) NSString *metadata;

- (void)create:(void (^)(BOOL success, NSError *))completionBlock;

@end
