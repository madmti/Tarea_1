from faker import Faker
import psycopg2 as pg

#=============================================#
#   Funciones para generar datos aleatorios   #
#=============================================#

def generate_aut(faker:Faker):
    return {}

def generate_rev(faker:Faker):
    return {}

def generate_art(faker:Faker):
    return {}


#===================================================================#
#   Funciones para relacionar autores y revisores a los articulos   #
#===================================================================#

def get_auts_for_art():
    return []

def get_revs_for_art():
    return []



def connect():
    conexion = pg.connect(
        dbname="gescon",
        user="user",
        password="admin",
        host="localhost",
        port="5432"
    )
    cursor = conexion.cursor()
    return conexion, cursor

def populate():
    faker = Faker('es_ES')
    conexion, cursor = connect()

    for _ in range(50):
        aut = generate_aut(faker)
        rev = generate_rev(faker)
        query = f""
        cursor.execute(query)
    
    conexion.commit()

    for _ in range(400):
        art = generate_art(faker)
        query = f""
        cursor.execute(query)
    
    conexion.commit()

    cursor.close()
    conexion.close()

if __name__ == '__main__':
    populate()