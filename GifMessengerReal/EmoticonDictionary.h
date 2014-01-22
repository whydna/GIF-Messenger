//
//  EmoticonDictionary.h
//  GifMessengerReal
//
//  Created by Andy Hin on 1/12/2014.
//  Copyright (c) 2014 Andy Hin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmoticonDictionary : NSObject

+ (id) singletonInstance;

- (void)addEmoticonWithUrl:(NSURL *)url andKeyword:(NSString *)keyword;
- (NSURL *)urlForKeyword:(NSString *)keyword;
- (NSArray *)getAllKeywords;

@end
