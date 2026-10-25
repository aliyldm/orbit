'use strict';
// Curated official FAQ facts, NOT values inferred from NPC graphics.
// The selected source editions and conflicts are recorded in docs/npc-catalog-local.md.
const SOURCES = {
  normal: 'https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/',
  normal2: 'https://board-de.darkorbit.com/threads/faq-npc-daten-mit-bildern.2812/page-2',
  speeds: 'https://board-en.darkorbit.com/threads/npc-standard-aliens.1005/',
  bossSpeeds: 'https://board-en.darkorbit.com/threads/boss-alien-faq.801/',
  zeta: 'https://board-en.darkorbit.com/threads/zeta-gate-faq.852/',
  epsilon: 'https://board-en.darkorbit.com/threads/epsilon-gate-faq.829/',
  special: 'https://board-es.darkorbit.com/threads/faqs-aliens.135697/'
};
// key, client visual type, name, HP, shield, speed, min/max damage, EP, honour, credits, URI.
const rows = [
  ['streuner',84,'Streuner',800,400,270,10,20,400,2,400,1],
  ['lordakia',71,'Lordakia',2000,2000,320,80,100,800,4,800,2],
  ['saimon',75,'Saimon',6000,3000,320,200,250,1600,8,1600,4],
  ['mordon',73,'Mordon',20000,10000,125,300,390,3200,16,6400,8],
  ['devolarium',72,'Devolarium',100000,100000,200,1000,1200,6400,32,51200,16],
  ['sibelon',74,'Sibelon',200000,200000,100,2650,2650,12800,64,102400,32],
  ['sibelonit',76,'Sibelonit',40000,40000,320,1000,1500,3200,16,12800,12],
  ['lordakium',77,'Lordakium',300000,200000,230,3150,3600,25600,128,204800,64],
  ['kristallin',78,'Kristallin',50000,40000,320,1500,1650,6400,32,12800,16],
  ['kristallon',79,'Kristallon',400000,300000,250,4050,4988,51200,256,409600,128],
  ['protegit',81,'Protegit',50000,40000,420,1300,1500,6400,32,12800,16],
  ['cubikon',80,'Cubikon',1600000,1200000,30,0,0,512000,4096,1638400,1024],
  ['streuner-upper',85,'StreuneR',20000,10000,280,400,900,3200,16,6400,8],
  ['boss-streuner',23,'Boss Streuner',3200,1600,250,100,120,1600,8,1600,4],
  ['boss-lordakia',24,'Boss Lordakia',8000,8000,400,295,350,3200,16,3200,8],
  ['boss-saimon',25,'Boss Saimon',24000,12000,300,600,720,6400,32,6400,16],
  ['boss-mordon',31,'Boss Mordon',80000,40000,150,1300,1500,12800,64,25600,32],
  ['boss-devolarium',26,'Boss Devolarium',400000,400000,160,4100,4650,25600,128,204800,64],
  ['boss-sibelon',46,'Boss Sibelon',800000,800000,175,9100,12350,51200,256,409600,128],
  ['boss-sibelonit',27,'Boss Sibelonit',160000,160000,300,3175,4350,12800,64,51200,48],
  ['boss-lordakium',28,'Boss Lordakium',1200000,800000,200,10000,16000,102400,512,819200,256],
  ['boss-kristallin',29,'Boss Kristallin',200000,160000,340,3600,4700,25600,128,51200,64],
  ['boss-kristallon',35,'Boss Kristallon',1600000,1200000,250,15000,20000,204800,1024,1638400,512],
  ['boss-streuner-upper',34,'Boss StreuneR',80000,40000,200,1500,2000,12800,64,25600,32],
  ['uber-streuner',36,'Uber Streuner',6400,3200,300,160,270,3200,16,3200,8],
  ['uber-lordakia',37,'Uber Lordakia',16000,16000,300,500,700,6400,32,6400,16],
  ['uber-saimon',38,'Uber Saimon',48000,24000,300,1200,1440,12800,64,12800,32],
  ['uber-mordon',43,'Uber Mordon',160000,80000,300,2600,3100,25600,128,51200,64],
  ['uber-devolarium',39,'Uber Devolarium',800000,800000,300,8200,9300,51200,256,409600,128],
  ['uber-sibelon',47,'Uber Sibelon',1600000,1600000,300,18200,24700,102400,512,819200,256],
  ['uber-sibelonit',40,'Uber Sibelonit',320000,320000,300,6350,8700,25600,128,102400,96],
  ['uber-lordakium',41,'Uber Lordakium',2400000,1600000,300,20000,31000,204800,1024,1638400,512],
  ['uber-kristallin',42,'Uber Kristallin',400000,320000,300,7900,9400,51200,256,102400,128],
  ['uber-kristallon',45,'Uber Kristallon',3200000,2400000,300,30000,45000,409600,2048,3276800,1024],
  ['uber-streuner-upper',44,'Uber StreuneR',160000,80000,300,3000,4000,25600,128,51200,64],
  ['infernal',100,'Infernal',60000,50000,300,900,1000,8000,4,25000,16],
  ['scorcher',99,'Scorcher',200000,200000,300,2000,3000,15000,8,150000,32],
  ['melter',102,'Melter',400000,300000,300,3500,5000,55000,12,400000,256],
  ['devourer',105,'Devourer',2000000,1000000,300,1500,2000,1000000,512,2500000,1024],
  ['vagrant',94,'Vagrant',40000,40000,300,1900,2500,2000,4,2000,8],
  ['marauder',93,'Marauder',100000,60000,300,3500,4500,4500,8,4500,16],
  ['outcast',92,'Outcast',150000,80000,300,3800,5000,7500,12,7500,24],
  ['hooligan',96,'Hooligan',250000,200000,300,7000,9000,12000,16,15000,32],
  ['ravager',97,'Ravager',300000,200000,300,8000,11000,15000,64,20000,128],
  ['corsair',91,'Corsair',200000,120000,300,6000,8000,10000,32,12000,64],
  ['convict',95,'Convict',400000,200000,300,9500,12000,18000,64,25000,128],
  ['epsilon-vagrant',94,'Vagrant',60000,40000,300,2000,2500,4000,4,15000,8],
  ['epsilon-marauder',93,'Marauder',80000,60000,300,4000,4500,8000,8,30000,16],
  ['epsilon-outcast',92,'Outcast',150000,100000,300,4000,4500,11000,12,50000,24],
  ['epsilon-corsair',91,'Corsair',180000,120000,300,6200,7800,15000,16,80000,32],
  ['epsilon-hooligan',96,'Hooligan',250000,200000,300,7200,9000,20000,32,125000,64],
  ['epsilon-ravager',97,'Ravager',300000,250000,300,8500,10700,25000,64,160000,128],
  ['epsilon-convict',95,'Convict',450000,300000,300,9500,11500,30000,100,220000,150],
  ['century-falcon',90,'Century Falcon',4000000,3000000,300,19000,25000,1000000,5000,1000000,5000],
  ['demaner',11,'DemaNeR',400000,300000,300,3580,4850,51200,512,409600,128],
  ['kucurbium',82,'Kucurbium',1600000,1200000,300,15000,30000,204800,1024,3276800,512],
  ['boss-kucurbium',83,'Boss Kucurbium',6400000,4800000,300,45000,70000,819200,4096,13107200,2048],
  ['kappa-kucurbium',82,'Kucurbium',320000,1200000,200,5000,7000,204800,1024,3276800,512],
  ['kappa-boss-kucurbium',83,'Boss Kucurbium',640000,480000,200,30000,40000,819200,4096,13107200,2048],
  ['kappa-century-falcon',90,'Century Falcon',800000,600000,100,19000,25000,1000000,5000,1000000,5000],
  ['kappa-demaner',11,'DemaNeR',512000,256000,300,3500,5000,51200,512,409600,256],
  ['icy',103,'Icy',80000,60000,475,1300,1900,6400,32,12800,16],
  ['interceptor',111,'Interceptor',60000,40000,300,350,500,7500,24,25000,20],
  ['barracuda',112,'Barracuda',180000,100000,300,4500,6000,15000,56,90000,25],
  ['saboteur',113,'Saboteur',200000,150000,300,3000,4000,22500,72,125000,45],
  ['annihilator',114,'Annihilator',300000,200000,300,12000,14000,75000,128,250000,65],
  ['battleray',115,'Battleray',330000,260000,300,4800,6400,89964,200,1160000,116],
  ['uber-interceptor',257,'Uber Interceptor',480000,320000,600,4000,4000,30000,100,100000,80],
  ['uber-barracuda',255,'Uber Barracuda',1400000,800000,400,48000,48000,60000,100,360000,80],
  ['uber-annihilator',254,'Uber Annihilator',2400000,1600000,320,90000,90000,300000,200,100000,220],
  ['uber-saboteur',258,'Uber Saboteur',1600000,1200000,400,32000,32000,90000,130,500000,150],
  ['uber-battleray',256,'Uber Battleray',2640000,2080000,350,12800,12800,320000,300,4000000,300],
  ['emperor-sibelon',124,'Emperor Sibelon',6400000,6400000,300,35000,35000,409600,2048,1400000,4608],
  ['emperor-lordakium',123,'Emperor Lordakium',9600000,6400000,300,45000,45000,786000,4096,2000000,9216],
  ['emperor-kristallon',122,'Emperor Kristallon',14080000,11100000,300,45000,45000,1536000,8192,5000000,36864],
  ['streuner-soldier',150,'Streuner Soldier',150000,150000,300,2000,5000,12000,40,100000,80],
  ['streuner-specialist',149,'Streuner Specialist',450000,300000,300,5000,7000,20000,70,200000,200],
  ['streuner-turret',148,'Streuner Guard Turret',300000,300000,0,3000,5000,18000,50,180000,100],
  ['streuner-emperor',147,'Emperor Streuner',650000,700000,300,2000,3000,30000,150,400000,6000],
  ['streuner-rocketeer',158,'Streuner Rocketeer',20000,10000,300,200,200,3200,16,6400,10]
];
const knownPirateSpeeds = new Set(['uber-interceptor','uber-barracuda','uber-annihilator','uber-saboteur','uber-battleray']);
const localSpeed = new Set(rows.filter(r => !r[0].startsWith('kappa-') && !knownPirateSpeeds.has(r[0]) && (r[0].startsWith('uber-') || (r[1] >= 90 && !['icy','streuner-turret'].includes(r[0])) || ['demaner','kucurbium','boss-kucurbium'].includes(r[0]))).map(r => r[0]));
const definitions = Object.fromEntries(rows.map(([key,typeId,name,hitpoints,shield,speed,damageMin,damageMax,ep,honour,credits,uridium]) => [key,
  { key,typeId,name,hitpoints,shield,speed,damageMin,damageMax,reward:{ep,honour,credits,uridium},localSpeed:localSpeed.has(key) }]));
function get(key, scale = 1) {
  const d = definitions[key];
  if (!d) throw Error(`NPC catalogue key missing: ${key}`);
  if (!Number.isFinite(scale) || scale <= 0 || scale > 100) throw Error('Invalid NPC scale');
  return { ...d, hitpoints:Math.round(d.hitpoints*scale), shield:Math.round(d.shield*scale),
    damageMin:Math.round(d.damageMin*scale),damageMax:Math.round(d.damageMax*scale),
    reward:Object.fromEntries(Object.entries(d.reward).map(([k,n])=>[k,Math.round(n*scale)])),
    shieldAbsorb:.5, aggressive:true, respawnMs:0 };
}
function seed(db) {
  const insert = db.prepare('INSERT OR IGNORE INTO npc_types(type_id,name,hitpoints,shield,speed,damage_min,damage_max,reward_ep,reward_honour,reward_credits,reward_uridium)VALUES(?,?,?,?,?,?,?,?,?,?,?)');
  for (const d of Object.values(definitions)) insert.run(d.typeId,d.name,d.hitpoints,d.shield,d.speed,d.damageMin,d.damageMax,d.reward.ep,d.reward.honour,d.reward.credits,d.reward.uridium);
}
module.exports = { definitions, get, seed, SOURCES };
