package net.bigpoint.darkorbit.map.model.env.mine
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.EMPEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ShockwaveEffect;
   import net.bigpoint.darkorbit.map.model.traits.PulsingRingTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class Mine extends MapEntity
   {
      
      public static const MINE_EMP01:int = 2;
      
      public static const MINE_ICEMINE:int = 21;
      
      public var typeID:int;
      
      public var pulseColorId:int;
      
      public var explodeType:int;
      
      public var shockwaveColorID:int;
      
      private var _indicatorRingTrait:PulsingRingTrait;
      
      public function Mine(param1:int, param2:int, param3:int, param4:int, param5:int = 0, param6:int = 0)
      {
         super(param4,new BindablePointLite(param1,param2));
         this.typeID = param3;
         this.pulseColorId = param5;
         this.shockwaveColorID = param6;
         UberAssetsLib.instance.fillTraits(this,"mine_" + param3,UberAssetsLib.LIB_DEFAULT);
         var _loc7_:UberDisplayTrait = getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         if(_loc7_)
         {
            this.explodeType = int(_loc7_.descriptor.display2D.@explodeType);
            _loc7_.decorators.push({"id":"mine"});
            this.createIndicator();
         }
      }
      
      public function bang() : void
      {
         var _loc2_:ExplosionPattern = null;
         var _loc1_:Map = ScreenManager.getInstance().map;
         if(this.typeID == MINE_EMP01)
         {
            _loc1_.effects.addMapObjectEffectOnce(new EMPEffect(this,EMPEffect.TYPE_NORMAL));
         }
         else
         {
            _loc2_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_MINE_EXPLOSION,this.explodeType);
            _loc1_.effects.playEffect(new PyroEffect(x,y,z,_loc2_));
            if(this.shockwaveColorID > 0)
            {
               _loc1_.effects.playEffect(new ShockwaveEffect(0,x,y,true));
            }
         }
      }
      
      private function createIndicator() : void
      {
         if(this.typeID == MINE_ICEMINE)
         {
            this._indicatorRingTrait = new PulsingRingTrait(true,840,16711680,false,1);
            addTrait(this._indicatorRingTrait);
            this._indicatorRingTrait.enable(840,16711680,false,1);
         }
      }
   }
}

