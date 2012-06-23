//
//  RHKeychain.m
//  RHKeychain
//
//  Created by Richard Heard on 26/04/12.
//  Copyright (c) 2012 Richard Heard. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "RHKeychain.h"

#pragma mark - add and remove
BOOL RHKeychainAddGenericEntry(SecKeychainRef keychain, NSString *serviceName){
    OSStatus status = SecKeychainAddGenericPassword(keychain,
                                                    (UInt32)strlen([serviceName UTF8String]),
                                                    [serviceName UTF8String],
                                                    0,                        
                                                    NULL,
                                                    0,
                                                    NULL,
                                                    NULL /* dont care about the returned keychain item*/
                                                    );
    if (status != noErr) {
        CFStringRef errorMessageRef = SecCopyErrorMessageString(status, NULL);
        NSLog(@"Error: %s failed with error code: %ld msg: %@", __func__, (long)status, errorMessageRef);
        if (errorMessageRef) CFRelease(errorMessageRef);
        return NO;
    }
    return YES;
    
}

BOOL RHKeychainRemoveGenericEntry(SecKeychainRef keychain, NSString *serviceName){
    SecKeychainItemRef itemRef = RHKeychainGetKeychainItemRefWithServiceName(keychain, serviceName);
    if (!itemRef) return YES;
    
    OSStatus status = SecKeychainItemDelete(itemRef);
    
    if (status != noErr){
        CFStringRef errorMessageRef = SecCopyErrorMessageString(status, NULL);
        NSLog(@"Error: %s failed with error code: %ld msg: %@", __func__, (long)status, errorMessageRef);
        if (errorMessageRef) CFRelease(errorMessageRef);
        return NO;
    }
    
    return  YES;
}


extern BOOL RHKeychainRenameGenericEntry(SecKeychainRef keychain, NSString *serviceName, NSString *newServiceName){
    //look up the item
    SecKeychainItemRef itemRef = RHKeychainGetKeychainItemRefWithServiceName(keychain, serviceName);
    if (!itemRef) return NO;
    
    //return
    return RHKeychainSetItemAttributeTagForKeychainItemRef(itemRef, kSecServiceItemAttr, [newServiceName dataUsingEncoding:NSUTF8StringEncoding]) &&
    RHKeychainSetItemAttributeTagForKeychainItemRef(itemRef, kSecLabelItemAttr, [newServiceName dataUsingEncoding:NSUTF8StringEncoding]);

}

BOOL RHKeychainDoesGenericEntryExist(SecKeychainRef keychain, NSString *serviceName){
    SecKeychainItemRef itemRef = NULL;
    OSStatus status = SecKeychainFindGenericPassword(keychain,
                                                     (UInt32)strlen([serviceName UTF8String]),
                                                     [serviceName UTF8String],
                                                     0,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     &itemRef);
    if (status == errSecItemNotFound) return NO;
    
    if (status != noErr ) {
        CFStringRef errorMessageRef = SecCopyErrorMessageString(status, NULL);
        NSLog(@"Error: %s failed with error code: %ld msg: %@", __func__, (long)status, errorMessageRef);
        if (errorMessageRef) CFRelease(errorMessageRef);
        return NO;
    }
    
    return YES;
}



