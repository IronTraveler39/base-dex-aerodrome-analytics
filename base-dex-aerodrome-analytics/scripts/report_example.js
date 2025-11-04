// Example reporter script (Node.js)
// Usage: fill .env with RPC URL and private key, then `node report_example.js`
// This script is only illustrative — replace the API endpoint with your BaseScan or chosen data source.

const { ethers } = require("ethers");
const axios = require("axios");
require('dotenv').config();

const RPC = process.env.BASE_RPC_URL || "https://mainnet.base.org"; // replace with real Base RPC
const PRIVATE_KEY = process.env.REPORTER_PRIVATE_KEY || "";
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS || ""; // deployed VolumeAggregator

const ABI = [
  "function reportVolume(uint256 day, uint256 volume)",
  "function bulkReport(uint256[] days, uint256[] vols)"
];

async function fetchDexVolumes() {
  // Placeholder: replace with real BaseScan/Dex API
  // Example expected output:
  // [{ day: 20251001, volume: "1230000000000000000" }, ...]
  const API = "https://api.basescan.org/dex/aerodrome/volumes?days=7"; // <-- replace with real
  const resp = await axios.get(API);
  return resp.data;
}

async function main() {
  if (!PRIVATE_KEY || !CONTRACT_ADDRESS) {
    console.error("Please set REPORTER_PRIVATE_KEY and CONTRACT_ADDRESS in .env");
    return;
  }
  const provider = new ethers.providers.JsonRpcProvider(RPC);
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
  const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, wallet);

  const samples = await fetchDexVolumes();
  // Convert to arrays
  const days = samples.map(s => Number(s.day));
  const vols = samples.map(s => s.volume.toString());
  console.log("Reporting", days.length, "entries to", CONTRACT_ADDRESS);

  const tx = await contract.bulkReport(days, vols);
  console.log("Tx sent:", tx.hash);
  await tx.wait();
  console.log("Reported");
}

main().catch(console.error);
