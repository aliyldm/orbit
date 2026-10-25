'use strict';
// SQLite veritabanı (Node'un yerleşik node:sqlite modülü). data/darkorbit.db.
// migrations/NNN-*.sql dosyaları sırayla ve bir kez uygulanır; ardından seed/ çalışır.

const fs = require('fs');
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const DB_FILE = path.join(__dirname, '..', '..', 'data', 'darkorbit.db');
const MIGRATIONS = path.join(__dirname, 'migrations');

let db = null;
let transactionId = 0;

function migrate(conn) {
  conn.exec('CREATE TABLE IF NOT EXISTS schema_migrations (name TEXT PRIMARY KEY, applied_at INTEGER NOT NULL)');
  const done = new Set(conn.prepare('SELECT name FROM schema_migrations').all().map(r => r.name));
  for (const file of fs.readdirSync(MIGRATIONS).filter(f => f.endsWith('.sql')).sort()) {
    if (done.has(file)) continue;
    conn.exec('BEGIN');
    try {
      conn.exec(fs.readFileSync(path.join(MIGRATIONS, file), 'utf8'));
      conn.prepare('INSERT INTO schema_migrations (name, applied_at) VALUES (?, ?)').run(file, Date.now());
      conn.exec('COMMIT');
      console.log(`[db] migration uygulandı: ${file}`);
    } catch (e) {
      conn.exec('ROLLBACK');
      throw e;
    }
  }
}

// Node's test workers must never migrate or seed the real account database on
// an implicit reopen (e.g. a cleanup handler after the test closes its DB).
function open(file = process.env.DARKORBIT_DB || (process.env.NODE_TEST_CONTEXT ? ':memory:' : DB_FILE)) {
  if (db) return db;
  fs.mkdirSync(path.dirname(file), { recursive: true });
  const conn = new DatabaseSync(file);
  try {
    conn.exec('PRAGMA journal_mode = WAL; PRAGMA foreign_keys = ON; PRAGMA busy_timeout = 5000;');
    migrate(conn);
    require('./seed').run(conn);
    require('../gate-rings').backfill(conn);
    db = conn;
    return db;
  } catch (err) {
    conn.close();
    throw err;
  }
}

// İşlem yardımcısı: fn hata atarsa geri alınır.
function tx(fn) {
  const conn = open();
  const nested = conn.isTransaction;
  const savepoint = `local_tx_${++transactionId}`;
  conn.exec(nested ? `SAVEPOINT ${savepoint}` : 'BEGIN IMMEDIATE');
  try {
    const r = fn(conn);
    if (r && typeof r.then === 'function') throw new TypeError('SQLite transaction callbacks must be synchronous');
    conn.exec(nested ? `RELEASE ${savepoint}` : 'COMMIT');
    return r;
  } catch (e) {
    if (conn.isTransaction) conn.exec(nested ? `ROLLBACK TO ${savepoint}; RELEASE ${savepoint}` : 'ROLLBACK');
    throw e;
  }
}

function close() {
  if (db) { db.close(); db = null; }
}

module.exports = { open, tx, close, DB_FILE };
