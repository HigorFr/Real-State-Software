from flask import Blueprint, jsonify, request
from serviços.imóvel import ImóvelDatabase

imovel_blueprint = Blueprint("imóvel", __name__)

@imovel_blueprint.route("/imóveis/filtro", methods=["GET"])
def filtra_imóveis():
    valor_venal = request.args.get("valor_venal", type=float)
    logradouro = request.args.get("logradouro", "")
    número = request.args.get("número", "")
    cep = request.args.get("cep", "")
    cidade = request.args.get("cidade", "")
    metragem_min = request.args.get("metragem_min", type=float)
    metragem_max = request.args.get("metragem_max", type=float)
    finalidade = request.args.get("finalidade", "")
    tipo = request.args.get("tipo", "")
    n_quartos = request.args.get("n_quartos", type=int)
    n_reformas = request.args.get("n_reformas", type=int)
    possui_garagem = request.args.get("possui_garagem", type=lambda v: v.lower() == 'true' if v else None)
    mobiliado = request.args.get("mobiliado", type=lambda v: v.lower() == 'true' if v else None)
    cpf_prop= request.args.get("cpf", "")
    matrícula= request.args.get("matrícula", "")
    comodidade= request.args.get("comodidade", "")

    return jsonify(ImóvelDatabase().filtra_imoveis(
        valor_venal,
        logradouro,
        número,
        cep,
        cidade,
        metragem_min,
        metragem_max,
        finalidade,
        tipo,
        n_quartos,
        n_reformas,
        possui_garagem,
        mobiliado,
        cpf_prop,
        matrícula,
        comodidade
    )), 200

@imovel_blueprint.route("/imóveis/status", methods=["GET"])
def verifica_status_imóveis():
    matrícula = request.args.get("matrícula", "")
    return jsonify(ImóvelDatabase().get_status_imovel(
        matrícula
    )), 200

@imovel_blueprint.route("/imóveis/cadastro", methods=["POST"])
def cadastrar_imóvel():
    json = request.get_json()
    cpf_prop = json.get("cpf_prop")
    logradouro = json.get("logradouro")
    complemento = json.get("complemento")
    número = json.get("número")
    CEP = json.get("cep")
    cidade = json.get("cidade")
    metragem = json.get("metragem")
    finalidade = json.get("finalidade")
    tipo = json.get("tipo")
    n_quartos = json.get("n_quartos")
    n_reformas = json.get("n_reformas")
    possui_garagem = json.get("possui_garagem")
    mobiliado = json.get("mobiliado")
    valor_venal = json.get("valor_venal")
    matrícula = json.get("matrícula")

    if not all([cpf_prop, logradouro, número, CEP, cidade, matrícula]):
        return jsonify("Há campos obrigatórios não preenchidos"), 400

    registro = ImóvelDatabase().cadastra_imóvel(
        matrícula,
        n_quartos,
        valor_venal,
        metragem,
        tipo,
        mobiliado,
        possui_garagem,
        n_reformas,
        finalidade,
        logradouro,
        complemento,
        número, 
        CEP,
        cidade, 
        cpf_prop
    )

    if not registro:
        return jsonify("Não foi possível cadastrar o imóvel."), 400

    return jsonify("Imóvel cadastrado com sucesso."), 200

@imovel_blueprint.route("/imóveis/alteração", methods=["PUT"])
def alterar_imóvel():
    json = request.get_json()
    matrícula = json.get("matrícula")
    n_quartos = json.get("n_quartos")
    valor_venal = json.get("valor_venal")
    metragem = json.get("metragem")
    tipo = json.get("tipo")
    mobiliado = json.get("mobiliado")
    possui_garagem = json.get("possui_garagem")
    n_reformas = json.get("n_reformas")
    finalidade = json.get("finalidade")

    if not matrícula:
        return jsonify("Matrícula é um campo obrigatório"), 400

    registro = ImóvelDatabase().altera_imóvel(
        matrícula,
        n_quartos,
        valor_venal,
        metragem,
        tipo,
        mobiliado,
        possui_garagem,
        n_reformas,
        finalidade,
    )

    if not registro:
        return jsonify("Não foi possível alterar o imóvel."), 400

    return jsonify("Imóvel alterado com sucesso."), 200

@imovel_blueprint.route("/imóveis/alteração/proprietario", methods=["PUT"])
def alterar_proprietario_imóvel():
    json = request.get_json()
    matrícula = json.get("matrícula")
    cpf_prop = json.get("cpf_novo_prop")

    if not all([matrícula, cpf_prop]):
        return jsonify("Matrícula e CPF do novo proprietário são campos obrigatórios"), 400

    registro = ImóvelDatabase().altera_proprietario_imóvel(
        matrícula,
        cpf_prop
    )

    if not registro:
        return jsonify("Não foi possível alterar o proprietário do imóvel."), 400

    return jsonify("Proprietário do imóvel alterado com sucesso."), 200

@imovel_blueprint.route("/imóveis/comodidades", methods=["POST"])
def adiciona_comodidades_imóvel():
    json = request.get_json()
    matrícula = json.get("matrícula")
    comodidades = json.get("comodidades")  # aqui você passa uma lista separada por vírgula

    if not all([matrícula, comodidades]):
        return jsonify("Matrícula e comodidades são campos obrigatórios"), 400

    registro = ImóvelDatabase().adiciona_comodidades_imóvel(
        matrícula,
        comodidades
    )

    if not registro:
        return jsonify("Não foi possível adicionar as comodidades."), 400

    return jsonify("Comodidades adicionadas com sucesso."), 200

@imovel_blueprint.route("/imóveis/comodidades", methods=["DELETE"])
def remove_comodidades_imóvel():
    json = request.get_json()
    matrícula = json.get("matrícula")
    comodidades = json.get("comodidades")  # aqui você passa uma lista separada por vírgula

    if not all([matrícula, comodidades]):
        return jsonify("Matrícula e comodidades são campos obrigatórios"), 400

    registro = ImóvelDatabase().remove_comodidades_imóvel(
        matrícula,
        comodidades
    )

    if not registro:
        return jsonify("Não foi possível remover as comodidades."), 400

    return jsonify("Comodidades removidas com sucesso."), 200

@imovel_blueprint.route("/imóveis/deleta", methods=["DELETE"])
def deleta_imóvel():
    json = request.get_json()
    matrícula = json.get("matrícula")

    if not matrícula:
        return jsonify("Matrícula é um campo obrigatório"), 400

    registro = ImóvelDatabase().deleta_imóvel(
        matrícula
    )

    if not registro:
        return jsonify("Não foi possível deletar o imóvel."), 400

    return jsonify("Imóvel deletado com sucesso."), 200