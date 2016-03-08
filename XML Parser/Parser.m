//
//  Parser.m
//  XML Parser
//
//  Created by Nikolay on 06.03.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

#import "Parser.h"
#import "VideoData.h"

#define kRSSUrl @"https://gdata.youtube.com/feeds/api/users/Learn2Xcode/uploads"

@interface Parser () <NSXMLParserDelegate>
{
    BOOL isEntry;
    BOOL isTitle;
}

@property (nonatomic, strong) NSMutableArray *thumbnailArray;
@property (nonatomic, strong) NSMutableString *mutableVideoTitle;
@property (nonatomic, strong) VideoData *videoData;

@end

@implementation Parser

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)parserStart{
    NSURL *url = [NSURL URLWithString:kRSSUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    [xmlParser setDelegate:self];
    
    [xmlParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

    if ([elementName isEqualToString:@"entry"]) {
        isEntry = YES;
        
        if (!self.videoArray) {
            self.videoArray = [[NSMutableArray alloc]init];
        }
        
        if (!self.videoData) {
            self.videoData = [[VideoData alloc]init];
        }
        
        if (!self.thumbnailArray) {
            self.thumbnailArray = [[NSMutableArray alloc]init];
        }
        return;
    }
    
    if ([elementName isEqualToString:@"mediaTitle"] && isEntry) {
        isTitle = YES;
        return;
    }
    
    if ([elementName isEqualToString:@"link"] && isEntry) {
        if ([[attributeDict objectForKey:@"rel"] isEqualToString:@"alternate"]){
            self.videoData.videoURL = [attributeDict objectForKey:@"href"];
        }
        return;
    }
    
    if ([elementName isEqualToString:@"yt:duration"] && isEntry) {
        self.videoData.videoLingth = [attributeDict objectForKey:@"seconds"];
        return;
    }
    
    if ([elementName isEqualToString:@"media: thumbnail"] && isEntry) {
        [self.thumbnailArray addObject:[attributeDict objectForKey:@"url"]];
        return;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (isTitle) {
        if (!self.mutableVideoTitle) {
            self.mutableVideoTitle = [[NSMutableString alloc] init];
        }
        [self.mutableVideoTitle appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"media:title"] && isEntry) {
        isTitle = NO;
        self.videoData.videoTitle = self.mutableVideoTitle;
        self.mutableVideoTitle = nil;
        return;
    }
    
    if ([elementName isEqualToString:@"entry"]) {
        isEntry = NO;
        
        self.videoData.thumbnailURL = self.thumbnailArray;
        [self.videoArray addObject:self.videoData];
        
        self.videoData = nil;
        self.thumbnailArray = nil;
        return;
    }
    
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"Fehler beim Parsen: %@", parseError.localizedDescription);
}

@end
