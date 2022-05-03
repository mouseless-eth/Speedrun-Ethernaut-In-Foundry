# Speedrun Ethernaut With Foundry :shipit:

OpenZeppelin's wargame, [Ethernaut](https://ethernaut.openzeppelin.com/) teaches practical smart contract security concepts. This repo contains walkthroughs and solutions to each level using only [Foundry](https://book.getfoundry.sh/index.html) 

#### Foundry's toolchain consists of :
- **`Forge`** a cli tool for testing, building, and deploying smart contracts
 
- **`Cast`** a swiss army knife for interacting with Ethereum RPC nodes
 
## How To Use This Repo
### Setup & Config
Set up the following environment variables for when we use **forge** and **cast** 
```
export PRIVATE_KEY=<your-private-key-here> 
export ETH_RPC_URL=<your-rinkerby-node-url-here>
```
> `ETH_RPC_URL` will be automatically checked by forge and cast

> `PRIVATE_KEY` needs to be manually added when using forge or cast

### Level Solution Navigation

| Level Name       | Concepts Explored & Difficulty        |
| -----------      | -----------                           |
| Fallback         | receive and fallback functions (1/10) |
| Fallout          | 2/10                                  |
| Coin Flip        | 3/10                                  |
| Telephone        | 1/10                                  |
| Token            | 3/10                                  |
| Delegation       | 4/10                                  |
| Force            | 5/10                                  |
| Vault            | 3/10                                  |
| King             | 6/10                                  |
| Re-entrancy      | 6/10                                  |
| Elevator         | 4/10                                  |
| Privacy          | 8/10                                  |
| Gatekeeper One   | 5/10                                  |
| Gatekeeper Two   | 6/10                                  |
| Naught Coin      | 5/10                                  |
| Preservation     | 8/10                                  |
| Recovery         | 6/10                                  |
| Magic Number     | 6/10                                  |
| Alien Codex      | 7/10                                  |
| Denial           | 5/10                                  |
| Shop             | 4/10                                  |
| Dex              | 3/10                                  |
| Dex Two          | 4/10                                  |
| Puzzle Wallet    | 7/10                                  |
| Motorbike        | 6/10                                  |
| DoubleEntryPoint | 4/10                                  |
