//
//  BFFileStream.m
//  BFFileManagerDemo
//
//  Created by BFsAlex on 2018/9/26.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "BFFileStream.h"
#import "BFsFileAssistant.h"

@implementation BFFileStream

#pragma mark - API

+ (instancetype)fileStream {
    
    BFFileStream *fileStream = [[BFFileStream alloc] init];
    if (fileStream) {
        [fileStream configDefault];
    }
    
    return fileStream;
}

#pragma mark - Feature

- (void)configDefault {
    
//    [self testData];
    
    BFsFileAssistant *fa = [BFsFileAssistant defaultAssistant];
    NSString *dirtPath = [fa getDirectoryPathOfFolderInDocumentsDirectory:@"Test"];
    NSString *filePath = [fa getFilePath:@"DataTest.txt" fromDirectoryPath:dirtPath];
    [self createFileAtPath:filePath];
    NSLog(@"filePath: %@", filePath);
    NSFileHandle *readFH = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *readData = [readFH readDataToEndOfFile];
    NSLog(@"readData: %@", readData);
    NSFileHandle *writeFH = [NSFileHandle fileHandleForWritingAtPath:filePath];
    for (int i = 0; i < 2; i++) {
        NSData *writeData = [[NSString stringWithFormat:@"写文件数据:%d;", i] dataUsingEncoding:NSUTF8StringEncoding];
        [writeFH seekToEndOfFile];
        [writeFH writeData:writeData];
    }
    // 全数据
    readData = [readFH readDataToEndOfFile];
    NSLog(@"readData: %@", readData);
    // 流数据
//    NSUInteger rdLength = 10;
//    [readFH seekToFileOffset:0];
//    NSData *rd = [readFH readDataOfLength:rdLength];
//    NSLog(@"rd:%@", rd);
//    unsigned long long offSet = readFH.offsetInFile;
//    NSLog(@"stream data:%@, offset:%llu", [NSString stringWithCString:[rd bytes] encoding:NSUTF8StringEncoding], offSet);
    
    NSMutableData *readDatas = [NSMutableData data];
    unsigned long long offSetIndex = 0;
    NSUInteger rdLength = 8;
    [readFH seekToFileOffset:0];
    unsigned long long endOfFile = readFH.seekToEndOfFile;
    NSData *tmpData = [readFH readDataOfLength:rdLength];
    while (offSetIndex <= endOfFile) {
        [readDatas appendData:tmpData];
        offSetIndex += rdLength;
        NSLog(@"read file data(%llu): %@", offSetIndex, readDatas);
        [readFH seekToFileOffset:offSetIndex];
        tmpData = [readFH readDataOfLength:rdLength];
    }
    [readDatas appendData:tmpData];
    NSLog(@"finish: %@", readDatas);
    
    
    char *chars = [readDatas bytes];
    [self binaryStringFromByte:chars andLength:readDatas.length];
}

- (BOOL)createFileAtPath:(NSString *)filePath {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSData data] attributes:nil];
    }
    
    return YES;
}

- (void)testData {
    
    NSData *data = [[NSString stringWithFormat:@"test str???"] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"data: %@", data);
    NSLog(@"data.length: %ld", data.length);
    NSLog(@"data bytes: %s", [data bytes]);
    NSLog(@"data description: %@", [data description]);
    NSData *subData = [data subdataWithRange:NSMakeRange(0, 3)];
    NSLog(@"subData: %@", subData);
    NSString *subStr = [NSString stringWithUTF8String:[subData bytes]];
    NSLog(@"subStr: %@", subStr);
    const char *subData2 = [[data subdataWithRange:NSMakeRange(3, 3)] bytes];
    NSLog(@"subData2: %s", subData2);
    NSString *subStr2 = [NSString stringWithCString:subData2 encoding:NSUTF8StringEncoding];
    NSLog(@"subStr2: %@", subStr2);
}

- (NSString *)binaryStringFromByte:(char *)chars andLength:(NSUInteger)length {
    NSLog(@"binaryStringFromByte -> chars: %s", chars);
    
    NSString *bs;
    for (int i = 0; i < length; i++) {
        char c = chars[i];
        NSLog(@"char: %c", c);
    }
    
    return bs;
}

@end
