#ifndef CriticReportData_h
#define CriticReportData_h

#endif /* CriticReportData_h */

#import <Foundation/Foundation.h>

@interface CriticReportData : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *attachmentFileName;
@property (nonatomic, strong) NSString *attachmentFilePath;
@property (nonatomic, strong) NSString *metadata;

- (id)initWithDescription:(NSString *)description;
- (id)initWithDescriptionAndFile:(NSString *)description attachmentFileName:(NSString *)fileName attachmentFilePath:(NSString *)filePath;
- (id)initWithAll:(NSString *)description attachmentFileName:(NSString *)fileName attachmentFilePath:(NSString *)filePath customJSONData:(NSString *)data;

- (void)addCustomJSONData:(NSString*)data;
- (NSString *)getJSONRepresentation;

@end
