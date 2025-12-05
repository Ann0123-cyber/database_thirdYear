/*
  Warnings:

  - You are about to drop the column `description` on the `task` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "task" DROP COLUMN "description",
ADD COLUMN     "details" TEXT;
