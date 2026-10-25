package net.bigpoint.darkorbit.map.view3D.display3D
{
   import away3d.lights.DirectionalLight;
   import away3d.lights.LightBase;
   import away3d.lights.PointLight;
   import away3d.materials.lightpickers.StaticLightPicker;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.view3D.settings.LightSettings;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import net.bigpoint.darkorbit.settings.BindableSettings;
   import net.bigpoint.darkorbit.settings.CrowdedCombatPreset;
   
   public class LightsManager
   {
      
      private var _particlesEffectsQuality:BindableBoolean = Settings3D.effects.high;
      
      private var _empty:DirectionalLight;
      
      private var _allEffectLights:Vector.<PointLight> = new Vector.<PointLight>();
      
      private var _freeEffectLights:Vector.<PointLight> = new Vector.<PointLight>();
      
      private var _dirty:Boolean = true;
      
      private var _bindings:Vector.<LightToSettingsBinding> = new Vector.<LightToSettingsBinding>();
      
      private var _lastSetQuality:int = 2;
      
      private var _laserLightTimeouts:Dictionary = new Dictionary();
      
      private var _picker:StaticLightPicker;
      
      private var _particlesPicker:StaticLightPicker;
      
      private var _sun:DirectionalLight;
      
      private var _hero:PointLight;
      
      public function LightsManager()
      {
         super();
         this._empty = new DirectionalLight();
         this._empty.ambient = this._empty.specular = this._empty.diffuse = 0;
         this._sun = new DirectionalLight();
         this.addEffectLight();
         this.addEffectLight();
         this.addEffectLight();
         this._hero = new PointLight();
         this._picker = new StaticLightPicker([]);
         this._particlesPicker = new StaticLightPicker([]);
         this._particlesEffectsQuality.changed.add(this.updateParticlesLightPicker);
         this.updateParticlesLightPicker();
         this.bindLightToSettings(this._sun,Settings3D.sunLight);
         this.bindLightToSettings(this._hero,Settings3D.heroPositionLight);
         Settings3D.lights.changed.add(this.handleLightsSettingsChanged);
         CrowdedCombatPreset.changed.add(this.handleLightsSettingsChanged);
         this.handleLightsSettingsChanged();
      }
      
      public function get picker() : StaticLightPicker
      {
         return this._picker;
      }
      
      public function get particlesPicker() : StaticLightPicker
      {
         return this._particlesPicker;
      }
      
      public function get sun() : LightBase
      {
         return this._sun;
      }
      
      public function get hero() : PointLight
      {
         return this._hero;
      }
      
      public function getQuality() : int
      {
         return this._lastSetQuality;
      }
      
      public function update(param1:Boolean = false) : void
      {
         var _loc2_:Array = null;
         var _loc3_:PointLight = null;
         if(this._dirty || param1)
         {
            _loc2_ = [];
            if(this._sun.visible)
            {
               _loc2_.push(this._sun);
            }
            if(this._hero.visible)
            {
               _loc2_.push(this._hero);
            }
            for each(_loc3_ in this._allEffectLights)
            {
               if(_loc3_.visible)
               {
                  _loc2_.push(_loc3_);
               }
            }
            this._picker.lights = _loc2_;
            this.updateParticlesLightPicker();
            this._dirty = false;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:LightToSettingsBinding = null;
         while(this._bindings.length)
         {
            _loc1_ = LightToSettingsBinding(this._bindings.pop());
            _loc1_.animateChanged.remove(this.animateSunChanged);
            _loc1_.dispose();
         }
         TweenLite.killTweensOf(Settings3D.sunLight.directionPan);
         this._particlesEffectsQuality.changed.remove(this.updateParticlesLightPicker);
         CrowdedCombatPreset.changed.remove(this.handleLightsSettingsChanged);
      }
      
      public function activateEffectLight(param1:Number, param2:Number, param3:Number, param4:uint, param5:Number, param6:Number = 1, param7:Number = 1, param8:Number = 0.06, param9:Number = 0) : void
      {
         var _loc10_:PointLight = this.getFreeEffectLight(false);
         _loc10_.moveTo(param1,param2,param3);
         _loc10_.color = param4;
         TweenMax.to(_loc10_,param9,{
            "diffuse":param6,
            "specular":param7,
            "fallOff":param5
         });
         this._laserLightTimeouts[_loc10_] = setTimeout(this.laserLightOff,param8 * 1000,_loc10_,param9);
         World3D.instance.mapView.gameWorld.addChild(_loc10_);
      }
      
      public function getFreeEffectLight(param1:Boolean) : PointLight
      {
         var _loc2_:PointLight = this._freeEffectLights.shift();
         clearTimeout(this._laserLightTimeouts[_loc2_]);
         if(!(param1 && this._freeEffectLights.length > 0))
         {
            this._freeEffectLights.push(_loc2_);
         }
         return _loc2_;
      }
      
      public function freeEffectLight(param1:PointLight) : void
      {
         param1.radius = param1.fallOff = 0;
         var _loc2_:int = this._freeEffectLights.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._freeEffectLights.splice(_loc2_,1);
         }
         this._freeEffectLights.push(param1);
      }
      
      private function handleLightsSettingsChanged() : void
      {
         this._lastSetQuality = CrowdedCombatPreset.enabled ? BindableSettings.MEDIUM : Settings3D.lights.value;
         var _loc1_:int = 0;
         switch(this._lastSetQuality)
         {
            case BindableSettings.LOW:
               this.sun.visible = false;
               this.hero.visible = false;
               break;
            case BindableSettings.MEDIUM:
               this.sun.visible = true;
               this.hero.visible = false;
               _loc1_ = 1;
               break;
            case BindableSettings.HIGH:
               this.sun.visible = true;
               this.hero.visible = true;
               _loc1_ = int.MAX_VALUE;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._allEffectLights.length)
         {
            this._allEffectLights[_loc2_].visible = _loc2_ < _loc1_;
            _loc2_++;
         }
         this.update(true);
      }
      
      private function addEffectLight() : void
      {
         var _loc1_:PointLight = new PointLight();
         _loc1_.radius = _loc1_.fallOff = 0;
         this._allEffectLights.push(_loc1_);
         this._freeEffectLights.push(_loc1_);
      }
      
      private function bindLightToSettings(param1:LightBase, param2:LightSettings) : void
      {
         param2.visible.changed.add(this.markDirty);
         var _loc3_:LightToSettingsBinding = new LightToSettingsBinding(param1,param2);
         _loc3_.animateChanged.add(this.animateSunChanged);
         this._bindings.push();
      }
      
      private function markDirty() : void
      {
         this._dirty = true;
      }
      
      private function updateParticlesLightPicker() : void
      {
         this._particlesPicker.lights = this._particlesEffectsQuality.value && this._sun.visible ? [this._sun] : [];
      }
      
      private function laserLightOff(param1:PointLight, param2:Number = 0) : void
      {
         TweenMax.to(param1,param2,{
            "specular":0,
            "ambient":0
         });
      }
      
      private function animateSunChanged(param1:Number) : void
      {
         TweenLite.killTweensOf(Settings3D.sunLight.directionPan);
         this.animateSun(param1);
      }
      
      private function animateSun(param1:Number) : void
      {
         if(param1 > 0)
         {
            TweenLite.to(Settings3D.sunLight.directionPan,param1,{
               "value":"360",
               "ease":Linear.easeNone,
               "onComplete":this.animateSun,
               "onCompleteParams":[param1]
            });
         }
      }
   }
}

