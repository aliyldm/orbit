package net.bigpoint.darkorbit.net.netty.handlers
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.EventActivationAttributeModule;
   import net.bigpoint.darkorbit.com.module.EventActivationFactionAttributeModule;
   import net.bigpoint.darkorbit.com.module.EventActivationIntegerAttributeModule;
   import net.bigpoint.darkorbit.com.module.EventActivationMapExchangeAttributeModule;
   import net.bigpoint.darkorbit.com.module.EventActivationStateCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.events.control.notifications.EventNotifications;
   import net.bigpoint.darkorbit.mvc.events.model.EventProxy;
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
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EventActivationStateHandler extends DOAbstractSimpleCommand
   {
      
      private const DELEGATE_DICT:Array = this.getLookup();
      
      public function EventActivationStateHandler()
      {
         super();
      }
      
      private function get eventProxy() : EventProxy
      {
         return facade.retrieveProxy(EventProxy.NAME) as EventProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:EventActivationStateCommand = param1.getBody() as EventActivationStateCommand;
         if(this.DELEGATE_DICT[_loc2_.type] != null)
         {
            this.DELEGATE_DICT[_loc2_.type](_loc2_);
         }
      }
      
      private function getLookup() : Array
      {
         var _loc1_:Array = [];
         _loc1_[EventActivationStateCommand.EVENTTYPE_CHRISTMAS_TREES] = this.createChristmasTreeEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_FROSTED_GATES] = this.createFrostedGatesEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_APRIL_FOOLS] = this.runAprilsFoolsEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_INFLUENCE_BATTLE] = this.runInflueceBattleEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_BREACH] = this.runBreachEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_ICEBERG] = this.runIceBergEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_INFLUENCE_BATTLE_VICTORY_BANNER] = this.runInflueceBattleVictoryBannerEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_MAP_REPLACEMENT] = this.runMapReplacementEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_DEMOLISHED_HQ] = this.runDemolishedHQEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_EVENT_DOMINATING_FACTION] = this.runEventDominatingFactionEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_PLAGUE_MOOD_ASSET] = this.runPlagueMoodAssetEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_PROPAGANDA_ASTEROIDS] = this.runPrometheusEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_PROPAGANDA_ASTEROIDS_CARNIVAL] = this.runCarnivalEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_PROPAGANDA_ASTEROIDS_EASTER2016] = this.runEaster2016Event;
         _loc1_[EventActivationStateCommand.EVENTTYPE_PIXELATED_RENDERING_SETTING] = this.runPixelationModeEvent;
         _loc1_[EventActivationStateCommand.EVENTTYPE_PERMAFROST_FISSURE_ASSEMBLY_WINDOW] = this.runPermaFrostFissureEvent;
         return _loc1_;
      }
      
      private function runEventDominatingFactionEvent(param1:EventActivationStateCommand) : void
      {
         var _loc2_:EventActivationFactionAttributeModule = this.getModule(param1.attributes,EventActivationFactionAttributeModule.instance.getLibcomModuleId()) as EventActivationFactionAttributeModule;
         if(_loc2_)
         {
            if(this.eventProxy.isEventActive(param1.type) && param1.active)
            {
               if((this.eventProxy.getEventWithId(param1.type) as EventDominatingFactionEvent).dominatingFaction == _loc2_.faction.faction)
               {
                  return;
               }
            }
            sendNotification(EventNotifications.ADD_EVENT,new EventDominatingFactionEvent(param1.type,param1.active,_loc2_.faction.faction));
         }
      }
      
      private function runDemolishedHQEvent(param1:EventActivationStateCommand) : void
      {
         if(this.eventProxy.isEventActive(param1.type) != param1.active)
         {
            sendNotification(EventNotifications.ADD_EVENT,new HQdemolitionEvent(param1.type,param1.active));
         }
      }
      
      private function runAprilsFoolsEvent(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new AprilsFoolsEvent(param1.type,param1.active));
      }
      
      private function createFrostedGatesEvent(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new FrostedGatesEvent(param1.type,param1.active));
      }
      
      private function runPrometheusEvent(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new MoodAssetEvent(param1.type,param1.active,MoodAssetEvent.PROMETHEUS_DAY_ASSET_LIB_ID));
      }
      
      private function runCarnivalEvent(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new MoodAssetEvent(param1.type,param1.active,MoodAssetEvent.CARNIVAL_DAY_ASSET_LIB_ID));
      }
      
      private function runEaster2016Event(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new MoodAssetEvent(param1.type,param1.active,MoodAssetEvent.EASTER_2016_ASSET_LIB_ID));
      }
      
      private function runPixelationModeEvent(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new PixelatedRenderingEvent(param1.type,param1.active));
      }
      
      private function createChristmasTreeEvent(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new ChristmasTreeEvent(param1.type,param1.active));
      }
      
      private function runPermaFrostFissureEvent(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new PermaFrostFissurEvent(param1.type,param1.active));
      }
      
      private function runMapReplacementEvent(param1:EventActivationStateCommand) : void
      {
         var _loc5_:EventActivationMapExchangeAttributeModule = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:MapReplacementEvent = null;
         var _loc2_:Vector.<EventActivationAttributeModule> = this.getModules(param1.attributes,EventActivationMapExchangeAttributeModule.instance.getLibcomModuleId());
         if(_loc2_.length == 0)
         {
            return;
         }
         var _loc3_:MapReplacementEvent = this.eventProxy.getEventWithId(param1.type) as MapReplacementEvent;
         var _loc4_:Dictionary = _loc3_ ? _loc3_.mapReplacements || new Dictionary() : new Dictionary();
         if(Boolean(_loc3_) && Boolean(_loc3_.isActive != param1.active) || param1.active && !_loc3_)
         {
            _loc6_ = true;
         }
         for each(_loc5_ in _loc2_)
         {
            _loc7_ = MapReplacementEvent.getMapResKey(_loc5_.replacement);
            if(_loc4_[_loc5_.mapId] != _loc7_)
            {
               _loc4_[_loc5_.mapId] = _loc7_;
               _loc6_ = true;
            }
         }
         if(_loc6_)
         {
            _loc8_ = new MapReplacementEvent(param1.type,param1.active,_loc4_);
            sendNotification(EventNotifications.ADD_EVENT,_loc8_);
         }
      }
      
      private function runInflueceBattleVictoryBannerEvent(param1:EventActivationStateCommand) : void
      {
         var _loc3_:String = null;
         var _loc2_:EventActivationFactionAttributeModule = this.getModule(param1.attributes,EventActivationFactionAttributeModule.instance.getLibcomModuleId()) as EventActivationFactionAttributeModule;
         if(_loc2_)
         {
            _loc3_ = MoodAssetEvent.getReskeyByFaction(_loc2_.faction);
            sendNotification(EventNotifications.ADD_EVENT,new MoodAssetEvent(param1.type,param1.active,_loc3_));
         }
      }
      
      private function runInflueceBattleEvent(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new MoodAssetEvent(param1.type,param1.active,MoodAssetEvent.SPRING_FIGHT_MOOD_ASSET_LIB_ID));
      }
      
      private function runIceBergEvent(param1:EventActivationStateCommand) : void
      {
         var _loc2_:Vector.<String> = new Vector.<String>();
         var _loc3_:EventActivationIntegerAttributeModule = this.getModule(param1.attributes,EventActivationIntegerAttributeModule.instance.getLibcomModuleId()) as EventActivationIntegerAttributeModule;
         switch(_loc3_.value)
         {
            case 3:
               _loc2_.push("large");
            case 2:
               _loc2_.push("medium");
            case 1:
               _loc2_.push("small");
         }
         sendNotification(EventNotifications.ADD_EVENT,new MoodAssetDestributionEvent(param1.type,param1.active,MoodAssetDestributionEvent.ICEBERG_MOOD_ASSET_LIB_ID,_loc2_));
      }
      
      private function runPlagueMoodAssetEvent(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new MoodAssetEvent(param1.type,param1.active,MoodAssetEvent.PLAGUE_MOOD_ASSET_LIB_ID));
      }
      
      private function runBreachEvent(param1:EventActivationStateCommand) : void
      {
         sendNotification(EventNotifications.ADD_EVENT,new MoodAssetEvent(param1.type,param1.active,MoodAssetEvent.BREACH_MOOD_ASSET_LIB_ID));
      }
      
      private function getModule(param1:Vector.<EventActivationAttributeModule>, param2:int) : EventActivationAttributeModule
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1[_loc4_].getLibcomModuleId() == param2)
            {
               return param1[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      private function getModules(param1:Vector.<EventActivationAttributeModule>, param2:int) : Vector.<EventActivationAttributeModule>
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:Vector.<EventActivationAttributeModule> = new Vector.<EventActivationAttributeModule>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if(param1[_loc5_].getLibcomModuleId() == param2)
            {
               _loc4_.push(param1[_loc5_]);
            }
            _loc5_++;
         }
         return _loc4_;
      }
   }
}

