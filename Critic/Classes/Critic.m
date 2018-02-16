#import <Foundation/Foundation.h>
#import "Critic.h"

@implementation Critic

+ (Critic *)instance{
    static Critic *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        // default to writing to a log file if there is no debugger attached.
        [_instance setShouldLogToFile:(!isatty(STDERR_FILENO) && !isatty(STDOUT_FILENO))];
    });
    return _instance;
}

- (void)start:(NSString *)productAccessToken{
    [self setProductAccessToken:productAccessToken];

    if([self shouldLogToFile]){
        NSString *logFilePath = [self getLogFilePath];
        id fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        dup2([fileHandle fileDescriptor], STDERR_FILENO);
        dup2([fileHandle fileDescriptor], STDOUT_FILENO);
    }
}

- (NSString *)getLogFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"log01.txt"];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

@end