import away3d.lights.LightBase;
import net.bigpoint.darkorbit.map.view3D.settings.LightSettings;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

class LightToSettingsBinding
{
   
   public const animateChanged:ISignal = new Signal(Number);
   
   private var _light:LightBase;
   
   private var _settings:LightSettings;
   
   public function LightToSettingsBinding(param1:LightBase, param2:LightSettings)
   {
      super();
      this._light = param1;
      this._settings = param2;
      this._settings.visible.changed.add(this.updateLight);
      this._settings.color.changed.add(this.updateLight);
      this._settings.diffuse.changed.add(this.updateLight);
      this._settings.specular.changed.add(this.updateLight);
      this._settings.ambientColor.changed.add(this.updateLight);
      this._settings.ambient.changed.add(this.updateLight);
      this._settings.radius.changed.add(this.updateLight);
      this._settings.fallOff.changed.add(this.updateLight);
      this._settings.directionTilt.changed.add(this.updateLight);
      this._settings.directionPan.changed.add(this.updateLight);
      this._settings.animateSpeed.changed.add(this.dispatchAnimate);
      this.updateLight();
   }
   
   public function dispose() : void
   {
      this._settings.visible.changed.remove(this.updateLight);
      this._settings.color.changed.remove(this.updateLight);
      this._settings.diffuse.changed.remove(this.updateLight);
      this._settings.specular.changed.remove(this.updateLight);
      this._settings.ambientColor.changed.remove(this.updateLight);
      this._settings.ambient.changed.remove(this.updateLight);
      this._settings.radius.changed.remove(this.updateLight);
      this._settings.fallOff.changed.remove(this.updateLight);
      this._settings.directionTilt.changed.remove(this.updateLight);
      this._settings.directionPan.changed.remove(this.updateLight);
      this._settings.animateSpeed.changed.remove(this.dispatchAnimate);
      this._settings = null;
      this._light = null;
   }
   
   private function dispatchAnimate() : void
   {
      this.animateChanged.dispatch(this._settings.animateSpeed.value);
   }
   
   private function updateLight() : void
   {
      this._settings.apply(this._light);
   }
}
