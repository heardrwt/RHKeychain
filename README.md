## RHKeychain
Simple wrapper functions to the OS X keychain to create, edit and delete generic password items.

## Interface
<pre>
//add and remove
extern BOOL RHKeychainAddGenericEntry(SecKeychainRef keychain, NSString *serviceName);
extern BOOL RHKeychainRemoveGenericEntry(SecKeychainRef keychain, NSString *serviceName);
extern BOOL RHKeychainDoesGenericEntryExist(SecKeychainRef keychain, NSString *serviceName);

//setting properties
extern NSString* RHKeychainGetGenericPassword(SecKeychainRef keychain, NSString *serviceName);
extern BOOL RHKeychainSetGenericPassword(SecKeychainRef keychain, NSString *serviceName, NSString *newPassword);

extern NSString* RHKeychainGetGenericUsername(SecKeychainRef keychain, NSString *serviceName);
extern BOOL RHKeychainSetGenericUsername(SecKeychainRef keychain, NSString *serviceName, NSString *newUsername);

extern NSString* RHKeychainGetGenericComment(SecKeychainRef keychain, NSString *serviceName);
extern BOOL RHKeychainSetGenericComment(SecKeychainRef keychain, NSString *serviceName, NSString *newComment);


//generic lookup/access methods
extern SecKeychainItemRef RHKeychainGetKeychainItemRefWithServiceName(SecKeychainRef keychain, NSString *serviceName);

extern NSData* RHKeychainGetItemAttributeTagForKeychainItemRef(SecKeychainItemRef itemRef, SecItemAttr attributeTag);
extern BOOL RHKeychainSetItemAttributeTagForKeychainItemRef(SecKeychainItemRef itemRef, SecItemAttr attributeTag, NSData *setData);

extern NSData* RHKeychainGetPasswordForKeychainItemRef(SecKeychainItemRef itemRef);
extern BOOL RHKeychainSetPasswordForKeychainItemRef(SecKeychainItemRef itemRef, NSData *setData);
</pre>

## Licence
Released under the Modified BSD License. 
(Attribution Required)
<pre>
RHKeychain

Copyright (c) 2012 Richard Heard. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
</pre>


### Version Support (Executive Summary: Tested on 10.7 Intel 64bit)
This Framework code runs and compiles on and has been tested on OS X 10.7

Unit tests are in place.
