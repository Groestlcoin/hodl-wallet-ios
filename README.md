## [Hodl Wallet](https://hodlwallet.com/) - The easy and secure bitcoin wallet for IOS

Hodl is the best way to get started with Bitcoin. Our simple, streamlined design is easy for beginners, yet powerful enough for experienced users. You can get it on the app store here: [Download Hodl Wallet IOS](https://apps.apple.com/us/app/hodl-wallet/id1382342568?ls=1)

### Completely decentralized

Unlike other iOS Bitcoin wallets, **Hodl** is a standalone Bitcoin client. It connects directly to the Bitcoin network using [SPV](https://en.bitcoin.it/wiki/Thin_Client_Security#Header-Only_Clients) mode, and doesn't rely on servers that can be hacked or disabled. Even if **Hodl** disappears, the app will continue to function, allowing users to access their money at any time. You can also recover **Hodl's** backup recovery key in other Bitcoin wallets if necessary as we follow BIP standards for wallet generation.

### Cutting-edge security

**Hodl** utilizes AES hardware encryption, app sandboxing, and the latest iOS security features to protect users from malware, browser security holes, and even physical theft. Private keys are stored only in the secure enclave of the user's phone, inaccessible to anyone other than the user.

### Simple yet robust

Simplicity and ease-of-use is **Hodl's** core design principle. A simple recovery phrase (which we call a Backup Recovery Key) is all that is needed to restore the user's wallet if they ever lose or replace their device. **Hodl** is [deterministic](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki), which means the user's balance and transaction history can be recovered just from the backup recovery key.

### Features

- [Simplified payment verification](https://github.com/bitcoin/bips/blob/master/bip-0037.mediawiki) for fast mobile performance
- No server to get hacked or go down
- Single backup recovry key is all that's needed to backup & restore your wallet
- Private keys never leave your device
- Save a memo for each transaction (off-chain)
- Supports importing [password protected](https://github.com/bitcoin/bips/blob/master/bip-0038.mediawiki) paper wallets
- Supports ["Payment protocol"](https://github.com/bitcoin/bips/blob/master/bip-0070.mediawiki) payee identity certification

### Localization

**Hodl** is available in the following languages:

- Chinese (Simplified and traditional)
- Danish
- Dutch
- English
- French
- German
- Italian
- Japanese
- Korean
- Portuguese
- Russian
- Spanish
- Swedish


### Recovering your funds with other Bitcoin Wallets.

It may be necessary at somepoint to recover your bitcoin via your Hodl Wallet Backup Recovery Key (seed) using another Bitcoin wallet. In this case it is important to know what path Hodl Wallet derives your keys from. 

### Derivation path

Hodl Wallet conforms to [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) standards when generating your wallet. 

Derivation Path - `m/0'`

### Recovering funds with Electrum

If you find yourself with the need to recvor your funds with an external app, Hodl Wallet reccomends [Electrum](https://electrum.org/#home).

It's importnat that you make sure you our downloading Electrum from the real source. You can do this by double checking the ssl certificate at the site or building from source.

Steps to recovering your bitcoin using Electrum:

1. Select New/Restore
2. Name the Wallet
3. Select Standard Wallet
4. Select "I have the seed"
5. In options select BIP39
6. Enter the seed
7. Select Path `m/0'`

**NOTE:** If you wish to recover funds in legacy addresses you must repeat the process in Electrum while the existing wallet showing your balance in the segwit addresses is open. Do this by selecting File --> New/Restore. Electrum allows a user to manage multiple wallets and seeds at once. 


### Contact

Should you need to get in contact with us for any reason please feel free to write us at support@hodlwallet.com

You can visit our site here: [Hodlwallet.com](https://hodlwallet.com/) 


### WARNING:

***Installation on jailbroken devices is strongly discouraged.***

Any jailbreak app can grant itself access to every other app's keychain data. This means it can access your wallet and steal your bitcoin by self-signing as described [here](http://www.saurik.com/id/8) and including `<key>application-identifier</key><string>*</string>` in its .entitlements file.

---

**Hodl** is open source and available under the terms of the MIT license.

Source code is available at https://github.com/hodlwallet
