from serviços.database.conector import DatabaseManager
from datetime import date

class UsuárioDatabase:
    def __init__(self, db_provider=DatabaseManager()) -> None:
        self.db = db_provider

    def insere_usuário(self, cpf: str, prenome: str, sobrenome: str, data_nasc:date):
        statement = f"""
            INSERT INTO usuário (CPF, prenome, sobrenome, data_nasc)
            VALUES ('{cpf}', '{prenome}', '{sobrenome}', '{data_nasc}'); \n
        """
        
        return self.db.execute_statement(statement)
    
    def insere_lista_tel_usuário(self, cpf: str, tel_usuario: str): #aqui vc passa uma lista separada por vírgula
        statement = """
                INSERT INTO tel_usuário(CPF, telefone) VALUES \n
        """
        tel_list_limpa = [tel.strip() for tel in tel_usuario.split(',') if tel.strip()] #para limpar a lista e não quebrar a consulta
        if not tel_list_limpa:
            return

        tam_list= len(tel_list_limpa)
        for indice, item in enumerate(tel_list_limpa):
            if indice < tam_list - 1:
                statement += f"('{cpf}', '{item}'), \n"
            else:
                statement += f"('{cpf}', '{item}'); \n"

        return self.db.execute_statement(statement)
    
    def deleta_tel_usuário(self, cpf: str, tel_usuario: str): #aqui vc passa uma lista separada por vírgula
        tel_list_limpa = [tel.strip() for tel in tel_usuario.split(',') if tel.strip()] #para limpar a lista e não quebrar a consulta
        if not tel_list_limpa:
            return

        tel_str = "', '".join(tel_list_limpa)

        statement = f"""
            DELETE FROM tel_usuário
            WHERE CPF = '{cpf}' AND telefone IN ('{tel_str}'); \n
        """

        return self.db.execute_statement(statement)
    
    def deleta_usuário(self, cpf: str):
        statement = f"""
            DELETE FROM usuário
            WHERE CPF = '{cpf}'; \n
        """
        return self.db.execute_statement(statement)
