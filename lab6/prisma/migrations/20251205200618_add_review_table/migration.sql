-- CreateTable
CREATE TABLE "User" (
    "userid" SERIAL NOT NULL,
    "fullname" VARCHAR(100) NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "passwordhash" VARCHAR(255) NOT NULL,
    "position" VARCHAR(100),

    CONSTRAINT "User_pkey" PRIMARY KEY ("userid")
);

-- CreateTable
CREATE TABLE "board" (
    "boardid" SERIAL NOT NULL,
    "boardname" VARCHAR(100) NOT NULL,
    "projectid" INTEGER,

    CONSTRAINT "board_pkey" PRIMARY KEY ("boardid")
);

-- CreateTable
CREATE TABLE "comment" (
    "commentid" SERIAL NOT NULL,
    "content" TEXT NOT NULL,
    "createdat" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "userid" INTEGER,
    "taskid" INTEGER,

    CONSTRAINT "comment_pkey" PRIMARY KEY ("commentid")
);

-- CreateTable
CREATE TABLE "project" (
    "projectid" SERIAL NOT NULL,
    "projectname" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "startdate" DATE NOT NULL,
    "enddate" DATE,
    "teamid" INTEGER,

    CONSTRAINT "project_pkey" PRIMARY KEY ("projectid")
);

-- CreateTable
CREATE TABLE "project_user" (
    "projectid" INTEGER NOT NULL,
    "userid" INTEGER NOT NULL,
    "role" VARCHAR(50) NOT NULL,

    CONSTRAINT "project_user_pkey" PRIMARY KEY ("projectid","userid")
);

-- CreateTable
CREATE TABLE "tag" (
    "tagid" SERIAL NOT NULL,
    "tagname" VARCHAR(50) NOT NULL,
    "color" VARCHAR(20),

    CONSTRAINT "tag_pkey" PRIMARY KEY ("tagid")
);

-- CreateTable
CREATE TABLE "task" (
    "taskid" SERIAL NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "status" VARCHAR(50) DEFAULT 'To Do',
    "priority" VARCHAR(20),
    "duedate" DATE,
    "boardid" INTEGER,

    CONSTRAINT "task_pkey" PRIMARY KEY ("taskid")
);

-- CreateTable
CREATE TABLE "task_assignee" (
    "userid" INTEGER NOT NULL,
    "taskid" INTEGER NOT NULL,

    CONSTRAINT "task_assignee_pkey" PRIMARY KEY ("userid","taskid")
);

-- CreateTable
CREATE TABLE "task_tag" (
    "taskid" INTEGER NOT NULL,
    "tagid" INTEGER NOT NULL,

    CONSTRAINT "task_tag_pkey" PRIMARY KEY ("taskid","tagid")
);

-- CreateTable
CREATE TABLE "team" (
    "teamid" SERIAL NOT NULL,
    "teamname" VARCHAR(100) NOT NULL,
    "description" TEXT,

    CONSTRAINT "team_pkey" PRIMARY KEY ("teamid")
);

-- CreateTable
CREATE TABLE "team_user" (
    "teamid" INTEGER NOT NULL,
    "userid" INTEGER NOT NULL,

    CONSTRAINT "team_user_pkey" PRIMARY KEY ("teamid","userid")
);

-- CreateTable
CREATE TABLE "Review" (
    "reviewid" SERIAL NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "taskId" INTEGER NOT NULL,

    CONSTRAINT "Review_pkey" PRIMARY KEY ("reviewid")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "board" ADD CONSTRAINT "board_projectid_fkey" FOREIGN KEY ("projectid") REFERENCES "project"("projectid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_taskid_fkey" FOREIGN KEY ("taskid") REFERENCES "task"("taskid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_userid_fkey" FOREIGN KEY ("userid") REFERENCES "User"("userid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project" ADD CONSTRAINT "project_teamid_fkey" FOREIGN KEY ("teamid") REFERENCES "team"("teamid") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_user" ADD CONSTRAINT "project_user_projectid_fkey" FOREIGN KEY ("projectid") REFERENCES "project"("projectid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "project_user" ADD CONSTRAINT "project_user_userid_fkey" FOREIGN KEY ("userid") REFERENCES "User"("userid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "task" ADD CONSTRAINT "task_boardid_fkey" FOREIGN KEY ("boardid") REFERENCES "board"("boardid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "task_assignee" ADD CONSTRAINT "task_assignee_taskid_fkey" FOREIGN KEY ("taskid") REFERENCES "task"("taskid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "task_assignee" ADD CONSTRAINT "task_assignee_userid_fkey" FOREIGN KEY ("userid") REFERENCES "User"("userid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "task_tag" ADD CONSTRAINT "task_tag_tagid_fkey" FOREIGN KEY ("tagid") REFERENCES "tag"("tagid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "task_tag" ADD CONSTRAINT "task_tag_taskid_fkey" FOREIGN KEY ("taskid") REFERENCES "task"("taskid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "team_user" ADD CONSTRAINT "team_user_teamid_fkey" FOREIGN KEY ("teamid") REFERENCES "team"("teamid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "team_user" ADD CONSTRAINT "team_user_userid_fkey" FOREIGN KEY ("userid") REFERENCES "User"("userid") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review_taskId_fkey" FOREIGN KEY ("taskId") REFERENCES "task"("taskid") ON DELETE RESTRICT ON UPDATE CASCADE;
