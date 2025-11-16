# Base DEX (Aerodrome) - On-chain Volume Aggregator (Solidity)

A simple **developer-style** repository for the Base blockchain that demonstrates a minimal Solidity contract for collecting and exposing reported DEX volume metrics (example: Aerodrome).  
This repo is deliberately lightweight: unpack and upload to your GitHub, pin it, and it looks like a real dev project.

> **Note:** On-chain contracts cannot directly call off-chain APIs (like BaseScan). The usual pattern is:
> 1. Off-chain data collector (script, cron job) fetches metrics from BaseScan / APIs.
> 2. The collector submits verified aggregates to a trusted on-chain contract (owner or oracle).
> 3. The contract stores aggregates and exposes read functions.

This repo contains:
- `contracts/VolumeAggregator.sol` — simple Solidity contract (Ownable-like) to store reported daily volumes.
- `scripts/report_example.js` — example Node.js script (ethers + axios) showing how an off-chain collector could fetch data from BaseScan and call the contract.
- `.env.example` — example env variables to fill before running scripts.
- `README.md` — this file.

## Quick files overview

```
base-dex-aerodrome-analytics/
 ┣ README.md
 ┣ contracts/
 ┃   ┗ VolumeAggregator.sol
 ┣ scripts/
 ┃   ┗ report_example.js
 ┣ .env.example
 ┗ LICENSE
```

## How to use

1. Compile & deploy `contracts/VolumeAggregator.sol` on Base (use Hardhat/Foundry/Remix).
2. Run the `scripts/report_example.js` (after `npm install ethers axios dotenv`) to fetch data (example uses BaseScan) and call the contract.
3. View reported volumes by calling `getVolume(day)` or `getTotal(days[])`.

## Deployment (example with Hardhat)

- Install dependencies:
  ```bash
  npm init -y
  npm install --save-dev hardhat
  npm install ethers axios dotenv
  npx hardhat
  ```
- Add contract to `contracts/` and write a simple deploy script.
- Use `REPORTER_PRIVATE_KEY` and `BASE_RPC_URL` in your `.env`.

---

## Attribution / Data source
This example references **BaseScan** (or other Base chain explorers/APIs) as the off-chain data source for DEX volumes (Aerodrome). Replace the placeholder API endpoint in `scripts/report_example.js` with the real one you use.

---

## License
MIT — feel free to adapt.



## 🌐 Deployment

**Network:** Base Mainnet  
**Contract Address:** https://base.blockscout.com/address/0x994537D1e646D0F62476A0820Bc76460E594c738?tab=contract 
**Compiler:** Solidity 0.8.17  
**Deployed via:** Remix + MetaMask  
**Deployed by:** 0x0B8F7389369487786b5a6Fe9501241Be77E951dc  

Verified on **BaseScan** ✅ https://basescan.org/tx/0x74e28dd295a06ed457a2cead5a830b81e19f4f8b11e3d36499a134785736322b
