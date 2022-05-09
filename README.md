# Speedrun Ethernaut With Foundry :shipit:

OpenZeppelin's wargame, [Ethernaut](https://ethernaut.openzeppelin.com/) teaches practical smart contract security concepts through CTF like challenges. 

This repo contains walkthroughs and solutions to each level using only [Foundry](https://book.getfoundry.sh/index.html).

#### Foundry's toolchain consists of :
- **`Forge`** a cli tool for testing, building, and deploying smart contracts
 
- **`Cast`** a swiss army knife for interacting with Ethereum RPC nodes
 
## How To Use This Repo
### Config & Setup
This project uses [environment variables](https://www.geeksforgeeks.org/environment-variables-in-linux-unix/) to handle all config variables:
- `ETH_RPC_URL` this is **automatically** checked by forge and cast
- `PRIVATE_KEY` this has to be **manually** included when using forge or cast
- `LEVEL_ADDRESS` instance address

Environment variables can be set in the terminal as follows
```
export PRIVATE_KEY=<your-private-key-here> 
export ETH_RPC_URL=<your-rinkerby-node-url-here>
export LEVEL_ADDRESS=<your-instance-address-here>
```
**Note:** Foundry offers multiple ways to store your private key for signing, the method proposed above is **not secure** and **should only be used with a temporary wallet** for the purpose of this walkthrough.

> Foundry offers support for raw private keys, keystore private keys, and hardware wallets. Read more about how to implement each one [here](https://book.getfoundry.sh/reference/cast/cast-send.html)

### Level Solution Navigation

Level Name link leads to solution write up.

| Level Name                                          | Concepts Explored                           | Difficulty |
| -----------                                         | -----------                                 | :----:     |
| [Fallback](./01_Fallback/README.md)                 | Fallback & receive functions                | 1/10       |
| [Fallout](./02_Fallout/README.md)                   | Misnaming functions                         | 2/10       |
| [Coin Flip](./03_CoinFlip/README.md)                | Predicting onchain randomness               | 3/10       |
| [Telephone](./04_Telephone/README.md)               | Msg.sender vs tx.origin                     | 1/10       |
| [Token](./05_Token/README.md)                       | Overflow and underflows attacks             | 3/10       |
| [Delegation](./06_Delegation/README.md)             | DelegateCall                                | 4/10       |
| [Force](./07_Force/README.md)                       | SelfDestruct function                       | 5/10       |
| [Vault](./08_Vault/README.md)                       | Inspecting contract storage slots           | 3/10       |
| [King](./09_King/README.md)                         | Spoofing contract that expects EOA          | 6/10       |
| [Re-entrancy](./10_Reentrancy/README.md)            | Re-entrancy attacks                         | 6/10       |
| [Elevator](./11_Elevator/README.md)                 | Malicious interfaces                        | 4/10       |
| [Privacy](./12_Privacy/README.md)                   | Layout of state variables in storage        | 8/10       |
| [Gatekeeper One](./13_GateKeeperOne/README.md)      | Bytemasking and gasLeft function            | 5/10       |
| [Gatekeeper Two](./14_GateKeeperTwo/README.md)      | Calling from code from constructor          | 6/10       |
| [Naught Coin](./15_NaughtCoin/README.md)            | Inheritance and transferFrom function       | 5/10       |
| [Preservation](./16_Preservation/README.md)         | DelegateCall                                | 8/10       |
| [Recovery](./17_Recovery/README.md)                 | Contract address creation                   | 6/10       |
| [Magic Number](./18_MagicNumber/README.md)          | Contract init and runtime opcodes           | 6/10       |
| [Alien Codex](./19_AlienCodex/README.md)            | Writing to any storage slot using overflows | 7/10       |
| [Denial](./20_Denial/README.md)                     | Ddos gas draining attack                    | 5/10       |
| [Shop](./21_Shop/README.md)                         | Malicious view function interfaces          | 4/10       |
| [Dex](./22_Dex/README.md)                           | Manipulating oracle-less price data         | 3/10       |
| [Dex Two](./23_DexTwo/README.md)                    | Creating a malicious ERC20 token            | 4/10       |
| [Puzzle Wallet](./24_PuzzleWallet/README.md)        | Proxy design patterns                       | 7/10       |
| [Motorbike](./25_Moterbike/README.md)               | Upgradable pattern and EIP-1967             | 6/10       |
| [DoubleEntryPoint](./26_DoubleEntryPoint/README.md) | Fortra contracts                            | 4/10       |

--- 
 
### Contribution
All contribution is welcome, if you find any mistakes or have a better implementation feel free to **create a pull request**.

Levels without writeups : 
- `24 Puzzle Wallet`
- `25 Moterbike`
- `26 Double Entry Point`
