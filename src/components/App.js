import React, {Component} from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from "../abis/KryptoBirdz.json";

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      account: "",
      networkId: 0,
      totalSupply: 0,
    };
  }

  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }

  //first up is to detect ethereum provider
  async loadWeb3() {
    const provider = await detectEthereumProvider();

    //modern browsers
    // if there is a provider then lets use it
    if (provider) {
      console.log("ethereum wallet is connected");
      window.web3 = new Web3(provider);
    } else {
      console.log(`no Ethereum wallet detected`);
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3;
    const accounts = await web3.eth.getAccounts();
    const networkId = await web3.eth.net.getId();
    const networkData = KryptoBird.networks[networkId];
    if (networkData) {
      const abi = KryptoBird.abi;
      const address = networkData.address;
      const kryptoBird = new web3.eth.Contract(abi, address);
      const totalSupply = await kryptoBird.methods.totalSupply().call();
      console.log(totalSupply);
      this.setState({totalSupply});
    }
    this.setState({account: accounts[0], networkId: networkId});
  }

  render() {
    return (
      <div>
        <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
          <div
            className="navbar-brand col-sm-3 col-md-2 mr-0"
            style={{color: "white"}}
          >
            KriptoBirdz (Non Fungible Tokens)
          </div>
          <ul className="navbar-nav px-3">
            <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
              <small className="text-white">
                {this.state.account} [{this.state.networkId}]
              </small>
            </li>
          </ul>
        </nav>
        <h1>NFT Marketplace</h1>
      </div>
    );
  }
}

export default App;
