const Arts = artifacts.require('./Arts.sol');

require('chai').use(require('chai-as-promised')).should();

contract('Arts',  (accounts)=>{
    let contract;

    before(async() => {
        contract = await Arts.deployed();
    });

    describe('deployment', async() => {
        it('deploys successfully', async () => {    
            const address = contract.address;
            assert.notEqual(address, 0x0);
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
        });

        it('has a name', async () => {
            const name = await contract.name();
            assert.equal(name, 'Slipstream');

        })
    }) 

    describe('minting', async () => {
        it('creates a new token', async () => {
            const result = await contract.mint(
                '0x2d1142754bC713545B98b499fe4a3F4B4479d591',
                'Alvarez', 
                'Puesta del Sol', 
                'Pequeña imagen de cuando estaba cerca de la hora para la puesta del sol', 
                'https://i.picsum.photos/id/360/200/300.jpg?hmac=Fl1CgUfxrFjmcS1trYDG80XpEjYixcXfc2uTtCxFkDw', 
                'https://i.picsum.photos/id/271/200/200.jpg?hmac=ZEj4e_twCOPm3eoBeBMIKpcbFcD7s8TwRPMuyhLmqPk'
                );
            const totalSupply = await contract.totalSupply();
            //SUCCESS
            assert.equal(totalSupply, 1);
            const event = result.logs[0].args;
            assert.equal(event.tokenId.toNumber(), 1, 'id is correct');
            assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct');
            assert.equal(event.to, accounts[0],'to is correct');

            //FAILURE: There cannot be 2 images the same
            await contract.mint(
                '0x2d1142754bC713545B98b499fe4a3F4B4479d591',
                'Alvarez', 
                'Puesta del Sol', 
                'Pequeña imagen de cuando estaba cerca de la hora para la puesta del sol', 
                'https://i.picsum.photos/id/360/200/300.jpg?hmac=Fl1CgUfxrFjmcS1trYDG80XpEjYixcXfc2uTtCxFkDw', 
                'https://i.picsum.photos/id/271/200/200.jpg?hmac=ZEj4e_twCOPm3eoBeBMIKpcbFcD7s8TwRPMuyhLmqPk'
                ).should.be.rejected;
        })
    });


    describe('indexing', async () => {
        it('list arts', async() => {

            await contract.mint(
                '0x1d149282C75FF143c6A885568E234Ab8dac3197a',
                'Jose M', 
                'pequeña Puesta del Sol', 
                'Pequeña imagen de cuando estaba cerca de la hora para la puesta del sol para irse a acostar', 
                'https://i.picsum.photos/id/353/200/200.jpg?hmac=0pI-jYBxEC3AHp_0G8YowhiQRtQdv6u1Kfvuf0c9VNQ', 
                'https://i.picsum.photos/id/278/200/200.jpg?hmac=ttIZUII9b-qTWIpyIHChMPIA802dHskBJGR2EAa-Ywc'
                );

            await contract.mint(
                '0x2d1142754bC713545B98b499fe4a3F4B4479d591',
                'Josue E.', 
                'La Viki', 
                'Imagen de mi esposa en sus mejores momentos', 
                'https://i.picsum.photos/id/581/200/200.jpg?hmac=l2PTQyeWhW42zIrR020S5LHZ2yrX63cSOgZqpeWM0BA', 
                'https://i.picsum.photos/id/294/200/200.jpg?hmac=tSuqBbGGNYqgxQ-6KO7-wxq8B4m3GbZqQAbr7tNApz8'
                );

            await contract.mint(
                '0xf93EF65f9B687C456865650aDf56735A782CE06e',
                'Angela S.', 
                'El joe', 
                'Joel jose en sus mejores momentos de programación', 
                'https://i.picsum.photos/id/1039/200/200.jpg?hmac=VpGJWDIq64ZdzDD5NAREaY7l5gX14vU5NBH84b5Fj-o', 
                'https://i.picsum.photos/id/189/200/200.jpg?hmac=D4dFU1JWalnD5ZptSD-jGDOEc8abV1vBRfC5HstzT_8'
                );
            
            const totalSupply = await contract.totalSupply();
            let art;
            let result = [];
            for (let i = 1; i <= totalSupply; i++){
                art = await contract.artsArray(i - 1);
                result.push(art);
            }

            let expected = [
                {
                    creator:'0x2d1142754bC713545B98b499fe4a3F4B4479d591',
                    creatorName:'Alvarez', 
                    nameArt:'Puesta del Sol', 
                    descriptionArt:'Pequeña imagen de cuando estaba cerca de la hora para la puesta del sol', 
                    imageArt:'https://i.picsum.photos/id/360/200/300.jpg?hmac=Fl1CgUfxrFjmcS1trYDG80XpEjYixcXfc2uTtCxFkDw', 
                    audioArt:'https://i.picsum.photos/id/271/200/200.jpg?hmac=ZEj4e_twCOPm3eoBeBMIKpcbFcD7s8TwRPMuyhLmqPk'
                },
                {
                    creator:'0x1d149282C75FF143c6A885568E234Ab8dac3197a',
                    creatorName:'Jose M', 
                    nameArt:'pequeña Puesta del Sol', 
                    descriptionArt:'Pequeña imagen de cuando estaba cerca de la hora para la puesta del sol para irse a acostar', 
                    imageArt:'https://i.picsum.photos/id/353/200/200.jpg?hmac=0pI-jYBxEC3AHp_0G8YowhiQRtQdv6u1Kfvuf0c9VNQ', 
                    audioArt:'https://i.picsum.photos/id/278/200/200.jpg?hmac=ttIZUII9b-qTWIpyIHChMPIA802dHskBJGR2EAa-Ywc'
                },
                {
                    creator:'0x2d1142754bC713545B98b499fe4a3F4B4479d591',
                    creatorName:'Josue E.', 
                    nameArt:'La Viki', 
                    descriptionArt:'Imagen de mi esposa en sus mejores momentos', 
                    imageArt:'https://i.picsum.photos/id/581/200/200.jpg?hmac=l2PTQyeWhW42zIrR020S5LHZ2yrX63cSOgZqpeWM0BA', 
                    audioArt:'https://i.picsum.photos/id/294/200/200.jpg?hmac=tSuqBbGGNYqgxQ-6KO7-wxq8B4m3GbZqQAbr7tNApz8'
                },
                {
                    creator:'0xf93EF65f9B687C456865650aDf56735A782CE06e',
                    creatorName:'Angela S.', 
                    nameArt:'El joe', 
                    descriptionArt:'Joel jose en sus mejores momentos de programación', 
                    imageArt:'https://i.picsum.photos/id/1039/200/200.jpg?hmac=VpGJWDIq64ZdzDD5NAREaY7l5gX14vU5NBH84b5Fj-o', 
                    audioArt:'https://i.picsum.photos/id/189/200/200.jpg?hmac=D4dFU1JWalnD5ZptSD-jGDOEc8abV1vBRfC5HstzT_8'
                }
            ];

            assert.equal(result.join(','), expected.join(','));

        })
    })

})