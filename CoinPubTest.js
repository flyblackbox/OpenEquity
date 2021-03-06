var CoinPub = artifacts.require("./CoinPub.sol");
contract('CoinPub', function(accounts) {
it("creates a Coin with readerstake of 1 ", function() {
	var N=1;
    var instance;
    return CoinPub.new( {
      from: accounts[0],
       })
        .then(_instance => {
            instance = _instance;
           return instance.createCoinStruct(1,"MYCoin","BK","boardroom");
        })
        .then(() =>{

            return instance.structRet.call(1);
        })
        .then(resultValue => {
		    console.log(resultValue);
            assert.equal(resultValue.toString(), N, "Readershipstake should be 1");
            // Do not return anything on the last callback or it will believe there is an error.
        });
});
it("creates a Coin with a tokenname of MYCoin", function() {
	var Name="MYCoin";
    var instance;
    return CoinPub.new( {
      from: accounts[0],
       })
        .then(_instance => {
            instance = _instance;
           return instance.createCoinStruct(1,"MYCoin","BK","boardroom");
        })
        .then(() =>{

            return instance.nameret.call(1);
        })
        .then(resultValue => {
		    console.log(resultValue);
            assert.equal(resultValue.toString(), Name, "tokenname should be MYCoin");
            // Do not return anything on the last callback or it will believe there is an error.
        });
});
it("creates a Coin with a tokensymbol of BK", function() {
	var Symbol="BK";
    var instance;
    return CoinPub.new( {
      from: accounts[0],
       })
        .then(_instance => {
            instance = _instance;
            return instance.createCoinStruct(1,"MYCoin","BK","boardroom");
        })
        .then(() =>{

            return instance.symbolret.call(1);
        })
        .then(resultValue => {
		    console.log(resultValue);
            assert.equal(resultValue.toString(), Symbol, " symbol should be BK");
            // Do not return anything on the last callback or it will believe there is an error.
        });
});
it(" CoinID will increment with iterate with function call", function() {
	var Symbol="BKK";
    var instance;
    return CoinPub.new( {
      from: accounts[0],
       })
        .then(_instance => {
            instance = _instance;
            return instance.createCoinStruct(1,"MYCoin","BK","boardroom");
        }).then(() =>{

             return instance.createCoinStruct(1,"MYCoin","BKK","boardroom");
        }).then(() =>{

            return instance.symbolret.call(2);
        })
        .then(resultValue => {
		    console.log(resultValue);
            assert.equal(resultValue.toString(), Symbol, " symbol should be BK");
            // Do not return anything on the last callback or it will believe there is an error.
        });
});
it(" modify Coin works", function() {
	var goal=100;
	var s=2;
	var e=4;
	var eligible=300;
    var instance;
    return CoinPub.new( {
      from: accounts[0],
       })
        .then(_instance => {
            instance = _instance;
            return instance.createCoinStruct(1,"MYCoin","BK","boardroom");
        }).then(() =>{

             return instance.modifyCoinStruct(1,100,2,4,300);
        }).then(() =>{

            return instance.getOtherparams.call(1);
        })
        .then(resultValue => {
		   // console.log(resultValue);
            assert.equal(resultValue[0].c.toString(), goal, " goal should be 100");
						assert.equal(resultValue[1].toString(), s, " start should be 2");
						assert.equal(resultValue[2].toString(), e, " end should be 4");
						assert.equal(resultValue[3].toString(), eligible, " eligible should be 300");
            // Do not return anything on the last callback or it will believe there is an error.
        });
		});
				it(" add a partner works", function() {
					var stake=100;

				    var instance;
				    return CoinPub.new( {
				      from: accounts[0],
				       })
				        .then(_instance => {
				            instance = _instance;
				            return instance.createCoinStruct(1,"MYCoin","BK","boardroom");
				        }).then(() =>{

				             return instance.addPartner(1,100);
				        }).then(() =>{

				            return instance.getPartnerShare.call(1,0);
				        })
				        .then(resultValue => {
						    //console.log(resultValue);
				            assert.equal(resultValue.toString(), stake, " gstake should be 100");

				            // Do not return anything on the last callback or it will believe there is an error.
				        });
							});









});
