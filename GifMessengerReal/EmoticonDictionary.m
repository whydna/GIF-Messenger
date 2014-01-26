//
//  EmoticonDictionary.m
//  GifMessengerReal
//
//  Created by Andy Hin on 1/12/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import "EmoticonDictionary.h"

@implementation EmoticonDictionary
{
    NSMutableDictionary *_dict;
}

+ (id)singletonInstance
{
    static EmoticonDictionary *singletonInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        singletonInstance = [[self alloc] init];
    });
    
    return singletonInstance;
}

- (id)init
{
    if (self = [super init]) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)addEmoticonWithId:(NSString *)id andKeyword:(NSString *)keyword
{
    [_dict setObject:id forKey:keyword];
}

- (NSString *)emoticonIdForKeyword:(NSString *)keyword
{
    return [_dict objectForKey:keyword];
}

- (NSURL *)thumbnailUrlForKeyword:(NSString *)keyword
{
    NSString *emoticonId = [self emoticonIdForKeyword:keyword];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gifsicle.com/sandbox/emoticons/%@.gif", emoticonId]];
    return url;
}

- (NSURL *)mp4UrlForKeyword:(NSString *)keyword
{
    NSString *emoticonId = [self emoticonIdForKeyword:keyword];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.gifsicle.com/sandbox/emoticons_mp4/%@.mp4", emoticonId]];
    return url;
}

- (NSArray *)getAllKeywords
{
    return [_dict allKeys];
}
@end
