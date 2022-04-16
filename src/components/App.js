import './App.css'

import {MDBBtn, MDBCard, MDBCardBody, MDBCardImage, MDBCardText, MDBCardTitle} from 'mdb-react-ui-kit';
import React,{Component} from 'react';

import KryptoBird from '../abis/KryptoBird.json'
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';

class App extends Component {

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData()
    }

    async loadWeb3() {
        const provider = await detectEthereumProvider();
        if(provider) {
            console.log('etherium wallet is connected')
            window.web3 = new Web3(provider)
        } else {
            console.log('no etherum wallet detected')
        }
    }

    async loadBlockchainData() {
        const web3 = window.web3
        const accounts = await web3.eth.getAccounts()
        this.setState({
            account: accounts[0]
        })
        const networkId = await web3.eth.net.getId()
        const networkData = KryptoBird.networks[networkId]
        if(networkData) {
            const abi = KryptoBird.abi
            const address = networkData.address
            const contract = new web3.eth.Contract(abi, address)
            this.setState({
                contract: contract
            })

            const totalSupply = await contract.methods.totalSupply().call()
            this.setState({totalSupply})
            console.log(this.state.totalSupply)

            //Load Krypto Bird
            for(let i=1; i<= totalSupply; i++) {
                const kryptoBird = await contract.methods.KryptoBirdz(i-1).call()
                this.setState({
                    kryptoBirdz: [...this.state.kryptoBirdz, kryptoBird]
                })
            }
        }
    }
    
    mint = (kryptoBird) => {
        this.state.contract.methods.mint(kryptoBird).send({from : this.state.account})
        .once('recipt', (recipt) => {
            this.setState({
                kryptoBirdz: [...this.state.kryptoBirdz, kryptoBird]
            })
        })
    }

    constructor (props) {
        super(props)
        this.state = {
            account: '',
            contract: null,
            totalSupply: 0,
            kryptoBirdz: []
        }
    }

    render() {
        return (
            <div>
                {console.log(this.state.kryptoBirdz)}
                <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'> 
                    <div className='navbar-brand col-sm-3 col-md-3 mr-0s'
                         style={{color: 'white'}}
                    >
                     Krypto Birdz NFTs (Non Fungible Tokens) 
                    </div>
                    <ul className='nav-bar-nav px-3'>
                        <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
                            <small className='text-white'>
                                {this.state.account}
                            </small>
                        </li>
                    </ul>
                </nav>

                <div className='container-filled'>
                    <div className='row'>
                        <main role='main' className='col-lg-12 d-flex text-center'>
                            <div className='content mr-auto ml-aoto'
                                style={{opacity: '0.8'}}
                            >
                                <h1 style={{color: 'black'}}> Krypto Birdz - NFT Market place</h1>

                                <form onSubmit={(event) => {
                                    event.preventDefault()
                                    const kryptoBird  = this.kryptoBird.value
                                    this.mint(kryptoBird)
                                }}>
                                    <input type='text'
                                           placeholder='Add a file location'
                                           className='mb-1'
                                           ref ={(input) => {
                                               this.kryptoBird = input
                                           }}
                                    /> 
                                    <input type='submit'
                                           className='btn btn-primary btn-black'
                                           value='MINT'
                                           style={{margin:'6px'}}
                                    >
                                    </input>
                                </form>
                            </div>
                        </main>
                        <div>
                            <hr></hr>
                            <div className='row textCenter'>
                                 {this.state.kryptoBirdz.map((kryptoBird , key)=>{
                                     return (
                                         <div> 
                                             <div>
                                                 <MDBCard className='token img' style={{maxWidth:'22rem'}} >
                                                    <MDBCardImage src={kryptoBird} position='top' height='250rem' style={{marginRight:'4px'}}/>
                                                    <MDBCardBody >
                                                        <MDBCardTitle>
                                                            KryptoBirdz
                                                        </MDBCardTitle>
                                                        <MDBCardText>
                                                            KryptoBirdz are 20 uniquely generated KBirdz from galaxy  Mystopia! There is only one of each bird.
                                                        </MDBCardText>
                                                        <MDBBtn> Download</MDBBtn>
                                                    </MDBCardBody>
                                                 </MDBCard>
                                             </div>
                                         </div>
                                     )
                                 })}
                            </div>
                        </div>
                    </div>              
                </div>
            </div>
        )
    }
}

export default App;