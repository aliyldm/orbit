package net.bigpoint.darkorbit.mvc.events.control
{
   import net.bigpoint.darkorbit.mvc.common.utils.ClassUtils;
   import net.bigpoint.darkorbit.mvc.events.control.notifications.EventNotifications;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.AprilsFoolsEvent;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.ChristmasTreeEvent;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.EventDominatingFactionEvent;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.FrostedGatesEvent;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.HQdemolitionEvent;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.MapReplacementEvent;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.MoodAssetDestributionEvent;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.MoodAssetEvent;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.PermaFrostFissurEvent;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.PixelatedRenderingEvent;
   import net.bigpoint.darkorbit.mvc.events.model.interfaces.IDOEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class ActivateEventCommand extends SimpleCommand
   {
      
      public function ActivateEventCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:IDOEvent = param1.getBody() as IDOEvent;
         switch(ClassUtils.getClass(_loc2_))
         {
            case ChristmasTreeEvent:
               sendNotification(EventNotifications.CHRISTMAS_TREES,_loc2_);
               break;
            case FrostedGatesEvent:
               sendNotification(EventNotifications.FROSTED_GATES,_loc2_);
               break;
            case AprilsFoolsEvent:
               sendNotification(EventNotifications.APRILS_FOOLS,_loc2_);
               break;
            case PixelatedRenderingEvent:
               sendNotification(EventNotifications.PIXELATED_RENDERING_EVENT,_loc2_);
               break;
            case MoodAssetEvent:
               sendNotification(EventNotifications.MOOD_ASSETS,_loc2_);
               break;
            case MoodAssetDestributionEvent:
               sendNotification(EventNotifications.MOOD_ASSETS_DESTRIBUTION,_loc2_);
               break;
            case MapReplacementEvent:
               sendNotification(EventNotifications.EXCHANGE_MAP,_loc2_);
               break;
            case HQdemolitionEvent:
               sendNotification(EventNotifications.DEMOLISHED_HQ,_loc2_);
               break;
            case EventDominatingFactionEvent:
               sendNotification(EventNotifications.EVENT_DOMINATION_FACTION,_loc2_);
               break;
            case PermaFrostFissurEvent:
               sendNotification(EventNotifications.PERMAFROST_FISSURE_EVENT,_loc2_);
         }
      }
   }
}

