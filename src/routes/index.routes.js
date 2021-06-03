const { Router } = require('express');
const router = Router();

const { renderIndex, renderPruebas, dashboardwork, createArt } = require('../controllers/index.controllers')

router.get('/', renderIndex)
router.get('/dashboard/work', dashboardwork)
router.get('/dashboard/create/art', createArt)



module.exports = router;