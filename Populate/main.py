import sys
from os import path, getenv
from dotenv import load_dotenv
from gen import DataGenerator
from tablesdata import TableData
import psycopg2 as pg

def get_path(file_name:str) -> str:
    return path.join(path.dirname(path.dirname(__file__)), "Migrations", file_name)

def data_to_file(data:dict[str, list['TableData']], file_name:str) -> None:
    file_path = get_path(file_name)
    with open(file_path, 'w', encoding='utf-8') as file:
        for table_name, rows in data.items():
            print(f'Generando {len(rows)} {table_name}')
            for row in rows:
                query = row.to_psql_insert()
                file.write(query + '\n')
        file.close()

def data_to_db(data:dict[str, list['TableData']]) -> None:
    conn = pg.connect(
        host=getenv('PG_HOST'),
        database=getenv('PG_DATABASE'),
        user=getenv('PG_USER'),
        password=getenv('PG_PASSWORD')
    )
    cursor = conn.cursor()
    for table_name, rows in data.items():
        print(f'Insertando {len(rows)} {table_name}')
        for row in rows:
            query = row.to_psql_insert()
            cursor.execute(query)
        conn.commit()
    cursor.close()

def main(arg:str) -> None:
    gen = DataGenerator(
        n_articulos=400,
        n_autores=50,
        n_revisores=50,
    )
    gen.generate()
    data = gen.get_data()

    if arg == 'file':
        data_to_file(data, '02_INSERT.sql')
    else:
        data_to_db(data)

if __name__ == "__main__":
    load_dotenv()
    main(sys.argv[1] if len(sys.argv) > 1 else 'file')
