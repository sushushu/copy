#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "sqlite3.h"
#import "fts3_tokenizer.h"
#import "sqlite3_wcdb.h"

FOUNDATION_EXPORT double sqlcipherVersionNumber;
FOUNDATION_EXPORT const unsigned char sqlcipherVersionString[];

