const ethers = require('ethers');
require('dotenv').config();

const NODE_URL = process.env.RINKERBY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const LEVEL_ADDRESS = process.env.LEVEL_ADDRESS;

const provider = new ethers.providers.JsonRpcProvider(NODE_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY);
const signer = wallet.connect(provider);

const FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

const coinFlipContract = new ethers.Contract(
  LEVEL_ADDRESS,
  ["function flip(bool _guess) public returns (bool)"],
  signer
)

let correctFlips = 0;

provider.on('block', async (blockNum) => {
  console.log("blockNum : ", blockNum);
  let blockData = await provider.getBlock(blockNum);
  let blockHash = blockData.hash;
  let blockValue = parseInt(blockHash, 16);
  let coinFlip = Math.floor(blockValue / FACTOR);
  let side = coinFlip == 1 ? true : false;

  const tx = await coinFlipContract.flip(side);
  const promise = tx.wait();
  const receipt = await promise;

  correctFlips++;
  console.log(correctFlips);
})
