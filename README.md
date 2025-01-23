# ios-lib-nfc: IOS NFC - Mit Library
- 基本情報はREADME

# NDEF - NFC Data Exchange Format Requirements
[NDEF](https://developer.apple.com/documentation/corenfc/nfcndefmessage) - A reader session for detecting NFC Data Exchange Format (NDEF) tags.

To enable NDEF functionality in your app, there are certain requirements that must be met
1. Signing & Capabilities -> Near Field Communication Tag Reading - NFC Near Field Communication Tag Reader Session Formats Entitlement 
2. Info.plist - Privacy - NFC Scan Usage Description

# NFCTagReader Requirements
[NFCTagReaderSession](https://developer.apple.com/documentation/corenfc/nfctagreadersession) - A reader session for detecting ISO7816, ISO15693, FeliCa, and MIFARE tags.


To enable NFCTagReader functionality in your app, You need the following
1. Signing & Capabilities -> Near Field Communication Tag Reading - NFC Near Field Communication Tag Reader Session Formats Entitlement 
2. Info.plist - Privacy - NFC Scan Usage Description

There is other requirement that would differe depending on the ISO specification of NFCTagReader

FOR NFC-F(FELICA) or ISO18092

3. Info.plist - ISO type(ex. ISO18092 system codes for NFC Tag Reader Session)
4. Item 0: [iDm and System Codes](https://github.com/treastrain/TRETJapanNFCReader)

カード種別  

    0003: 交通系ICカード (Suica, ICOCA, Kitaca, PASMO, TOICA, manaca, PiTaPa, SUGOCA, nimoca, はやかけん, icsca, ...etc.)
        残高の読み取りと表示
        利用履歴、改札入出場履歴、SF入場情報の読み取り
    80DE: IruCa
        残高の読み取りと表示
        利用履歴、改札入出場履歴、SF入場情報の読み取り
    8592: PASPY
        残高の読み取りと表示
        利用履歴、改札入出場履歴、SF入場情報の読み取り
    865E: SAPICA
        残高の読み取りと表示
        利用履歴、改札入出場履歴、SF入場情報の読み取り
    8FC1: OKICA
        残高の読み取りと表示
        利用履歴、改札入出場履歴、SF入場情報の読み取り
    8B5D: りゅーと
        残高の読み取りと表示
        利用履歴の読み取り
    FE00: 楽天Edy
        残高の読み取りと表示
        利用履歴の読み取り
    FE00: nanaco
        残高の読み取りと表示
        利用履歴の読み取り
    FE00: WAON
        残高の読み取りと表示
        利用履歴の読み取り
    FE00: 大学生協プリペイドカード（大学 学生証）
        残高の読み取りと表示
        利用履歴の読み取り
    8008: 八達通
        残高の読み取りと表示

FOR NFC-B (Type-B) driver license, my number card

while Type-B doesnt have a iDM like sony, they have AID which is used for items

3. Info.plist - ISO7816 application identifiers for NFC Tag Reader Session
4. Item 0: [AID](https://www.osstech.co.jp/download/libjeid/ios/)

カード種別  

    運転免許証 (driver license)
        使用するAID
        A00000023101, 
        A00000023102
    マイナンバーカード (My number card)
        使用するAID   
        D392F000260100000001, 
        D3921000310001010401, 
        D3921000310001010402, 
        D3921000310001010408
    在留カード (Residence card)
        使用するAID  
        D392F0004F0200000000000000000000, 
        D392F0004F0300000000000000000000, 
        D392F0004F0400000000000000000000

# NFCVASReader
// TODO: NEED MORE RESEARCH
NFCVASReaderSession - A reader session for processing Value Added Service (VAS) tags.


TODO: documentation here


# LIBRARY - HOW TO USE
NDEF
 1. To implement the app first is to apply the requirements mention above
 2. Call the Property MitNDEFReader, MitNDEFWrite
 3. Initiate the viewcontroller
 4. For reading - call the scanner
    For writing:
        * Text
            - have a text(string type) and call beginWriting(TextRecordWrite(Sometext))
        * URL
            - have it input with www.somewebsite.com or return fatal error 
            - have a url(URL type) and call
                beginWriting(URLRecordWrite(URL))
        * URI
            - any input url, but with proper uri type would be better
            - have the url(URL type) and call
                beginWriting(URIRecordWrite(URL))
            - depending on the URIType listed [here](https://qiita.com/shimosyan/items/ed21fb6984240baa7397) would send the data with specific protocol
 
            
NDEFTagReader
 1. To implement the app first is to apply the requirements mention above
 2. Call the NFCTag you want ex. MitResidenceReader,MitFelicaReader,MitMyNumberReader
 3. Initiate
 4. beginScanning
 

# Notes
 * NDEF(NFC Data Exchange Format) 
  - NDEF message can have 1 - n record as long as the tag supports the number of bytes
  
  - Notes: do not add detecttag for reading it would conflict


# References
* NDEF(NFC Data Exchange Format) [Understanding](https://qiita.com/shimosyan/items/ed21fb6984240baa7397) - is the communication protocol used by NFC (Near-Field Communication) devices.
    - https://www.slideshare.net/slideshow/ndef-13784268/13784268
    - https://nfc-forum.org (if you can open the specification)
    - [Apple CoreNFC](https://developer.apple.com/documentation/corenfc/nfcndefmessage)
    - https://engineering.purdue.edu/ece477/Archive/2012/Spring/S12-Grp14/Specs/NFC/NFCRTD.pdf
    - Payload https://developer.apple.com/documentation/corenfc/nfcndefpayload?language=objc

* NFCTag Reader System Code and IDm: https://github.com/treastrain/TRETJapanNFCReader
    - [Driving License](https://www.osstech.co.jp/download/libjeid/ios/)
    - https://pcsc-tools.apdu.fr/smartcard_list.txt

