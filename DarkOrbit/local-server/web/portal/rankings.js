'use strict';
const esc=s=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const num=n=>Number(n||0).toLocaleString('tr-TR',{maximumFractionDigits:2});
function rows(list){return list.map((p,n)=>`<tr class="${n%2?'none':'rankingOdd'}"><td>${esc(p.name)}</td><td>${['','MMO','EIC','VRU'][p.factionId]||''}</td><td><img src="/client/do_img/global/ranks/rank_${p.dailyRank}.png" alt="${esc(require('../../game/ranks').NAMES[p.dailyRank]||'')}"/> ${p.position}</td><td>${num(p.userPoints)}</td></tr>`).join('')||'<tr><td colspan="4">Henüz yerel oyuncu kaydı yok.</td></tr>';}
function replaceDiv(html,id,content){
 const re=new RegExp('<div\\b[^>]*id="'+id+'"[^>]*>'),m=re.exec(html);if(!m)return html;
 const tags=/<\/?div\b[^>]*>/g;tags.lastIndex=m.index+m[0].length;let depth=1,t;
 while((t=tags.exec(html))){depth+=t[0].startsWith('</')?-1:1;if(!depth)return html.slice(0,m.index+m[0].length)+content+html.slice(t.index);}
 throw Error('Ranking template is unclosed');
}
function decorate(html,player,{hall=false}={}){
 const db=require('../../game/db').open(),rank=require('../../game/ranks'),list=rank.leaderboard(db),own=rank.current(db,player.userId);
 html=html.replace(/(<img\b[^>]*id="userRankIcon"[^>]*>)\s*[^<]*/,(_,image)=>image+' '+esc(rank.NAMES[own.dailyRank]||'Uzay Pilotu'));
 html=html.replace(/(<table\b[^>]*id="ranking_Users"[^>]*>)[\s\S]*?<\/table>/,(_,tag)=>tag+'<tr class="rankingHeadline"><td>İsim</td><td>Şirket</td><td>Sıra</td><td>Puan</td></tr>'+rows(list.slice(0,10))+'</table>');
 html=html.replace(/(<table\b[^>]*id="ranking_Clans"[^>]*>)[\s\S]*?<\/table>/,(_,tag)=>tag+'<tr><td>Yerel solo sunucuda klan sıralaması yok.</td></tr></table>');
 if(!hall)return html;
 const labels={experience:'Tecrübe / 100.000',honour:'Şeref / 100',playerKills:'Oyuncu puanları × 3',level:'Seviye × 100',days:'Hesap günü × 6',ship:'Gemi türü × 1.000',npcKills:'NPC puanları / 2',quests:'Tamamlanan görev × 100',friendlyKills:'Dost imhası cezası',enemyDeaths:'Oyuncuya ölüm cezası',radiationDeaths:'Radyasyon cezası',phoenixKills:'Phoenix cezası'};
 const detail=Object.entries(own.breakdown).map(([key,value])=>`<tr><td>${labels[key]||key}</td><td>${num(value)}</td></tr>`).join('');
 return replaceDiv(html,'mainContainerContent',`<div style="padding:18px;color:#ddd"><div class="infoContainerHeadline">ŞEREF SALONU</div><table class="homeRankingTable" style="width:100%"><tr class="rankingHeadline"><td>Pilot</td><td>Şirket</td><td>Sıra</td><td>Kullanıcı puanı</td></tr>${rows(list)}</table><h3>Bugünkü rütben: ${esc(rank.NAMES[own.dailyRank]||'')}</h3><p>Rütbe puanı: ${num(own.points)} · Günlük hesap: ${esc(own.day)}</p>${own.eligible?'':'<p>Rütbe dağılımı için en az 2. seviye ve 4 haftalık hesap gerekir.</p>'}<table style="width:100%">${detail}</table><p>Kullanıcı sıralaması TP/1.000 + şeref/100 ile; rütbe rozeti ayrı rütbe puanıyla hesaplanır.</p></div>`);
}
module.exports={decorate,replaceDiv};
