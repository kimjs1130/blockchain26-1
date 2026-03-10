require("dotenv").config()

async function main() {

  const url = `https://mainnet.infura.io/v3/${process.env.API_KEY}`

  const response = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      jsonrpc: "2.0",
      method: "eth_blockNumber",
      params: [],
      id: 1
    })
  })

  const data = await response.json()

  const blockNumber = parseInt(data.result, 16)

  console.log("Latest block:", blockNumber)
}

main()