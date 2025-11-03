from serviços.database.conector import DatabaseManager
from datetime import date, datetime, timedelta

class ContratoDatabase:
    def __init__(self, db_provider=DatabaseManager()) -> None:
        self.db = db_provider

    def get_prazo_contrato(self): #obtém contratos perto de vencer (em até 30 dias)
        dias_ate_vencer=30
        data_hoje_obj = datetime.now().date() 
        data_futura_obj = data_hoje_obj + timedelta(days=dias_ate_vencer)  
        
        data_hoje_str = data_hoje_obj.isoformat()
        data_futura_str = data_futura_obj.isoformat()
        
        query = f"""
                SELECT * FROM contrato
                WHERE tipo='Aluguel' AND status = 'Ativo' AND
                data_fim BETWEEN '{data_hoje_str}' AND '{data_futura_str}';

        """
        return self.db.execute_select_all(query)
    
    def insere_contrato(self, código:int, valor:float, status:str,data_início:date, data_fim:date, tipo:str, matrícula_imóvel:str, CPF_prop:str, CPF_corretor:str): #insere um novo contrato
        statement = f"""
            INSERT INTO contrato (código, valor, status, data_início, data_fim, tipo, matrícula_imóvel, CPF_prop, CPF_corretor)
            VALUES ({código}, {valor}, '{status}', '{data_início}', '{data_fim}', '{tipo}', '{matrícula_imóvel}', '{CPF_prop}', '{CPF_corretor}'); \n
        """
        
        return self.db.execute_statement(statement)
    
    def completa_adquirente(self, CPF_adq:str, código_c:int): #completa a tabela adquirente
       statement = f"""
            INSERT INTO assina(CPF_adq, código_c) VALUES ('{CPF_adq}', {código_c}); \n
        """ 
       return self.db.execute_statement(statement)

    
    def deleta_contrato(self, código:int): #deleta um contrato
        statement = f"""
            DELETE FROM contrato
            WHERE código = {código}; \n
        """
        return self.db.execute_statement(statement) 
    
    def altera_status_contrato(self, código:int, status:str): #altera status de um contrato
        statement = f"""
            UPDATE contrato
            SET 
                status = '{status}'
            WHERE código = {código}; \n
        """
        return self.db.execute_statement(statement)
    
    def get_período_aluguéis_imóvel(self, matrícula_imóvel:str): #obtém os períodos dos contratos de aluguel de um imóvel
        statement=f"""
        SELECT código, matrícula_imóvel,data_início,data_fim FROM contrato
        WHERE tipo='Aluguel' AND matrícula_imóvel='{matrícula_imóvel}'
        ORDER BY data_início DESC;
        """

        return self.db.execute_select_all(statement)

    def get_alugueis_ativos(self): #obtém contratos de alguel ativos
        statement=f""" 
        SELECT c.código,c.status, c.data_início, c.data_fim, c.valor, i.matrícula, i.logradouro, i.número
        FROM contrato c
        JOIN imóvel i ON c.matrícula_imóvel = i.matrícula
        WHERE c.tipo='Aluguel' AND c.status='Ativo';
        """
        return self.db.execute_select_all(statement)
    
    def get_valores_contratos_imóvel(self, matrícula_imóvel:str): #obtém histórico de valores dos contratos de um imóvel
        statement=f"""
        SELECT código,matrícula_imóvel,valor FROM contrato 
        WHERE matrícula_imóvel='{matrícula_imóvel}' 
        ORDER BY código DESC;
        """

        return self.db.execute_select_all(statement)
    
    def get_mais_alugados(self): #obtém os imóveis mais alugados
        statement=f"""
        SELECT i.matrícula, i.logradouro, i.número, 
        COUNT(c.código) AS nr_de_vezes_alugado
        FROM contrato c JOIN imóvel i ON c.matrícula_imóvel = i.matrícula
        WHERE c.tipo='Aluguel'
		GROUP BY i.matrícula
        ORDER BY nr_de_vezes_alugado DESC;
        """
        
        return self.db.execute_select_all(statement)