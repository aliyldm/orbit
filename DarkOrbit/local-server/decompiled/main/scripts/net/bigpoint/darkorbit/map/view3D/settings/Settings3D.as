package net.bigpoint.darkorbit.map.view3D.settings
{
   import away3d.materials.TextureMaterial;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.AnimatedCloudMaterial;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.AwakenedGlowMaterial;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.EntityBasicMaterial;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.EntityXRayMaterial;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.FrostMaterial;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.PlayerGlowMaterial;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.SectorControlBeaconMaterial;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.UberShipMaterial;
   import net.bigpoint.darkorbit.settings.BindableSettings;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class Settings3D
   {
      
      public static const antialiasing:BindableSettings = Settings.displaySetting3DqualityAntialias;
      
      public static const lights:BindableSettings = Settings.displaySetting3DqualityLights;
      
      public static const effects:BindableSettings = Settings.displaySetting3DqualityEffects;
      
      public static const background:BindableSettings = Settings.qualityBackground;
      
      public static const zones:BindableSettings = Settings.qualityPoizone;
      
      public static const TEXTURE_FILTERING:BindableSettings = new BindableSettings(BindableSettings.HIGH);
      
      public static const TEXTURE_USE_ADVANCED_TEXTURES:BindableBoolean = new BindableBoolean(true);
      
      public static const TEXTURE_USE_GLOW_MAPS:BindableBoolean = new BindableBoolean(true);
      
      private static const tex_ships_very_small:BindableInt = new BindableInt(64);
      
      private static const tex_ships_small:BindableInt = new BindableInt(64);
      
      private static const tex_ships:BindableInt = new BindableInt(128);
      
      private static const tex_ships_big:BindableInt = new BindableInt(256);
      
      private static const tex_ships_very_big:BindableInt = new BindableInt(512);
      
      private static const tex_buildings_small:BindableInt = new BindableInt(256);
      
      private static const tex_buildings:BindableInt = new BindableInt(512);
      
      private static const tex_buildings_big:BindableInt = new BindableInt(1024);
      
      private static const tex_planet:BindableInt = new BindableInt(1024);
      
      private static const textureSizeLookup:Object = {};
      
      private static const _defaultSunLight:LightSettings = new LightSettings(false,true,10747903,0.8,1.1,16745820,0.5,0,0,100,35);
      
      public static const sunLight:LightSettings = _defaultSunLight.clone();
      
      public static const heroPositionLight:LightSettings = new LightSettings(true,true,3046911,0.6,1.5,0,0,0,450);
      
      public static const laserLight:LightSettings = new LightSettings(true,true,0,0,3,0,0,0,150);
      
      public static const rocketLight:LightSettings = new LightSettings(true,true,16236736,1,2,0,0,0,200);
      
      public static const explosionLight:LightSettings = new LightSettings(true,true,14607560,0,20,0,0,0,400);
      
      public static const cacheDisabled:BindableBoolean = new BindableBoolean(false);
      
      public static const render:BindableBoolean = new BindableBoolean(true);
      
      public static const limitCameraAngle:BindableBoolean = new BindableBoolean(true);
      
      private static const _effectsQualityLookup:Object = {};
      
      public static const shadersLookup:Object = {};
      
      textureSizeLookup["ship"] = tex_ships;
      textureSizeLookup["ship_small"] = tex_ships_small;
      textureSizeLookup["ship_very_small"] = tex_ships_very_small;
      textureSizeLookup["ship_big"] = tex_ships_big;
      textureSizeLookup["ship_very_big"] = tex_ships_very_big;
      textureSizeLookup["drone"] = tex_ships_very_small;
      textureSizeLookup["building_small"] = tex_buildings_small;
      textureSizeLookup["building"] = tex_buildings;
      textureSizeLookup["building_big"] = tex_buildings_big;
      textureSizeLookup["planet"] = tex_planet;
      textureSizeLookup["planet_small"] = tex_buildings_small;
      Settings.displaySetting3DtextureFiltering.changed.add(updateTexturesFiltering);
      updateTexturesFiltering();
      Settings.displaySetting3DqualityTextures.changed.add(updateTexturesType);
      updateTexturesType();
      Settings.displaySetting3DsizeTextures.changed.add(updateTexturesSize);
      updateTexturesSize();
      _effectsQualityLookup["effects.low"] = effects.low;
      _effectsQualityLookup["effects.medium"] = effects.medium;
      _effectsQualityLookup["effects.high"] = effects.high;
      _effectsQualityLookup["effects.max"] = effects.max;
      _effectsQualityLookup["background.low"] = background.low;
      _effectsQualityLookup["background.average"] = background.medium;
      _effectsQualityLookup["background.medium"] = background.medium;
      _effectsQualityLookup["background.high"] = background.high;
      _effectsQualityLookup["background.max"] = background.max;
      _effectsQualityLookup["zones.low"] = zones.low;
      _effectsQualityLookup["zones.average"] = zones.medium;
      _effectsQualityLookup["zones.medium"] = zones.medium;
      _effectsQualityLookup["zones.high"] = zones.high;
      _effectsQualityLookup["zones.max"] = zones.max;
      shadersLookup["basic"] = TextureMaterial;
      shadersLookup["ship"] = EntityBasicMaterial;
      shadersLookup["xRay"] = EntityXRayMaterial;
      shadersLookup["uber_ship"] = UberShipMaterial;
      shadersLookup["player_glow"] = PlayerGlowMaterial;
      shadersLookup["sector_control_beacon"] = SectorControlBeaconMaterial;
      shadersLookup["animated_cloud"] = AnimatedCloudMaterial;
      shadersLookup["frozen"] = FrostMaterial;
      shadersLookup["awakened_glow"] = AwakenedGlowMaterial;
      
      public function Settings3D()
      {
         super();
      }
      
      public static function getTextureSize(param1:String, param2:BindableInt = null) : BindableInt
      {
         return textureSizeLookup[param1] || param2 || tex_ships;
      }
      
      private static function updateTexturesFiltering() : void
      {
         TEXTURE_FILTERING.value = Settings.displaySetting3DtextureFiltering.value;
      }
      
      private static function updateTexturesType() : void
      {
         var _loc1_:BindableSettings = Settings.displaySetting3DqualityTextures;
         TEXTURE_USE_ADVANCED_TEXTURES.value = _loc1_.high.value;
         TEXTURE_USE_GLOW_MAPS.value = _loc1_.medium.value;
      }
      
      private static function updateTexturesSize() : void
      {
         switch(Settings.displaySetting3DsizeTextures.value)
         {
            case BindableSettings.LOW:
               tex_ships_very_small.value = 64;
               tex_ships_small.value = 64;
               tex_ships.value = 128;
               tex_ships_big.value = 256;
               tex_ships_very_big.value = 256;
               tex_buildings_small.value = 128;
               tex_buildings.value = 256;
               tex_planet.value = 256;
               tex_buildings_big.value = 256;
               break;
            case BindableSettings.MEDIUM:
               tex_ships_very_small.value = 64;
               tex_ships_small.value = 64;
               tex_ships.value = 128;
               tex_ships_big.value = 256;
               tex_ships_very_big.value = 512;
               tex_buildings_small.value = 256;
               tex_buildings.value = 512;
               tex_planet.value = 512;
               tex_buildings_big.value = 512;
               break;
            case BindableSettings.HIGH:
               tex_ships_very_small.value = 128;
               tex_ships_small.value = 128;
               tex_ships.value = 256;
               tex_ships_big.value = 512;
               tex_ships_very_big.value = 1024;
               tex_buildings_small.value = 512;
               tex_buildings.value = 512;
               tex_planet.value = 1024;
               tex_buildings_big.value = 1024;
         }
      }
      
      public static function getEffectsQualityFromLookup(param1:String) : BindableBoolean
      {
         var _loc3_:Vector.<BindableBoolean> = null;
         var _loc4_:BindableBoolean = null;
         var _loc5_:String = null;
         var _loc2_:Array = param1.split(" AND ");
         if(_loc2_.length > 1)
         {
            _loc3_ = new Vector.<BindableBoolean>();
            for each(_loc5_ in _loc2_)
            {
               _loc4_ = getEffectsQualityFromLookup(_loc5_);
               if(_loc4_)
               {
                  _loc3_.push(_loc4_);
               }
            }
            if(_loc3_.length == 0)
            {
               return null;
            }
            if(_loc3_.length == 1)
            {
               return _loc3_[0];
            }
            return new ANDBindableBoolean(_loc3_);
         }
         return _effectsQualityLookup[param1];
      }
      
      public static function getShaderClass(param1:String, param2:Class = null) : Class
      {
         return shadersLookup[param1] || param2 || EntityBasicMaterial;
      }
   }
}

