package net.bigpoint.darkorbit.map.view3D.display3D
{
   import away3d.animators.ParticleGroupAnimator;
   import away3d.containers.ObjectContainer3D;
   import away3d.entities.Mesh;
   import away3d.entities.ParticleGroup;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   
   public class Starfield3D extends ObjectContainer3D implements IUpdatable
   {
      
      private static const QUALITY_SETTING:BindableBoolean = Settings3D.effects.medium;
      
      private static const CLUSTER_SIZE:int = 2000;
      
      private var _particles:ParticleGroup;
      
      private var _animators:Vector.<ParticleGroupAnimator> = new Vector.<ParticleGroupAnimator>();
      
      private var _map:Map;
      
      public function Starfield3D()
      {
         super();
         QUALITY_SETTING.changed.add(this.reloadEffect);
      }
      
      public function set map(param1:Map) : void
      {
         this._map = param1;
         this.reloadEffect();
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:int = param1 * 1000;
         var _loc3_:* = int(this._animators.length - 1);
         while(_loc3_ >= 0)
         {
            this._animators[_loc3_].time += _loc2_;
            _loc3_--;
         }
      }
      
      private function reloadEffect() : void
      {
         var _loc1_:String = null;
         if(QUALITY_SETTING.value)
         {
            if(Boolean(this._map) && Boolean(this._map.mapXml) && String(this._map.mapXml.@starfield).length > 0)
            {
               if(String(this._map.mapXml.@starfield) != "none")
               {
                  _loc1_ = String(this._map.mapXml.@starfield);
               }
            }
            else
            {
               _loc1_ = "star_dust_chaotic";
            }
            if(_loc1_)
            {
               World3D.instance.particleLoader.loadParticleByUrl(_loc1_ + ".zip",World3D.LIFETIME_MAP).addOnce(this.handleAssetLoadComplete);
            }
            else
            {
               this._particles = null;
               this.update();
            }
         }
         else
         {
            this._particles = null;
            this.update();
         }
      }
      
      private function handleAssetLoadComplete(param1:ParticleGroup) : void
      {
         this._particles = param1;
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:ParticleGroup = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Mesh = null;
         while(numChildren > 0)
         {
            removeChildAt(numChildren - 1);
         }
         this._animators.length = 0;
         if(Boolean(QUALITY_SETTING.value) && Boolean(this._map) && Boolean(this._particles))
         {
            _loc1_ = Math.ceil(this._map.serious_height / CLUSTER_SIZE);
            _loc2_ = Math.ceil(this._map.serious_width / CLUSTER_SIZE);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc1_)
               {
                  _loc3_ = this._particles.clone() as ParticleGroup;
                  _loc3_.x = _loc4_ * CLUSTER_SIZE;
                  _loc3_.y = 0;
                  _loc3_.z = -_loc5_ * CLUSTER_SIZE;
                  for each(_loc6_ in _loc3_.particleMeshes)
                  {
                     _loc6_.bounds.fromExtremes(0,0,0,CLUSTER_SIZE,-300,CLUSTER_SIZE);
                  }
                  this._animators.push(_loc3_.animator);
                  addChild(_loc3_);
                  _loc5_++;
               }
               _loc4_++;
            }
         }
      }
   }
}

