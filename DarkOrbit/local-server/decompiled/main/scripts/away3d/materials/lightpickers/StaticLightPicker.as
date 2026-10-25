package away3d.materials.lightpickers
{
   import away3d.events.LightEvent;
   import away3d.lights.DirectionalLight;
   import away3d.lights.LightBase;
   import away3d.lights.LightProbe;
   import away3d.lights.PointLight;
   import flash.events.Event;
   
   public class StaticLightPicker extends LightPickerBase
   {
      
      private var _lights:Array;
      
      public function StaticLightPicker(param1:Array)
      {
         super();
         this.lights = param1;
      }
      
      public function get lights() : Array
      {
         return this._lights;
      }
      
      public function set lights(param1:Array) : void
      {
         var _loc7_:LightBase = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(this._lights)
         {
            this.clearListeners();
         }
         this._lights = param1;
         _allPickedLights = Vector.<LightBase>(param1);
         _pointLights = new Vector.<PointLight>();
         _castingPointLights = new Vector.<PointLight>();
         _directionalLights = new Vector.<DirectionalLight>();
         _castingDirectionalLights = new Vector.<DirectionalLight>();
         _lightProbes = new Vector.<LightProbe>();
         var _loc8_:uint = param1.length;
         var _loc9_:uint = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_ = param1[_loc9_];
            _loc7_.addEventListener(LightEvent.CASTS_SHADOW_CHANGE,this.onCastShadowChange);
            if(_loc7_ is PointLight)
            {
               if(_loc7_.castsShadows)
               {
                  var _loc10_:uint;
                  _castingPointLights[_loc10_ = _loc4_++] = PointLight(_loc7_);
               }
               else
               {
                  _pointLights[_loc10_ = _loc2_++] = PointLight(_loc7_);
               }
            }
            else if(_loc7_ is DirectionalLight)
            {
               if(_loc7_.castsShadows)
               {
                  _castingDirectionalLights[_loc10_ = _loc5_++] = DirectionalLight(_loc7_);
               }
               else
               {
                  _directionalLights[_loc10_ = _loc3_++] = DirectionalLight(_loc7_);
               }
            }
            else if(_loc7_ is LightProbe)
            {
               _lightProbes[_loc10_ = _loc6_++] = LightProbe(_loc7_);
            }
            _loc9_++;
         }
         if(_numDirectionalLights == _loc3_ && _numPointLights == _loc2_ && _numLightProbes == _loc6_ && _numCastingPointLights == _loc4_ && _numCastingDirectionalLights == _loc5_)
         {
            return;
         }
         _numDirectionalLights = _loc3_;
         _numCastingDirectionalLights = _loc5_;
         _numPointLights = _loc2_;
         _numCastingPointLights = _loc4_;
         _numLightProbes = _loc6_;
         _lightProbeWeights = new Vector.<Number>(Math.ceil(_loc6_ / 4) * 4,true);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function clearListeners() : void
      {
         var _loc1_:uint = this._lights.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._lights[_loc2_].removeEventListener(LightEvent.CASTS_SHADOW_CHANGE,this.onCastShadowChange);
            _loc2_++;
         }
      }
      
      private function onCastShadowChange(param1:LightEvent) : void
      {
         var _loc2_:LightBase = LightBase(param1.target);
         if(_loc2_ is PointLight)
         {
            this.updatePointCasting(_loc2_ as PointLight);
         }
         else if(_loc2_ is DirectionalLight)
         {
            this.updateDirectionalCasting(_loc2_ as DirectionalLight);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateDirectionalCasting(param1:DirectionalLight) : void
      {
         if(param1.castsShadows)
         {
            --_numDirectionalLights;
            ++_numCastingDirectionalLights;
            _directionalLights.splice(_directionalLights.indexOf(param1 as DirectionalLight),1);
            _castingDirectionalLights.push(param1);
         }
         else
         {
            ++_numDirectionalLights;
            --_numCastingDirectionalLights;
            _castingDirectionalLights.splice(_castingDirectionalLights.indexOf(param1 as DirectionalLight),1);
            _directionalLights.push(param1);
         }
      }
      
      private function updatePointCasting(param1:PointLight) : void
      {
         if(param1.castsShadows)
         {
            --_numPointLights;
            ++_numCastingPointLights;
            _pointLights.splice(_pointLights.indexOf(param1 as PointLight),1);
            _castingPointLights.push(param1);
         }
         else
         {
            ++_numPointLights;
            --_numCastingPointLights;
            _castingPointLights.splice(_castingPointLights.indexOf(param1 as PointLight),1);
            _pointLights.push(param1);
         }
      }
   }
}