#pragma mark - setting properties
NSString* RHKeychainGetGenericPassword(SecKeychainRef keychain, NSString *serviceName){
    //look up the item
    SecKeychainItemRef itemRef = RHKeychainGetKeychainItemRefWithServiceName(keychain, serviceName);
    if (!itemRef) return nil;
    
    // get the attribute data
    NSData *passwordData = RHKeychainGetPasswordForKeychainItemRef(itemRef);
    if (!passwordData) return nil;
    
    //return
    return [[[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding] autorelease];
}

BOOL RHKeychainSetGenericPassword(SecKeychainRef keychain, NSString *serviceName, NSString *newPassword){
    //look up the item
    SecKeychainItemRef itemRef = RHKeychainGetKeychainItemRefWithServiceName(keychain, serviceName);
    if (!itemRef) return NO;
    
    //return
    return RHKeychainSetPasswordForKeychainItemRef(itemRef, [newPassword dataUsingEncoding:NSUTF8StringEncoding]);
}


NSString* RHKeychainGetGenericUsername(SecKeychainRef keychain, NSString *serviceName){
    //look up the item
    SecKeychainItemRef itemRef = RHKeychainGetKeychainItemRefWithServiceName(keychain, serviceName);
    if (!itemRef) return nil;
    
    // get the attribute data
    NSData *usernameData = RHKeychainGetItemAttributeTagForKeychainItemRef(itemRef, kSecAccountItemAttr);
    if (!usernameData) return nil;
    
    //return
    return [[[NSString alloc] initWithData:usernameData encoding:NSUTF8StringEncoding] autorelease];
}

BOOL RHKeychainSetGenericUsername(SecKeychainRef keychain, NSString *serviceName, NSString *newUsername){
    //look up the item
    SecKeychainItemRef itemRef = RHKeychainGetKeychainItemRefWithServiceName(keychain, serviceName);
    if (!itemRef) return NO;
    
    //return
    return RHKeychainSetItemAttributeTagForKeychainItemRef(itemRef, kSecAccountItemAttr, [newUsername dataUsingEncoding:NSUTF8StringEncoding]);
    
}

extern NSString* RHKeychainGetGenericComment(SecKeychainRef keychain, NSString *serviceName){
    //look up the item
    SecKeychainItemRef itemRef = RHKeychainGetKeychainItemRefWithServiceName(keychain, serviceName);
    if (!itemRef) return nil;
    
    // get the attribute data
    NSData *commentData = RHKeychainGetItemAttributeTagForKeychainItemRef(itemRef, kSecCommentItemAttr);
    if (!commentData) return nil;
    
    //return
    return [[[NSString alloc] initWithData:commentData encoding:NSUTF8StringEncoding] autorelease];

}

extern BOOL RHKeychainSetGenericComment(SecKeychainRef keychain, NSString *serviceName, NSString *newComment){
    //look up the item
    SecKeychainItemRef itemRef = RHKeychainGetKeychainItemRefWithServiceName(keychain, serviceName);
    if (!itemRef) return NO;
    
    //return
    return RHKeychainSetItemAttributeTagForKeychainItemRef(itemRef, kSecCommentItemAttr, [newComment dataUsingEncoding:NSUTF8StringEncoding]);

}



#pragma mark - generic lookup/access methods
SecKeychainItemRef RHKeychainGetKeychainItemRefWithServiceName(SecKeychainRef keychain, NSString *serviceName){
    SecKeychainItemRef itemRef = NULL;
    OSStatus status = SecKeychainFindGenericPassword(keychain,
                                                     (UInt32)strlen([serviceName UTF8String]),
                                                     [serviceName UTF8String],
                                                     0,
                                                     NULL,
                                                     NULL,
                                                     NULL,
                                                     &itemRef);
    if (status != noErr || !itemRef) {
        CFStringRef errorMessageRef = SecCopyErrorMessageString(status, NULL);
        NSLog(@"Error: %s failed with error code: %ld msg: %@", __func__, (long)status, errorMessageRef);
        if (errorMessageRef) CFRelease(errorMessageRef);
        return NULL;
    }
    
    return itemRef;
}


NSData* RHKeychainGetItemAttributeTagForKeychainItemRef(SecKeychainItemRef itemRef, SecItemAttr attributeTag){
    if (!itemRef) return nil;
    
    NSData *result = nil;

    //specify what we want to fetch
    SecKeychainAttributeInfo attributeInfo;
    attributeInfo.count = 1;
    attributeInfo.tag = &attributeTag;
    attributeInfo.format = CSSM_DB_ATTRIBUTE_FORMAT_STRING;
    
    //variable for outputing the result
    SecKeychainAttributeList *listOut = NULL;
    
    //perform the query
    OSStatus status = SecKeychainItemCopyAttributesAndData(itemRef, &attributeInfo, NULL, &listOut, NULL, NULL);
    
    //if error
    if (status != noErr) {
        CFStringRef errorMessageRef = SecCopyErrorMessageString(status, NULL);
        NSLog(@"Error: %s failed with error code: %ld msg: %@", __func__, (long)status, errorMessageRef);
        if (errorMessageRef) CFRelease(errorMessageRef);
        return nil;
    }    
    
    //copy the attrubutes data into an NSData object
    if (listOut->count > 0 && listOut->attr->length > 0){
        result = [NSData dataWithBytes:listOut->attr->data length:listOut->attr->length];
    }
    
    //free the list structure
    SecKeychainItemFreeContent (listOut, NULL);
    
    return result; //done
}

BOOL RHKeychainSetItemAttributeTagForKeychainItemRef(SecKeychainItemRef itemRef, SecItemAttr attributeTag, NSData *setData){
    if (!itemRef) return NO;
    
    void *dataBytes = NULL;
    if (setData){ //allow NULL to unset an item value?
        dataBytes = malloc([setData length]);
        [setData getBytes:dataBytes length:[setData length]];
    }
    
    //define our attributes
    SecKeychainAttribute attributes[4];
    attributes[0].tag = attributeTag; //use the passed in tag
    attributes[0].data = dataBytes; 
    attributes[0].length = (UInt32)[setData length];
    
    //wrap in a list structure
    SecKeychainAttributeList list;
    list.count = 1;
    list.attr = attributes;
    
    //perform the query
    OSStatus status = SecKeychainItemModifyAttributesAndData(itemRef, &list, 0, NULL);
    
    //if error
    if (status != noErr) {
        CFStringRef errorMessageRef = SecCopyErrorMessageString(status, NULL);
        NSLog(@"Error: %s failed with error code: %ld msg: %@", __func__, (long)status, errorMessageRef);
        if (errorMessageRef) CFRelease(errorMessageRef);
        return NO;
    }    
    
    //free the attribute data
    if (dataBytes) free(dataBytes);

    return YES; //done
}


NSData* RHKeychainGetPasswordForKeychainItemRef(SecKeychainItemRef itemRef){
    if (!itemRef) return nil;
    
    NSData *result = nil;
    
    UInt32 lengthOut = 0;
    void *dataOut = NULL;
    
    //perform the query
    OSStatus status = SecKeychainItemCopyAttributesAndData(itemRef, NULL, NULL, NULL, &lengthOut, &dataOut);
    
    //if error
    if (status != noErr) {
        CFStringRef errorMessageRef = SecCopyErrorMessageString(status, NULL);
        NSLog(@"Error: %s failed with error code: %ld msg: %@", __func__, (long)status, errorMessageRef);
        if (errorMessageRef) CFRelease(errorMessageRef);
        return nil;
    }    
    
    //copy the attrubutes data into an NSData object
    if (lengthOut > 0){
        result = [NSData dataWithBytes:dataOut length:lengthOut];
    }
    //free the list structure
    SecKeychainItemFreeAttributesAndData(NULL, dataOut);
    
    return result; //done
    
}

BOOL RHKeychainSetPasswordForKeychainItemRef(SecKeychainItemRef itemRef, NSData *setData){
    if (!itemRef) return NO;
    
    void *dataBytes = NULL;
    dataBytes = malloc([setData length]);
    [setData getBytes:dataBytes length:[setData length]];
    
    
    //perform the query    
    OSStatus status = SecKeychainItemModifyAttributesAndData(itemRef, NULL, (UInt32)[setData length], dataBytes);
    
    //free the password data
    if (dataBytes) free(dataBytes);
    
    //if error
    if (status != noErr) {
        CFStringRef errorMessageRef = SecCopyErrorMessageString(status, NULL);
        NSLog(@"Error: %s failed with error code: %ld msg: %@", __func__, (long)status, errorMessageRef);
        if (errorMessageRef) CFRelease(errorMessageRef);
        return NO;
    }    
    
    return YES; //done
}

