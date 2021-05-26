const { Router } = require('express');
const router = Router();

const { renderIndex, renderPruebas } = require('../controllers/index.controllers')

router.get('/inicio', renderIndex)
router.get('/', renderPruebas)


module.exports = router;