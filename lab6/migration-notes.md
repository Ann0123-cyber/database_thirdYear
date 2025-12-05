Початкова схема (отримана через prisma db pull)

Проєкт містив таблиці:

User

board

comment

project

project_user

tag

task

task_assignee

task_tag

team

team_user

Жодної таблиці Review не було.
У User не було поля phone.
У таблиці task було поле description.
У таблиці project було поле description.


Міграція 1 — Додавання нової таблиці Review

Команда:

npx prisma migrate dev --name add-review-table

Було:

Таблиці Review не існувало.

Стало:

У schema.prisma додано:

model Review {
  reviewid  Int   @id @default(autoincrement())
  rating    Int
  comment   String?
  taskId    Int
  task      task @relation(fields: [taskId], references: [taskid])
}

Результат:

Створена нова таблиця з FK → task.

Міграція 2 — Додавання нового поля phone в таблицю User

Команда:

npx prisma migrate dev --name add-user-phone

Було:
position String? @db.VarChar(100)

Стало:
position String? @db.VarChar(100)
phone    String? @db.VarChar(20)

Результат:

У таблицю User додано нове опціональне поле phone.

Міграція 3 — Перейменування поля description → details у task

Команда:

npx prisma migrate dev --name rename-description-to-details

Було:
description String?

Стало:
details String?

Prisma не перейменовує поле — вона видаляє старе і створює нове.
База даних тепер має поле details.

Міграція 4 — Видалення поля description з таблиці project

Команда:

npx prisma migrate dev --name remove-project-description

Було:
description String?

Результат:
Таблиця project більше не містить description.

## Перевірка результатів через Prisma Studio

Команда:

npx prisma studio


Перевірено:

Таблиця Review — присутня
У User є поле phone
У task є поле details і немає description
У project немає description

