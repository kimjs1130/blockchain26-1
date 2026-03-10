require("dotenv").config()
const { ethers } = require("ethers")

async function main(){

  const provider = new ethers.JsonRpcProvider(
    `https://mainnet.infura.io/v3/${process.env.API_KEY}`
  )

  const block = await provider.getBlockNumber()

  console.log("Latest block:", block)

}

main()