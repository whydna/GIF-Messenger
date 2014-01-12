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

- (void)addEmoticonWithUrl:(NSURL *)url andKeyword:(NSString *)keyword
{
    [_dict setObject:url forKey:keyword];
}

- (NSURL *)urlForKeyword:(NSString *)keyword
{
    return [_dict objectForKey:keyword];
}

- (NSArray *)getAllKeywords
{
    return [_dict allKeys];
}
@end
