package net.bigpoint.darkorbit.mvc.events.control
{
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.com.module.EventActivationStateCommand;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.events.model.EventProxy;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.MapReplacementEvent;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HandleExchangeMapCommand extends DOAbstractAsyncCommand
   {
      
      public function HandleExchangeMapCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:EventProxy = null;
         var _loc5_:String = null;
         var _loc2_:MapReplacementEvent = param1.getBody() as MapReplacementEvent;
         var _loc3_:Map = screenManager.map;
         if(Boolean(_loc3_) && Boolean(_loc2_.mapReplacements[_loc3_.getMapID()]))
         {
            _loc4_ = retrieveProxy(EventProxy.NAME) as EventProxy;
            if((Boolean(_loc4_)) && _loc4_.isEventActive(EventActivationStateCommand.EVENTTYPE_MAP_REPLACEMENT))
            {
               _loc5_ = _loc2_.mapReplacements[_loc3_.mapID];
               if(_loc5_)
               {
                  ResourceManager.fileCollection.load(_loc5_,this.handleReplacementLoadComplete);
                  return;
               }
            }
            _loc3_.init();
         }
      }
      
      private function handleReplacementLoadComplete(param1:XMLFinisher) : void
      {
         screenManager.map.init(param1.getXML());
         Settings.displayMiniMapBackgroundImage.changed.dispatch();
      }
   }
}

