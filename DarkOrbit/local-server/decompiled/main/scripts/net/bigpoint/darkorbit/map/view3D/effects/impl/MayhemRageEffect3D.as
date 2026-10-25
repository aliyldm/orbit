package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.OutlineMethod;
   import away3d.materials.methods.RimLightMethod;
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.map.model.effects.impl.MayhemRageEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.AbstractShipGlowEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   
   public class MayhemRageEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "mayhem_rage.zip";
      
      private var _shaderMethods:Vector.<EffectMethodBase>;
      
      private var _ship:MapUberAsset3D;
      
      private var _effect:AbstractShipGlowEffect;
      
      private var _rimMethod:RimLightMethod;
      
      private var _outlineMethod:OutlineMethod;
      
      public function MayhemRageEffect3D(param1:MapView3D, param2:MayhemRageEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position,param2.source);
         this._ship = param1.mainContainer.getViewByTrait(param2.source.getFirstTrait(UberDisplayTrait)) as MapUberAsset3D;
         this._effect = param2;
         offset3D.setTo(0,15,0);
         var _loc3_:Number = 1;
         var _loc4_:UberDisplayTrait = this._effect.source.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         if((Boolean(_loc4_)) && Boolean(_loc4_.descriptor) && _loc4_.descriptor.display3D.length() > 0)
         {
            if(_loc4_.descriptor.display3D[0].mesh.length() > 0)
            {
               _loc3_ = 1 / (Number(_loc4_.descriptor.display3D[0].mesh[0].@scale) || 1);
            }
            else
            {
               _loc3_ = 1 / (Number(_loc4_.descriptor.display3D[0].@scale) || 1);
            }
         }
         this._rimMethod = new RimLightMethod(this._effect.color,this._effect.glowStrength,0.5);
         this._outlineMethod = new OutlineMethod(this._effect.color,_loc3_ / 2);
         this._ship.addMethods(this._shaderMethods = Vector.<EffectMethodBase>([this._rimMethod,this._outlineMethod]));
         if(this._effect.pulseTime > 0)
         {
            TweenMax.to(this._rimMethod,this._effect.pulseTime,{
               "strength":0.5,
               "power":0.8,
               "yoyo":true,
               "repeat":-1
            });
            TweenMax.to(this._outlineMethod,this._effect.pulseTime,{
               "outlineSize":0,
               "yoyo":true,
               "repeat":-1
            });
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         super.disposeView(param1);
         if(this._shaderMethods)
         {
            this._ship.removeMethods(this._shaderMethods);
            this._shaderMethods = null;
            TweenMax.killTweensOf(this._rimMethod);
            TweenMax.killTweensOf(this._outlineMethod);
         }
      }
   }
}

