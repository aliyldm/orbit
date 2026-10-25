'use strict';
// Read-only catalogue audit. No player id / no database connection is needed.
const rows=require('../game/shop-product-audit').audit(require('../game/economy').offers());
const statuses={},types={};for(const r of rows){statuses[r.status]=(statuses[r.status]||0)+1;types[r.type]=(types[r.type]||0)+1;}
process.stdout.write(JSON.stringify({scope:'Captured native offers, canonical aliases and Payment components; capability classification is not a claim of exact original server formulas.',totalOffers:rows.length,statuses,types,rows},null,2)+'\n');
