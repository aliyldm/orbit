package net.bigpoint.darkorbit.data.stats
{
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   
   public class PingStats
   {
      
      public static const PING_INTERVAL:int = 15000;
      
      private static const _inst:PingStats = new PingStats();
      
      private const _pings:Vector.<int> = new Vector.<int>(0);
      
      private var _time:int;
      
      public function PingStats()
      {
         super();
         if(_inst)
         {
            throw new Error("PingStats is singleton");
         }
      }
      
      public static function get instance() : PingStats
      {
         return _inst;
      }
      
      public function ping() : void
      {
         this._time = getTimer();
      }
      
      public function pong() : void
      {
         this.addData(getTimer() - this._time);
      }
      
      private function addData(param1:int) : void
      {
         this._pings.push(param1);
         if(this._pings.length > 50)
         {
            this.track();
            this._pings.length = 0;
         }
      }
      
      private function track() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int.MAX_VALUE;
         var _loc3_:int = int.MIN_VALUE;
         var _loc4_:int = int(this._pings.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc1_ += this._pings[_loc5_];
            _loc2_ = Math.min(this._pings[_loc5_],_loc2_);
            _loc3_ = Math.max(this._pings[_loc5_],_loc3_);
            _loc5_++;
         }
         _loc1_ /= this._pings.length;
         var _loc6_:ConnectionProxy = GameFacade.getInstance().retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         var _loc7_:String = _loc6_ ? _loc6_.connectionManager.currentIPAddress : Settings.defaultGameServer;
         EventStreamClient.track("client_statistics_ping",{
            "avg_ping":_loc1_,
            "min_ping":_loc2_,
            "max_ping":_loc3_,
            "gameserver":_loc7_,
            "time_interval":PING_INTERVAL * 0.001
         });
      }
   }
}

