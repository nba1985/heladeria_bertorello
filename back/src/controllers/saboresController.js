
const saboresService = require("../services/saboresService");
const asyncHandler = require("../middlewares/asyncHandler");

const listarSabores = asyncHandler(async (req, res) => {
    const sabores = await saboresService.listarSabores();
    res.status(200).json(sabores);
});

module.exports = { listarSabores };
