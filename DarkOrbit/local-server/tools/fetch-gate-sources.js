'use strict';
// Public, unauthenticated official FAQ snapshots for reproducible NPC research.
const fs = require('node:fs'), path = require('node:path'), crypto = require('node:crypto');
const sources = {
  'npc-standard-en': 'https://board-en.darkorbit.com/threads/npc-standard-aliens.1005/',
  'npc-boss-en': 'https://board-en.darkorbit.com/threads/boss-alien-faq.801/',
  'npc-uber-en': 'https://board-en.darkorbit.com/threads/uber-alien-faq.885/',
  'npc-de': 'https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/',
  'npc-de-page2': 'https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/page-2',
  'zeta-en': 'https://board-en.darkorbit.com/threads/zeta-gate-faq.852/',
  'epsilon-en': 'https://board-en.darkorbit.com/threads/epsilon-gate-faq.829/',
  'group-npc-en': 'https://board-en.darkorbit.com/threads/group-gate-faq.969/',
  'npc-es': 'https://board-es.darkorbit.com/threads/faqs-aliens.135697/'
};
async function main() {
  const dir = path.resolve(__dirname, '../decompiled/gate-source-evidence');
  fs.mkdirSync(dir, { recursive: true });
  for (const [name, url] of Object.entries(sources)) {
    if (process.argv.length > 2 && !process.argv.slice(2).includes(name)) continue;
    const response = await fetch(url, { signal: AbortSignal.timeout(20000) });
    if (!response.ok) throw Error(`${response.status} ${url}`);
    const html = await response.text();
    if (!html.includes('messageContent')) throw Error(`Expected forum content missing: ${url}`);
    fs.writeFileSync(path.join(dir, name + '.html'), html);
    // Review text retains table boundaries as lines; raw HTML remains the source.
    const text = html.replace(/<script\b[\s\S]*?<\/script>/gi, '').replace(/<style\b[\s\S]*?<\/style>/gi, '')
      .replace(/<(?:br|\/div|\/p|\/tr|\/li)\b[^>]*>/gi, '\n').replace(/<[^>]+>/g, '')
      .replace(/&nbsp;/g, ' ').replace(/&amp;/g, '&').replace(/&#039;/g, "'").replace(/&quot;/g, '"')
      .replace(/[ \t]+/g, ' ').replace(/\n\s*\n/g, '\n');
    fs.writeFileSync(path.join(dir, name + '.txt'), text);
    fs.writeFileSync(path.join(dir, name + '.source.json'), JSON.stringify({ url, fetchedAt: new Date().toISOString(), sha256: crypto.createHash('sha256').update(html).digest('hex') }, null, 2));
    console.log(name + ': captured');
  }
}
main().catch(error => { console.error(error.message); process.exitCode = 1; });
