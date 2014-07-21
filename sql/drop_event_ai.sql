-- Drop EventAI wehn using same Scripts in lua.

DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (6, 38, 61, 80);
DELETE FROM `creature_ai_texts` WHERE `entry` IN (-2, -3, -4, -7, -8);

UPDATE `creature_template` SET `AIName` = '' WHERE `entry` IN (6, 38, 61, 80)
