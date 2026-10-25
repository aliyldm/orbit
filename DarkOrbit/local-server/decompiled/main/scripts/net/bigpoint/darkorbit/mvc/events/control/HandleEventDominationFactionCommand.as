package net.bigpoint.darkorbit.mvc.events.control
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.DominationEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.EventDominatingFactionEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HandleEventDominationFactionCommand extends DOAbstractSimpleCommand
   {
      
      public function HandleEventDominationFactionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:Ship = null;
         var _loc5_:MapEntity = null;
         var _loc2_:EventDominatingFactionEvent = param1.getBody() as EventDominatingFactionEvent;
         var _loc3_:Vector.<MapEntity> = map.entities;
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = _loc5_ as Ship;
            if(_loc4_)
            {
               if(_loc2_.isActive && _loc4_.info.factionID.value == _loc2_.dominatingFaction)
               {
                  map.effects.addMapObjectEffectOnce(new DominationEffect(_loc4_));
               }
               else
               {
                  map.effects.removeEffectFromMapObject(_loc4_.id,EffectIDList.DOMINATION_ICON_EFFECT);
               }
            }
         }
      }
   }
}

