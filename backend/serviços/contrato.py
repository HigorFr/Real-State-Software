from serviços.database.conector import DatabaseManager
from datetime import datetime, timedelta

class ContratoDatabase:
    def __init__(self, db_provider=DatabaseManager()) -> None:
        self.db = db_provider

    def get_prazo_contrato(self):
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