package net.bigpoint.darkorbit.map.view3D.effects.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ShieldPattern;
   
   public class ShieldImpactEffect extends StandaloneParticle3D
   {
      
      public static const NORMAL_LASER_AND_ROCKET:int = 0;
      
      private var _lookAtX:Number;
      
      private var _lookAtY:Number;
      
      private var _lookAtZ:Number;
      
      public function ShieldImpactEffect(param1:Number, param2:Number, param3:Number, param4:MapEntity, param5:int = 0, param6:Boolean = false)
      {
         this._lookAtX = param1;
         this._lookAtY = param2;
         this._lookAtZ = param3;
         var _loc7_:ShieldPattern = PatternManager.getShieldPattern(param5);
         super(null,param6 ? _loc7_.resKeySkilled : _loc7_.resKey,param4.position,param4,true,0.2);
         this.fixedScale = _loc7_.scale;
         var _loc8_:UberDisplayTrait = param4.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         if(_loc8_)
         {
            scale = _loc8_.visualSize3D * this.fixedScale;
         }
         interpolateScale = false;
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
         lookAt(this._lookAtX,this._lookAtY,this._lookAtZ);
      }
   }
}

