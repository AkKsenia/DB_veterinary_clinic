import random
from random import randint

import psycopg2
from psycopg2 import Error

from faker import Faker
fake = Faker(['en_US', 'ru'])

AMOUNT_OF_USERS = 100000


def fill_pet():
    SEX = ['male', 'female']
    AGE =
    REGISTRATION_DATE =
    SPECIES =
    NICKNAME = fake.name()
    WEIGHT =
    CONDITION_ =
    HEIGHT =


    query = 'INSERT INTO interface (appearance, sound, app_icon, font_size, language_) VALUES '

    for i in range(AMOUNT_OF_USERS):
        appearance = random.choice(APPEARANCE)
        sound = random.choice(SOUND)
        app_icon = random.choice(APP_ICON)
        font_size = random.choice(FONT_SIZE)
        language = random.choice(LANGUAGE)

        # используем f-строки
        query += f'(\'{appearance}\', \'{sound}\', \'{app_icon}\', \'{font_size}\', \'{language}\'), '

    # все кроме 2 последних элементов (там запятая и пробел)
    query = query[:-2]
    query += ';'

    return query


def fill_interface():
    APPEARANCE = ['blue', 'pink', 'green', 'yellow', 'black', 'grey', 'white']
    SOUND = ['beep', 'drum', 'blocks', 'chimes', 'crystal', 'harp', 'ladder', 'lattice', 'leap', 'matrix', 'music box', 'pulse', 'spiral']
    APP_ICON = ['default', 'red christmas', 'green christmas']
    FONT_SIZE = ['system default', 'standard', 'large']
    LANGUAGE = ['русский', 'english', '中文', 'العربية', 'español', 'português', '日本語', 'deutsch']

    query = 'INSERT INTO interface (appearance, sound, app_icon, font_size, language_) VALUES '

    for i in range(AMOUNT_OF_USERS):
        appearance = random.choice(APPEARANCE)
        sound = random.choice(SOUND)
        app_icon = random.choice(APP_ICON)
        font_size = random.choice(FONT_SIZE)
        language = random.choice(LANGUAGE)

        # используем f-строки
        query += f'(\'{appearance}\', \'{sound}\', \'{app_icon}\', \'{font_size}\', \'{language}\'), '

    # все кроме 2 последних элементов (там запятая и пробел)
    query = query[:-2]
    query += ';'

    return query


def fill_users():
    query = 'INSERT INTO users (interface_id, password_, email, nickname, path_to_photo) VALUES '

    for i in range(AMOUNT_OF_USERS):
        interface_id = i + 1
        password = fake.password(length=randint(6,64))
        email = fake.ascii_free_email()
        path_to_photo = fake.file_path(depth=3, category='image')
        nickname = fake.name()

        query += f'(\'{interface_id}\', \'{password}\', \'{email}\', \'{nickname}\', \'{path_to_photo}\'), '

    query = query[:-2]
    query += ';'

    return query


def fill_achievements():
    query = 'INSERT INTO achievements (score, level_, name_) VALUES '

    for i in range(AMOUNT_OF_USERS):
        score = fake.random_int(0, 200000)

        if 0 <= score < 100:
            level = 1
            name = 'beginner'
        elif 100 <= score < 300:
            level = 2
            name = 'primary'
        elif 300 <= score < 700:
            level = 3
            name = 'hardworker'
        elif 700 <= score < 1400:
            level = 4
            name = 'challenger'
        elif 1400 <= score < 3000:
            level = 5
            name = 'rising star'
        elif 3000 <= score < 6000:
            level = 6
            name = 'freestyle'
        elif 6000 <= score < 10000:
            level = 7
            name = 'skyrocket'
        elif 10000 <= score < 20000:
            level = 8
            name = 'superhero'
        elif 20000 <= score < 50000:
            level = 9
            name = 'legend'
        elif 50000 <= score < 100000:
            level = 10
            name = 'epic'
        elif 100000 <= score < 200000:
            level = 11
            name = 'platinum'
        elif 200000 <= score:
            level = 12
            name = 'diamond'

        query += f'(\'{score}\', \'{level}\', \'{name}\'), '

    query = query[:-2]
    query += ';'

    return query


