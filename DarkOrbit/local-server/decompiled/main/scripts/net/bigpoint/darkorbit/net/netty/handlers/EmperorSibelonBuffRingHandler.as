package net.bigpoint.darkorbit.net.netty.handlers
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.EmperorSibelonBuffRingCommand;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.EffectManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.GlowingRingEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EmperorSibelonBuffRingHandler extends DOAbstractSimpleCommand
   {
      
      public function EmperorSibelonBuffRingHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:int = 16777215;
         var _loc3_:EmperorSibelonBuffRingCommand = param1.getBody() as EmperorSibelonBuffRingCommand;
         var _loc4_:Ship = map.getEntityById(_loc3_.avatarId) as Ship;
         if(_loc4_ == null)
         {
            return;
         }
         var _loc5_:EffectManager = screenManager.map.effects;
         switch(_loc3_.type)
         {
            case EmperorSibelonBuffRingCommand.BUFFTYPE_DAMAGE:
               _loc2_ = 16711680;
               break;
            case EmperorSibelonBuffRingCommand.BUFFTYPE_SHIELD:
               _loc5_.addEffect(new ShieldEffect(_loc4_,Effect.NOT_PERSISTANT));
               _loc2_ = 3379148;
               break;
            case EmperorSibelonBuffRingCommand.BUFFTYPE_HEALTH:
               _loc5_.addEffect(new MapObjectEffect(EffectIDList.HEAL_EFFECT,_loc4_));
               _loc2_ = 65280;
         }
         _loc5_.addEffect(new GlowingRingEffect(new PointLite(_loc3_.x,_loc3_.y),80,_loc3_.radius * 2,_loc2_,false,4,false,false));
      }
   }
}

