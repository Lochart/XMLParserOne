//
//  VideoData.h
//  XML Parser
//
//  Created by Nikolay on 06.03.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoData : NSObject

@property (nonatomic, strong) NSString *videoTitle;
@property (nonatomic, strong) NSNumber *videoLingth;
@property (nonatomic, strong) NSString *videoURL;
@property (nonatomic, strong) NSMutableArray *thumbnailURL;

@end