import com.bigpoint.utils.bindables.BindableBoolean;

class ANDBindableBoolean extends BindableBoolean
{
   
   private var _source:Vector.<BindableBoolean>;
   
   public function ANDBindableBoolean(param1:Vector.<BindableBoolean>)
   {
      var _loc2_:BindableBoolean = null;
      super();
      this._source = param1;
      for each(_loc2_ in this._source)
      {
         _loc2_.changed.add(this.update);
      }
      this.update();
   }
   
   private function update() : void
   {
      var _loc1_:BindableBoolean = null;
      for each(_loc1_ in this._source)
      {
         if(!_loc1_.value)
         {
            this.value = false;
            return;
         }
      }
      this.value = true;
   }
}

class ORBindableBoolean extends BindableBoolean
{
   
   private var _source:Vector.<BindableBoolean>;
   
   public function ORBindableBoolean(param1:Vector.<BindableBoolean>)
   {
      var _loc2_:BindableBoolean = null;
      super();
      this._source = param1;
      for each(_loc2_ in this._source)
      {
         _loc2_.changed.add(this.update);
      }
      this.update();
   }
   
   private function update() : void
   {
      var _loc1_:BindableBoolean = null;
      for each(_loc1_ in this._source)
      {
         if(_loc1_.value)
         {
            this.value = true;
            return;
         }
      }
      this.value = false;
   }
}
