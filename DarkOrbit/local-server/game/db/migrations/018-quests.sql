-- Pin accepted objectives and rewards. Existing quest statuses/progress stay intact.
ALTER TABLE player_quests ADD COLUMN snapshot_json TEXT;
ALTER TABLE quest_definitions ADD COLUMN constraints_json TEXT NOT NULL DEFAULT '{}';
UPDATE player_quests SET snapshot_json=(
  SELECT json_object('definition',json(d.definition_json),'constraints',json(d.constraints_json))
  FROM quest_definitions d WHERE d.id=player_quests.quest_id
);
CREATE TABLE quest_reward_claims (
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  quest_id INTEGER NOT NULL REFERENCES quest_definitions(id),
  reward_json TEXT NOT NULL,
  claimed_at INTEGER NOT NULL,
  PRIMARY KEY (player_id,quest_id)
);
INSERT INTO quest_reward_claims(player_id,quest_id,reward_json,claimed_at)
SELECT p.player_id,p.quest_id,json_extract(d.definition_json,'$.rewards'),coalesce(p.completed_at,p.accepted_at)
FROM player_quests p JOIN quest_definitions d ON d.id=p.quest_id WHERE p.status='completed';
CREATE TABLE quest_event_receipts (
  player_id INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL,
  event_id TEXT NOT NULL,
  recorded_at INTEGER NOT NULL,
  PRIMARY KEY(player_id,event_type,event_id)
);
CREATE INDEX player_quests_running ON player_quests(player_id,status);
