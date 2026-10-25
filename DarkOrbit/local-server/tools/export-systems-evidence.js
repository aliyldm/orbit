'use strict';
// Rebuild the static protocol fixtures without replaying recorded player state.
const fs = require('fs');
const path = require('path');
const codec = require('../game/codec/codec');
const files = ['session-6182-1.json', 'session-6182-2.json'];
const result = { source: files, defaults: {}, quests: [], gateInfo: null };
const definitions = new Map(), slim = new Map();
for (const file of files) {
  const packets = JSON.parse(fs.readFileSync(path.join(__dirname, '../logs', file), 'utf8'));
  for (const packet of packets) {
    let command;
    try { command = codec.decode(Buffer.from(packet.hex, 'hex')).obj; } catch { continue; }
    if (['UserSettingsCommand', 'UIWindowSettingsCommand', 'UserKeyBindingsUpdate'].includes(command._) && !result.defaults[command._])
      result.defaults[command._] = command;
    if (command._ === 'QuestListCommand') for (const quest of command.list) slim.set(quest.questId, quest);
    if (command._ === 'QuestInfoCommand') definitions.set(command.definition.id, command.definition);
    if (command._ === 'QuestInitializationCommand') definitions.set(command.quest.id, command.quest);
    if (command._ === 'GalaxyGateBuilderInfoCommand' && !result.gateInfo) result.gateInfo = command;
  }
}
for (const [id, definition] of definitions) result.quests.push({ definition, slim: slim.get(id) || null });
const destination = path.join(__dirname, '../game/handlers/systems-evidence.json');
fs.writeFileSync(destination, JSON.stringify(result, null, 2) + '\n');
console.log(`Wrote ${result.quests.length} quest definitions to ${destination}`);
