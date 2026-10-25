package net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.SnipedLaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossLaserWarningEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class BossLaserWarningEffect2D extends AbstractEffect2D
   {
      
      public function BossLaserWarningEffect2D(param1:MapView2D, param2:BossLaserWarningEffect)
      {
         super(param1,param2);
         var _loc3_:SnipedLaserEffect = new SnipedLaserEffect(param2.source,param2.target,2);
         ScreenManager.getInstance().map.effects.addEffect(_loc3_);
      }
   }
}

