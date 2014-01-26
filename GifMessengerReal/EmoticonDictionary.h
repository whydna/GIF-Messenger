//
//  EmoticonDictionary.h
//  GifMessengerReal
//
//  Created by Andy Hin on 1/12/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmoticonDictionary : NSObject

+ (id)singletonInstance;

- (void)addEmoticonWithId:(NSString *)id andKeyword:(NSString *)keyword;
- (NSURL *)thumbnailUrlForKeyword:(NSString *)keyword;
- (NSURL *)mp4UrlForKeyword:(NSString *)keyword;
- (NSArray *)getAllKeywords;

@end
