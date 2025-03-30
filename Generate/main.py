import os
import random
from typing import TypedDict
from choices import *

class TableData(TypedDict):
    table: str
    columns: list[str]
    values: list[str]

    @staticmethod
    def categoria(id_categoria:int, nombre:str) -> 'TableData':
        return TableData(
            table='categoria',
            columns=['id_categoria', 'nombre'],
            values=[id_categoria, f"'{nombre}'"]
        )
    @staticmethod
    def articulo(id_articulo:int, titulo:str, resumen:str, fecha_envio:str) -> 'TableData':
        return TableData(
            table='articulo',
            columns=['id_articulo', 'titulo', 'resumen', 'fecha_envio'],
            values=[id_articulo, f"'{titulo}'", f"'{resumen}'", f"'{fecha_envio}'"]
        )
    @staticmethod
    def autor(id_autor:int, rut:str, nombre:str, email:str) -> 'TableData':
        return TableData(
            table='autor',
            columns=['id_autor', 'rut', 'nombre', 'email'],
            values=[id_autor, f"'{rut}'", f"'{nombre}'", f"'{email}'"]
        )
    @staticmethod
    def revisor(id_revisor:int, rut:str, nombre:str, email:str) -> 'TableData':
        return TableData(
            table='revisor',
            columns=['id_revisor', 'rut', 'nombre', 'email'],
            values=[id_revisor, f"'{rut}'", f"'{nombre}'", f"'{email}'"]
        )
    @staticmethod
    def revision(id_articulo:int, id_revisor:int) -> 'TableData':
        return TableData(
            table='revision',
            columns=['id_articulo', 'id_revisor'],
            values=[id_articulo, id_revisor]
        )
    @staticmethod
    def topico(id_categoria:int, id_articulo:int) -> 'TableData':
        return TableData(
            table='topico',
            columns=['id_categoria', 'id_articulo'],
            values=[id_categoria, id_articulo]
        )
    @staticmethod
    def especialidad(id_categoria:int, id_revisor:int) -> 'TableData':
        return TableData(
            table='especialidad',
            columns=['id_categoria', 'id_revisor'],
            values=[id_categoria, id_revisor]
        )
    
    @staticmethod
    def propiedad(id_articulo:int, id_autor:int, es_contacto:bool) -> 'TableData':
        return TableData(
            table='propiedad',
            columns=['id_articulo', 'id_autor', 'es_contacto'],
            values=[id_articulo, id_autor, str(es_contacto).lower()]
        )
    

class DataGenerator:
    def __init__(self, db_name="gescon", n_articulos=100, n_revisores=50, n_autores=50) -> None:
        self.n_articulos = n_articulos
        self.n_revisores = n_revisores
        self.n_autores = n_autores
        self.n_categorias = len(CATEGORIAS)
        self.__db_name = db_name

    def __convert_to_psql_insert(self, data:TableData) -> str:
        return f"INSERT INTO {data['table']} ({', '.join(data['columns'])}) VALUES ({', '.join(map(str, data['values']))});"
    
    def __generate_rut(self) -> str:
        numero = random.randint(10000000, 99999999)
        digito_verificador = random.choice(DIGITOS_VERIFICADORES)
        return f"{numero}-{digito_verificador}"
    
    def __generate_email(self, nombre:str, rut:str) -> str:
        return f"{nombre.replace(' ', '.').lower()}{rut[-1]}@{random.choice(DOMINIOS)}"

    def __generate_fecha(self) -> str:
        return f"{random.randint(2000, 2023)}-{random.randint(1, 12):02}-{random.randint(1, 28):02}"
    
    def __generate_titulo(self) -> str:
        return f"{random.choice(TITULO_INICIO)} {random.choice(TITULO_VERBOS)} {random.choice(TITULO_OBJETOS)}"

    def __generate_categorias(self) -> list[TableData]:
        return [TableData.categoria(i, nombre) for i, nombre in enumerate(CATEGORIAS)]

    def __generate_articulos(self) -> list[TableData]:
        return [TableData.articulo(i, self.__generate_titulo(), random.choice(RESUMENES), self.__generate_fecha()) for i in range(self.n_articulos)]
    
    def __generate_revisores(self) -> list[TableData]:
        return [TableData.revisor(i, self.__generate_rut(), random.choice(NOMBRES), self.__generate_email(random.choice(NOMBRES), self.__generate_rut())) for i in range(self.n_revisores)]
    
    def __generate_autores(self) -> list[TableData]:
        return [TableData.autor(i, self.__generate_rut(), random.choice(NOMBRES), self.__generate_email(random.choice(NOMBRES), self.__generate_rut())) for i in range(self.n_autores)]
    
    def __generate_relaciones_especialidad(self) -> list[TableData]:
        relaciones = []
        for revisor in range(self.n_revisores):
            num_topicos = random.randint(1, 3)
            topicos = random.sample(range(self.n_categorias), num_topicos)
            for topico in topicos:
                relaciones.append(TableData.especialidad(topico, revisor))
        return relaciones
    
    def __generate_relaciones_revision(self) -> list[TableData]:
        relaciones = []
        for articulo in range(self.n_articulos):
            num_revisores = random.randint(1, 3)
            revisores = random.sample(range(self.n_revisores), num_revisores)
            for revisor in revisores:
                relaciones.append(TableData.revision(articulo, revisor))
        return relaciones
    
    def __generate_relaciones_topico(self) -> list[TableData]:
        relaciones = []
        for articulo in range(self.n_articulos):
            num_topicos = random.randint(1, 3)
            topicos = random.sample(range(self.n_categorias), num_topicos)
            for topico in topicos:
                relaciones.append(TableData.topico(topico, articulo))
        return relaciones
    
    def __generate_relaciones_propiedad(self) -> list[TableData]:
        relaciones = []
        for articulo in range(self.n_articulos):
            num_autores = random.randint(1, 3)
            autores = random.sample(range(self.n_autores), num_autores)
            for i, autor in enumerate(autores):
                es_contacto = i == 0
                relaciones.append(TableData.propiedad(articulo, autor, es_contacto))
        return relaciones

    def __generate_data(self) -> list[str]:
        data = []
        data.extend(self.__generate_categorias())
        data.extend(self.__generate_articulos())
        data.extend(self.__generate_revisores())
        data.extend(self.__generate_autores())
        data.extend(self.__generate_relaciones_especialidad())
        data.extend(self.__generate_relaciones_revision())
        data.extend(self.__generate_relaciones_topico())
        data.extend(self.__generate_relaciones_propiedad())
        return [self.__convert_to_psql_insert(d) for d in data]
    
    def __get_path(self, file_name:str) -> str:
        return os.path.join(os.path.dirname(os.path.dirname(__file__)), "Migrations", file_name)

    def write_to_file(self, file_name:str) -> None:
        path = self.__get_path(file_name)
        with open(path, 'w') as file:
            data = self.__generate_data()
            file.write(f"\\c {self.__db_name};\n")
            for line in data:
                file.write(line + '\n')
            file.close()


if __name__ == "__main__":
    generator = DataGenerator(
        db_name="gescon",
        n_articulos=400,
        n_revisores=50,
        n_autores=50
    )
    generator.write_to_file('INSERT.sql')
