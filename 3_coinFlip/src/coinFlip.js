const ethers = require('ethers');
require('dotenv').config();

const NODE_URL = process.env.RINKERBY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const provider = new ethers.providers.JsonRpcProvider(NODE_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY);
const signer = wallet.connect(provider);
