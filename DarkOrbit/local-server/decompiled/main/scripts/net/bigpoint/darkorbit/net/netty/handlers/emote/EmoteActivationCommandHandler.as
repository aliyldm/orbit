package net.bigpoint.darkorbit.net.netty.handlers.emote
{
   import net.bigpoint.darkorbit.com.module.EmoteActivationCommand;
   import net.bigpoint.darkorbit.items.ItemDataProvider;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.items.item.attributes.EmoteAttributes;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.EmoteEffect;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EmoteActivationCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function EmoteActivationCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:EmoteActivationCommand = param1.getBody() as EmoteActivationCommand;
         var _loc3_:Item = ItemDataProvider.getItem(_loc2_.lootId);
         var _loc4_:MapEntity = map.getEntityById(_loc2_.userId);
         if(Boolean(_loc3_) && Boolean(_loc4_))
         {
            map.effects.addEffect(new EmoteEffect(_loc4_,_loc2_.lootId,(_loc3_.attributes as EmoteAttributes).duration));
         }
      }
   }
}

