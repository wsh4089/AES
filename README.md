# AES
在做热修复的时候，使用`openssl`对文件进行`AES`加密，然后使用OC进行解密，中间遇到了些坑，分享出来。

##Installation
只需拷贝`Core/AES.{h.m}`即可
##Usage
使用方式如下:

```objective-c
NSString *test = [AES encryptAES:@"I'm AES" key:@"447C54BE3ACDFAF2E131B7657180D5AA" initialVector:nil keySize:kWMKeySizeAES128];
NSString *deTest = [AES decryptAES:test key:@"447C54BE3ACDFAF2E131B7657180D5AA" initialVector:nil keySize:kWMKeySizeAES128];
NSLog(@"%s:%@",__func__,deTest);
```

##注意点

以下：

- OC中使用CCCrypt()方法进行加密，该方法只支持`AES`模式中的`ECB`和`CBC`，因`ECB`安全性不高，故使用`CBC模式`。
- OC中使用CCCrypt()进行解密的时候，key，iv的转换都需要注意，openssl使用的是十六进制的数，而OC进行封装的时候，容易传入的是字符串，`AES.{h.m}`中已经进行了类似于`"EBC"`=>`0xEBC`这样的格式转换，开发者需注意该点。

##Openssl
使用Openssl进行文件加密命令如下：

```ruby
//生成key和iv
$openssl enc -aes-128-cbc -k secret -P -md sha1
salt=08688003DD77B43B
key=4CE729B454CBE5DB751140EE2A3C3C44
iv =1EB526F904BE7EBDAF046ED75B2FFDC7
//进行加密
$openssl enc -aes-128-cbc -in test.file -out test.enc -K 4CE729B454CBE5DB751140EE2A3C3C44 -iv 1EB526F904BE7EBDAF046ED75B2FFDC7
//进行解密验证，-d 代表 解密
$openssl aes-128-cbc -d  -K 4CE729B454CBE5DB751140EE2A3C3C44 -iv 1EB526F904BE7EBDAF046ED75B2FFDC7 -in test.enc -out test.de
```

<!--
//mark:
1.openssl enc -aes-128-cbc -k secret -P -md sha1
2.openssl enc -aes-128-cbc -in test -out test.enc -K 2C6CFE5129312EF6B4FC599A929528B8 -iv 444082C9CD71BF42A44D00539F9B6D50
3.openssl aes-128-cbc -d  -K 591136F2024CD24D22F5F5BD311EB563 -iv D3887387B83F9BA57242A371E18F8B94 -in /Users/WuShiHai/Desktop/HotFix/patch/resources_6hfjahdsfoih/test.js.aes -out 666ss.js

openssl enc -aes-128-cbc -in test -out test.enc -K 447C54BE3ACDFAF2E131B7657180D5AA -iv B09208ECAA148A5B5A78090946DB2518

openssl enc -aes-128-cbc -in test -K 2C6CFE5129312EF6B4FC599A929528B8 -iv 444082C9CD71BF42A44D00539F9B6D50

echo wushihai | openssl enc -aes-128-cbc -p -K 2C6CFE5129312EF6B4FC599A929528B8 -iv 444082C9CD71BF42A44D00539F9B6D50 | base64

echo wushihai | openssl enc -aes-128-cbc -a -nosalt -pass pass:1 
echo -n wushihai | openssl enc -aes-128-cbc -a -K C81E728D9D4C2F636F067F89CC14862C -iv 65990ABE58735B91B6B8798E8CE45F22 | base64


echo -n wushihai | openssl enc -aes-128-cbc -a -K 447C54BE3ACDFAF2E131B7657180D5AA -iv B09208ECAA148A5B5A78090946DB2518

echo -n wushihai | openssl enc -aes-128-cbc -a -pass pass:1 -p
echo "U2FsdGVkX1+21O5RB08bavFTq7Yq/gChmXrO3f00tvJaT55A5pPvqw0zFVnHSW1o" | openssl enc -d -aes-256-cbc -a -k password
//666
echo -n "TEST1" | openssl enc -aes256 -k FUUU -nosalt -a -p

echo -n "6363898b2e1ad77121b8b95682b4d14c&iv=444082C9CD71BF42A44D00539F9B6D50&key=2C6CFE5129312EF6B4FC599A929528B8&size=128” | openssl rsautl -encrypt -inkey  /Users/WuShiHai/Desktop/HotFix/rsa_private_key.pem  -sign | base64
-->

##Test
先用`openssl`对字符串进行`AES`加密:

```ruby
$openssl enc -aes-128-cbc -k secret -P -md sha1
salt=08688003DD77B43B
key=4CE729B454CBE5DB751140EE2A3C3C44
iv =1EB526F904BE7EBDAF046ED75B2FFDC7
$echo "I'm Test" | openssl enc -aes-128-cbc -p -a -K 4CE729B454CBE5DB751140EE2A3C3C44 -iv 1EB526F904BE7EBDAF046ED75B2FFDC7
salt=78035160E07F0000
key=4CE729B454CBE5DB751140EE2A3C3C44
iv =1EB526F904BE7EBDAF046ED75B2FFDC7
HoP38q0t30OXkI1dEesILQ==
```
然后在`OC`中进行解密

```objective-c
NSString *deTest = [AES decryptAES:@"HoP38q0t30OXkI1dEesILQ==" key:@"4CE729B454CBE5DB751140EE2A3C3C44" initialVector:@"1EB526F904BE7EBDAF046ED75B2FFDC7" keySize:kWMKeySizeAES128];
NSLog(@"%s:%@",__func__,deTest);
```
运行工程发现输出如下:

`AESExample:I'm AES`

代码详见工程。

## Author

WuShiHai, 408939786@qq.com

## License

WMHotfix is available under the MIT license. See the LICENSE file for more info.

