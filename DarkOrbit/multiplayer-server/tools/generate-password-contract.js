'use strict';
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const salt='0123456789abcdef0123456789abcdef';
const cases=['pilot-qa-pass','Türkçe 🚀 şifre',' spaces are preserved '].map(password=>({password,stored:salt+':'+crypto.scryptSync(password,salt,32).toString('hex')}));
fs.writeFileSync(path.join(__dirname,'../artifacts/password-contract.json'),JSON.stringify({synthetic:true,cases},null,2)+'\n');
console.log('Generated three synthetic Node scrypt compatibility fixtures; no real account credentials');