def fill_list():
    COLOUR = ['none', 'blue', 'pink', 'green', 'yellow']

    query = 'INSERT INTO list (name_, colour) VALUES '

    for i in range(AMOUNT_OF_USERS):
        name = fake.word()
        colour = random.choice(COLOUR)

        query += f'(\'{name}\', \'{colour}\'), '

    query = query[:-2]
    query += ';'

    return query


def fill_task():
    PRIORITY = ['no priority', 'low priority', 'medium priority', 'high priority']
    IS_DONE = ['true', 'false']

    query = 'INSERT INTO task (content_, priority, is_done, date_) VALUES '

    for i in range(AMOUNT_OF_USERS):
        content = fake.paragraph(nb_sentences=fake.random_int(1, 5))
        priority = random.choice(PRIORITY)
        is_done = random.choice(IS_DONE)
        date = fake.date_this_decade()

        query += f'(\'{content}\', \'{priority}\', \'{is_done}\', \'{date}\'), '

    query = query[:-2]
    query += ';'

    return query


def fill_reminder():
    FREQUENCY = ['every hour', 'every day', 'every week', 'every month', 'every year']

    query = 'INSERT INTO reminder (task_id, time_, frequency) VALUES '

    for i in range(AMOUNT_OF_USERS):
        task_id = i + 1
        time = fake.time()
        frequency = random.choice(FREQUENCY)

        query += f'(\'{task_id}\', \'{time}\', \'{frequency}\'), '

    query = query[:-2]
    query += ';'

    return query


def fill_tag():
    query = 'INSERT INTO tag (name_) VALUES '

    for i in range(AMOUNT_OF_USERS):
        name = fake.word()

        query += f'(\'{name}\'), '

    query = query[:-2]
    query += ';'

    return query


def fill_list_to_users():
    query = 'INSERT INTO list_to_users (list_id, user_id) VALUES '

    for i in range(AMOUNT_OF_USERS):
        list_id = i + 1
        user_id = i + 1

        query += f'(\'{list_id}\', \'{user_id}\'), '

    query = query[:-2]
    query += ';'

    return query


def fill_task_to_list():
    query = 'INSERT INTO task_to_list (task_id, list_id) VALUES '

    for i in range(AMOUNT_OF_USERS):
        task_id = i + 1
        list_id = i + 1

        query += f'(\'{task_id}\', \'{list_id}\'), '

    query = query[:-2]
    query += ';'

    return query


def fill_task_to_tag():
    query = 'INSERT INTO task_to_tag (task_id, tag_id) VALUES '

    for i in range(AMOUNT_OF_USERS):
        task_id = i + 1
        tag_id = i + 1

        query += f'(\'{task_id}\', \'{tag_id}\'), '

    query = query[:-2]
    query += ';'

    return query


def fill_users_to_achievements():
    query = 'INSERT INTO users_to_achievements (user_id, achievement_id) VALUES '

    for i in range(AMOUNT_OF_USERS):
        user_id = i + 1
        achievement_id = i + 1

        query += f'(\'{user_id}\', \'{achievement_id}\'), '

    query = query[:-2]
    query += ';'

    return query


def main():
    try:
        # подключение к существующей базе данных
        connection = psycopg2.connect(user="postgres", password="190190", host="localhost", port="5432", database="TickTick")

        # класс курсор для выполнения операций с базой данных
        cursor = connection.cursor()

        # выполнение SQL-запроса для вставки данных в таблицу
        cursor.execute(fill_interface())
        cursor.execute(fill_users())
        cursor.execute(fill_achievements())
        cursor.execute(fill_list())
        cursor.execute(fill_task())
        cursor.execute(fill_reminder())
        cursor.execute(fill_tag())
        cursor.execute(fill_list_to_users())
        cursor.execute(fill_task_to_list())
        cursor.execute(fill_task_to_tag())
        cursor.execute(fill_users_to_achievements())

        connection.commit()

    except (Exception, Error) as error:
        print("Ошибка при работе с PostgreSQL", error)
    finally:
        if connection:
            cursor.close()
            connection.close()
            print("Соединение с PostgreSQL закрыто")


main()
