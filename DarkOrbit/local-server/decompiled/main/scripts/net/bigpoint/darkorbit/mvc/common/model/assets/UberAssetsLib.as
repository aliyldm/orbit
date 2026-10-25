package net.bigpoint.darkorbit.mvc.common.model.assets
{
   import com.bigpoint.utils.PointLite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.System;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapDotTrait;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapIconTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.LabelTrait;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.map.model.traits.PulsingRingTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberBackgroundDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.factory.ClickIconFactory;
   import net.bigpoint.darkorbit.map.model.traits.weapons.LaserCannon;
   import net.bigpoint.darkorbit.map.model.traits.weapons.RocketLauncher;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.utils.XMLUtils;
   
   public class UberAssetsLib
   {
      
      public static const LIB_DEFAULT:String = "lib_assets";
      
      public static const LIB_SHIPS:String = "lib_ships";
      
      public static const LIB_DRONES:String = "lib_drones";
      
      public static const LIB_PORTALS:String = "lib_portals";
      
      public static const LIB_COLLECTABLES:String = "lib_collectables";
      
      public static const LIB_BATTLE_STATION:String = "lib_battlestation";
      
      public static const LIB_MAPS:String = "lib_maps";
      
      public static const ALL_LIBRARIES:Vector.<String> = Vector.<String>([LIB_DEFAULT,LIB_SHIPS,LIB_DRONES,LIB_PORTALS,LIB_COLLECTABLES,LIB_BATTLE_STATION,LIB_MAPS]);
      
      private static const LIB_DEFAULT_XML:Class = UberAssetsLib_LIB_DEFAULT_XML;
      
      private static const LIB_SHIPS_XML:Class = UberAssetsLib_LIB_SHIPS_XML;
      
      private static const LIB_DRONES_XML:Class = UberAssetsLib_LIB_DRONES_XML;
      
      private static const LIB_PORTALS_XML:Class = UberAssetsLib_LIB_PORTALS_XML;
      
      private static const LIB_COLLECTABLES_XML:Class = UberAssetsLib_LIB_COLLECTABLES_XML;
      
      private static const LIB_BATTLE_STATION_XML:Class = UberAssetsLib_LIB_BATTLE_STATION_XML;
      
      private static const LIB_MAPS_XML:Class = UberAssetsLib_LIB_MAPS_XML;
      
      private static const LIB_TEST_XML:Class = UberAssetsLib_LIB_TEST_XML;
      
      public static const instance:UberAssetsLib = new UberAssetsLib();
      
      private var _callback:Function;
      
      private var _filesToLoad:Vector.<String>;
      
      private var _libraries:Object = {};
      
      private var _assetsIdsByLibrary:Object = {};
      
      private var _assets:Object = {};
      
      private var _currentLibId:String;
      
      private var _libLoader:URLLoader;
      
      public function UberAssetsLib()
      {
         super();
      }
      
      public function init(param1:Function) : void
      {
         this.addEmbededLib(LIB_DEFAULT,LIB_DEFAULT_XML);
         this.addEmbededLib(LIB_SHIPS,LIB_SHIPS_XML);
         this.addEmbededLib(LIB_DRONES,LIB_DRONES_XML);
         this.addEmbededLib(LIB_PORTALS,LIB_PORTALS_XML);
         this.addEmbededLib(LIB_COLLECTABLES,LIB_COLLECTABLES_XML);
         this.addEmbededLib(LIB_BATTLE_STATION,LIB_BATTLE_STATION_XML);
         this.addEmbededLib(LIB_MAPS,LIB_MAPS_XML);
         param1();
      }
      
      private function addEmbededLib(param1:String, param2:Class) : void
      {
         var _loc3_:ByteArray = new param2() as ByteArray;
         this.addDefinitions(param1,new XML(_loc3_.readUTFBytes(_loc3_.length)));
      }
      
      public function getLibraryAssetsIds(param1:String) : Vector.<String>
      {
         return this._assetsIdsByLibrary[param1] as Vector.<String>;
      }
      
      public function loadDescriptors(param1:Function = null, param2:Vector.<String> = null) : void
      {
         this._callback = param1;
         if(param2 != null)
         {
            this._filesToLoad = param2;
         }
         else
         {
            this._filesToLoad = ALL_LIBRARIES.concat();
            this._libraries = {};
            this._assets = {};
         }
         this.loadNextFile();
      }
      
      public function getDescriptor(param1:String, param2:String, param3:Boolean = true) : XML
      {
         if(param3 && this._assets[param2 + ":" + param1] == null)
         {
         }
         return this._assets[param2 + ":" + param1] as XML;
      }
      
      public function getDebugDescription() : XML
      {
         return this._assets["lib_ships:120"];
      }
      
      public function getDescriptorByCompositeId(param1:String) : XML
      {
         return this._assets[param1] as XML;
      }
      
      public function fillTraits(param1:MapEntity, param2:String, param3:String, param4:Function = null, param5:Function = null, param6:String = null, param7:Boolean = true) : void
      {
         var _loc9_:EntityTraitBase = null;
         var _loc8_:Vector.<EntityTraitBase> = this.getTraits(param1,this.getDescriptor(param2,param3),param4,param5,param6,param7);
         for each(_loc9_ in _loc8_)
         {
            param1.addTrait(_loc9_);
         }
      }
      
      public function getTraits(param1:MapEntity, param2:XML, param3:Function = null, param4:Function = null, param5:String = null, param6:Boolean = true) : Vector.<EntityTraitBase>
      {
         var _loc10_:XML = null;
         var _loc11_:XML = null;
         var _loc12_:XML = null;
         var _loc13_:XML = null;
         var _loc14_:ClickIconTrait = null;
         var _loc15_:MouseHitAreaTrait = null;
         var _loc16_:String = null;
         var _loc17_:HPTrait = null;
         var _loc18_:Boolean = false;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:Boolean = false;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:PulsingRingTrait = null;
         var _loc26_:AttackerTrait = null;
         var _loc7_:Vector.<EntityTraitBase> = new Vector.<EntityTraitBase>();
         var _loc8_:XML = param2;
         if(_loc8_ == null)
         {
            return _loc7_;
         }
         var _loc9_:UberDisplayTrait = UberDisplayTrait.fromXML(_loc8_,param6);
         if(_loc9_)
         {
            _loc7_.push(_loc9_);
         }
         for each(_loc10_ in _loc8_.background2D)
         {
            _loc7_.push(new UberBackgroundDisplayTrait(int(_loc10_.@parallaxFactor),int(_loc10_.@layer),String(_loc10_.@descriptorResKey),_loc8_,Vector.<String>(String(_loc10_.@decorators).split(",")),!param6));
         }
         if(param3 != null && _loc8_.click_icon.length() > 0)
         {
            _loc13_ = _loc8_.click_icon[0];
            _loc14_ = ClickIconFactory.create(_loc13_,param1);
            _loc14_.clicked.add(param3);
            _loc7_.push(_loc14_);
         }
         for each(_loc11_ in _loc8_.click_area)
         {
            _loc15_ = new MouseHitAreaTrait(int(_loc11_.@radius),int(_loc11_.@priority),int(_loc11_.@screenOffsetX),int(_loc11_.@screenOffsetY),param1.getPivot(String(_loc11_.@pivotId) || "click_area"));
            if(param4 != null)
            {
               _loc15_.clicked.add(param4);
            }
            if(String(_loc11_.@toolTipKey).length > 0)
            {
               _loc16_ = String(_loc11_.@toolTipCategory).length > 0 ? String(_loc11_.@toolTipCategory) : "";
               _loc15_.toolTip = BPLocale.getItemInCategory(_loc16_,String(_loc11_.@toolTipKey));
            }
            _loc7_.push(_loc15_);
         }
         for each(_loc12_ in _loc8_.miniMapIcon)
         {
            if(String(_loc12_.@srcKey).length > 0)
            {
               _loc7_.push(new MiniMapIconTrait(String(_loc12_.@resKey),String(_loc12_.@srcKey),int(String(_loc12_.@layer)),Number(String(_loc12_.@scale))));
            }
            else if(String(_loc12_.@color).length > 0)
            {
               _loc7_.push(new MiniMapDotTrait(uint(String(_loc12_.@color)),int(String(_loc12_.@layer))));
            }
         }
         if(_loc8_.label.length() > 0)
         {
            _loc7_.push(new LabelTrait(param5,int(_loc8_.label.@x),int(_loc8_.label.@y)));
         }
         if(_loc8_.hp.length() > 0)
         {
            _loc17_ = new HPTrait();
            _loc17_.hpBarWidth = int(_loc8_.hp.@bar_width);
            _loc7_.push(_loc17_);
         }
         if(_loc8_.attack_target.length() > 0)
         {
            _loc7_.push(new AttackTargetTrait(int(String(_loc8_.attack_target.@lockType)) || AttackTargetTrait.ENEMY,_loc8_.attack_target.attribute("explosion").length() > 0 ? int(String(_loc8_.attack_target.explosion)) : -1));
         }
         if(_loc8_.pulsingRing.length() > 0)
         {
            _loc18_ = ParserUtility.parseBooleanFromString(_loc8_.pulsingRing.@enabled);
            _loc19_ = uint(int(_loc8_.pulsingRing.@radius));
            _loc20_ = uint("0x" + _loc8_.pulsingRing.@color);
            _loc21_ = ParserUtility.parseBooleanFromString(_loc8_.pulsingRing.@explosionLike);
            _loc22_ = Number(_loc8_.pulsingRing.@cycleTime);
            _loc23_ = _loc8_.pulsingRing.attribute("startRadius").length() > 0 ? Number(_loc8_.pulsingRing.@startRadius) : 0;
            _loc24_ = _loc8_.pulsingRing.attribute("endAlpha").length() > 0 ? Number(_loc8_.pulsingRing.@endAlpha) : 0;
            _loc25_ = new PulsingRingTrait(_loc18_,_loc19_,_loc20_,_loc21_,_loc22_,_loc23_,_loc24_);
            _loc7_.push(_loc25_);
         }
         if(_loc8_.attacker.length() > 0)
         {
            _loc26_ = new AttackerTrait(new LaserCannon(),new RocketLauncher());
            if(_loc8_.attacker.laserCannon.salvo.length() > 0)
            {
            }
            if(_loc8_.attacker.laserCannon.attribute("animation").length() > 0)
            {
               _loc26_.laser.attackAnimationName = _loc8_.attacker.laserCannon.attribute("animation");
            }
            _loc26_.rocketLauncher.localPosition = new PointLite(int(_loc8_.attacker.rocketLauncher.@x),int(_loc8_.attacker.rocketLauncher.@y));
            if(_loc8_.attacker.rocketLauncher.attribute("animation").length() > 0)
            {
               _loc26_.rocketLauncher.attackAnimationName = _loc8_.attacker.rocketLauncher.attribute("animation");
            }
            if(_loc8_.attacker.rocketLauncher.attribute("directionX").length() > 0 || _loc8_.attacker.rocketLauncher.attribute("directionY").length() > 0)
            {
               _loc26_.rocketLauncher.direction = new PointLite(int(_loc8_.attacker.rocketLauncher.@directionX),int(_loc8_.attacker.rocketLauncher.@directionY));
            }
            _loc7_.push(_loc26_);
         }
         return _loc7_;
      }
      
      private function loadNextFile() : void
      {
         if(this._filesToLoad.length > 0)
         {
            if(this._libLoader == null)
            {
               this._libLoader = new URLLoader();
               this._libLoader.addEventListener(Event.COMPLETE,this.handleConfigLoadComplete);
               this._libLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleConfigLoadError);
            }
            this._currentLibId = this._filesToLoad.shift();
            this._libLoader.load(new URLRequest("../../config/data/" + this._currentLibId + ".xml?v=" + new Date().getTime()));
         }
         else if(this._callback != null)
         {
            this._callback();
            this._callback = null;
         }
      }
      
      private function handleConfigLoadComplete(param1:Event) : void
      {
         this.addDefinitions(this._currentLibId,new XML(this._libLoader.data));
         this.loadNextFile();
      }
      
      private function handleConfigLoadError(param1:IOErrorEvent) : void
      {
         this.loadNextFile();
      }
      
      private function addDefinitions(param1:String, param2:XML) : void
      {
         var _loc6_:Array = null;
         var _loc7_:XML = null;
         var _loc8_:String = null;
         var _loc3_:XML = XMLUtils.resolveReferences(param2);
         if(param1 == "lib_ships")
         {
         }
         var _loc4_:Object = {};
         var _loc5_:Vector.<String> = new Vector.<String>();
         for each(_loc7_ in _loc3_.asset)
         {
            _loc6_ = String(_loc7_.@id).split(",");
            for each(_loc8_ in _loc6_)
            {
               _loc4_[_loc8_] = _loc7_;
               this._assets[param1 + ":" + _loc8_] = _loc7_;
               _loc5_.push(_loc8_);
            }
         }
         this._libraries[param1] = _loc4_;
         this._assetsIdsByLibrary[param1] = _loc5_;
         System.disposeXML(param2);
      }
   }
}

