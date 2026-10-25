'use strict';
const fs=require('node:fs'),path=require('node:path'),root=path.resolve(__dirname,'..');
const file=path.join(root,'client/spacemap/graphics/ui/windows/crafting/upgrade/upgradeWindowUI.xml');
let xml=fs.readFileSync(file,'utf8');
if(xml.includes('name="bulkUpgrade"'))throw Error('Bulk UI already installed');
const panel=`            <container name="bulkUpgrade" width="510" height="52" mouseEnabled="false">
                <button name="weapons" marginLeft="150" width="130" height="21" text="[ ] Tüm silahlar" registeredSkinName="commonui_smallbutton_blue"/>
                <button name="shields" marginLeft="285" width="130" height="21" text="[ ] Tüm kalkanlar" registeredSkinName="commonui_smallbutton_blue"/>
                <button name="refresh" marginLeft="420" width="70" height="21" text="Yenile" registeredSkinName="commonui_smallbutton_blue"/>
                <label name="cost" marginLeft="20" marginTop="25" width="315" height="32" wordWrap="true" multiline="true" text="Maliyet için eşya seç." registeredTextStyleName="bulk_upgrade_cost"/>
                <button name="build" marginLeft="345" marginTop="27" width="145" height="25" enabled="false" text="Maksimuma başlat" registeredSkinName="commonui_scale9_button_green"/>
            </container>

`;
const style='    <textstyle name="bulk_upgrade_cost" textColor="0xE9E2C0" type="dynamic" fontSize="9" wordWrap="true" multiline="true" embedFonts="false" fontName="Verdana" align="left"/>\n\n';
xml=xml.replace('    <!-- TEMPLATES -->',style+'    <!-- TEMPLATES -->');
xml=xml.replace('            <container name="filterEmptyItemsContainer"',panel+'            <container name="filterEmptyItemsContainer"');
xml=xml.replace('                       marginTop="26"','                       marginTop="69"').replace('                           marginTop="79"','                           marginTop="36"');
fs.writeFileSync(file,xml);console.log('Native Upgrade bulk bar installed; original bottom layout retained by redistributing 43px existing gap.');
