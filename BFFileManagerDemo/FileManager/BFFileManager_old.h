//
//  BFFileManager.h
//  BFFileManagerDemo
//
//  Created by BFsAlex on 2018/9/12.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFFileManager_old : NSObject

+ (instancetype)defaultManager;

#pragma mark - 路径
// 目录路径
/*
 默认在Documents目录上的一个目录
 **/
- (NSString *)getDirectoryPathOfFolderInDocumentsDirectory:(NSString *)folderName;
/*
 默认在Documents目录上n个级别目录
 **/
- (NSString *)getDirectoryPathFromDirectories:(NSArray *)directoryList;
- (NSString *)getDirectoryPathFromDirectories:(NSArray *)directoryList isBaseOnDocuments:(BOOL)isInDocumentsFolder;
// 文件路径
- (NSString *)getFilePath:(NSString *)fileName fromDirectoryPath:(NSString *)dirtPath;

#pragma mark - 查
- (NSArray *)getFilesFromDirectoryPath:(NSString *)directoryPath;
- (BOOL)fileExists:(NSString *)fileName inDirectoryPath:(NSString *)directoryPath;

#pragma mark - 增
- (BOOL)saveFile:(NSData *)fData toPath:(NSString *)filePath;
- (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

#pragma mark - 相簿

@end
