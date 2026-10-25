package net.bigpoint.darkorbit.mvc.stats.model
{
   import flash.system.System;
   import flash.utils.Dictionary;
   import flash.utils.setInterval;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.stats.StatsNotifications;
   import net.bigpoint.darkorbit.mvc.stats.model.vo.StatsVO;
   import net.bigpoint.darkorbit.mvc.stats.model.vo.TrackingVO;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class StatsProxy extends Proxy implements IProxy, IFrameObserver
   {
      
      public static const NAME:String = "StatsProxy";
      
      private var _trackDataPointer:uint;
      
      private var _frameTicks:int;
      
      private var _timerTicks:int;
      
      private var _megaByteCoefficient:Number;
      
      private var _statsVO:StatsVO;
      
      private var _trackingVO:TrackingVO;
      
      private var _params:Dictionary = new Dictionary();
      
      private var _tpf:Number = 0;
      
      public function StatsProxy()
      {
         super(NAME,null);
      }
      
      override public function onRegister() : void
      {
         this._megaByteCoefficient = 1 / 1024 / 1024;
         this._statsVO = new StatsVO();
         this._trackingVO = new TrackingVO();
         ScreenManager.addObserver(this);
         sendNotification(StatsNotifications.READY);
         this._trackDataPointer = setInterval(this.trackData,60000);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:ConnectionProxy = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<int> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         ++this._frameTicks;
         this._tpf += param1;
         if(this._tpf > 999)
         {
            ++this._timerTicks;
            if(this._statsVO.currentFPS > this._trackingVO.maxFPS)
            {
               this._trackingVO.maxFPS = this._statsVO.currentFPS;
            }
            if(this._statsVO.currentFPS < this._trackingVO.minFPS || this._trackingVO.minFPS == 0)
            {
               this._trackingVO.minFPS = this._statsVO.currentFPS;
            }
            if(this._statsVO.currentMem > this._trackingVO.maxMem)
            {
               this._trackingVO.maxMem = this._statsVO.currentMem;
            }
            if(this._statsVO.currentMem < this._trackingVO.minMem || this._trackingVO.minMem == 0)
            {
               this._trackingVO.minMem = this._statsVO.currentMem;
            }
            this._trackingVO.averageFPS = (this._trackingVO.averageFPS * (this._timerTicks - 1) + this._statsVO.currentFPS) / this._timerTicks;
            this._trackingVO.averageMem = (this._trackingVO.averageMem * (this._timerTicks - 1) + this._statsVO.currentMem) / this._timerTicks;
            this._statsVO.currentFPS = this._frameTicks;
            if(ScreenManager.getInstance().hasFocus)
            {
               this._statsVO.lastFPSs.unshift(this._frameTicks);
               if(this._statsVO.lastFPSs.length > 50)
               {
                  _loc2_ = GameFacade.getInstance().retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
                  _loc3_ = _loc2_ ? _loc2_.connectionManager.currentIPAddress : Settings.defaultGameServer;
                  if(_loc3_)
                  {
                     _loc4_ = 0;
                     _loc5_ = int.MAX_VALUE;
                     _loc6_ = int.MIN_VALUE;
                     _loc7_ = this._statsVO.lastFPSs;
                     _loc8_ = int(_loc7_.length);
                     _loc9_ = 0;
                     while(_loc9_ < _loc8_)
                     {
                        _loc4_ += _loc7_[_loc9_];
                        _loc5_ = Math.min(_loc5_,_loc7_[_loc9_]);
                        _loc6_ = Math.max(_loc6_,_loc7_[_loc9_]);
                        _loc9_++;
                     }
                     _loc4_ /= _loc8_;
                     EventStreamClient.track("client_statistics_fps",{
                        "avg_fps":_loc4_,
                        "min_fps":_loc5_,
                        "max_fps":_loc6_,
                        "gameserver":_loc3_,
                        "time_interval":0.999
                     });
                  }
                  this._statsVO.lastFPSs.length = 0;
               }
            }
            this._statsVO.currentMem = Number(System.totalMemory * this._megaByteCoefficient);
            this._frameTicks = 0;
            this._tpf = 0;
            sendNotification(StatsNotifications.UPDATE,[this._statsVO]);
         }
      }
      
      public function setParam(param1:String, param2:String) : void
      {
         this._params[param1] = param2;
         this.joinParams();
         sendNotification(StatsNotifications.UPDATE,[this._statsVO]);
      }
      
      private function trackData() : void
      {
         var _loc1_:ScreenManager = ScreenManager.getInstance();
         if(Boolean(_loc1_.map) && Boolean(_loc1_.map.hero) && _loc1_.hasFocus)
         {
            EventStreamClient.track("usersystem_current_fps",{
               "position_area":Settings.mapID,
               "fps":this._statsVO.currentFPS,
               "position_x":int(_loc1_.map.hero.x),
               "position_y":int(_loc1_.map.hero.y)
            });
         }
      }
      
      private function joinParams() : void
      {
         var _loc1_:String = null;
         this._statsVO.joinedParams = "";
         for(_loc1_ in this._params)
         {
            if(this._statsVO.joinedParams != "")
            {
               this._statsVO.joinedParams += " | ";
            }
            this._statsVO.joinedParams += _loc1_ + ": " + this._params[_loc1_];
         }
      }
   }
}

