const indexCtrl = {};
const Web3 = require('web3');

indexCtrl.renderIndex = (req,res) => {
    const titlePage = 'Home';
    res.render('index', { titlePage });
}

indexCtrl.renderPruebas = (req,res) => {
    const titlePage = 'Pruebas';
    res.render('pruebas', { titlePage });
}

module.exports = indexCtrl;