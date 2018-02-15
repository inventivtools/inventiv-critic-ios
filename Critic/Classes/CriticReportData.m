#import <Foundation/Foundation.h>
#import "CriticReportData.h"

@implementation CriticReportData

@synthesize description;
@synthesize attachmentFileName;
@synthesize attachmentFilePath;
@synthesize metadata;

- (id)initWithDescription:(NSString *)description{
    
    return [self initWithAll:description attachmentFileName:nil attachmentFilePath:nil customJSONData:nil];
}

- (id)initWithDescriptionAndFile:(NSString *)description attachmentFileName:(NSString *)fileName attachmentFilePath:(NSString *)filePath{
    
    return [self initWithAll:description attachmentFileName:fileName attachmentFilePath:filePath customJSONData:nil];
}

- (id)initWithAll:(NSString *)description attachmentFileName:(NSString *)fileName attachmentFilePath:(NSString *)filePath customJSONData:(NSString *)data{
    
    self = [super init];
    self.description = description;
    self.attachmentFileName = fileName;
    self.attachmentFilePath = filePath;
    self.metadata = data;
    
    return self;
}

- (void)addCustomJSONData:(NSString*)data{
    
    self.metadata = data;
}

- (NSString *)getJSONRepresentation{
    
    return self.metadata;
}
@end
