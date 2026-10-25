package net.bigpoint.darkorbit.mvc.commandCenter.model
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.CommandCenterDontShowInfoCommand;
   import net.bigpoint.darkorbit.com.module.CommandCenterInfoCommand;
   import net.bigpoint.darkorbit.com.module.CommandCenterNewsClickedRequest;
   import net.bigpoint.darkorbit.com.module.CommandCenterNewsInfoRequest;
   import net.bigpoint.darkorbit.com.module.CommandCenterNewsModule;
   import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterConsts;
   import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterNotifications;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.repo.CommandCenterNewsDefinition;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.repo.CommandCenterNewsRepository;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.serverEvents.model.ServerEventModel;
   import net.bigpoint.darkorbit.mvc.serverEvents.model.ServerEventProxy;
   import net.bigpoint.darkorbit.mvc.serverEvents.model.ServerEventVO;
   
   public class CommandCenterProxy extends SimpleWindowProxy
   {
      
      private var _events:ServerEventModel;
      
      private var _invalidNewsInfo:Vector.<CommandCenterNewsClickedRequest> = new Vector.<CommandCenterNewsClickedRequest>(0);
      
      private var _requestInfosPointer:uint;
      
      public function CommandCenterProxy(param1:String)
      {
         super(param1,new CommandCenterModel());
      }
      
      public function get newsRepository() : CommandCenterNewsRepository
      {
         return this.model.newsRepository;
      }
      
      private function get model() : CommandCenterModel
      {
         return data as CommandCenterModel;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.newsRepository.init().addOnce(this.repoLoaded);
      }
      
      public function dontShowInfoReturned(param1:CommandCenterDontShowInfoCommand) : void
      {
         this.model.dontShowInfoReturnedUpdate(param1.inspected);
      }
      
      public function updateViewCounts(param1:CommandCenterInfoCommand) : void
      {
         var _loc4_:CommandCenterNewsModule = null;
         var _loc2_:int = int(param1.ids.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.ids[_loc3_];
            this.model.updateViewCount(_loc4_.newsId,_loc4_.clickCount);
            _loc3_++;
         }
      }
      
      public function triggerShopButtonAction() : Boolean
      {
         var _loc2_:CommandCenterNewsVO = null;
         var _loc3_:XMLList = null;
         var _loc1_:CommandCenterCategory = this.model.getCategory(CommandCenterCategory.CATEGORY_SALES);
         if(_loc1_)
         {
            if(_loc1_.listOfNews.length > 0)
            {
               _loc2_ = _loc1_.listOfNews[0];
               _loc3_ = _loc2_.data.actionsXML.child("button").child("onclick");
               if(_loc3_.length() > 0)
               {
                  sendNotification(CommandCenterNotifications.TRIGGER_ACTION,_loc3_[0]);
                  return true;
               }
            }
         }
         return false;
      }
      
      private function repoLoaded() : void
      {
         var _loc4_:ServerEventVO = null;
         this._events = (retrieveProxy(ServerEventProxy.NAME) as ServerEventProxy).getData() as ServerEventModel;
         this._events.eventActivated.add(this.onEventActivated);
         this._events.eventDeactivated.add(this.onEventDeactivated);
         var _loc1_:Vector.<ServerEventVO> = this._events.getAsVector();
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            this.onEventActivated(_loc4_);
            _loc3_++;
         }
      }
      
      private function onEventDeactivated(param1:ServerEventVO) : void
      {
         var _loc5_:CommandCenterNewsDefinition = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc2_:Vector.<CommandCenterNewsDefinition> = this.getDefinitions(param1);
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = _loc5_.getEventNames();
            _loc7_ = int(_loc6_.length);
            _loc8_ = false;
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               if(this._events.getEventByType(_loc6_[_loc9_]))
               {
                  _loc8_ = true;
               }
               _loc9_++;
            }
            if(!_loc8_)
            {
               this.model.removeNewsByNewsId(_loc5_.name);
            }
            _loc4_++;
         }
      }
      
      private function onEventActivated(param1:ServerEventVO) : void
      {
         var event:ServerEventVO = param1;
         var events:Vector.<CommandCenterNewsDefinition> = this.getDefinitions(event);
         if(event.type.indexOf(CommandCenterConsts.NEWS_EVENT_PREFIX) == 0 && events.length == 0)
         {
            this.newsRepository.reload().addOnce(function():void
            {
               internalAdd(getDefinitions(event),event);
            });
            return;
         }
         this.internalAdd(events,event);
      }
      
      private function internalAdd(param1:Vector.<CommandCenterNewsDefinition>, param2:ServerEventVO) : void
      {
         var _loc5_:CommandCenterNewsDefinition = null;
         var _loc6_:CommandCenterNewsVO = null;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = this.model.getNewsByKey(_loc5_.name);
            if(!_loc6_)
            {
               this.model.addNews(_loc5_,param2.timeLeft.value);
               this._invalidNewsInfo.push(new CommandCenterNewsClickedRequest(_loc5_.name,param2.id));
               clearTimeout(this._requestInfosPointer);
               this._requestInfosPointer = setTimeout(this.requestInfo,1);
            }
            else
            {
               _loc6_.updateTimeLeft(param2.timeLeft.value);
            }
            _loc4_++;
         }
      }
      
      private function requestInfo() : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new CommandCenterNewsInfoRequest(this._invalidNewsInfo.concat()));
         this._invalidNewsInfo.length = 0;
         this._requestInfosPointer = 0;
      }
      
      private function getDefinitions(param1:ServerEventVO) : Vector.<CommandCenterNewsDefinition>
      {
         var _loc3_:CommandCenterNewsDefinition = null;
         var _loc2_:Vector.<CommandCenterNewsDefinition> = this.newsRepository.getNewsByEventType(param1.type);
         _loc2_ ||= new Vector.<CommandCenterNewsDefinition>();
         if(param1.type.indexOf(CommandCenterConsts.NEWS_EVENT_PREFIX) == 0)
         {
            _loc3_ = this.newsRepository.getNewsByName(param1.type.substr(3));
            if(_loc3_)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}

