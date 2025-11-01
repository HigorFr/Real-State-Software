from flask import Blueprint, jsonify, request
from serviços.contrato import ContratoDatabase

contrato_blueprint = Blueprint("contrato", __name__)

@contrato_blueprint.route("/contratos/prazo", methods=["GET"])
def contratos_prazo():  
    return jsonify(ContratoDatabase().get_prazo_contrato()), 200