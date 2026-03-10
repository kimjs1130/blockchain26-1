# Ethereum RPC Practice

## Project Description
This project demonstrates two ways to retrieve Ethereum blockchain data.

1. Raw JSON-RPC request
2. Using ethers.js library

Both programs retrieve the latest Ethereum block number through Infura.

---

## Install Dependencies


npm install


---

## Setup .env File

Create a `.env` file in the project root directory.


API_KEY=your_infura_api_key


---

## Run Programs

Run JSON-RPC version


node json-rpc/index.js


Run ethers.js version


node ethers/index.js
