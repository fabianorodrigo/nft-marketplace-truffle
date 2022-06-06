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
      contract: null,
      kryptoBirdz: [],
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
      const contract = new web3.eth.Contract(abi, address);
      this.setState({contract});
      const totalSupply = await contract.methods.totalSupply().call();
      this.setState({totalSupply});
      //load crypto birdz
      for (let i = 0; i < totalSupply; i++) {
        const bird = await contract.methods.kryptoBirdz(i).call();
        this.setState({kryptoBirdz: [...this.state.kryptoBirdz, bird]});
      }
      console.log(this.state.kryptoBirdz);
    } else {
      alert("KryptoBirdz contract not deployed to detected network");
    }
    this.setState({account: accounts[0], networkId: networkId});
  }

  mint = (kryptoBird) => {
    this.state.contract.methods
      .mint(kryptoBird)
      .send({from: this.state.account})
      .once("receipt", (receipt) => {
        console.log(receipt);
        this.setState({kryptoBirdz: [...this.state.kryptoBirdz, kryptoBird]});
      });
  };

  render() {
    console.log(this.state.kryptoBirdz);
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
        <div className="container-fluid mt-1">
          <div className="row">
            <main role="main" className="col-lg-12 d-flex text-center">
              <div className="content mr-auto ml-auto" style={{opacity: 0.8}}>
                <h1 style={{color: "white"}}>KryptoBirdz - NFT Market</h1>
                <form
                  onSubmit={(e) => {
                    e.preventDefault();
                    this.mint(this.kryptoBird.value);
                  }}
                >
                  <input
                    type="text"
                    className="form-control mb-1"
                    placeholder="File location of krypto bird"
                    name="kryptoBird"
                    ref={(input) => {
                      this.kryptoBird = input;
                    }}
                  />
                  <input
                    style={{margin: "6px"}}
                    type="submit"
                    value="Mint"
                    className="btn btn-primary btn-black"
                  />
                </form>
              </div>
            </main>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
