#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NVCReportCreator.h"
#import "Critic.h"

@implementation NVCReportCreator

@synthesize description;
@synthesize attachmentFileName;
@synthesize attachmentFilePath;
@synthesize metadata;

- (void)create:(void (^)(BOOL success, NSError *))completionBlock{

    NSURL *url = [NSURL URLWithString:@"https://critic.inventiv.io/api/v1/reports"];
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    if(!metadata){
        metadata = [NSMutableDictionary new];
    }
    [self addStandardMetadata];
    
    NSDictionary *params = [self generateParams];
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params path:attachmentFilePath fieldName:@"report[attachment]"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            NSLog(@"Critic - failed to upload report. Error = %@", error);
            completionBlock(NO, error);
        }
        else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            long code = (long)[httpResponse statusCode];
            if(code == 201){
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Critic - report has been uploaded successfully. Result = %@", result);
                completionBlock(YES, error);
            }
            else{
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Critic - server returned code: %ld and result = %@", code, result);
                completionBlock(NO, error);
            }
        }
    }];
    [task resume];
}

- (void)addStandardMetadata{
    
    NSMutableDictionary* device = [NSMutableDictionary new];
    [device setObject:@"iOS" forKey:@"platform"];
    [metadata setObject:device forKey:@"ic_device"];
}

- (NSDictionary *)generateParams{
    NSLog(@"TOKEN: %@", [Critic instance].productAccessToken);
    
    NSError* error;
    NSData* metadataJsonData = [NSJSONSerialization dataWithJSONObject:metadata options:(NSJSONWritingOptions) 0 error:&error];
    NSString* metadataJsonString = [[NSString alloc] initWithData:metadataJsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{
        @"report[product_access_token]" : [[Critic instance] productAccessToken],
        @"report[description]" : description != nil ? description : @"",
        @"report[metadata]" : metadataJsonString != nil ? metadataJsonString : @"{}",
        @"report[attachment_file_name]" : attachmentFileName != nil ? attachmentFileName : @"",
    };
    return params;
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
parameters:(NSDictionary *)parameters
path:(NSString *)path
fieldName:(NSString *)fieldName {
    NSMutableData *httpBody = [NSMutableData data];
    
    // add parameters
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add file if it exists
    if(path) {
        NSString *filename = [path lastPathComponent];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSString *mimetype = [self mimeTypeForPath:path];
        
        NSLog(@"Critic - sending %@ with mimetype of %@", filename, mimetype);
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

- (NSString *)mimeTypeForPath:(NSString *)path {
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    
    CFRelease(UTI);
    
    return mimetype;
}
@end
