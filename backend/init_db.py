from sqlalchemy import create_engine
from models import Base
from config import DATABASE_URI

def init_database():
    engine = create_engine(DATABASE_URI)
    Base.metadata.create_all(engine)
    print("数据库表已创建")

if __name__ == "__main__":
    init_database() 