package net.bigpoint.darkorbit.mvc.events.control
{
   import net.bigpoint.darkorbit.mvc.events.christmastreeevent.HandleChristmasTreesCommand;
   import net.bigpoint.darkorbit.mvc.events.control.notifications.EventNotifications;
   import net.bigpoint.darkorbit.mvc.events.model.EventProxy;
   import net.bigpoint.darkorbit.mvc.events.model.interfaces.IDOEvent;
   import net.bigpoint.darkorbit.mvc.events.springfight.HandleMoodAssetsCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InitEventSystem extends SimpleCommand
   {
      
      public function InitEventSystem()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.registerProxy(new EventProxy(new Vector.<IDOEvent>()));
         facade.registerCommand(EventNotifications.ACTIVATE_EVENT,ActivateEventCommand);
         facade.registerCommand(EventNotifications.ADD_EVENT,AddEventCommand);
         facade.registerCommand(EventNotifications.CHRISTMAS_TREES,HandleChristmasTreesCommand);
         facade.registerCommand(EventNotifications.MOOD_ASSETS,HandleMoodAssetsCommand);
         facade.registerCommand(EventNotifications.MOOD_ASSETS_DESTRIBUTION,HandelMoodAssetsDestributionCommand);
         facade.registerCommand(EventNotifications.EXCHANGE_MAP,HandleExchangeMapCommand);
         facade.registerCommand(EventNotifications.DEMOLISHED_HQ,HandleDemolishedHQCommand);
         facade.registerCommand(EventNotifications.EVENT_DOMINATION_FACTION,HandleEventDominationFactionCommand);
         facade.registerCommand(EventNotifications.APRILS_FOOLS,HandleAprilsFoolsCommand);
         facade.registerCommand(EventNotifications.PIXELATED_RENDERING_EVENT,HandlePixelatedRenderingEvent);
      }
   }
}

