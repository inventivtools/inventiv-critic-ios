#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Critic.h"
#import "CriticReportData.h"

static NSString* _accessToken = nil;

@implementation Critic

+ (instancetype)sharedCritic{
    static Critic *sSharedCritic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedCritic = [[self alloc] init];
    });
    return sSharedCritic;
}

- (void)setProductAccessToken:(NSString *)productAccessToken{
    
    _accessToken = productAccessToken;
}

- (void)createReport:(CriticReportData *)report completion:(void (^)(BOOL success, NSError *))completionBlock{
    
    if(_accessToken){
        
        NSURL *url = [NSURL URLWithString:@"https://critic.inventiv.io/api/v1/reports"];

        // generate request
        NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
        
        // configure the request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"POST"];
        
        // set content type
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // create body
        NSDictionary *params = [self generateParams:report];
        NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params path:report.attachmentFilePath fieldName:@"report[attachment]"];

        // send the request
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
                    NSLog(@"Critic - server returned code: %lo and result = %@", code, result);
                    completionBlock(NO, error);
                }
            }
        }];
        
        [task resume];
    }
    else{
        
        NSLog(@"Critic - There is no access token set! Please call setProductAccessToken before creating a report.");
        
        NSDictionary *errorDictionary = @{
                                          NSLocalizedDescriptionKey : @"There is no access token set! Please call setProductAccessToken before creating a report.",
                                          NSUnderlyingErrorKey : @"no access token",
                                          NSFilePathErrorKey : @""
                                          };
        NSError* error = [[NSError alloc] initWithDomain:@"Critic"
                                                    code:1 userInfo:errorDictionary];
        completionBlock(YES, error);
    }
}

- (NSDictionary *)generateParams:(CriticReportData *)report{
    
    NSDictionary *params = @{
                             @"report[attachment_file_name]" : report.attachmentFileName ? report.attachmentFileName : @"",
                             @"report[description]" : report.description ? report.description : @"",
                             @"report[metadata]" : report.metadata ? report.metadata : @"{}",
                             @"report[product_access_token]" : _accessToken
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
