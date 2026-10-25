package net.bigpoint.darkorbit.net.netty.handlers.combat
{
   import net.bigpoint.darkorbit.com.module.AttackRangeExceededCommand;
   import net.bigpoint.darkorbit.map.model.effects.impl.OutOfRangeEffect;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AttackRangeExceededHandler extends BaseHandler
   {
      
      public function AttackRangeExceededHandler()
      {
         super();
      }
      
      public static function run(param1:AttackRangeExceededCommand) : void
      {
         map.effects.playEffect(new OutOfRangeEffect(map.hero,map.getEntityById(param1.uid),param1.type,param1.maxRange));
      }
   }
}

