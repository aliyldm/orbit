'use strict';
// Single-class JPEXS patch. All native layout/assets and the existing bulk move
// algorithm/model response are retained. Never executes the Flash artifact.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),zlib=require('node:zlib'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..'),evidence=path.join(root,'decompiled/drone-bulk-patch'),className='net.bigpoint.darkorbit.equipment.view.components.items.DragComponent';
const java=process.env.DARKORBIT_JAVA||'C:\\Program Files\\Java\\jdk-21.0.12.1\\bin\\java.exe',jar=process.env.DARKORBIT_FFDEC||'D:\\swfde\\ffdec.jar';
const original=path.resolve(process.argv[2]||path.join(evidence,'inventory-before.swf')),output=path.resolve(process.argv[3]||path.join(evidence,'inventory-patched.swf'));
const sha=b=>crypto.createHash('sha256').update(b).digest('hex');
function run(args,log){const result=spawnSync(java,['-jar',jar,...args],{cwd:root,encoding:'utf8',windowsHide:true,maxBuffer:8*1024*1024});fs.writeFileSync(path.join(evidence,log),(result.stdout||'')+(result.stderr||''));if(result.error||result.status!==0)throw result.error||Error('JPEXS failed: '+log);}
function tags(b){if(b.toString('ascii',0,3)==='CWS')b=Buffer.concat([Buffer.from('FWS'),b.subarray(3,8),zlib.inflateSync(b.subarray(8))]);if(b.toString('ascii',0,3)!=='FWS')throw Error('Expected FWS/CWS');let at=8+Math.ceil((5+4*(b[8]>>3))/8)+4;const result=[];while(at<b.length){const h=b.readUInt16LE(at);at+=2;const tag=h>>6;let size=h&63;if(size===63){size=b.readUInt32LE(at);at+=4;}if(at+size>b.length)throw Error('Truncated SWF tag');result.push({tag,size,sha256:sha(b.subarray(at,at+size))});at+=size;}return result;}
fs.mkdirSync(evidence,{recursive:true});const sourceFile=path.join(evidence,'actual-before/scripts',className.replaceAll('.',path.sep)+'.as');
run(['-selectclass',className,'-export','script',path.join(evidence,'actual-before'),original],'before-export.log');
const beforeSource=fs.readFileSync(sourceFile,'utf8'),anchor='      private function rearrangeItem(param1:IMenuView) : void\r\n      {\r\n';
const guard='         if(param1.getCurrentlyOpenMenu() == ActionIdentifiers.DRONES && this._currentDraggedIcon.menuSectionComponent.getContainingViewID() == Settings.INVENTORY_NAME && this.multiSelection != null && this.multiSelection.length > 1 && this.currentIconIsPartOfSelection())\r\n         {\r\n            this.handleMultiSectionQuickMove(param1,new Transporter());\r\n            return;\r\n         }\r\n';
if(!beforeSource.includes(anchor)||beforeSource.includes(guard))throw Error('Expected unpatched native DragComponent');
const patched=beforeSource.replace(anchor,anchor+guard),source=path.join(evidence,'source/DragComponent.as');fs.mkdirSync(path.dirname(source),{recursive:true});fs.writeFileSync(source,patched);
run(['-replace',original,output,className,source],'compile.log');if(!fs.existsSync(output))throw Error('No compiled artifact');
run(['-selectclass',className,'-export','script',path.join(evidence,'actual-after'),output],'verify.log');
const after=fs.readFileSync(path.join(evidence,'actual-after/scripts',className.replaceAll('.',path.sep)+'.as'),'utf8');
if(after.replaceAll('Number(NaN)','NaN')!==patched)throw Error('Re-decompiled class differs outside intended guard');
const a=fs.readFileSync(original),b=fs.readFileSync(output),ta=tags(a),tb=tags(b);
if(ta.length!==tb.length)throw Error('Unexpected tag inventory change');
const differences=ta.flatMap((v,i)=>v.sha256!==tb[i].sha256?[{index:i,before:v,after:tb[i]}]:[]);
if(!differences.length||differences.some(v=>v.before.tag!==82||v.after.tag!==82))throw Error('Unexpected non-DoABC changes');
const record={className,sourceSha256:sha(a),patchedSha256:sha(b),beforeBytes:a.length,afterBytes:b.length,sourceAS:sha(Buffer.from(beforeSource)),patchedAS:sha(Buffer.from(patched)),verifiedAS:sha(Buffer.from(after)),unchangedNonAbcTags:ta.length-differences.length,tagDifferences:differences,guard,limitations:['Static compilation/re-decompilation validation; native Flash mouse gesture is not executed by this tool.']};
fs.writeFileSync(path.join(evidence,'evidence.json'),JSON.stringify(record,null,2));console.log(JSON.stringify({source:record.sourceSha256,patched:record.patchedSha256,unchangedNonAbcTags:record.unchangedNonAbcTags,abcTagsChanged:differences.length,output}));
